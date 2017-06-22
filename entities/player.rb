require 'gosu'

class Player
  attr_accessor :pos_x, :pos_y, :direction, :speed

  FRAME_DELAY = 50 #milliseconds

  def initialize(play_state)
    @play_state = play_state
    @map = @play_state.map

    @anims = load_animation
    @current_frame = 0

    @pos_x = 30 * 16
    @pos_y = 30 * 16
    @direction = :down
    @stopped_moving = true
    @speed = 2
  end

  ####
  # logic
  ####

  def update(camera)
    @current_frame += 1 if frame_expired?
    
    new_pos_x, new_pos_y = @pos_x, @pos_y
    new_pos_y -= @speed if $window.button_down?(Gosu::KbW)
    new_pos_x -= @speed if $window.button_down?(Gosu::KbA)
    new_pos_y += @speed if $window.button_down?(Gosu::KbS)
    new_pos_x += @speed if $window.button_down?(Gosu::KbD)

    if @map.can_move_to?(new_pos_x / 16, new_pos_y / 16)
      @pos_x, @pos_y = new_pos_x, new_pos_y
    end
  end

  ####
  # movement and position
  ####

  def tile_pos_x
    return @pos_x / 16
  end

  def tile_pos_y
    return @pos_y / 16
  end

  def tiles_facing
    x, y = tile_pos_x, tile_pos_y

    case direction
    when :up
      y -= 1
    when :left
      x -= 1
    when :down
      y += 1
    when :right
      x += 1
    end

    return @map.tiles_at(x, y)
  end

  def tile_facing
    return @map.get_top_nonzero_tile(tiles_facing.last.pos_x, tiles_facing.last.pos_y)
  end

  def tile_above; [tile_pos_x, tile_pos_y - 1] end
  def tile_left; [tile_pos_x - 1, tile_pos_y] end
  def tile_below; [tile_pos_x, tile_pos_y + 1] end
  def tile_right; [tile_pos_x + 1, tile_pos_y] end

  def is_moving?
    if any_button_down?(Gosu::KbW, Gosu::KbA, Gosu::KbS, Gosu::KbD)
      @stopped_moving = false
      return true
    else
      @stopped_moving = true if !@stopped_moving
      return false
    end
  end

  ####
  # graphics
  ####

  def needs_redraw?
    return frame_expired?
  end

  def draw
    if is_moving? or @stopped_moving
      image = @stopped_moving ? get_animation[1] : get_animation[@current_frame % 3]
      image.draw(@pos_x - 8, @pos_y - 8, 1)
      @stopped_moving = false
    end
  end

  private

  def any_button_down?(*buttons)
    buttons.each do |b|
      return true if $window.button_down?(b)
    end

    return false
  end

  def frame_expired?
    now = Gosu.milliseconds
    @last_frame ||= now
    if (now - @last_frame) > FRAME_DELAY
      @last_frame = now
      return true
    end
  end

  def load_animation
    return Gosu::Image.load_tiles($window, 'assets/mainguy.png', 16, 16, false)
  end

  def get_animation
    case @direction
    when :up
      return @anims[9..11]
    when :left
      return @anims[3..5]
    when :down
      return @anims[0..2]
    when :right
      return @anims[6..8]
    end
  end

end
