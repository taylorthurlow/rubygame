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
  
  def draw_bounding_box
    previous_coord = nil
    object.physics.box.each do |x, y|
      if previous_coord.nil?
        previous_coord = [
          pos_x + object.physics.box.last[0],
          pos_y + object.physics.box.last[1]
        ]
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