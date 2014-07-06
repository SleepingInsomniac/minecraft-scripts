#!/usr/bin/env ruby

def get_players(path)

  file = File.new(path)

  players = Hash.new
  
  if (path.match(/\.gz$/))
    file = Zlib::GzipReader.new(file)
  end  

  file.each_line do |line|
    matches = line.match(/UUID of player (\S+) is ([\da-f\-]+)/i);
    next unless matches
  
    player = matches[1].to_sym
    uuid = matches[2]
  
    players[player] = uuid
  
    # puts "Player: #{player}, UUID: #{uuid}"
  
  end

  file.close
  players
  
end

require 'json'
require 'mysql2'
require 'zlib'

path = ARGV[0] || File.expand_path(File.dirname(__FILE__))+"/../logs"

master_hash = Hash.new

Dir.foreach(path) do |file|
  next if File.directory?(file)
  next if file == __FILE__
  next if file.match(/^\./)
  # puts "reading #{file}"
  master_hash.merge!(get_players("#{path}/#{file}"))
end

client = Mysql2::Client.new(:host => "localhost", :username => "minecraft", :password => '', :database => "minecraft", :socket => "/var/run/mysqld/mysqld.sock")
master_hash.each_pair do |name, uuid|
  x_name = client.escape(name.to_s)
  x_uuid = client.escape(uuid)
  client.query("INSERT IGNORE INTO `players` (`name`, `uuid`) VALUES ('#{x_name}', '#{x_uuid}');")
end

puts master_hash.to_json
