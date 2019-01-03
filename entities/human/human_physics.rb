class HumanPhysics < EntityPhysics
  attr_accessor :speed, :stopped_moving, :attempting_to_move, :colliders,
                :width, :height

  def initialize(game_object, object_pool)
    Component.instance_method(:initialize).bind(self).call(game_object)

    @object_pool = object_pool
    @map = object_pool.map
    game_object.pos_x = 30 * 16
    game_object.pos_y = 30 * 16
    @speed = 0.0
    @stopped_moving = true
    @colliders = [EntityCollider.new(10, 4, self)]
  end

  def coord_facing(distance = 1)
    facing_x = x
    facing_y = y

    case object.direction
    when :north
      facing_y -= distance
    when :west
      facing_x -= distance
    when :south
      facing_y += distance
    when :east
      facing_x += distance
    end

    if facing_x <= @map.width &&
       facing_x.positive? &&
       facing_y <= @map.height &&
       facing_y.positive?
      return facing_x, facing_y
    else
      return nil
    end
  end

  def tile
    @map.tile_at(x, y)
  end

  def tile_facing
    coord = coord_facing
    @map.tile_at(coord[0], coord[1])
  end

  def tiles_facing(distance = 1)
    tiles = []
    distance.times do |i|
      coord = coord_facing(i + 1)
      tiles << @map.tiles_at(coord[0], coord[1]) if coord
    end

    tiles.flatten
  end
end
