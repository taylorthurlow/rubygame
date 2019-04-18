class TileStairs < Tile
  def initialize(scene, id: nil, sprite_id: nil)
    super(scene, id: id, sprite_id: sprite_id)

    @font = Gosu::Font.new(8, bold: true)
  end

  def interact
    puts "Interacting with: #{self}" if $debugging
    teleport = find_teleport
    @scene.transition_to(teleport[:target_scene_name])
    @scene.player.physics.set_position(
      teleport[:target_pos_x],
      teleport[:target_pos_y],
      pixel: true
    )
    @scene.camera.target = @scene.player
  end

  def draw(draw_x, draw_y)
    super(draw_x, draw_y)
    @font.draw_text_rel(debug_text, draw_x + 8, draw_y + 8, 10000, 0.5, 0.5, 1, 1, 0xFF_FFFF00) if $debugging
  end

  private

  def find_teleport
    @scene.map.teleports.find { |t| t[:x] / 16 == @x && t[:y] / 16 == @y }
  end

  def debug_text
    teleport = find_teleport

    if teleport
      teleport[:target_scene_name]
    elsif $debugging
      puts "Tried finding a teleport for tile #{self}, but found nothing."
    end
  end
end
