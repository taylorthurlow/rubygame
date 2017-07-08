class TileDoor < Tile

  def initialize(id)
    super(id)
    
    @tile_sprites = get_sprites
    @name = "Door"

    @state = :closed
  end

  def draw(draw_x, draw_y)
    z_index = @colliders.empty? ? 0 : draw_y

    case @state
    when :closed
      @current_frame = 0
    when :opening
      @current_frame += 1
      if @current_frame == 2
        @state = :open
      end
    when :open
      @current_frame = 3
    when :closing
      @current_frame -= 1
      if @current_frame == 1
        @state = :closed
      end
    end

    #puts "frame: #{@current_frame}, state: #{@state.to_s}"

    @tile_sprites[@current_frame].draw(draw_x, draw_y, z_index)
  end

  def interact
    super
    if @state == :closed
      puts 'opening door'
      @state = :opening
    elsif @state == :open
      puts 'closing door'
      @state = :closing
    end
  end

  private

  def get_sprites
    return Gosu::Image.load_tiles('assets/door.png', 16, 16, retro: true)
  end

end