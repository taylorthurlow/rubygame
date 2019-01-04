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

  def transition_to_new_scene(new_scene)
    @physics.scene = new_scene
    @physics.set_position(new_scene.spawn[0], new_scene.spawn[1])
    new_scene.object_pool.objects << self
  end
end
