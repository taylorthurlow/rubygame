require 'gosu'
require 'json'
require_relative 'entities/tile'
Dir[File.dirname(__FILE__) + '/entities/tiles/*.rb'].each {|f| require f}

class WorldMap
  attr_accessor :data, :tile_sprites

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
      tiles:      {}
    }

    # initialize layer hash with names
    data_hash['layers'].each do |layer|
      data[:tiles][layer['name'].to_sym] = []
    end

    # iterate layers in map, fill in data to tiles hash
    data_hash['layers'].each do |layer|
      tile_id_array = layer['data'].each_slice(data[:width]).map {|t| t}

      tile_array = []
      tile_id_array.each do |row|
        tile_array << row.map {|t| Tile.factory(t)}
      end

      data[:tiles][layer['name'].to_sym] = tile_array
    end

    return data
  end

  def draw(camera)

    @data[:tiles].each do |layer, data|
      data.each_with_index do |row, y|

        row.each_with_index do |tile, x|
          pos_x = x * @data[:tile_size]
          pos_y = y * @data[:tile_size]

          if tile.id != 0# and camera.can_view?(pos_x, pos_y)
            tile.draw(pos_x, pos_y)
          else
            tile.drawn = false
          end

          tile.pos_x, tile.pos_y = x, y
        end
      end
    end
  end

  def can_move_to?(x, y)
    tnzt = get_top_nonzero_tile(x, y)
    return tnzt.nil? ? false : tnzt.traversible?
  end

  def get_top_nonzero_tile(x, y)
    tnzt = nil
    tiles_at(x, y).each do |tile|
      tnzt = tile if tile.id != 0
    end
    
    return tnzt
  end

  def tile_at(x, y)
    @data[:tiles].reverse_each do |layer, data|
      return data[y][x] if data[y][x].id != 0
    end
  end
  
  def tiles_at(x, y)
    tiles = @data[:tiles].map {|layer, data| data[y][x]}
    return tiles.reject {|t| t.id == 0}
  end
end