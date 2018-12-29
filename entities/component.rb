class Component
  def initialize(game_object = nil)
    self.object = game_object
  end

  def update; end

  def draw(viewport); end

  protected

  def pos_x
    @object.pos_x
  end

  def pos_y
    @object.pos_y
  end

  def x
    pos_x / 16
  end

  def y
    pos_y / 16
  end

  def object
    @object
  end

  # register with components array
  def object=(obj)
    if obj
      @object = obj
      obj.components << self
    end
  end
end
