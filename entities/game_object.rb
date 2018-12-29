class GameObject
  attr_accessor :components, :object_pool

  def initialize(object_pool)
    @components = []
    @object_pool = object_pool
    @object_pool.objects << self
  end

  def update
    @components.map(&:update)
  end

  def draw(viewport)
    @components.each { |c| c.draw(viewport) }
  end

  def removable?
    @removable
  end

  def mark_for_removal
    @removable = true
  end
end
