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
    previous_coord = nil
    object.physics.box.each do |x, y|
      if previous_coord.nil?
        previous_coord = [
          object.physics.box.last[0],
          object.physics.box.last[1]
        ]
      end
      
      $window.draw_line(
        previous_coord[0], previous_coord[1], Gosu::Color::RED,
        x,                 y,                 Gosu::Color::RED,
        9999)
      previous_coord = [x, y]
    end
  end

end