class Human < Entity
  attr_accessor :pos_x, :pos_y, :direction, :physics, :sounds, :input

  def initialize(scene, input)
    GameObject.instance_method(:initialize).bind(self).call(scene.object_pool)

    @input = input
    @input.control(self)
    @physics = HumanPhysics.new(self, scene.object_pool)
    @graphics = HumanGraphics.new(self)
    @sounds = EntitySounds.new(self)
    @direction = :south

    @pos_x = 32 * 16
    @pos_y = 32 * 16
  end

  def to_s
    "Player: #{pos_x / 16}, #{pos_y / 16} (#{pos_x}, #{pos_y}), Direction: #{direction}"
  end
end
