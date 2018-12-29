class Human < Entity
  attr_accessor :pos_x, :pos_y, :direction, :physics, :sounds, :input

  def initialize(object_pool, input)
    GameObject.instance_method(:initialize).bind(self).call(object_pool)

    @input = input
    @input.control(self)
    @physics = HumanPhysics.new(self, object_pool)
    @graphics = HumanGraphics.new(self)
    @sounds = EntitySounds.new(self)
    @direction = :south

    @pos_x = 32 * 16
    @pos_y = 32 * 16
  end
end
