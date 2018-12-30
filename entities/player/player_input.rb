class PlayerInput < Component
  attr_accessor :moving_up, :moving_left, :moving_down, :moving_right

  def initialize(camera)
    super(nil)

    @camera = camera
    @motion_buttons = [Gosu::KB_W, Gosu::KB_A, Gosu::KB_S, Gosu::KB_D]
    @moving_up, @moving_left, @moving_down, @moving_right = false
  end

  def control(obj)
    self.object = obj
  end

  def update
    if any_button_down?(*@motion_buttons)
      object.physics.attempting_to_move = true
      @moving_up = Utils.button_down?(Gosu::KB_W)
      @moving_left = Utils.button_down?(Gosu::KB_A)
      @moving_down = Utils.button_down?(Gosu::KB_S)
      @moving_right = Utils.button_down?(Gosu::KB_D)
    else
      object.physics.attempting_to_move = false
    end
  end

  def button_down(id)
    case id
    when Gosu::KB_W
      object.direction = :north
    when Gosu::KB_A
      object.direction = :west
    when Gosu::KB_S
      object.direction = :south
    when Gosu::KB_D
      object.direction = :east
    when Gosu::KB_SPACE
      object.physics.tile_facing.interact
    end
  end

  def button_up(id)
    if any_button_down?(*@motion_buttons)
      object.direction = :north if Utils.button_down?(Gosu::KB_W)
      object.direction = :west if Utils.button_down?(Gosu::KB_A)
      object.direction = :south if Utils.button_down?(Gosu::KB_S)
      object.direction = :east if Utils.button_down?(Gosu::KB_D)
    end
  end

  private

  def any_button_down?(*buttons)
    buttons.each do |b|
      return true if Utils.button_down?(b)
    end

    return false
  end
end
