class Debug
  def initialize(vars)
    vars.each { |name, value| instance_variable_set("@#{name}".to_sym, value) }
    @font = Gosu::Font.new(20)
    @line_height = 20
  end

  def update
    @tiles_facing = @player.physics.tiles_facing
  end

  def draw
    draw_fps_meter
    draw_debugging
    draw_select_highlight
  end

  def draw_select_highlight
    Utils.draw_scaled(@camera) do |viewport|
      Gosu.draw_rect(@tiles_facing.first.pos_x,
                     @tiles_facing.first.pos_y,
                     16,
                     16,
                     Gosu::Color.argb(0x3F_00FF00),
                     9999)
    end
  end

  private

  def draw_debug_line(line, text)
    @font.draw_text(text,
                    5,
                    line * @line_height - @line_height + 2,
                    9999,
                    1,
                    1,
                    Gosu::Color::YELLOW)
  end

  def draw_debugging
    draw_debug_line(1, "Memory: #{$window.memory_usage}")
    draw_debug_line(2, "Camera: #{@camera}")
    draw_debug_line(3, "Player: #{@player}")
    draw_debug_line(4, "Facing: #{@tiles_facing.map(&:id)}, #{@tiles_facing.last}")
    draw_debug_line(5, "Scene: #{@scene}")
  end

  def draw_fps_meter
    @font.draw_text_rel(Gosu.fps.to_s,
                        $window.width - 5,
                        2,
                        9999,
                        1.0,
                        0.0,
                        1,
                        1,
                        Gosu::Color::YELLOW)
  end
end
