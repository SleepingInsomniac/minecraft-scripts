#!/usr/bin/env ruby

require 'yaml'

# ===================================================
# = Track the changes made to a directory structure =
# ===================================================
# Written by Alex Clink, 2014-07-10

class ChangeLog
  
  def initialize(directory)
    @directory = directory
  end
  
  attr_reader :directory
  
  def read_files(dir = @directory, paths = [])
    Dir.chdir dir
    paths.push dir
    file_hash = Hash.new
    Dir.foreach(".") do |file|
      next if file[0] == "."
      if File.directory? File.expand_path file
        file_hash[paths.join("/")] = read_files(file, paths)
      else
        file_hash[paths.join("/")+"/#{file}"] = File.mtime(file).to_s
      end      
    end
    
    Dir.chdir ".."
    file_hash
  end 
  
  def save_state
    files = read_files
    save = File.open("#{@directory}.yaml", "w")
    save.write(files.to_yaml)
    save.close
    files
  end
  
  def diff
    
    begin
      last_check = YAML.load_file("#{@directory}.yaml")
    rescue
      return save_state
    end
    
    def check(thing1, thing2, level = 0)
      diffs = []
      thing1.zip(thing2).each do |one, two|
        if (one[1].class == Hash)
          diffs += check one[1], two[1], level+1
        else
          diffs.push one[0] if one[1] != two[1]
        end
      end
      diffs
    end
    
    check last_check, read_files
  end
  
end