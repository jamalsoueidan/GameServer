require File.expand_path(File.dirname(__FILE__)) + "/Request"

class GameObjectRequest < Request  
  def execute
    p "Executing GameObjectRequest"
    send_all(@object)
  end
end