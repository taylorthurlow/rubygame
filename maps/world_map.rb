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
      layers:     []
    }

    data_hash['layers'].each do |layer|
      tile_layer = TileLayer.new(layer['name'], data[:width], data[:height])
      tile_ids = layer['data'].each_slice(data[:width]).map {|t| t}

      tile_ids.each do |y|
        y.each do |x|
          tile_layer.add_tile(x)
        end
      end

      data[:layers] << tile_layer
    end

    return data
  end

  def draw(viewport)
    viewport.map! {|p| p / data[:tile_size]}
    x0, x1, y0, y1 = viewport.map(&:to_i)

    # restrict to prevent re-rendering
    x0 = 0 if x0 < 0
    x1 = data[:width] - 1 if x1 >= data[:width]
    y0 = 0 if y0 < 0
    y1 = data[:height] - 1 if y1 >= data[:height]

    (x0..x1).each do |x|
      (y0..y1).each do |y|

        data[:layers].each do |tl|
          tile = tl.tile(x, y)
          if tile.id != 0
            tile.draw(x * @data[:tile_size], y * @data[:tile_size])
          else
            tile.drawn = false
          end

          tile.x = x
          tile.y = y
        end

      end
    end

  end

  def nearby(object)
    near = []
    (object.x - 1..object.x + 1).each do |x|
      (object.y - 1..object.y + 1).each do |y|
        near << tiles_at(x, y)
      end
    end
    return near
  end

  def can_move_to?(x, y)
    traversible = true
    data[:layers].each do |layer|
      if !layer.tile(x, y).traversible?
        traversible = false
        return false
      end
    end

    return true
  end

  def tile_at(x, y)
    return tiles_at(x, y).last
  end
  
  def tiles_at(x, y)
    return data[:layers].map {|layer| layer.tile(x, y)}.delete_if {|t| t.is_a? TileEmpty}
  end
end