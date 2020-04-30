class PlayerGraphics < HumanGraphics
  def initialize(game_object)
    Component.instance_method(:initialize).bind(self).call(game_object)

    @sprites = load_sprite("assets/mainguy.png")
    @current_frame = 0
  end

  def update
    advance_frame
  end
end
