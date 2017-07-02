class Tile < Gosu::Image
  attr_accessor :id, :name, :x, :y, :drawn

  def initialize(id)
    @@tile_sprites ||= Tile.get_tile_sprites

    @id = id
    @name = "Unnamed"
    @traversible = false
    @x = nil
    @y = nil
  end

  def pos_x; @x * 16 end
  def pos_y; @y * 16 end
  def traversible?; @traversible end

  def draw(draw_x, draw_y)
    z_index = traversible? ? 0 : draw_y
    @@tile_sprites[id - 1].draw(draw_x, draw_y, z_index)
  end

  def interact
    # override
    puts "Player interacted with #{@name} tile @ #{@x}, #{@y}."
  end

  def to_s
    return "#{name} (#{id}) @ #{x}, #{y} #{traversible? ? 'T' : 'NT'}"
  end

  def self.factory(id)
    case id
    when 0; return TileEmpty.new(id)
    when (1..4), (214..218), (230..234), (246..248); return TileGrass.new(id)
    when (219..223), (235..239), (251..253); return TileDirt.new(id)
    when (209..213), (225..229), (241..243); return TileTree.new(id)
    when 5, 6; return TileWater.new(id)
    when 10; return TileDoor.new(id)
    end

    return Tile.new(id)
  end

  private
  
  def self.get_tile_sprites
    return Gosu::Image.load_tiles('assets/basictiles.png', 16, 16, retro: true)
  end

end
