require 'gosu'
require 'gosu_tiled'

class GameWindow < Gosu::Window
  MAP_FILE = File.join(File.dirname(__FILE__), 'maps/test.json')

  def initialize
    super(800, 600, false)
    puts MAP_FILE
    @map = Gosu::Tiled.load_json(self, 'maps/test.json')
    @x = @y = 0
    @speed = 3
    @first_render = true
  end

  def update
    @x -= @speed if button_down?(Gosu::KbLeft)
    @x += @speed if button_down?(Gosu::KbRight)
    @y -= @speed if button_down?(Gosu::KbUp)
    @y += @speed if button_down?(Gosu::KbDown)
    self.caption = "#{Gosu.fps} FPS. Use arrow keys to pan"
  end

  def button_down(id)
    close if id == Gosu::KbEscape
  end

  def needs_redraw?
    [Gosu::KbLeft, Gosu::KbRight, Gosu::KbUp, Gosu::KbDown].each {|b| return true if button_down?(b)}
    return @first_render
  end

  def draw
    @first_render = false
    @map.draw(@x, @y)
  end
end

GameWindow.new.show