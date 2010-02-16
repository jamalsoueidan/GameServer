require File.expand_path(File.dirname(__FILE__)) + "/Request"

class CloseRequest < Request
  
  def execute
    p "Executing CloseRequest"
    p ".................."
    
    
    #command = UserListRequest.new
    #command.instance = @instance    
    #command.execute
    
    if @connection.in_lobby?
      update_session_list!
      p "Updating lobby list!"
    else 
      update_player_list!
      p "Updating player list!"
    end
    
    #p "--------------------"
  end

  def update_session_list!
    session = Session.find(@connection.client.id)
    return false if session.nil?
    lobby = Lobby.find(session.lobby_id)
    lobby.joined_sessions -= 1
    lobby.save
      
    Session.delete(sesion.id)
      
    if lobby.joined_sessions > 0
      instance = SessionListRequest.new
      instance.connection = @connection
      instance.execute
    end
    
    return true
  end
    
  def update_player_list!
    player = Player.find(@connection.client.id)
    return false if player.nil?
    game = Room.find(player.room_id)
    game.joined_players -= 1
    game.save
      
    Player.delete(player.id)
      
    if game.joined_players > 0
      instance = PlayerListRequest.new
      instance.connection = @connection
      instance.execute
    end
    
    return true
  end
end