require 'gosu'
require_relative 'states/menu_state'
require_relative 'states/game_state'
require_relative 'states/play_state'
require_relative 'game_window'

module Game
  def self.media_path(file)
    File.join(File.dirname(file.dirname(__FILE__)), 'assets', file)
  end
end

$window = GameWindow.new
GameState.switch(MenuState.instance)
$window.show