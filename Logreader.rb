class Logreader
  
  def initialize (log_dir = "", file_name = "latest.log")
    @file_name = file_name
    @log_dir = log_dir
  end
  
  attr_reader :file_name
  
  def abs_path
    # Dir.chdir @log_dir
    File.expand_path(@file_name)
  end
  
  def update_mtime
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
    last_modified > last_checked ? update_mtime : false
  end
  
  def last_lines(n = 1)
    `tail -n#{n} #{abs_path}`
  end
  
end
