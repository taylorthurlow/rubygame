class Player < Human
  attr_accessor :pos_x, :pos_y, :direction, :physics, :sounds, :input

  def initialize(object_pool, input)
    GameObject.instance_method(:initialize).bind(self).call(object_pool)

    @input = input
    @input.control(self)
    @physics = HumanPhysics.new(self, object_pool)
    @graphics = PlayerGraphics.new(self)
    @sounds = EntitySounds.new(self)
    @direction = :south
  end
end
