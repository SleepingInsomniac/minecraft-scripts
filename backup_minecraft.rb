#!/usr/bin/env ruby

#require "~/server/scripts/Crontab.rb"
require "~/server/scripts/Minecraft.rb"

# server/scripts
Dir.chdir(File.expand_path(File.dirname(__FILE__)))
# server
Dir.chdir("..")

server = Minecraft.new


last_update = File.mtime('logs/latest.log').strftime("%Y%m%d%H%M%s")
unless File.exists?("last_update")
  `touch last_update`
end

last_mod = ""
File.open("last_update", "r") do |file|
  while line = file.gets
    last_mod +=line
  end
end

puts "last update: #{last_update}"
puts "last file mod: #{last_mod}"

if last_mod.chomp == last_update
  puts "Nothing noticable has happened"
  exit
end

server.say("Backing up world files in 30 seconds...")
`sleep 30`
server.say("Backing up world files...")
server.save_all

# backup...
unless Dir.exists?("backups")
  Dir.mkdir("backups")
end

Dir.chdir("backups")
backup_dir = Time.now.strftime("%Y-%m-%d-%H")

`tar -zcvf #{backup_dir}.tar.gz ../world`
server.say("Backup saved as #{backup_dir}.tar.gz!")

cutoff = Time.now - 60*60*24 * 2

Dir.foreach(".") do |file|

  next if file == __FILE__
     
  mod_date = File.atime(file)

  if (mod_date < cutoff)
    server.say("Removing old backup #{file}")
    File.unlink file
  end

end

server.say("Backup complete!")

Dir.chdir("..")
File.open("last_update", "w") do |line|
  line.puts File.mtime('logs/latest.log').strftime("%Y%m%d%H%M%s")
end
