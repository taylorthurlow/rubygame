class EntityGraphics < Component

  def initialize(game_object)
    super(game_object)

    @body = units('assets/mainguy.png')
    @current_frame = 0
  end

  def update
    advance_frame
  end

  def draw(viewport)
    if object.physics.moving? or object.physics.stopped_moving
      image = object.physics.stopped_moving ? get_animation[1] : get_animation[@current_frame % 3]
      image.draw(pos_x - 8, pos_y - 8, pos_y)
      object.physics.stopped_moving = false
    end

    draw_bounding_box if $debugging
  end

  private

  def units(path)
    @units = Gosu::Image.load_tiles(path, 16, 16, retro: true)
  end

  def draw_bounding_box
    # override
  end

  def get_animation
    case object.direction
    when :north
      return @units[9..11]
    when :west
      return @units[3..5]
    when :south
      return @units[0..2]
    when :east
      return @units[6..8]
    end
  end

  def advance_frame
    now = Gosu.milliseconds
    delta = now - (@last_frame ||= now)
    if delta > Utils.frame_delay
      @last_frame = now
    end
    @current_frame += (delta / Utils.frame_delay).floor
  end

  def done?
    @done ||= @current_frame >= 3 # 3 = anim size
  end

end