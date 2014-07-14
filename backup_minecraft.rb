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
`sleep 1`
`cp world/* world_git/`
Dir.chdir("world_git")
`git add .`
puts `git commit -m "Regularly scheduled World backup"`
server.say "Done!"