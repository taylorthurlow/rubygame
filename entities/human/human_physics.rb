class HumanPhysics < EntityPhysics
  attr_accessor :speed, :stopped_moving, :attempting_to_move

  def initialize(game_object, object_pool)
    Component.instance_method(:initialize).bind(self).call(game_object)

    @object_pool = object_pool
    @map = object_pool.map
    game_object.pos_x, game_object.pos_y = [30 * 16, 30 * 16]
    @speed = 0.0
    @stopped_moving = true
  end

  def box
    return [
      [pos_x - 8 + 4,  pos_y - 8 + 8 ],
      [pos_x - 8 + 12, pos_y - 8 + 8 ],
      [pos_x - 8 + 12, pos_y - 8 + 16],
      [pos_x - 8 + 4,  pos_y - 8 + 16]
    ]
  end

  def coord_facing
    facing_x, facing_y = x, y

    case object.direction
    when :north
      facing_y -= 1
    when :west
      facing_x -= 1
    when :south
      facing_y += 1
    when :east
      facing_x += 1
    end

    return facing_x, facing_y
  end

  def tile_facing
    coord = coord_facing
    return @map.tile_at(coord[0], coord[1])
  end

  def tiles_facing
    coord = coord_facing
    return @map.tiles_at(coord[0], coord[1])
  end

end