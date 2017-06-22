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

    tile_facing = @player.tile_facing
    facing_ids = @map.tiles_at(tile_facing[0], tile_facing[1])
    can_move = @map.can_move_to?(tile_facing[0], tile_facing[1])
    player_info = "Player: #{@player.tile_pos_x}, #{@player.tile_pos_y} (#{@player.pos_x}, #{@player.pos_y})"

    @font.draw("Direction: #{@player.direction}", 0, 0, 0, 1, 1, Gosu::Color::YELLOW)
    @font.draw("FPS: #{Gosu.fps}", 0, 20, 0, 1, 1, Gosu::Color::YELLOW)
    @font.draw("Camera: #{@camera.pos_x}, #{@camera.pos_y}", 0, 40, 0, 1, 1, Gosu::Color::YELLOW)
    @font.draw(player_info, 0, 60, 0, 1, 1, Gosu::Color::YELLOW)
    @font.draw("Moving: #{@player.is_moving?}, buttons: #{@buttons_down}", 0, 80, 0, 1, 1, Gosu::Color::YELLOW)
    @font.draw($window.memory_usage, 0, 100, 0, 1, 1, Gosu::Color::YELLOW)
    @font.draw("Facing: #{facing_ids} (#{tile_facing[0]}, #{tile_facing[1]})", 0, 120, 0, 1, 1, Gosu::Color::YELLOW)
    @font.draw("Next tile traversible?: #{@map.can_move_to?(tile_facing[0], tile_facing[1])}", 0, 140, 0, 1, 1, Gosu::Color::YELLOW)
    @font.draw("Top Non-zero Tile: #{@map.get_top_nonzero_tile(tile_facing[0], tile_facing[1])}", 0, 160, 0, 1, 1, Gosu::Color::YELLOW)
  end

  def draw_select_highlight
    tile_x, tile_y = @player.tile_facing
    draw_x = tile_x * 16
    draw_y = tile_y * 16

    Gosu.draw_rect(draw_x, draw_y, 16, 16, Gosu::Color::GREEN, 2)

    # crosshair center of screen for alignment
    # Gosu.draw_rect(@player.pos_x, 0, 1, $window.height, Gosu::Color::RED, 2)
    # Gosu.draw_rect(0, @player.pos_y, $window.width, 1, Gosu::Color::RED, 2)
  end

  def needs_redraw?
    true
  end
end