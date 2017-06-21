require 'gosu'
require_relative '../entities/player'

class PlayState
  attr_accessor :buttons_down, :x, :y

  def initialize
    @x = @y = 0
    @speed = 2
    @buttons_down = 1 # start at 1 because the main menu key registers as a button_up but not down
    @font = Gosu::Font.new($window, Gosu.default_font_name, 20)

    @map = WorldMap.new
    @player = Player.new(self)
  end

  def enter
  end

  def leave
  end

  def update
    handle_keyboard
    @player.update
  end

  def handle_keyboard
    if $window.button_down?(Gosu::KbW)
      tile_above_x, tile_above_y = @player.tile_above
      if @map.can_move_to?(tile_above_x, tile_above_y)
        @player.pos_y -= @speed
      end
    end

    if $window.button_down?(Gosu::KbA)
      tile_left_x, tile_left_y = @player.tile_left
      if @map.can_move_to?(tile_left_x, tile_left_y)
        @player.pos_x -= @speed
      end
    end

    if $window.button_down?(Gosu::KbS)
      tile_below_x, tile_below_y = @player.tile_below
      if @map.can_move_to?(tile_below_x, tile_below_y)
        @player.pos_y += @speed
      end
    end

    if $window.button_down?(Gosu::KbD)
      tile_right_x, tile_right_y = @player.tile_right
      if @map.can_move_to?(tile_right_x, tile_right_y)
        @player.pos_x += @speed
      end
    end
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
    camera_x = @player.pos_x - $window.width / 2
    camera_y = @player.pos_y - $window.height / 2

    @map.draw(camera_x, camera_y)
    @player.draw

    tile_facing = @player.tile_facing
    facing_ids = @map.tiles_at(tile_facing[0], tile_facing[1])
    can_move = @map.can_move_to?(tile_facing[0], tile_facing[1])
    player_info = "Player: #{@player.tile_pos_x}, #{@player.tile_pos_y} (#{@player.pos_x}, #{@player.pos_y})"
    @font.draw("Direction: #{@player.direction}", 0, 0, 0, 1, 1, Gosu::Color::YELLOW)
    @font.draw("FPS: #{Gosu.fps}", 0, 20, 0, 1, 1, Gosu::Color::YELLOW)
    @font.draw("Camera: #{camera_x}, #{camera_y}", 0, 40, 0, 1, 1, Gosu::Color::YELLOW)
    @font.draw(player_info, 0, 60, 0, 1, 1, Gosu::Color::YELLOW)
    @font.draw("Moving: #{@player.is_moving?}, buttons: #{@buttons_down}", 0, 80, 0, 1, 1, Gosu::Color::YELLOW)
    @font.draw($window.memory_usage, 0, 100, 0, 1, 1, Gosu::Color::YELLOW)
    @font.draw("Facing: #{facing_ids} (#{tile_facing[0]}, #{tile_facing[1]}), Collidable: #{!@map.can_move_to?(tile_facing[0], tile_facing[1])}", 0, 120, 0, 1, 1, Gosu::Color::YELLOW)

  end

  def needs_redraw?
    true
  end
end