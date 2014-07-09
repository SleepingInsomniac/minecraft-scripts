class Logreader
  
  def initialize (log_dir = ".", file_name = "latest.log")
    @file_name = file_name
    @log_dir = log_dir
  end
  
  attr_reader :file_name
  
  def abs_path
    File.expand_path(@log_dir + "/" + @file_name)
  end
  
  def register_change
    mtime_file = File.open("/tmp/#{@file_name}.logreader", "w")
    mtime_file.write(Time.now)
    mtime_file.close
    true
  end
  
  def last_checked
    begin
      File.mtime("/tmp/#{@file_name}.logreader")
    rescue
      update_mtime
      retry
    end
  end
  
  def last_modified
    File.mtime(abs_path)
  end
  
  def changed?
    last_modified > last_checked
  end
  
  def read_line
    read_lines(1)[0]
  end
  
  def read_lines(n = 1)
    array = []
    `tail -n#{n} #{abs_path}`.each_line do |l|
      array.push(LogLine.new(l))
    end
    array
  end
  
  def since_last
    array = []
    check_time = last_checked.strftime("%H:%M:%S")
    log = File.open(abs_path, "r")
    log.each_line do |l|
      line = LogLine.new(l)
      next unless parsed = line.parse
      next if parsed[:time] < check_time
      array.push(line)
    end
    log.close
    array
  end
  
end

class LogLine < String
  
  def parse
    matches = match(/^\[(\d{2}:\d{2}:\d{2})\] \[([^\]]+)\]: (.+$)/i)
    begin
      line = {
        :time => matches[1].to_s,
        :info => matches[2].to_s,
        :msg => matches[3].to_s,
      }
    rescue
      nil
    end
  end
  
end
