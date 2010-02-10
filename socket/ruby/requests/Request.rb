class Request
  
  attr_accessor :object
  attr_accessor :connection
  
  def send_back(object)
    # set class name
    object["className"] = self.class.to_s
    if connection.player
      object["player"] = {:name => connection.player.user_name, :id => connection.player.id}
      p "-------------------------------------------------------"
      p "Sending to #{connection.player.user_name}"
      p "Object: " + object.inspect
      connection.send_data JSON.generate([object])
      p "_______________________________________________________"
    end
  end
  
  def send_to(id, object)
    # set class name
    object["className"] = self.class.to_s
    object["player"] = {:name => connection.player.user_name, :id => connection.player.id}
    p "-------------------------------------------------------"
    p "Sending to #{SocketServer.players[id].player.user_name}"
    p "Object: " + object.inspect
    SocketServer.players[id].send_data JSON.generate([object])
    p "_______________________________________________________"
  end
  
  def send_all(object)
    object["className"] = self.class.to_s
    object["player"] = {:name => connection.player.user_name, :id => connection.player.id}        
    json_object = JSON.generate([object])
    
    p "-------------------------------------------------------"
    p "Sending to all players (#{SocketServer.players.length})"
    players = Player.find_all_by_room_id(connection.player.room_id)
    players.each do |player|
      p "Sending to #{player.user_name} "
      c = SocketServer.players[player.id]
      c.send_data(json_object)
    end
    p "Object: " + object.inspect
    p "_______________________________________________________"
  end
  
  def send_privat
    
  end
  
  def execute
    puts "You need to create execute in the subclass"
    raise "You need to create execute in the subclass"
  end
end