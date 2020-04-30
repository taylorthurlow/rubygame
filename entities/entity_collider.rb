class EntityCollider < Collider
  attr_accessor :physics

  def initialize(width, height, physics)
    super(width, height)
    @physics = physics
  end

  def pos_x
    @physics.pos_x - @width / 2
  end

  def pos_y
    @physics.pos_y - @height / 2
  end

  def center
    [@physics.pos_x, @physics.pos_y]
  end

  def box
    [
      @physics.pos_x - @width / 2, @physics.pos_y - @height / 2, # top left
      @physics.pos_x + @width / 2, @physics.pos_y - @height / 2, # top right
      @physics.pos_x + @width / 2, @physics.pos_y + @height / 2, # bottom right
      @physics.pos_x - @width / 2, @physics.pos_y + @height / 2, # bottom left
    ]
  end

  def draw_bounding_box
    Utils.draw_box(box[0], box[1], @width, @height, 0xB0_FF00FF)
    Utils.draw_box(center[0] - 1, center[1] - 1, 2, 2, 0xFF_00FF00)
  end

  def to_s
    "EntityCollider #{@width}x#{@height}"
  end
end
