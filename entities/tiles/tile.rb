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
    @@tile_sprites[id - 1].draw(draw_x, draw_y, 0)
  end

  def to_s
    return "#{name} (#{id}) @ #{x}, #{y} #{traversible? ? 'T' : 'NT'}"
  end

  def self.factory(id)
    case id
    when 0; return TileEmpty.new(id)
    when 12, 13, 65, 66; return TileGrass.new(id)
    when 9, 10, 11, 17, 18; return TileGround.new(id)
    when 14; return TileWater.new(id)
    when 30, 38; return TileWaves.new(id)
    end

    return Tile.new(id)
  end

  private
  
  def self.get_tile_sprites
    Gosu::Image.load_tiles($window, 'assets/basictiles.png', 16, 16, true)
  end

end
