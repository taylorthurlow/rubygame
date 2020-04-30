class EntityGraphics < Component
  def initialize(game_object)
    super(game_object)

    @sprites = load_sprite("assets/mainguy.png")
    @current_frame = 0
  end

  def update
    advance_frame
  end

  def physics
    object.physics
  end

  def draw(_viewport)
    if physics.moving? || physics.stopped_moving
      select_frame.draw(physics.pos_x - 8, physics.pos_y - 12, physics.pos_y)
      physics.stopped_moving = false
    end

    if $debugging
      draw_bounding_box
      draw_position
    end
  end

  private

  def load_sprite(path)
    Gosu::Image.load_tiles(path, 16, 16, retro: true)
  end

  def draw_bounding_box
    physics.colliders.each(&:draw_bounding_box)
  end

  def draw_position
    Utils.draw_box(physics.pos_x - 1, physics.pos_y - 1, 2, 2, 0xFF_FF0000)
    Utils.draw_box(physics.x * 16, physics.y * 16, 16, 16, 0x45_000000)
  end

  def animation
    case physics.direction
    when :north
      @sprites[9..11]
    when :west
      @sprites[3..5]
    when :south
      @sprites[0..2]
    when :east
      @sprites[6..8]
    end
  end

  def select_frame
    if physics.stopped_moving
      animation[1]
    else
      animation[@current_frame % 3]
    end
  end

  def advance_frame
    now = Gosu.milliseconds
    delta = now - (@last_frame ||= now)
    @last_frame = now if delta > Utils.frame_delay
    @current_frame += (delta / Utils.frame_delay).floor
  end

  def done?
    @done ||= @current_frame >= 3 # 3 = anim size
  end
end
