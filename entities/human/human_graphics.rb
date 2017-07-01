class HumanGraphics < EntityGraphics

  def initialize(game_object)
    Component.instance_method(:initialize).bind(self).call(game_object)

    human_sprites = [
      'assets/boy.png',
      'assets/girl.png'
    ]

    @body = units(human_sprites.sample)
    @current_frame = 0
  end

  def update
    if rand(1..100) == 1
      object.direction = [:north, :east, :south, :west].sample
    end

    advance_frame
  end

  private

  def draw_bounding_box
    i = 0
    object.physics.box.each_slice(2) do |x, y|
      color = Utils.debug_colors[i]
      $window.draw_triangle(
        x - 3, y - 3, color,
        x,     y,     color,
        x + 3, y - 3, color,
        9999)
      i = (i + 1) % 4
    end
  end

end