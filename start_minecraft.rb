#!/usr/bin/env ruby

require "~/server/scripts/Crontab.rb"
require "~/server/scripts/Minecraft.rb"

# server/scripts
Dir.chdir(File.expand_path(File.dirname(__FILE__)))
# server
Dir.chdir("..")

server = Minecraft.new
cron = Crontab.new

if server.running?
  puts "Server is already running."
end
  server.start
end

puts "Backup cron job was already loaded." unless cron.add_job("0 */3 * * * ruby /home/minecraft/server/scripts/backup_minecraft.rb 2>&1 >> /home/minecraft/backup.log")
puts "Update players cron job was already loaded" unless cron.add_job("*/15 * * * * ruby /home/minecraft/server/scripts/update_player_db.rb 2>&1 >> /home/minecraft/player_db.log")
