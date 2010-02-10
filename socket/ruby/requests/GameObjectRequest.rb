require File.expand_path(File.dirname(__FILE__)) + "/Request"

class GameObjectRequest < Request  
  def execute
    p "Executing GameObjectRequest"
    if @object["to_player_id"]
      send_to(@object["to_player_id"], @object)
    else
      send_all(@object)
    end
  end
end