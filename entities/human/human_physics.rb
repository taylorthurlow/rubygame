class EntityPhysics < Component
  attr_accessor :speed, :stopped_moving, :attempting_to_move

  def initialize(game_object, object_pool)
    super(game_object)

    @object_pool = object_pool
    @map = object_pool.map
    game_object.pos_x, game_object.pos_y = [30 * 16, 30 * 16]
    @speed = 0.0
    @stopped_moving = true
  end

  def update
    if attempting_to_move
      accelerate
    else
      decelerate
    end

    if @speed > 0
      new_pos_x, new_pos_y = pos_x, pos_y
      shift = Utils.adjust_speed(@speed)
      shift = shift.round
      new_pos_y -= shift if object.input.moving_up
      new_pos_x -= shift if object.input.moving_left
      new_pos_y += shift if object.input.moving_down
      new_pos_x += shift if object.input.moving_right

      if can_move_to?(new_pos_x.round / 16, new_pos_y.round / 16)
        object.pos_x, object.pos_y = new_pos_x, new_pos_y
      else
        # make a sound possibly
        @speed = 0.0
      end

    end
  end

  def can_move_to?(pos_x, pos_y)
    return @map.can_move_to?(pos_x, pos_y)
  end

  def moving?
    if @speed > 0
      @stopped_moving = false
      return true
    else
      @stopped_moving = true if !@stopped_moving
      return false
    end
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

  def tile_above; [x, y - 1] end
  def tile_left;  [x - 1, y] end
  def tile_below; [x, y + 1] end
  def tile_right; [x + 1, y] end

  private

  def accelerate
    @speed += 1 if @speed < 2
  end

  def decelerate
    @speed -= 1 if @speed > 0
  end

end