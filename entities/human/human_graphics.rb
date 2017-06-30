class HumanGraphics < Component
  
  FRAME_DELAY = 100 #milliseconds

  def initialize(game_object)
    super(game_object)

    @body = units('assets/mainguy.png')
    @current_frame = 0
  end

  def update
    chance = rand(1..100)
    if chance == 1
      object.direction = [:north, :east, :south, :west].sample
    end

    advance_frame
  end

  def draw(viewport)
    if object.physics.moving? or object.physics.stopped_moving
      image = object.physics.stopped_moving ? get_animation[1] : get_animation[@current_frame % 3]
      image.draw(pos_x - 8, pos_y - 8, 1)
      object.physics.stopped_moving = false
    end
  end

  private

  def units(path)
    @@units = Gosu::Image.load_tiles($window, path, 16, 16, false)
  end

  def get_animation
    case object.direction
    when :north
      return @@units[9..11]
    when :west
      return @@units[3..5]
    when :south
      return @@units[0..2]
    when :east
      return @@units[6..8]
    end
  end

  def advance_frame
    now = Gosu.milliseconds
    delta = now - (@last_frame ||= now)
    if delta > FRAME_DELAY
      @last_frame = now
    end
    @current_frame += (delta / FRAME_DELAY).floor
  end

  def done?
    @done ||= @current_frame >= 3 # 3 = anim size
  end

end