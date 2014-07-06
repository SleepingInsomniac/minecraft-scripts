class Minecraft
  
  def initialize (screen_session_name = "minecraft")
    @screen_session = screen_session_name
  end
  
  def say(message)
    send_screen('say', message)
  end
  
  def start(starting_ram = '512M', max_ram = '1024M')
    puts `screen -S #{@screen_session} -t minecraft_server -dm java -Xms#{starting_ram} -Xmx#{max_ram} -jar minecraft_server.1.7.9.jar nogui`
  end
  
  def stop
    send_screen('stop')
  end

  def save_all
    send_screen('save-all')
  end
  
  private
  def send_screen(command, arguments = "")
    `screen -S #{@screen_session} -X stuff "\`printf "#{command} #{arguments}\r"\`"`
  end
  
end
