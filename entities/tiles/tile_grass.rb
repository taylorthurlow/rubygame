class TileGrass < Tile
  def initialize(id)
    super(id)
    @name = 'Grass'
    @traversible = true
  end
end
