class TileDoor < Tile
  def initialize(map, id: nil, sprite_id: nil)
    super(map, id: id, sprite_id: sprite_id)
  end

  def interact
    puts "Interacting with: #{self}" if $debugging
    if (open? && can_close?) || !open?
      new_tile = TileDoor.new(@map, id: other_door_open_state_id)
      @map.set_tile_at(@x, @y, new_tile, layer: :objects)
    else
      return false
    end

    true
  end

  def other_door_open_state_id
    closed? ? 10 : 9
  end

  def closed?
    @id == 9
  end

  def open?
    @id == 10
  end

  def can_close?
    # Temporarily set the door to the closed version so we can evaluate the
    # collider and the nearby entities
    new_tile = TileDoor.new(@map, id: other_door_open_state_id)
    @map.set_tile_at(@x, @y, new_tile, layer: :objects)

    new_tile.colliders.each do |tile_collider|
      @map.entities.each do |e|
        return false if e.physics.colliders.any? do |entity_collider|
          Collider.collision?(tile_collider, entity_collider)
        end
      end
    end

    true
  ensure
    # We're done evaluating the collider so we can set it back
    @map.set_tile_at(@x, @y, self, layer: :objects)
  end
end
