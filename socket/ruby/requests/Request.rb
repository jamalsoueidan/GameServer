class Request
  
  attr_accessor :object
  attr_accessor :connection
  
  def send_back(object)
      connection.send_data(json_genereate(object))
      
      p "-------------------------------------------------------"
      p "Sending to #{connection.client.user_name}"
      p "Object: " + object.inspect
      p "_______________________________________________________"
  end
  
  def send_to(id, object)
    SocketServer.clients[id].send_data(json_genereate(object))
    
    p "-------------------------------------------------------"
    p "Sending to player name (#{client[id].user_name})"
    p "Object: " + object.inspect
    p "_______________________________________________________"
  end
  
  def send_all(object)    
    json_object = json_genereate(object)
    p "-------------------------------------------------------"
    all_clients_in_current_room_or_lobby.each do |client|
      p "Sending to #{client.user_name} "
      c = @connection.clients[client.id]
      c.send_data(json_object)
    end
    p "Object: " + object.inspect
    p "_______________________________________________________"
  end
  
  def send_privat
    
  end
  
  def json_genereate(object)
    object["className"] = self.class.to_s
    object[@connection.type] = {:name => connection.client.user_name, :id => connection.client.id}
    return JSON.generate([object])
  end
  
  def all_clients_in_current_room_or_lobby
    if @connection.in_lobby?
      Session.find_all_by_lobby_id(connection.client.lobby_id)
    else
      Player.find_all_by_room_id(connection.client.room_id)
    end
  end
  
  def execute
    puts "You need to create execute in the subclass"
    raise "You need to create execute in the subclass"
  end
end