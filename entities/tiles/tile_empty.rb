require_relative '../tile'

class TileEmpty < Tile

  def initialize(id)
    super(id)
    @name = "Empty"
  end

end