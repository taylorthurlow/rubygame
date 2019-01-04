class Human < Entity
  attr_accessor :input

  def initialize(scene, input)
    GameObject.instance_method(:initialize).bind(self).call(scene.object_pool)

    @input = input
    @input.control(self)
    @physics = HumanPhysics.new(self, scene.object_pool)
    @graphics = HumanGraphics.new(self)
    @sounds = EntitySounds.new(self)
  end

  def to_s
    "Player: #{x}, #{y} (#{pos_x}, #{pos_y}), Direction: #{direction}"
  end
end
