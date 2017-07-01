class PlayerGraphics < HumanGraphics

  def initialize(game_object)
    Component.instance_method(:initialize).bind(self).call(game_object)

    @body = units('assets/mainguy.png')
    @current_frame = 0
  end

  def update
    advance_frame
  end

end