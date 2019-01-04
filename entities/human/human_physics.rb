class HumanPhysics < EntityPhysics
  def initialize(game_object, scene)
    Component.instance_method(:initialize).bind(self).call(game_object)

    @scene = scene
    @pos_x = scene.spawn[0] * 16 - 8
    @pos_y = scene.spawn[1] * 16 - 8
    @speed = 0.0
    @direction = :south
    @stopped_moving = true
    @colliders = [EntityCollider.new(10, 7, self)]
  end
end
