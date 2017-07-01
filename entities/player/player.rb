class Player < Human
  attr_accessor :pos_x, :pos_y, :direction, :physics, :sounds, :input

  def initialize(object_pool, input)
    super(object_pool, input)
    
    @input = input
    @input.control(self)
    @physics = HumanPhysics.new(self, object_pool)
    @graphics = HumanGraphics.new(self)
    @sounds = EntitySounds.new(self)
    @direction = :south
  end
 
end
