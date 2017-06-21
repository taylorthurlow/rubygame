# classes
require_relative 'player'
require_relative 'worldmap'

# libraries
require 'gosu'
require 'gosu_tiled'
require 'byebug'

class GameWindow < Gosu::Window
  attr_accessor :buttons_down

  WINDOW_WIDTH = 800
  WINDOW_HEIGHT = 600

  def initialize
    super(WINDOW_WIDTH, WINDOW_HEIGHT, false)
    #@map = Gosu::Tiled.load_json(self, MAP_FILE)
    @map = WorldMap.new(self)
    @x = @y = 0
    @zoom = 1

    @speed = 2
    @first_render = true
    @buttons_down = 0

    @font = Gosu::Font.new(self, Gosu::default_font_name, 20)

    # player
    @player = Player.new(self)
  end

  def update
    self.caption = 'some stupid ruby game'
    handle_keyboard
    @player.update
  end

  def handle_keyboard
    @x -= @speed if button_down?(Gosu::KbA)
    @x += @speed if button_down?(Gosu::KbD)
    @y -= @speed if button_down?(Gosu::KbW)
    @y += @speed if button_down?(Gosu::KbS)
  end

  def button_down(id)
    case id
    when Gosu::KbW
      @player.direction = :up
    when Gosu::KbA
      @player.direction = :left
    when Gosu::KbS
      @player.direction = :down
    when Gosu::KbD
      @player.direction = :right
    when Gosu::KbEscape
      close
    end

    @buttons_down += 1
  end

  def button_up(id)
    @buttons_down -= 1

    # handle multiple buttons
    if @buttons_down > 0
      @player.direction = :up if button_down?(Gosu::KbW)
      @player.direction = :left if button_down?(Gosu::KbA)
      @player.direction = :down if button_down?(Gosu::KbS)
      @player.direction = :right if button_down?(Gosu::KbD)
    end
  end

  def needs_redraw?
    return true
    # [Gosu::KbLeft, Gosu::KbRight, Gosu::KbUp, Gosu::KbDown].each {|b| return true if button_down?(b)}
    # return @first_render
  end

  def draw
    @map.draw(@x, @y)


    player_info = "Player: (#{@x + (WINDOW_WIDTH / 2)}, #{@y + (WINDOW_HEIGHT / 2)})"
    @font.draw("Direction: #{@player.direction}", 0, 0, 0, 1, 1, Gosu::Color::GREEN)
    @font.draw("FPS: #{Gosu.fps}", 0, 20, 0, 1, 1, Gosu::Color::GREEN)
    @font.draw(player_info, 0, 40, 0, 1, 1, Gosu::Color::GREEN)
    @font.draw(memory_usage, 0, 60, 0, 1, 1, Gosu::Color::GREEN)

    @player.draw
  end

  def memory_usage
    `ps -o rss= -p #{Process.pid}`.chomp.gsub(/(\d)(?=(\d{3})+(\..*)?$)/,'\1,') + ' KB'
    rescue
    "Unavailable. Using Windows?"
  end
end

GameWindow.new.show