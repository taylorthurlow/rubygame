class Camera
  attr_accessor :pos_x, :pos_y, :zoom

  def initialize(target)
    @target = target
    @pos_x, @pos_y = target.pos_x, target.pos_y
    @zoom = 1
  end

  def update
    @pos_x += @target.speed if @pos_x < @target.pos_x - $window.width / 4
    @pos_x -= @target.speed if @pos_x > @target.pos_x + $window.width / 4
    @pos_y += @target.speed if @pos_y < @target.pos_y - $window.height / 4
    @pos_y -= @target.speed if @pos_y > @target.pos_y + $window.height / 4
  end

  def viewport
    x0 = @pos_x - ($window.width / 2) / @zoom
    x1 = @pos_x + ($window.width / 2) / @zoom
    y0 = @pos_y - ($window.height / 2) / @zoom
    y1 = @pos_y + ($window.height / 2) / @zoom

    return [x0, x1, y0, y1]
  end
end