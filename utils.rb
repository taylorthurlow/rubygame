module Utils
  def self.draw_scaled(camera)
    off_x = $window.width / 2 - camera.pos_x
    off_y = $window.height / 2 - camera.pos_y

    $window.translate(off_x, off_y) do
      $window.scale(camera.zoom, camera.zoom, camera.pos_x, camera.pos_y) do
        yield(camera.viewport)
      end
    end
  end

  def self.media_path(file)
    File.join(File.dirname(file.dirname(__FILE__)), 'assets', file)
  end

  def self.frame_delay
    100 # milliseconds
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
    # divide by update_interval which corresponds to the 'intended' speed of the
    # game, which is 30fps (33.3333)
    speed * update_interval / 33.3333
  end

  def self.button_down?(button)
    $window.button_down?(button)
  end

  def self.rotate(angle, around_x, around_y, *points)
    result = []
    points.each_slice(2) do |x, y|
      r_x = Math.cos(angle) * (x - around_x) - Math.sin(angle) * (y - around_y) + around_x
      r_y = Math.sin(angle) * (x - around_x) - Math.cos(angle) * (y - around_y) + around_y
      result << r_x
      result << r_y
    end

    result
  end

  def self.distance_between(x1, y1, x2, y2)
    Math.sqrt((x1 - x2)**2 + (y1 - y2)**2)
  end

  def self.draw_box(x, y, width, height, color = 0x6F_FF00FF)
    $window.draw_rect(x, y, width, height, Gosu::Color.argb(color), 9999)
  end

  def self.direction_angle(direction)
    case direction
    when :north
      180
    when :east
      90
    when :south
      0
    when :west
      270
    end
  end

end
