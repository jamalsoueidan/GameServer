require File.expand_path(File.dirname(__FILE__)) + "/Request.rb"

class PlayerListRequest < Request
  def execute
    p "Executing PlayerListRequest"

    user_list = Array.new

    players = @connection.player.room.players.find(:all, :include => :user)
    
    if players.length > 0
      players.each do |player|
      user_list.push({:name => player.id, :id => player.user_id})
      end
    end
    
    send_all({:users => user_list})
  end
end