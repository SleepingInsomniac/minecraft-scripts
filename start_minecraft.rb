#!/usr/bin/env ruby

require "~/server/scripts/Crontab.rb"
require "~/server/scripts/Minecraft.rb"

# server/scripts
Dir.chdir(File.expand_path(File.dirname(__FILE__)))
# server
Dir.chdir("..")

server = Minecraft.new
cron = Crontab.new

server.start
unless cron.add_job("0 */3 * * * ruby /home/minecraft/server/scripts/backup_minecraft.rb")
  puts "Cron was already loaded."
end
