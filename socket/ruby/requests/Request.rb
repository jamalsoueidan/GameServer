class Request
  
  attr_accessor :object
  attr_accessor :connection
  
  def send_back(object)
    # set class name
    object["response"] = self.class.to_s
    
    connection.send_data JSON.generate([object])
  end
  
  def send_all(object)
    object["response"] = self.class.to_s
    
    p "Sending to all players (#{SocketServer.players.length})"
    players = Player.find_all_by_room_id(connection.player.room_id)
    players.each do |player|
      p "Sending to #{player.user_id}"
      c = SocketServer.players[player.id]
      c.send_data(JSON.generate([object]))
    end
  end
  
  def send_privat
    
  end
  
  def execute
    puts "You need to create execute in the subclass"
    raise "You need to create execute in the subclass"
  end
end