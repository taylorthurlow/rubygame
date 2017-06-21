require 'gosu'

class WorldMap

  def initialize
    @map = Gosu::Tiled.load_json($window, 'maps/test.json')
    @map_width = @map.width / 16
    @map_height = @map.height / 16

    @collider_ids = []
    256.times do |i|
      unless @map.tilesets.properties(i).nil? or @map.tilesets.properties(i).empty?
        # debugger
        @collider_ids << i if @map.tilesets.properties(i)['Collision'] == 'true'
      end
    end
  end

  def draw(pos_x, pos_y)
    @map.draw(pos_x, pos_y)
  end

  def can_move_to?(tile_pos_x, tile_pos_y)
    tiles = tiles_at(tile_pos_x, tile_pos_y)

    found_nonzero_tile = false
    top_nonzero_tile = nil
    tiles.reverse.each do |tile|
      break unless top_nonzero_tile.nil?
      top_nonzero_tile = tile if tile != 0
    end

    puts "top nonzero: #{top_nonzero_tile}"

    if top_nonzero_tile.nil?
      return false
    else
      return !collidable?(top_nonzero_tile)
    end
  end

  def collidable?(id)
    return @collider_ids.include?(id)
  end
  
  def tiles_at(tile_pos_x, tile_pos_y)
    tiles = []
    @map.data['layers'].each do |layer|
      if layer['type'] == 'tilelayer'
        offset = tile_pos_y * @map_width + tile_pos_x
        tiles << layer['data'][offset]
      end
    end
    return tiles;
  end
end