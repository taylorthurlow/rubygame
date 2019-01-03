class Tile < Gosu::Image
  attr_accessor :id, :logic_class, :sprite_id, :sprite, :name, :x, :y, :colliders

  def initialize(world, id: nil, sprite_id: nil)
    # instantiate all class level variables if necessary
    Tile.preset_class_vars

    # load tile data from map JSON, will skip if path already loaded
    Tile.load_tile_data(world.map_path)

    # load metadata from previously loaded tile data given either an id or a
    # sprite id (only one of the two is necessary)
    metadata = Tile.metadata(id, sprite_id)

    @world = world
    @id = metadata['id']
    @sprite_id = metadata['sprite_id']
    @sprite_path = metadata['sprite_path']
    @name = metadata['name']
    @colliders = metadata['colliders'].map(&:clone)
    @colliders.each { |c| c.tile = self }
    @logic_class = metadata['class']
    @sprite = Tile.load_sprite(@sprite_path, @sprite_id)
  end

  def self.metadata(id, sprite_id)
    raise 'No ID supplied for metadata lookup.' if id.nil? && sprite_id.nil?

    if id
      @@tile_data[id]
    elsif sprite_id
      Tile.find_tile_by_sprite_id(sprite_id)
    end
  end

  def pos_x
    @x * 16
  end

  def pos_y
    @y * 16
  end

  def interact
    # override this
    false
  end

  def draw(draw_x, draw_y)
    # determine z-index based on y coordinate
    @sprite.draw(draw_x, draw_y, @colliders.empty? ? 0 : draw_y + 15) unless id.zero?
    @colliders.each(&:draw_bounding_box) if $debugging
  end

  def to_s
    "#{name} (#{self.class} SID: #{@sprite_id}) @ #{x}, #{y}"
  end

  # Load tile data from file, include id key as a value for convencience
  def self.load_tile_data(map_path)
    @@data_files_loaded ||= []
    return if @@data_files_loaded.include? map_path

    @@data_files_loaded << map_path
    JSON.parse(File.read(map_path))['tilesets'].each do |tileset|
      tileset['tiles'].each do |tile|
        properties = tile['properties'].to_h { |p| [p['name'], p['value']] }
        colliders = if tile['objectgroup']
                      tile['objectgroup']['objects'].map { |c| TileCollider.new_from_json(c) }
                    else
                      []
                    end

        @@tile_data[properties['game_id']] = {
          'id' => properties['game_id'],
          'name' => properties['name'],
          'sprite_id' => tile['id'],
          'sprite_path' => tileset['image'].gsub('../', ''),
          'colliders' => colliders,
          'class' => properties['class']
        }
      end
    end
  end

  def self.load_sprite(path, sprite_id)
    path ||= 'assets/basictiles.png'

    unless @@tile_sprites.key? path
      @@tile_sprites[path] = Gosu::Image.load_tiles(path, 16, 16, retro: true)
    end

    @@tile_sprites[path][sprite_id]
  end

  # Get a hash with id keys and sprite_id values
  def self.tile_ids
    @@tile_data.map { |id, data| [id, Array(data['sprite'])] }.to_h
  end

  def self.find_tile_by_sprite_id(sprite_id)
    @@tile_data.find { |_, d| d['sprite_id'] == sprite_id }&.fetch(1)
  end

  def self.preset_class_vars
    @@tile_data ||= {}
    @@data_files_loaded ||= []
    @@tile_ids ||= Tile.tile_ids
    @@tile_sprites ||= {}
  end
end
