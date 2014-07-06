#!/usr/bin/env ruby

require "~/server/scripts/Crontab.rb"
require "~/server/scripts/Minecraft.rb"

# server/scripts
Dir.chdir(File.expand_path(File.dirname(__FILE__)))
# server
Dir.chdir("..")

server = Minecraft.new
cron = Crontab.new


server.say("Stopping server in 30 seconds")
`sleep 20`

10.downto(0) do |time|
  server.say("Stopping server in #{time} seconds")
  `sleep 1`
end

server.say("Goodbye")
`sleep 1`
server.stop
cron.remove_job("0 */3 * * * ruby /home/minecraft/server/scripts/backup_minecraft.rb")
