class Entity < GameObject
  attr_accessor :pos_x, :pos_y, :direction, :physics, :sounds

  def initialize(object_pool)
    super(object_pool)

    @physics = EntityPhysics.new(self, object_pool)
    @graphics = EntityGraphics.new(self)
    @sounds = EntitySounds.new(self)
    @direction = :south
  end
end
