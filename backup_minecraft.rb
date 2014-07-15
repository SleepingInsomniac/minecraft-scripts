#!/usr/bin/env ruby

require_relative "Minecraft.rb"

time = ARGV[0] || 30
time = time.to_i

# server/scripts
Dir.chdir(File.expand_path(File.dirname(__FILE__)))
# server
Dir.chdir("..")
server = Minecraft.new

server.say "Backing up in #{time} seconds"
server.save_all

time.times {
  `sleep 1`
  if time == 10 or time == 5
    server.say "Backing up in #{time} seconds."
  end
  time -= 1
}

server.say "Backing up!"
server.save_off
`sleep 2`
# `cp -r world/* world_git/`
Dir.chdir("world")
`git add .`
puts `git commit -m "Regularly scheduled World backup"`
server.say "Done!"
server.save_on