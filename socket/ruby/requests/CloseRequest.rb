require File.expand_path(File.dirname(__FILE__)) + "/Request"

class CloseRequest < Request
  
  def execute
    p "Executing CloseRequest"
    p ".................."
    
    
    #command = UserListRequest.new
    #command.instance = @instance    
    #command.execute
    
    if player_in_game?
      p "Updating player list!"
    else 
      
    end
    
    #p "--------------------"
  end
  
  def player_in_game?
    player = Player.find(@connection.player.id)
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