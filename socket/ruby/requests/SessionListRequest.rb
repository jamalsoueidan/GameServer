require File.expand_path(File.dirname(__FILE__)) + "/Request.rb"

class SessionListRequest < Request
  def execute
    p "Executing SessionListRequest"

    user_list = Array.new

    sessions = Session.find(:all, :conditions => {:room_id => @connection.client.lobby_id})
    if sessions.length > 0
      sessions.each do |session|
        user_list.push({:name => session.user_name, :id => session.id})
      end
      
      send_all({:users => user_list})
    end
  end
end