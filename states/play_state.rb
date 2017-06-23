require 'gosu'
require_relative '../entities/player'
require_relative '../entities/camera'

require 'ruby-prof'

class PlayState < GameState
  attr_accessor :buttons_down, :x, :y, :map, :camera

  def initialize
    @x = @y = 0
    @buttons_down = 1 # start at 1 because the main menu key registers as a button_up but not down
    @font = Gosu::Font.new($window, Gosu.default_font_name, 20)

    @map = WorldMap.new
    @player = Player.new(self)
    @camera = Camera.new(@player)

    @debugging = false
  end

  def enter
    RubyProf.start if ENV['ENABLE_PROFILING']
  end

  def leave
    RubyProf::FlatPrinter.new(RubyProf.stop).print(STDOUT) if ENV['ENABLE_PROFILING']
  end

  def update
    @player.update(@camera)
    @camera.update

    # debug stuff
    @tiles_facing = @player.tiles_facing
    @tile_facing = @player.tile_facing
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
    when Gosu::KbQ
      GameState.switch(MenuState.instance)
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
    cam_x = @camera.pos_x
    cam_y = @camera.pos_y

    off_x = $window.width / 2 - cam_x
    off_y = $window.height / 2 - cam_y

    $window.translate(off_x, off_y) do
      $window.scale(@camera.zoom, @camera.zoom, cam_x, cam_y) do
        @map.draw(@camera)
        @player.draw
        draw_select_highlight
      end
    end

    if @debugging
      player_info = "Player: #{@player.x}, #{@player.y} (#{@player.pos_x}, #{@player.pos_y}), Direction: #{@player.direction}"
      @font.draw("FPS: #{Gosu.fps}", 0, 0, 0, 1, 1, Gosu::Color::YELLOW)
      @font.draw($window.memory_usage, 0, 20, 0, 1, 1, Gosu::Color::YELLOW)
      @font.draw("Camera: #{@camera.pos_x}, #{@camera.pos_y}", 0, 40, 0, 1, 1, Gosu::Color::YELLOW)
      @font.draw(player_info, 0, 60, 0, 1, 1, Gosu::Color::YELLOW)
      @font.draw("Facing: #{@tiles_facing.map {|t| t.id}}, #{@tile_facing.to_s}", 0, 80, 0, 1, 1, Gosu::Color::YELLOW)
    end
  end

  def draw_select_highlight
    tile = @player.tile_facing
    tile_x, tile_y = tile.pos_x, tile.pos_y
    draw_x = tile_x * 16
    draw_y = tile_y * 16

    Gosu.draw_rect(draw_x, draw_y, 16, 16, Gosu::Color::GREEN, 2)
  end

  def needs_redraw?
    true
  end
end