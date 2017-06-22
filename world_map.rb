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
      colliders:  [],
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

    # get colliding tiles
    data_hash['tilesets'].first['tileproperties'].each do |tile|
      tile_id = tile[0].to_i
      properties = tile[1]
      collider = properties['Collision']
      data[:colliders] << tile_id if !collider.nil? and collider == 'true'
    end
    data[:colliders].sort

    return data
  end

  def draw(camera)
    @data[:tiles].each do |layer, data|
      data.each_with_index do |row, y|
        row.each_with_index do |tile, x|
          pos_x = x * @data[:tile_size]
          pos_y = y * @data[:tile_size]
          #if camera.can_view?(pos_x, pos_y)
            tile.draw(pos_x, pos_y)
            tile.pos_x, tile.pos_y = pos_x / 16, pos_y / 16
            #@tile_sprites[col-1].draw(pos_x, pos_y, 0)
          #end
        end
      end
    end
  end

  def can_move_to?(pos_x, pos_y)
    tnzt = get_top_nonzero_tile(pos_x, pos_y)
    return tnzt.nil? ? false : tnzt.traversible?
  end

  def get_top_nonzero_tile(pos_x, pos_y)
    tnzt = nil
    tiles_at(pos_x, pos_y).each do |tile|
      tnzt = tile if tile.id != 0
    end
    
    return tnzt
  end
  
  def tiles_at(pos_x, pos_y)
    tiles = []
    @data[:tiles].each do |layer, data|
      tiles << data[pos_y][pos_x]
    end

    return tiles
  end

  def collidable?(id)
    return @data[:colliders].include?(id - 1)
  end

end