require File.expand_path(File.dirname(__FILE__)) + "/Request.rb"

class PlayerListRequest < Request
  def execute
    p "Executing PlayerListRequest"

    user_list = Array.new

    players = Player.find(:all, :conditions => {:room_id => @connection.client.room_id})
    if players.length > 0
      players.each do |player|
        user_list.push({:name => player.user_name, :id => player.id})
      end
      
      send_all({:users => user_list})
    end
  end
end