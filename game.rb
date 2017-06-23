#!/usr/bin/env ruby

require 'gosu'
require 'byebug'
require 'json'

root_dir = File.dirname(__FILE__)
require_pattern = File.join(root_dir, '**/*.rb')
@failed = []

Dir.glob(require_pattern).each do |f|
  next if f.end_with?('/game.rb')
  begin
    require_relative f.gsub("#{root_dir}/", '')
  rescue
    # could fail if parent class not required yet
    @failed << f
  end
end

# retry failed requires
while @failed.count > 0
  @failed.each do |f|
    begin
      require_relative f.gsub("#{root_dir}/", '')
      @failed = @failed - [f]
    rescue
      # could fail if parent class not required yet
    end
  end
end

$window = GameWindow.new
GameState.switch(MenuState.instance)
$window.show