require File.expand_path(File.dirname(__FILE__)) + "/Request"

class JoinLobbyRequest < Request  
  def execute
    p "Executing JoinLobbyRequest"
    
    current_user = get_current_user(@object["user_key"])
    
    lobby = Lobby.find_by_key(@object["lobby_key"])
    
    if lobby.nil?
      p "Lobby is unknown! " +  @object["lobby_key"]
      return
    end
    
    if lobby.is_full?
      send_back({:failure => "Lobby is full"})
    else
      lobby.joined_sessions += 1
      lobby.save

      p "Session name logged: " + current_user.name
      session = current_user.create_session
      session.lobby_id = lobby.id
      session.user_name = current_user.name
      session.save

      @connection.client = session

      send_back({:max_sessions => lobby.max_sessions, :joined_session => lobby.joined_sessions})

      notify_new_player_to_other_sessions
    end
  end
  
  def notify_new_player_to_other_sessions
    instance = PlayerListRequest.new
    instance.connection = @connection
    instance.execute
  end
  
  def get_current_user(name)
    current_user = nil
    if name == "debug"
      User.find(:all, :include => :player).each do |user|
        if user.player.nil? && current_user.nil?
          current_user = user
        end
      end
    else
      current_user = User.find_by_key(@object["user_key"])
    end 
    return current_user
  end
end