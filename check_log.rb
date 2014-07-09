#!/usr/bin/env ruby

require_relative "Minecraft.rb"
require_relative "Logreader.rb"

Dir.chdir(File.expand_path(File.dirname(__FILE__))) #scripts
Dir.chdir("../logs") #server

log = Logreader.new
server = Minecraft.new


while true do
  if log.changed?
    log.since_last.each do |l|
      if player = l.parse[:msg].match(/(\S+) joined the game$/i)
        server.whisper player[1], "Welcome to Pixelfaucet #{player[1]}!"
        server.whisper player[1], "http://minecraft.pixelfaucet.com"
        puts "Greeting player #{player[1]}"
      end
    end
    log.register_change
  end
  
  `sleep 5`
end