require 'ruby-prof' if ENV['ENABLE_PROFILING']
require 'memory_profiler' if ENV['PROFILE_MEMORY']

class PlayState < GameState
  attr_accessor :update_interval, :debugging

  def initialize
    @map = WorldMap.new('maps/cave.json', 'maps/tileset.json')
    @camera = Camera.new
    @object_pool = ObjectPool.new(@map)

    # player
    @player = Player.new(@object_pool, PlayerInput.new(@camera))
    @map.entities << @player
    @camera.target = @player

    # npcs
    # 1.times do
    #   Human.new(@object_pool, AiInput.new)
    # end

    @font = Gosu::Font.new(24, name: 'monospace', bold: true)

    $debugging = false
    @debug = Debug.new(camera: @camera, player: @player, world: @world)
  end

  def enter
    RubyProf.start if ENV['ENABLE_PROFILING']
    MemoryProfiler.start if ENV['PROFILE_MEMORY']
  end

  def leave
    RubyProf::FlatPrinter.new(RubyProf.stop).print(STDOUT) if ENV['ENABLE_PROFILING']
    MemoryProfiler.stop.pretty_print(color_output: true, scale_bytes: true) if ENV['PROFILE_MEMORY']
  end

  def update
    @object_pool.objects.map(&:update)
    @object_pool.objects.reject!(&:removable?)
    @camera.update
    @debug.update if $debugging
  end

  def draw
    Utils.draw_scaled(@camera) do |viewport|
      @map.draw(viewport)
      @object_pool.objects.map { |o| o.draw(viewport) }
    end

    @debug.draw if $debugging
  end

  def button_down(id)
    case id
    when Gosu::KB_Q
      leave
      $window.close
    when Gosu::KB_ESCAPE
      GameState.switch(MenuState.instance)
    when Gosu::KB_E
      $debugging = !$debugging
    when Gosu::KB_0
      @camera.zoom = 2
    when Gosu::KB_MINUS
      @camera.zoom -= 1
      @camera.zoom = 1 if @camera.zoom < 1
    when Gosu::KB_EQUALS
      @camera.zoom += 1
      @camera.zoom = 6 if @camera.zoom > 6
    end

    @player.input.button_down(id)
  end

  def button_up(id)
    @player.input.button_up(id)
  end
end
