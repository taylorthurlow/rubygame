class HumanPhysics < Component
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

      if can_move_to?(new_pos_x.round, new_pos_y.round)
        object.pos_x, object.pos_y = new_pos_x, new_pos_y
      else
        # make a sound possibly
        @speed = 0.0
      end

    end
  end

  def box
    # standard human textures are 16x16, but the actual sprite is
    # only 10 pixels wide (3px blank, 10px content, 3px blank)
    # 
    # additionally, top half of sprite is not collidable to prevent
    # head from colliding with objects
  
    w = 8 / 2
    h = 16 / 2
    
    return [
      pos_x - w,     pos_y    ,     # top left
      pos_x + w,     pos_y    ,     # top right
      pos_x + w,     pos_y + h,     # bottom right
      pos_x - w,     pos_y + h,     # bottom left
    ]
  end

  def can_move_to?(pos_x, pos_y)
    old_pos_x, old_pos_y = object.pos_x, object.pos_y
    object.pos_x = pos_x
    object.pos_y = pos_y

    return false unless @map.can_move_to?(pos_x / 16, pos_y / 16)

    @object_pool.nearby(object, 100).each do |obj|
      if collides_with_poly?(obj.physics.box)
        # helps get unstuck
        old_distance = Utils.distance_between(obj.pos_x, obj.pos_y, old_pos_x, old_pos_y)
        new_distance = Utils.distance_between(obj.pos_x, obj.pos_y, pos_x, pos_y)
        return false if new_distance < old_distance
      end
    end

    return true
  ensure
    object.pos_x = old_pos_x
    object.pos_y = old_pos_y
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

  def collides_with_poly?(poly)
    if poly
      poly.each_slice(2) do |x, y|
        return true if Utils.point_in_poly(x, y, *box)
      end
      box.each_slice(2) do |x, y|
        return true if Utils.point_in_poly(x, y, *poly)
      end

      return false
    end
  end

  def accelerate
    @speed += 1 if @speed < 2
  end

  def decelerate
    @speed -= 1 if @speed > 0
  end

end