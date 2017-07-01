class TileLayer
  attr_accessor :name, :tiles

  def initialize(name, width, height)
    @name = name
    @width = width
    @height = height
    @tiles = []
  end

  def add_tile(id)
    if @tiles.last.nil?
      @tiles << []
    elsif @tiles.last.count == @width
      @tiles << []
    end

    @tiles.last << Tile.factory(id)
  end

  def set_tile(tile, x, y)
    @tiles[y][x] = tile
  end

  def tile(x, y)
    return @tiles[y][x]
  end

end