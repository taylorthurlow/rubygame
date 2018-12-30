require 'yaml'

class Tile < Gosu::Image
  attr_accessor :id, :sprite_id, :sprite, :name, :x, :y

  def initialize(metadata, world)
    @@tile_ids ||= Tile.tile_ids
    @@tile_sprites ||= { 'missing' => 'assets/missing.png' }
    @@tile_data ||= Tile.load_tile_data

    @world = world
    @id = metadata['id']
    @sprite_id = Array(metadata['sprite']).sample
    @name = metadata['name']
    @traversible = metadata['traversible']
    @sprite = Tile.load_sprite(metadata['sprite_path'], @sprite_id)

    @x = nil
    @y = nil
  end

  def pos_x
    @x * 16
  end

  def pos_y
    @y * 16
  end

  def traversible?
    @traversible
  end

  def interact
    # override this
  end

  def draw(draw_x, draw_y)
    # determine z-index based on y coordinte
    @sprite.draw(draw_x, draw_y, @traversible ? 0 : draw_y) unless id.zero?
  end

  def to_s
    "#{name} (#{self.class} SID: #{@sprite_id}) @ #{x}, #{y} #{@traversible ? 'T' : 'NT'}"
  end

  # Get tile metadata given an id or sprite_id
  def self.metadata(id: nil, sprite_id: nil)
    @@tile_data ||= load_tile_data
    raise 'No ID supplied for metadata lookup.' if id.nil? && sprite_id.nil?

    if id
      @@tile_data[id] || @@tile_data[0]
    elsif sprite_id
      data = @@tile_data.find { |_, d| Array(d['sprite']).include? sprite_id }
      data&.fetch(1) || @@tile_data[0]
    end
  end

  # Load tile data from yaml, include id key as a value for convencience
  def self.load_tile_data
    data = YAML.safe_load(File.open('entities/tiles/tile_data.yaml'))['tiles']
    data.each { |id, d| d.merge!('id' => id) }
  end

  def self.load_sprite(path, sprite_id)
    path ||= 'assets/basictiles.png'

    unless @@tile_sprites.key? path
      @@tile_sprites[path] = Gosu::Image.load_tiles(path, 16, 16, retro: true)
    end

    @@tile_sprites[path][sprite_id - 1]
  end

  # Get a hash with id keys and sprite_id values
  def self.tile_ids
    @@tile_data.map { |id, data| [id, Array(data['sprite'])] }.to_h
  end
end
