class TileDoor < Tile
  def initialize(world, id: nil, sprite_id: nil)
    super(world, id: id, sprite_id: sprite_id)
  end

  def interact
    puts "Interacting with: #{self}" if $debugging
    new_tile = TileDoor.new(@world, id: other_door_open_state_id)
    @world.set_tile_at(@x, @y, new_tile, layer: :objects)

    true
  end

  def other_door_open_state_id
    @id == 9 ? 10 : 9
  end
end
