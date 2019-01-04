class Entity < GameObject
  attr_accessor :pos_x, :pos_y, :direction, :physics, :sounds

  def initialize(scene)
    super(scene)

    @physics = EntityPhysics.new(self, scene)
    @graphics = EntityGraphics.new(self)
    @sounds = EntitySounds.new(self)
    @direction = :south
  end
end
