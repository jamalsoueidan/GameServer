require File.expand_path(File.dirname(__FILE__)) + "/Request"

class PublicMessageRequest < Request
  
  def execute
    p "Executing MessageRequest"
    p ".................."
    
    if player_in_game?
      p "Player in game, send to all players"
    else

    end
    p "--------------------"

  end
  
  def player_in_game?
    p "Player in game, sent message to all other players"
    
    send_all({:text => @object["text"]})
    
    return true
  end
end