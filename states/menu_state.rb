require "singleton"

class MenuState < GameState
  include Singleton
  attr_accessor :play_state

  def initialize
    @message = Gosu::Image.from_text("some stupid ruby game", 40)
  end

  def enter
    # start music here
  end

  def leave
    # stop music here
  end

  def update
    continue_text = @play_state ? "c = continue, " : ""
    @info = Gosu::Image.from_text("q = quit, #{continue_text}n = new Game", 30)
  end

  def button_down(id)
    case id
    when Gosu::KB_ESCAPE, Gosu::KB_Q
      $window.close
    when Gosu::KB_N
      @play_state = PlayState.new
      GameState.switch(@play_state)
    when Gosu::KB_C
      GameState.switch(@play_state) if @play_state
    end
  end

  def button_up(id); end

  def draw
    @message.draw($window.width / 2 - @message.width / 2, $window.height / 2 - @message.height / 2, 10)
    @info.draw($window.width / 2 - @info.width / 2, $window.height / 2 - @info.height / 2 + 200, 10)
  end

  def needs_redraw?
    true
  end
end
