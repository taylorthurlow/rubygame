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

  def self.rotate(angle, around_x, around_y, *points)
    result = []
    points.each_slice(2) do |x, y|
      r_x = Math.cos(angle) * (x - around_x) - Math.sin(angle) * (y - around_y) + around_x
      r_y = Math.sin(angle) * (x - around_x) - Math.cos(angle) * (y - around_y) + around_y
      result << r_x
      result << r_y
    end
    return result
  end

  def self.distance_between(x1, y1, x2, y2)
    dx = x1 - x2
    dy = y1 - y2
    return Math.sqrt(dx * dx + dy * dy)
  end

  def self.point_in_poly(testx, testy, *poly)
    nvert = poly.size # Number of vertices in poly
    vertx = []
    verty = []
    poly.each do |x, y|
      vertx << x
      verty << y
    end
    inside = false
    j = nvert - 1
    (0..nvert - 1).each do |i|
      # debugger if verty[i].nil? or verty[j].nil? or testy.nil?
      if (((verty[i] > testy) != (verty[j] > testy)) &&
        (testx < (vertx[j] - vertx[i]) * (testy - verty[i]) /
        (verty[j] - verty[i]) + vertx[i]))
        inside = !inside
      end
      j = i
    end
    return inside
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

end