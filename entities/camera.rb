class Camera
  attr_accessor :pos_x, :pos_y

  def initialize(target)
    @target = target
    @pos_x, @pos_y = target.pos_x, target.pos_y
  end

  def update
    @pos_x += @target.speed if @pos_x < @target.pos_x - $window.width / 4
    @pos_x -= @target.speed if @pos_x > @target.pos_x + $window.width / 4
    @pos_y += @target.speed if @pos_y < @target.pos_y - $window.height / 4
    @pos_y -= @target.speed if @pos_y > @target.pos_y + $window.height / 4
  end
end