class GameState
  attr_accessor :paused

  def initialize
    @paused = false
    @fade = 0
    @fading_out = false
    @fading_in = false
  end

  def self.switch(new_state)
    $window.state&.leave
    $window.state = new_state
    new_state.enter
  end

  def enter; end

  def leave; end

  def update; end

  def button_down(id); end

  def button_up(id); end

  def draw(speed = 10)
    if @fade.positive?
      $window.draw_rect(0,
                        0,
                        $window.width,
                        $window.height,
                        Gosu::Color.argb(@fade, 0, 0, 0),
                        10_000)
    end

    if @fade >= 255
      @fading_out = false
      draw # do a first draw of the new scene, because normal draw won't trigger
      @fading_in = true
    elsif @fade <= 0
      @fading_in = false
    end

    @fade += speed if @fading_out
    @fade -= speed if @fading_in
  end

  def fade_out
    @fading_out = true
  end

  def fading
    @fading_out || @fading_in
  end

  def needs_update?
    !@paused && !fading
  end

  def needs_redraw?
    true
  end
end
