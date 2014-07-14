#!/usr/bin/env ruby

require_relative "Minecraft.rb"

time = ARGV[0] || 30

# server/scripts
Dir.chdir(File.expand_path(File.dirname(__FILE__)))
# server/world
Dir.chdir("../world")
server = Minecraft.new

server.say "Backing up in #{time} seconds"

(time - 5).times {
  time -= 1
  if time == 10
    server.say "Backing up in 10 seconds."
  end
  `sleep 1`
}

time.downto(0) do |t|
  server.say "Backing up in #{t}..."
  `sleep 1`
end

server.say "Backing up!"
server.save_all
`git add .`
puts `git commit -m "Regularly scheduled World backup"`
server.say "Done!"