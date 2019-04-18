class EntityPhysics < Component
  attr_accessor :scene, :speed, :stopped_moving, :attempting_to_move, :pos_x,
                :pos_y, :colliders, :direction

  def initialize(game_object, scene)
    super(game_object)

    @scene = scene
    @pos_x = 30 * 16
    @pos_y = 30 * 16
    @speed = 0.0
    @direction = :south
    @stopped_moving = true
    @colliders = []
  end

  def object_pool
    @scene.object_pool
  end

  def map
    @scene.map
  end

  def input
    @object.input
  end

  def x
    @pos_x / 16
  end

  def y
    @pos_y / 16
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

    if facing_x <= map.width &&
       facing_x.positive? &&
       facing_y <= map.height &&
       facing_y.positive?
      return facing_x, facing_y
    else
      return nil
    end
  end

  def tile
    map.tile_at(x, y)
  end

  def tile_facing
    coord = coord_facing
    map.tile_at(coord[0], coord[1])
  end

  def tiles_facing(distance = 1)
    tiles = []
    distance.times do |i|
      coord = coord_facing(i + 1)
      tiles << map.tiles_at(coord[0], coord[1]) if coord
    end

    tiles.flatten
  end

  def set_position(x, y, pixel: false)
    if pixel
      @pos_x = x
      @pos_y = y
    else
      @pos_x = x * 16
      @pos_y = y * 16
    end
  end

  def update
    attempting_to_move ? accelerate : decelerate

    if @speed.positive?
      shift = Utils.adjust_speed(@speed).round

      dx = 0
      dy = 0
      dy -= shift if input.moving_up
      dx -= shift if input.moving_left
      dy += shift if input.moving_down
      dx += shift if input.moving_right

      magnitude = Math.sqrt(dx ** 2 + dy ** 2)

      if magnitude.positive?
        new_pos_x = @pos_x + (dx / magnitude)
        new_pos_y = @pos_y + (dy / magnitude)
      else
        new_pos_x = @pos_x + dx
        new_pos_y = @pos_y + dy
      end

      if can_move_to?(new_pos_x, new_pos_y)
        @pos_x = new_pos_x
        @pos_y = new_pos_y
      elsif can_move_to?(new_pos_x, pos_y)
        @pos_x = new_pos_x
      elsif can_move_to?(pos_x, new_pos_y)
        @pos_y = new_pos_y
      else
        # make a sound possibly
        @speed = 0.0
      end

      if tile != map.tile_at(x, y)
        # entering a new tile
      end
    end
  end

  def can_move_to?(pos_x, pos_y)
    old_pos_x = @pos_x
    old_pos_y = @pos_y
    @pos_x = pos_x
    @pos_y = pos_y

    map.surrounding_tiles(@pos_x / 16, @pos_y / 16).each do |t|
      return false if t.colliders.any? do |c|
        @colliders.any? { |ec| Collider.collision?(c, ec) }
      end
    end

    true
  ensure
    @pos_x = old_pos_x
    @pos_y = old_pos_y
  end

  def moving?
    if @speed.positive?
      @stopped_moving = false
      true
    else
      @stopped_moving ||= true
      false
    end
  end

  private

  def accelerate
    @speed += 1 if @speed < 2
  end

  def decelerate
    @speed -= 1 if @speed.positive?
  end
end
