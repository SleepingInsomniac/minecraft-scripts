class Minecraft
  
  def initialize (screen_session_name = "minecraft")
    @screen_session = screen_session_name
  end
  
  def say(message)
    command('say', message)
  end
  
  def whisper(player, message)
    command("w #{player}", message)
  end
  
  def running?
    if command("up?").match(/no/i)
      false
    else
      true
    end
  end
  
  def start(starting_ram = '512M', max_ram = '1024M', jar_file = "server.jar")
    puts `screen -S #{@screen_session} -t minecraft_server -dm java -Xms#{starting_ram} -Xmx#{max_ram} -jar #{jar_file} nogui`
  end
  
  def stop
    command('stop')
  end

  def save_all
    command('save-all')
  end
  
  def command(command, arguments = "")
    `screen -S #{@screen_session} -X stuff "\`printf "#{command} #{arguments}\r"\`"`
  end
  
end
