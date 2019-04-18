class GameWindow < Gosu::Window
  attr_accessor :state

  WINDOW_WIDTH = 1920
  WINDOW_HEIGHT = 1080

  def initialize
    super(WINDOW_WIDTH, WINDOW_HEIGHT)
    self.caption = 'some stupid ruby game'
    self.fullscreen = true

    @memory_usage = nil
    @memory_last_updated = Gosu.milliseconds
  end

  def update
    Utils.track_update_interval
    @state.update if @state.needs_update?
  end

  def button_down(id)
    @state.button_down(id)
  end

  def button_up(id)
    @state.button_up(id)
  end

  def needs_redraw?
    @state.needs_redraw?
  end

  def draw
    @state.draw if @state.needs_redraw?
  end

  def memory_usage
    if Gosu.milliseconds - @memory_last_updated >= 1000
      @memory_last_updated = Gosu.milliseconds
      @memory_usage = `ps -o rss= -p #{Process.pid}`.chomp.gsub(/(\d)(?=(\d{3})+(\..*)?$)/, '\1,') + ' KB'
    end

    @memory_usage || 'Unknown'
  end
end
