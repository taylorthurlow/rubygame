class Tile < Gosu::Image
  attr_accessor :id, :name, :x, :y, :drawn, :colliders

  def initialize(id)
    @@tile_sprites ||= Tile.get_tile_sprites

    @id = id
    @name = "Unnamed"
    @traversible = false
    @x = nil
    @y = nil
    
    @colliders = []
    @@tile_data ||= JSON.parse(File.read('maps/basictiles.json'))

    get_json_data unless id == 0
  end

  def pos_x; @x * 16 end
  def pos_y; @y * 16 end

  def traversible?; @traversible end

  def draw(draw_x, draw_y)
    z_index = @colliders.empty? ? 0 : draw_y
    @@tile_sprites[id - 1].draw(draw_x, draw_y, z_index)

    if $debugging
      draw_bounding_box
      font = Gosu::Font.new($window, Gosu.default_font_name, 6)
      #font.draw(z_index.to_s, draw_x, draw_y, 9999) if z_index != 0
    end
  end

  def interact
    # override
    puts "Player interacted with #{@name} tile @ #{@x}, #{@y}."
  end

  def to_s
    return "#{name} (#{id}) @ #{x}, #{y} #{traversible? ? 'T' : 'NT'}"
  end

  def self.factory(id)
    case id
    when 0; return TileEmpty.new(id)
    when (1..4), (214..218), (230..234), (246..248); return TileGrass.new(id)
    when (219..223), (235..239), (251..253); return TileDirt.new(id)
    when (209..213), (225..229), (241..243); return TileTree.new(id)
    when 5, 6; return TileWater.new(id)
    when 10; return TileDoor.new(id)
    end

    return Tile.new(id)
  end

  private
  
  def draw_bounding_box
    previous_coord = nil
    colliders.each do |collider|
      collider.each do |x, y|
        unless @x.nil? or @y.nil?
          if previous_coord.nil?
            previous_coord = [pos_x + collider.last[0], pos_y + collider.last[1]]
          end
          line_x = pos_x + x
          line_y = pos_y + y
          
          $window.draw_line(
            previous_coord[0], previous_coord[1], Gosu::Color::RED,
            line_x,            line_y,            Gosu::Color::RED,
            9999)
          previous_coord = [line_x, line_y]
        end
      end
    end
  end

  def self.get_tile_sprites
    return Gosu::Image.load_tiles('assets/basictiles.png', 16, 16, retro: true)
  end

  def get_json_data
    unless @@tile_data['tiles'][@id.to_s].nil?
      tile_hash = @@tile_data['tiles'][(@id - 1).to_s]
      unless tile_hash['objectgroup'].nil?
        tile_hash['objectgroup']['objects'].each do |ob|
          collider = []
          if !ob['polyline'].nil?
            # polyline
            rel_x = ob['x']
            rel_y = ob['y']
            ob['polyline'].each do |p|
              collider << [p['x'].to_i + rel_x, p['y'].to_i + rel_y]
            end
          else
            # rect
            w = ob['width'].to_i
            h = ob['height'].to_i
            x = ob['x'].to_i
            y = ob['y'].to_i
            collider << [x, y] << [x + w, y] << [x + w, y + h] << [x, y + h]
          end

          @colliders << collider
        end
      end
    end
  end

end
