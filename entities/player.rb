require 'gosu'

class Player
  attr_accessor :pos_x, :pos_y, :direction

  FRAME_DELAY = 50 #milliseconds

  def initialize(play_state)
    @play_state = play_state
    @anims = load_animation
    @current_frame = 0

    @pos_x = 20 * 16
    @pos_y = 20 * 16
    @direction = :down
    @stopped_moving = true
  end

  ####
  # logic
  ####

  def update
    @current_frame += 1 if frame_expired?
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

  def tile_facing
    x = tile_pos_x
    y = tile_pos_y

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

    return [x, y]
  end

  def tile_above
    return [tile_pos_x, tile_pos_y - 1]
  end

  def tile_left
    return [tile_pos_x - 1, tile_pos_y]
  end

  def tile_below
    return [tile_pos_x, tile_pos_y + 1]
  end

  def tile_right
    return [tile_pos_x + 1, tile_pos_y]
  end

  def is_moving?
    if @play_state.buttons_down > 0
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
    return true
    return frame_expired?
  end

  def draw
    if is_moving? or @stopped_moving
      image = @stopped_moving ? get_animation[1] : get_animation[@current_frame % 3]
      image.draw($window.width / 2 - 8, $window.height / 2 - 8, 1)
      @stopped_moving = false
    end

    draw_select_highlight
  end

  private

  def draw_select_highlight
    tile_x, tile_y = tile_facing
    draw_x = tile_x * 16 - @pos_x + $window.width / 2
    draw_y = tile_y * 16 - @pos_y + $window.height / 2

    Gosu.draw_rect(draw_x, draw_y, 16, 16, Gosu::Color::GREEN, 2)

    # crosshair center of screen for alignment
    # Gosu.draw_rect(800 / 2, 0, 1, 600, Gosu::Color::RED, 2)
    # Gosu.draw_rect(0, 600 / 2, 800, 1, Gosu::Color::RED, 2)
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
