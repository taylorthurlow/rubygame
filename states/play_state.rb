require 'gosu'
require_relative '../entities/player'
require_relative '../entities/camera'

class PlayState
  attr_accessor :buttons_down, :x, :y, :map, :camera

  def initialize
    @x = @y = 0
    @buttons_down = 1 # start at 1 because the main menu key registers as a button_up but not down
    @font = Gosu::Font.new($window, Gosu.default_font_name, 20)

    @map = WorldMap.new
    @player = Player.new(self)
    @camera = Camera.new(@player)
  end

  def enter
  end

  def leave
  end

  def update
    @player.update(@camera)
    @camera.update
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
    @map.draw(@camera.pos_x - $window.width / 2, @camera.pos_y - $window.height / 2)
    @player.draw

    tile_facing = @player.tile_facing
    facing_ids = @map.tiles_at(tile_facing[0] * 16, tile_facing[1] * 16)
    can_move = @map.can_move_to?(tile_facing[0] * 16, tile_facing[1] * 16)
    player_info = "Player: #{@player.tile_pos_x}, #{@player.tile_pos_y} (#{@player.pos_x}, #{@player.pos_y})"

    @font.draw("Direction: #{@player.direction}", 0, 0, 0, 1, 1, Gosu::Color::YELLOW)
    @font.draw("FPS: #{Gosu.fps}", 0, 20, 0, 1, 1, Gosu::Color::YELLOW)
    @font.draw("Camera: #{@camera.pos_x}, #{@camera.pos_y}", 0, 40, 0, 1, 1, Gosu::Color::YELLOW)
    @font.draw(player_info, 0, 60, 0, 1, 1, Gosu::Color::YELLOW)
    @font.draw("Moving: #{@player.is_moving?}, buttons: #{@buttons_down}", 0, 80, 0, 1, 1, Gosu::Color::YELLOW)
    @font.draw($window.memory_usage, 0, 100, 0, 1, 1, Gosu::Color::YELLOW)
    @font.draw("Facing: #{facing_ids} (#{tile_facing[0]}, #{tile_facing[1]}), CanMoveTo: #{@map.can_move_to?(tile_facing[0] * 16, tile_facing[1] * 16)}", 0, 120, 0, 1, 1, Gosu::Color::YELLOW)
    @font.draw("TNZT: #{@map.get_top_nonzero_tile(tile_facing[0], tile_facing[1], true)}", 0, 140, 0, 1, 1, Gosu::Color::YELLOW)

  end

  def needs_redraw?
    true
  end
end