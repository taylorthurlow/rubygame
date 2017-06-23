require 'gosu'
require 'json'
require_relative 'entities/tile'
Dir[File.dirname(__FILE__) + '/entities/tiles/*.rb'].each {|f| require f}

class WorldMap
  attr_accessor :data

  def initialize
    @data = parse_map_json('maps/test.json')
  end

  def parse_map_json(path)
    map_file = File.read(path)
    data_hash = JSON.parse(map_file)

    data = {
      width:      data_hash['width'],
      height:     data_hash['height'],
      tile_size:  data_hash['tileheight'],
      ground:     [],
      objects:    []
    }

    data_hash['layers'].each do |layer|
      tile_ids = layer['data'].each_slice(data[:width]).map {|t| t}
      tile_map = []
      tile_ids.each do |row|
        tile_map << row.map {|t| Tile.factory(t)}
      end
      data[layer['name'].to_sym] = tile_map
    end

    return data
  end

  def draw(camera)
    viewport = camera.viewport

    viewport.map! {|p| p / data[:tile_size]}
    x0, x1, y0, y1 = viewport.map(&:to_i)

    # restrict to prevent re-rendering
    x0 = 0 if x0 < 0
    x1 = data[:width] - 1 if x1 >= data[:width]
    y0 = 0 if y0 < 0
    y1 = data[:height] - 1 if y1 >= data[:height]

    (x0..x1).each do |x|
      (y0..y1).each do |y|
        [@data[:ground], @data[:objects]].each do |data|
          row = data[y]
          if row
            tile = data[y][x]
            if tile.id != 0
              tile.draw(x * @data[:tile_size], y * @data[:tile_size])
            else
              tile.drawn = false
            end

            tile.pos_x, tile.pos_y = x, y
          end
        end
      end
    end
  end

  def can_move_to?(x, y)
    traversible = true
    tiles_at(x, y).each {|t| traversible = false unless t.traversible?}
    return traversible
  end

  def tile_at(x, y)
    object = data[:objects][y][x]
    if object.id != 0
      return object
    else
      return data[:ground][y][x]
    end
  end
  
  def tiles_at(x, y)
    return [data[:ground][y][x], data[:objects][y][x]]
  end
end