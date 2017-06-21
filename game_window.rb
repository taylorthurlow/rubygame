# classes
require_relative 'entities/player'
require_relative 'world_map'

# libraries
require 'gosu'
require 'gosu_tiled'
require 'byebug'

class GameWindow < Gosu::Window
  attr_accessor :state

  WINDOW_WIDTH = 800
  WINDOW_HEIGHT = 600

  def initialize
    super(WINDOW_WIDTH, WINDOW_HEIGHT, false)
  end

  def update
    @state.update
    self.caption = 'some stupid ruby game'
  end

  def button_down(id)
    @state.button_down(id)
  end

  def button_up(id)
    @state.button_up(id)
  end

  def needs_redraw?
    @state.needs_redraw?
  end

  def draw
    @state.draw
  end

  def memory_usage
    `ps -o rss= -p #{Process.pid}`.chomp.gsub(/(\d)(?=(\d{3})+(\..*)?$)/,'\1,') + ' KB'
    rescue
    "Unavailable. Using Windows?"
  end
end