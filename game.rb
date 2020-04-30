#!/usr/bin/env ruby

require "gosu"
require "pry-byebug"
require "json"

root_dir = File.dirname(__FILE__)
require_pattern = File.join(root_dir, "**/*.rb")
@failed = []

Dir.glob(require_pattern).each do |f|
  next if f.end_with?("/game.rb") || f.start_with?("./vendor")

  begin
    require_relative f.gsub("#{root_dir}/", "")
  rescue NameError
    # could fail if parent class not required yet
    @failed << f
  end
end

# retry failed requires
while @failed.count.positive?
  @failed.each do |f|
    require_relative f.gsub("#{root_dir}/", "")
    @failed.delete(f)
  rescue NameError
    # could fail if parent class not required yet
  end
end

$window = GameWindow.new
GameState.switch(MenuState.instance)
$window.show
