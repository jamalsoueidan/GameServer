require File.expand_path(File.dirname(__FILE__)) + "/Request.rb"

class JoinRoomRequest < Request  
  
  def execute
    p "Executing JoinRoomRequest"
    current_user = get_current_user(@object["name"])
    
    if current_user.nil?
      p "Player is unknown trying to login"
      return
    end
    
    room = Room.find_by_salt(@object["salt"])
    if room.is_full?
      p "room is full"
      
      send_back({:failure => "Room is full"})
    else      
      room.joined_players += 1
      room.save
      
      p "Player name logged: " + current_user.name
      player = current_user.create_player
      player.room_id = room.id
      player.user_name = current_user.name
      player.save
      
      @connection.player = player
      
      send_back({:max_players => room.max_players, :joined_players => room.joined_players})
      
      notify_new_player_to_other_players
    end
  end
  
  def notify_new_player_to_other_players
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
      current_user = User.find_by_name(@object["name"])
    end 
    return current_user
  end
end