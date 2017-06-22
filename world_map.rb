require 'gosu'
require 'json'

class WorldMap
  attr_accessor :data

  def initialize
    @data = parse_map_json('maps/test.json')
    @images = Gosu::Image.load_tiles($window, 'assets/basictiles.png', 16, 16, true)
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
      tile_array = layer['data'].each_slice(data[:width]).map {|t| t}
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
        row.each_with_index do |col, x|
          # puts "drawing #{col} from #{layer.to_s} at (#{x}, #{y})" if col != 0
          pos_x = x * @data[:tile_size]
          pos_y = y * @data[:tile_size]
          #if camera.can_view?(pos_x, pos_y)
            @images[col-1].draw(pos_x, pos_y, 0)
          #end
        end
      end
    end
  end

  def can_move_to?(pos_x, pos_y)
    tnzt = get_top_nonzero_tile(pos_x, pos_y)
    if tnzt.nil?
      return false
    else
      return !collidable?(tnzt)
    end
  end

  def get_top_nonzero_tile(pos_x, pos_y)
    tnzt = nil
    tiles_at(pos_x, pos_y).each do |tile|
      tnzt = tile if tile != 0
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