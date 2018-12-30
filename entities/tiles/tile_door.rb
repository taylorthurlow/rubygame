class TileDoor < Tile
  def initialize(metadata, world)
    super(metadata, world)
  end

  def interact
    puts "Interacting with: #{self}"
    new_id = open? ? 6 : 5
    new_tile = TileDoor.new(Tile.metadata(id: new_id), @world)
    @world.set_tile_at(@x, @y, new_tile, object: true)
  end

  def open?
    @id == 5
  end
end
