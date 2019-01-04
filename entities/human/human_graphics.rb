class HumanGraphics < EntityGraphics
  def initialize(game_object)
    Component.instance_method(:initialize).bind(self).call(game_object)

    human_sprites = [
      'assets/boy.png',
      'assets/girl.png'
    ]

    @sprites = load_sprite(human_sprites.sample)
    @current_frame = 0
  end

  def update
    physics.direction = [:north, :east, :south, :west].sample if rand(1..100) == 1

    advance_frame
  end
end
