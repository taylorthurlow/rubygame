require 'ruby-prof' if ENV['ENABLE_PROFILING']
require 'memory_profiler' if ENV['PROFILE_MEMORY']

class PlayState < GameState
  attr_accessor :update_interval, :debugging

  def initialize
    @map = WorldMap.new
    @camera = Camera.new
    @object_pool = ObjectPool.new(@map)

    # player
    @player = Player.new(@object_pool, PlayerInput.new(@camera))
    @camera.target = @player

    # npcs
    1.times do
      Human.new(@object_pool, AiInput.new)
    end

    # debugging
    $debugging = false
    @font = Gosu::Font.new(24, name: 'monospace', bold: true)
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

    if $debugging
      @tiles_facing = @player.physics.tiles_facing
      @tile_facing = @player.physics.tile_facing
    end
  end

  def draw
    cam_x = @camera.pos_x
    cam_y = @camera.pos_y
    off_x = $window.width / 2 - cam_x
    off_y = $window.height / 2 - cam_y
    viewport = @camera.viewport

    $window.translate(off_x, off_y) do
      $window.scale(@camera.zoom, @camera.zoom, cam_x, cam_y) do
        @map.draw(viewport)
        @object_pool.objects.map { |o| o.draw(viewport) }
        draw_select_highlight if $debugging
      end
    end

    @font.draw_text("FPS: #{Gosu.fps}", 0, 0, 9999, 1, 1, Gosu::Color::YELLOW)
    if $debugging
      player_info = "Player: #{@player.pos_x / 16}, #{@player.pos_y / 16} (#{@player.pos_x}, #{@player.pos_y}), Direction: #{@player.direction}"
      @font.draw_text($window.memory_usage, 0, 20, 9999, 1, 1, Gosu::Color::YELLOW)
      @font.draw_text("Camera: #{@camera.pos_x}, #{@camera.pos_y}", 0, 40, 9999, 1, 1, Gosu::Color::YELLOW)
      @font.draw_text(player_info, 0, 60, 9999, 1, 1, Gosu::Color::YELLOW)
      @font.draw_text("Facing: #{@tiles_facing.map(&:id)}, #{@tile_facing}", 0, 80, 9999, 1, 1, Gosu::Color::YELLOW)
    end
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
      @camera.zoom = 3 if @camera.zoom > 3
    end

    @player.input.button_down(id)
  end

  def button_up(id)
    @player.input.button_up(id)
  end

  private

  def draw_select_highlight
    tile = @player.physics.tile_facing
    Gosu.draw_rect(tile.pos_x, tile.pos_y, 16, 16, Gosu::Color.argb(0x3F_00FF00), 9999)
  end
end
