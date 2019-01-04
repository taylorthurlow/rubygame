class Player < Human
  def initialize(scene, input)
    GameObject.instance_method(:initialize).bind(self).call(scene)

    @input = input
    @input.control(self)
    @physics = HumanPhysics.new(self, scene)
    @graphics = PlayerGraphics.new(self)
    @sounds = EntitySounds.new(self)
  end

  def transition_to_new_scene(new_scene)
    @physics.scene = new_scene
    @physics.set_position(new_scene.spawn[0], new_scene.spawn[1])
    new_scene.object_pool.objects << self
  end
end
