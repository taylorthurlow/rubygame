require 'gosu'
require_relative '../entities/player'

class PlayState
  attr_accessor :buttons_down

  def initialize
    @map = WorldMap.new
    @player = Player.new(self)

    @x = @y = 0
    @zoom = 1

    @speed = 2
    @buttons_down = 1 # start at 1 because the main menu key registers as a button_up but not down

    @font = Gosu::Font.new($window, Gosu.default_font_name, 20)
  end

  def enter
  end

  def leave
  end

  def update
    handle_keyboard
    @player.update
    puts @buttons_down
  end

  def handle_keyboard
    @x -= @speed if $window.button_down?(Gosu::KbA)
    @x += @speed if $window.button_down?(Gosu::KbD)
    @y -= @speed if $window.button_down?(Gosu::KbW)
    @y += @speed if $window.button_down?(Gosu::KbS)
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
      $window.close
    end

    @buttons_down += 1
  end

  def button_up(id)
    @buttons_down -= 1

    # handle multiple buttons
    if @buttons_down > 0
      @player.direction = :up    if $window.button_down?(Gosu::KbW)
      @player.direction = :left  if $window.button_down?(Gosu::KbA)
      @player.direction = :down  if $window.button_down?(Gosu::KbS)
      @player.direction = :right if $window.button_down?(Gosu::KbD)
    end
  end

  def draw
    @map.draw(@x, @y)
    @player.draw

    player_info = "Player: (#{@x + ($window.width / 2)}, #{@y + ($window.height / 2)})"
    @font.draw("Direction: #{@player.direction}", 0, 0, 0, 1, 1, Gosu::Color::GREEN)
    @font.draw("FPS: #{Gosu.fps}", 0, 20, 0, 1, 1, Gosu::Color::GREEN)
    @font.draw(player_info, 0, 40, 0, 1, 1, Gosu::Color::GREEN)
    @font.draw("Moving: #{@player.is_moving?}, buttons: #{@buttons_down}", 0, 60, 0, 1, 1, Gosu::Color::GREEN)
    @font.draw($window.memory_usage, 0, 80, 0, 1, 1, Gosu::Color::GREEN)

  end

  def needs_redraw?
    true
  end
end