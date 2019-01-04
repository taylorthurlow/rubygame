class Player < Human
  attr_accessor :pos_x, :pos_y, :direction, :physics, :sounds, :input

  def initialize(scene, input)
    GameObject.instance_method(:initialize).bind(self).call(scene)

    @input = input
    @input.control(self)
    @physics = HumanPhysics.new(self, scene)
    @graphics = PlayerGraphics.new(self)
    @sounds = EntitySounds.new(self)
    @direction = :south
  end
end
