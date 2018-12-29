class ObjectPool
  attr_accessor :objects, :map

  def initialize(map)
    @map = map
    @objects = []
  end

  def nearby(object, max_distance)
    @objects.select do |obj|
      distance = Utils.distance_between(obj.pos_x, obj.pos_y, object.pos_x, object.pos_y)
      obj != object && distance < max_distance
    end
  end

end
