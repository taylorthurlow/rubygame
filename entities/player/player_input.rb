class PlayerInput < Component
  attr_accessor :moving_up, :moving_left, :moving_down, :moving_right

  def initialize(camera)
    super(nil)

    @camera = camera
    @motion_buttons = [Gosu::KbW, Gosu::KbA, Gosu::KbS, Gosu::KbD]
    @moving_up, @moving_left, @moving_down, @moving_right = false
  end

  def control(obj)
    self.object = obj
  end

  def update
    if any_button_down?(*@motion_buttons)
      object.physics.attempting_to_move = true
      @moving_up = Utils.button_down?(Gosu::KbW)
      @moving_left = Utils.button_down?(Gosu::KbA)
      @moving_down = Utils.button_down?(Gosu::KbS)
      @moving_right = Utils.button_down?(Gosu::KbD)
    else
      object.physics.attempting_to_move = false
    end
  end

  def button_down(id)
    case id
    when Gosu::KbW
      object.direction = :north
    when Gosu::KbA
      object.direction = :west
    when Gosu::KbS
      object.direction = :south
    when Gosu::KbD
      object.direction = :east
    end
  end

  def button_up(id)
    if any_button_down?(*@motion_buttons)
      object.direction = :north if Utils.button_down?(Gosu::KbW)
      object.direction = :west if Utils.button_down?(Gosu::KbA)
      object.direction = :south if Utils.button_down?(Gosu::KbS)
      object.direction = :east if Utils.button_down?(Gosu::KbD)
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
