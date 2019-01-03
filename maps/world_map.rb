class WorldMap
  attr_accessor :data_hash, :map_path, :layers, :width, :height

  def initialize(map_path)
    @data_hash = load_map(map_path)
    @map_path = map_path
    @tile_size = data_hash['tilewidth']
    @width = data_hash['width']
    @height = data_hash['height']
    @layers = parse_map(data_hash)
  end

  # Consume the data hash directly from Tiled and construct tile objects to
  # form the map, returning the a hash containing each layer
  def parse_map(data_hash)
    data = {}
    data_hash['layers'].each do |layer|
      tile_ids = layer['data'].each_slice(@width)
      data[layer['name'].to_sym] = tile_ids.each_with_index.map do |row, i|
        row.each_with_index.map do |t, j|
          if t.zero?
            nil # essentially means no tile here, blank
          else
            tile = Tile.new(self, sprite_id: t - 1)
            tile = Object.const_get(tile.logic_class).new(self, sprite_id: t - 1) if tile.logic_class
            tile.x = j
            tile.y = i
            tile
          end
        end
      end
    end

    data
  end

  # Perform the draw of the map data onto the screen
  def draw(viewport)
    viewport.map! { |p| p / @tile_size }
    x0, x1, y0, y1 = viewport.map(&:to_i)

    # restrict to prevent re-rendering
    x0 = 0 if x0.negative?
    x1 = @width - 1 if x1 >= @width
    y0 = 0 if y0.negative?
    y1 = @height - 1 if y1 >= @height

    (x0..x1).each do |x|
      (y0..y1).each do |y|
        @layers.each do |_, tiles|
          next unless tiles[y][x]

          tiles[y][x].draw(x * @tile_size, y * @tile_size) if tiles[y][x].id != 0
          # tiles[y][x].x = x
          # tiles[y][x].y = y
        end
      end
    end
  end

  # Set the tile at a given coordinate pair and layer to a new tile
  def set_tile_at(x, y, new_tile, layer: :ground)
    new_tile.x = x
    new_tile.y = y
    @layers[layer][y][x] = new_tile
  end

  # Get the topmost tile at a given coordinate pair
  def tile_at(x, y)
    tiles_at(x, y).last
  end

  # Get a list of tiles at a given coordinate pair, in order of bottom to top
  def tiles_at(x, y)
    @layers.map { |_, tiles| tiles[y][x] }.compact
  end

  # Get a list of all tiles surrounding a tile at a given coordinate pair,
  # including the tile itself, from all layers
  def surrounding_tiles(x, y)
    diffs = [
      [-1, -1], [0, -1], [1, -1],
      [-1, 0], [0, 0], [1, 0],
      [-1, 1], [0, 1], [1, 1]
    ]

    diffs.map { |dx, dy| tiles_at(x + dx, y + dy) }.flatten
  end

  private

  def load_map(path)
    JSON.parse(File.read(path))
  end
end
