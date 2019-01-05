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

  def physics
    object.physics
  end

  def update
    if any_button_down?(*@motion_buttons)
      return if $window.state.fading

      physics.attempting_to_move = true
      @moving_up = Utils.button_down?(Gosu::KB_W)
      @moving_left = Utils.button_down?(Gosu::KB_A)
      @moving_down = Utils.button_down?(Gosu::KB_S)
      @moving_right = Utils.button_down?(Gosu::KB_D)
    else
      physics.attempting_to_move = false
    end
  end

  def button_down(id)
    case id
    when Gosu::KB_W
      physics.direction = :north
    when Gosu::KB_A
      physics.direction = :west
    when Gosu::KB_S
      physics.direction = :south
    when Gosu::KB_D
      physics.direction = :east
    when Gosu::KB_RETURN
      new_name = $window.state.scene.name == 'cave_scene' ? 'meadow_scene' : 'cave_scene'
      $window.state.scene.transition_to(new_name)
    when Gosu::KB_SPACE
      interacted = physics.tile.interact
      physics.tiles_facing.each(&:interact) unless interacted
    end
  end

  def button_up(id)
    if any_button_down?(*@motion_buttons)
      physics.direction = :north if Utils.button_down?(Gosu::KB_W)
      physics.direction = :west if Utils.button_down?(Gosu::KB_A)
      physics.direction = :south if Utils.button_down?(Gosu::KB_S)
      physics.direction = :east if Utils.button_down?(Gosu::KB_D)
    end
  end

  private

  def any_button_down?(*buttons)
    buttons.each { |b| return true if Utils.button_down?(b) }

    false
  end
end
