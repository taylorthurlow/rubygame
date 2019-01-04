class Scene
  attr_accessor :name, :map, :object_pool

  def initialize(name)
    @name = name
    @map = Map.new("maps/#{name_without_suffix}.json", 'maps/tileset.json')
    @object_pool = ObjectPool.new(@map)
  end

  def show
    # override me
  end

  def update
    @object_pool.objects.map(&:update)
    @object_pool.objects.reject!(&:removable?)
  end

  def draw(viewport)
    @map.draw(viewport)
    @object_pool.objects.map { |o| o.draw(viewport) }
  end

  def transition_to(new_scene_name)
    new_scene = Scene.generate(new_scene_name)
    prepare_transition_from(self)
    prepare_transition_to(new_scene)
    $window.scene = new_scene
  end

  def self.generate(new_scene_name)
    klass = Object.const_get(Utils.snake_to_pascal_case(new_scene_name))
    klass.new(new_scene_name)
  end

  def to_s
    name_without_suffix.split('_').map(&:capitalize).join(' ')
  end

  private

  def name_without_suffix
    @name.delete_suffix('_scene')
  end

  def prepare_transition_from(old_scene)
    # override me
  end

  def prepare_transition_to(new_scene)
    # override me
  end
end
