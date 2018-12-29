class TileEmpty < Tile
  def initialize(id)
    super(id)
    @name = 'Empty'
    @traversible = true
  end
end
