class WorldMap
  attr_accessor :data

  def initialize
    @data = parse_map_json('maps/test.json')
  end

  def parse_map_json(path)
    map_file = File.read(path)
    data_hash = JSON.parse(map_file)

    data = {
      width: data_hash['width'],
      height: data_hash['height'],
      tile_size: data_hash['tileheight'],
      ground: [],
      objects: []
    }

    data_hash['layers'].each do |layer|
      tile_ids = layer['data'].each_slice(data[:width]).map { |t| t }
      data[layer['name'].to_sym] = tile_ids.map { |row| row.map { |t| Tile.new(Tile.metadata(sprite_id: t)) } }
    end

    data
  end

  def draw(viewport)
    viewport.map! { |p| p / data[:tile_size] }
    x0, x1, y0, y1 = viewport.map(&:to_i)

    # restrict to prevent re-rendering
    x0 = 0 if x0.negative?
    x1 = data[:width] - 1 if x1 >= data[:width]
    y0 = 0 if y0.negative?
    y1 = data[:height] - 1 if y1 >= data[:height]

    (x0..x1).each do |x|
      (y0..y1).each do |y|
        if data[:ground][y][x]
          if data[:ground][y][x].id != 0
            data[:ground][y][x].draw(x * @data[:tile_size], y * @data[:tile_size])
          end

          data[:ground][y][x].x = x
          data[:ground][y][x].y = y
        end

        if data[:objects][y][x]
          if data[:objects][y][x].id != 0
            data[:objects][y][x].draw(x * @data[:tile_size], y * @data[:tile_size])
          end

          data[:objects][y][x].x = x
          data[:objects][y][x].y = y
        end
      end
    end
  end

  def can_move_to?(x, y)
    (data[:objects][y][x].traversible? && data[:ground][y][x].traversible?)
  end

  def tile_at(x, y)
    if data[:objects][y][x].id != 0
      data[:objects][y][x]
    else
      data[:ground][y][x]
    end
  end

  def tiles_at(x, y)
    [data[:ground][y][x], data[:objects][y][x]]
  end
end
