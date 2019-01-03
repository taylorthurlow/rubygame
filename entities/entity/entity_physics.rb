class EntityPhysics < Component
  attr_accessor :speed, :stopped_moving, :attempting_to_move

  def initialize(game_object, object_pool)
    super(game_object)

    @object_pool = object_pool
    @map = object_pool.map
    game_object.pos_x = 30 * 16
    game_object.pos_y = 30 * 16
    @speed = 0.0
    @stopped_moving = true
    @colliders = []
  end

  def pos_x
    object.pos_x
  end

  def pos_y
    object.pos_y
  end

  def update
    attempting_to_move ? accelerate : decelerate

    if @speed.positive?
      new_pos_x = pos_x
      new_pos_y = pos_y
      shift = Utils.adjust_speed(@speed).round
      new_pos_y -= shift if object.input.moving_up
      new_pos_x -= shift if object.input.moving_left
      new_pos_y += shift if object.input.moving_down
      new_pos_x += shift if object.input.moving_right

      if can_move_to?(new_pos_x, new_pos_y)
        object.pos_x = new_pos_x
        object.pos_y = new_pos_y
      elsif can_move_to?(new_pos_x, pos_y)
        object.pos_x = new_pos_x
      elsif can_move_to?(pos_x, new_pos_y)
        object.pos_y = new_pos_y
      else
        # make a sound possibly
        @speed = 0.0
      end
    end
  end

  def can_move_to?(pos_x, pos_y)
    old_pos_x = object.pos_x
    old_pos_y = object.pos_y
    object.pos_x = pos_x
    object.pos_y = pos_y

    # @object_pool.nearby(object, 100).each do |obj|
    #   next unless collides_with_poly?(obj.physics.box)

    #   # helps get unstuck by only blocking movement towards the colliding
    #   # object. walking away from it should be unrestricted. potentially some
    #   # room for exploitation here, though
    #   old_distance = Utils.distance_between(obj.pos_x, obj.pos_y, old_pos_x, old_pos_y)
    #   new_distance = Utils.distance_between(obj.pos_x, obj.pos_y, pos_x, pos_y)
    #   return false if new_distance < old_distance
    # end

    @map.surrounding_tiles(object.pos_x / 16, object.pos_y / 16).each do |t|
      return false if t.colliders.any? do |c|
        @colliders.any? { |ec| Collider.collision?(c, ec) }
      end
    end

    true
  ensure
    object.pos_x = old_pos_x
    object.pos_y = old_pos_y
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

  def tile_above
    [x, y - 1]
  end

  def tile_left
    [x - 1, y]
  end

  def tile_below
    [x, y + 1]
  end

  def tile_right
    [x + 1, y]
  end

  private

  def accelerate
    @speed += 1 if @speed < 2
  end

  def decelerate
    @speed -= 1 if @speed.positive?
  end
end
