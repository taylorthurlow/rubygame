class Scene
  attr_accessor :name, :map, :object_pool

  def initialize(name, state)
    @name = name
    @map = Map.new(self, "maps/#{name_without_suffix}.json", "maps/tileset.json")
    @object_pool = ObjectPool.new(@map)
    @state = state
  end

  def player
    @state.player
  end

  def camera
    @state.camera
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
    puts "Transitioning to #{new_scene_name}." if $debugging
    new_scene = Scene.generate(new_scene_name, @state)
    prepare_transition_from(self)
    prepare_transition_to(new_scene)
    $window.state.scene = new_scene
    camera.target = player
    @state.fade_out
  end

  def spawn
    # override me
  end

  def to_s
    name_without_suffix.split("_").map(&:capitalize).join(" ")
  end

  def prepare_transition_from(old_scene)
    # override me
  end

  def prepare_transition_to(new_scene)
    $window.state.player.transition_to_new_scene(new_scene)
  end

  def self.generate(new_scene_name, state)
    klass = Object.const_get(Utils.snake_to_pascal_case(new_scene_name))
    klass.new(new_scene_name, state)
  end

  private

  def name_without_suffix
    @name.delete_suffix("_scene")
  end
end
