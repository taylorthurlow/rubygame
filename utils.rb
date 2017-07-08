module Utils

  def self.media_path(file)
    File.join(File.dirname(file.dirname(__FILE__)), 'assets', file)
  end

  def self.frame_delay
    return 100 # milliseconds
  end

  def self.debug_colors
    return [
      Gosu::Color::RED,
      Gosu::Color::BLUE,
      Gosu::Color::YELLOW,
      Gosu::Color::WHITE
    ]
  end

  def self.track_update_interval
    now = Gosu.milliseconds
    @update_interval = (now - (@last_update ||= 0)).to_f
    @last_update = now
  end

  def self.update_interval
    @update_interval ||= $window.update_interval
  end

  def self.adjust_speed(speed)
    speed * update_interval / 33.33
  end

  def self.button_down?(button)
    return $window.button_down?(button)
  end

  def self.distance_between(x1, y1, x2, y2)
    dx = x1 - x2
    dy = y1 - y2
    return Math.sqrt(dx * dx + dy * dy)
  end

  def self.direction_angle(direction)
    case direction
    when :north
      return 180
    when :east
      return 90
    when :south
      return 0
    when :west
      return 270
    end
  end

  ## POINT IN POLY

  def self.point_in_poly(testx, testy, *poly)
    return false if outside_bounding_box?(testx, testy, *poly)

    point_in_poly = false
    i = -1
    j = poly.count - 1
    while (i += 1) < poly.count
      a_point_on_polygon = poly[i]
      trailing_point_on_polygon = poly[j]
      if point_is_between_the_ys_of_the_line_segment?([testx, testy], a_point_on_polygon, trailing_point_on_polygon)
        if ray_crosses_through_line_segment?([testx, testy], a_point_on_polygon, trailing_point_on_polygon)
          point_in_poly = !point_in_poly
        end
      end
      j = i
    end
    return point_in_poly
  end

  private

  def self.point_is_between_the_ys_of_the_line_segment?(point, a_point_on_polygon, trailing_point_on_polygon)
    (a_point_on_polygon[1] <= point[1] && point[1] < trailing_point_on_polygon[1]) || 
    (trailing_point_on_polygon[1] <= point[1] && point[1] < a_point_on_polygon[1])
  end

  def self.ray_crosses_through_line_segment?(point, a_point_on_polygon, trailing_point_on_polygon)
    (point[0] < (trailing_point_on_polygon[0] - a_point_on_polygon[0]) * (point[1] - a_point_on_polygon[1]) / (trailing_point_on_polygon[1] - a_point_on_polygon[1]) + a_point_on_polygon[0])
  end

  def self.outside_bounding_box?(x, y, *poly)
    max_x, max_y, min_x, min_y = nil
    x_coords = poly.map {|p| p[0]}
    y_coords = poly.map {|p| p[1]}

    max_x = x_coords.max
    max_y = y_coords.max
    min_x = x_coords.min
    min_y = y_coords.min
    
    return x < min_x || x > max_x || y < min_y || y > max_y
  end

end