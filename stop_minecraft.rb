#!/usr/bin/env ruby

require_relative "Crontab.rb"
require_relative "Minecraft.rb"

def remove_crons
  cron = Crontab.new
  puts "Removed backup job" unless cron.remove_job("0 */3 * * * ruby /home/minecraft/server/scripts/backup_minecraft.rb 2>&1 >> /home/minecraft/backup.log")
  puts "Removed player update job" unless cron.remove_job("*/15 * * * * ruby /home/minecraft/server/scripts/update_player_db.rb 2>&1 >> /home/minecraft/player_db.log")
end

stop_time = ARGV[0] || 30 # usage stop_minecraft.rb [delay]
stop_time = stop_time.to_i

Dir.chdir(File.expand_path(File.dirname(__FILE__))) # server/scripts
Dir.chdir("..") # server

server = Minecraft.new

unless server.running?
  puts "Server already stopped."
  remove_crons
  abort
end

puts "Stopping server"
server.say("Stopping server in #{stop_time} seconds")

while stop_time > 10 do
  stop_time -= 1;
  `sleep 1`
end

stop_time.downto(1) do |time|
  server.say("Stopping server in #{time} seconds")
  `sleep 1`
end

server.say("Goodbye")
`sleep 1`

server.stop
remove_crons