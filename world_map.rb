require 'gosu'

class WorldMap

  def initialize
    @map = Gosu::Tiled.load_json($window, 'maps/test.json')
  end

  def draw(pos_x, pos_y)
    @map.draw(pos_x, pos_y)
  end
end