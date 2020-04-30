require "ruby-prof" if ENV["ENABLE_PROFILING"]
require "memory_profiler" if ENV["PROFILE_MEMORY"]

class PlayState < GameState
  attr_accessor :update_interval, :debugging, :player, :scene, :camera, :debug

  def initialize
    super
    @scene = Scene.generate("meadow_scene", self)
    @camera = Camera.new
    @last_draw = nil

    # player
    @player = Player.new(@scene, PlayerInput.new(@camera))
    @camera.target = @player

    # npcs
    # 1.times do
    #   Human.new(@object_pool, AiInput.new)
    # end

    @font = Gosu::Font.new(24, name: "monospace", bold: true)

    $debugging = false
    @debug = Debug.new(state: self, camera: @camera, player: @player)
  end

  def enter
    RubyProf.start if ENV["ENABLE_PROFILING"]
    MemoryProfiler.start if ENV["PROFILE_MEMORY"]
  end

  def leave
    RubyProf::FlatPrinter.new(RubyProf.stop).print(STDOUT) if ENV["ENABLE_PROFILING"]
    MemoryProfiler.stop.pretty_print(color_output: true, scale_bytes: true) if ENV["PROFILE_MEMORY"]
  end

  def update
    @scene.update
    @camera.update
    @debug.update if $debugging
  end

  def draw
    if fading
      super
      @last_draw.draw(0, 0, 9999, 1, 1)
    else
      @last_draw = Gosu.record($window.width, $window.height) do
        Utils.draw_scaled(@camera) do |viewport|
          @scene.draw(viewport)
        end
      end
    end

    @last_draw.draw(0, 0, 9999, 1, 1)

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
