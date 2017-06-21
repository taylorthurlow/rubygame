require 'gosu'

class WorldMap
  attr_accessor :on_screen, :off_screen
  MAP_FILE = 'maps/test.json'

  def initialize(window)
    @map = Gosu::Tiled.load_json(window, MAP_FILE)
  end

  def draw(pos_x, pos_y)
    @map.draw(pos_x, pos_y)
  end
end