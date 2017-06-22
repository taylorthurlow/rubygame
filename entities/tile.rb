require 'gosu'

class Tile < Gosu::Image
  attr_accessor :id, :name, :pos_x, :pos_y

  def initialize(id)
    @@tile_sprites ||= Tile.get_tile_sprites

    @id = id
    @name = "Unnamed"
    @traversible = false
    @pos_x = nil
    @pos_y = nil
  end

  def traversible?; @traversible end

  def draw(draw_x, draw_y)
    @@tile_sprites[id - 1].draw(draw_x, draw_y, 0)
  end

  def to_s
    return "#{name} (#{id}) @ #{pos_x}, #{pos_y} #{traversible? ? 'T' : 'NT'}"
  end

  def self.factory(id)
    case id
    when 12, 13, 65, 66; return TileGrass.new(id)
    when 9, 10, 11, 17, 18; return TileGround.new(id)
    when 14, 30, 38; return TileWater.new(id)
    end

    return Tile.new(id)
  end

  private
  
  def self.get_tile_sprites
    Gosu::Image.load_tiles($window, 'assets/basictiles.png', 16, 16, true)
  end

end
