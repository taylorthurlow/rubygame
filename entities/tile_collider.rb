class TileCollider < Collider
  attr_accessor :tile

  def initialize(x, y, width, height, tile = nil)
    super(width, height)
    @x = x
    @y = y
    @tile = tile
  end

  def pos_x
    box[0]
  end

  def pos_y
    box[1]
  end

  def center
    [@tile.pos_x + @x + @width / 2, @tile.pos_y + @y + @height / 2]
  end

  def box
    [
      @tile.pos_x + @x, @tile.pos_y + @y,                    # top left
      @tile.pos_x + @x + @width, @tile.pos_y + @y,           # top right
      @tile.pos_x + @x + @width, @tile.pos_y + @y + @height, # bottom right
      @tile.pos_x + @x, @tile.pos_y + @y + @height,          # bottom left
    ]
  end

  def draw_bounding_box
    Utils.draw_box(@tile.pos_x + @x, @tile.pos_y + @y, @width, @height, 0xB0_FF00FF)
    Utils.draw_box(center[0] - 1, center[1] - 1, 2, 2, 0xFF_00FF00)
  end

  def to_s
    "#{super} - #{@tile.name}"
  end

  def self.new_from_json(collider)
    TileCollider.new(collider["x"],
                     collider["y"],
                     collider["width"],
                     collider["height"])
  end
end
