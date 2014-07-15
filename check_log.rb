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
      line = l.parse
      if player = line[:msg].match(/(\S+) joined the game$/i)
        server.whisper player[1], "Welcome to Pixelfaucet #{player[1]}!"
        server.whisper player[1], "http://minecraft.pixelfaucet.com"
        server.whisper player[1], "For info/rules type !info or !rules"
        puts "Greeting player #{player[1]}"
      end
      if command = line[:msg].match(/^(\S+) was kicked for floating too long!$/i)
        p = command[1]
        server.say "Kicked #{p} for flying. Repeated offenses will result in ban."
      end
      if command = line[:msg].match(/^\<(\S+)\>\s*\!([a-z]+)$/i)
        p = command[1]
        c = command[2].downcase
        # server.say "#{p}'s Command was #{command[2]}"
        if p == "SlpingInsomniac"
          case c
          when "backup"
            `./../scripts/backup_minecraft.rb 0`
          end
        end
        case c
        when "info"
          server.say "I know the the following commands:"
          server.say "!info - this message"
          server.say "!web - website"
          server.say "!rules - Server rules"
          server.say "!grief - report a griefing incident"
        when "web"
          server.say "http://minecraft.Pixelfaucet.com"
        when "rules"
          server.say "1. No griefing"
          server.say "2. No looting/raiding"
          server.say "3. No hacked clients"
          server.say "4. PvP is enabled, but don't be a jerk."
          server.say "Respect your fellow players."
        when "grief"
          puts "#{Time.now} #{p} reports griefing"
          server.command "tp" "#{p} ~ ~ ~"
          server.whisper p, "Your report has been submitted."
          server.whisper p, "A mod will look into the issue ASAP."
        end
      end
    end
    log.register_change
  end
  
  `sleep 5`
end