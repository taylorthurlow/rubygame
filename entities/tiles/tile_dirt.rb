class TileDirt < Tile

  def initialize(id)
    super(id)
    @name = "Dirt"
    @traversible = true
  end

end