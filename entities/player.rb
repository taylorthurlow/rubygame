require 'gosu'

class Player
  attr_accessor :direction

  FRAME_DELAY = 50 #milliseconds

  def initialize(play_state)
    @play_state = play_state
    @anims = load_animation
    @current_frame = 0

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
    return frame_expired?
  end

  def draw
    if is_moving? or @stopped_moving
      image = @stopped_moving ? get_animation[1] : get_animation[@current_frame % 3]
      image.draw($window.width / 2, $window.height / 2, 1)
      @stopped_moving = false
    end
  end

  private

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
