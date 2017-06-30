class Human < Entity
  attr_accessor :pos_x, :pos_y, :direction, :physics, :sounds, :input

  def initialize(object_pool, input)
    super(object_pool)
    
    @input = input
    @input.control(self)
    @physics = EntityPhysics.new(self, object_pool)
    @graphics = HumanGraphics.new(self)
    @sounds = EntitySounds.new(self)
    @direction = :south

    @pos_x, @pos_y = [32 * 16, 32 * 16]
  end
 
end
