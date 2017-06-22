require_relative '../tile'

class TileGround < Tile

  def initialize(id)
    super(id)
    @name = "Ground"
    @traversible = true
  end

end