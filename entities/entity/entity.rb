class Entity < GameObject
  attr_accessor :physics, :graphics, :sounds

  def initialize(scene)
    super(scene)

    @physics = EntityPhysics.new(self, scene)
    @graphics = EntityGraphics.new(self)
    @sounds = EntitySounds.new(self)
  end

  def pos_x
    @physics.pos_x
  end

  def pos_y
    @physics.pos_y
  end

  def x
    @physics.x
  end

  def y
    @physics.y
  end

  def direction
    @physics.direction
  end
end
