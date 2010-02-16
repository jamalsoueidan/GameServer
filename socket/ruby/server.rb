Dir[File.expand_path(File.dirname(__FILE__)) + "/requests/*.rb"].each do |file| 
  require file 
end

Player.delete_all
Room.find(:all).each do |room|
  room.joined_players = 0
  room.max_players = 4
  room.save
end

module SocketServer
  attr_accessor :client
  
  def clients
    if in_lobby?
      return $sessions
    else
      return $players
    end
  end
  
  def post_init
    $sesions ||= {}
    $players ||= {}
    puts "-- someone connected to the echo server!"
  end

  def receive_data data
    if policy_file_request?(data)
      p "-- respond with policy_file_request"
    else
      datas = data.split('}{')
      while(datas.length>0) do
        parse(datas.shift)
      end
    end
  end

  def client=(value)
    @client = value
    clients[value.id] = self
    p "-- new " + type + "is added:" + clients.length.to_s
  end

  
  def in_lobby?
    if @client.attribute_present?(:lobby_id)
      return true
    else
      return false
    end
  end
  
  def type
    if in_lobby?
      return "session"
    else
      return "player"
    end
  end
  
  def parse(data)
    if data[data.length-1..data.length] != "}"
      data += "}"
    end
    if data[0..0] != "{"
      data = "{" + data
    end
    
    p "Parsing: " + data
    
    # parse received data
    request = JSON.parse(data)

    # create instance from className
    class_name = request["className"]
    instance = Object.const_get(class_name).new
    instance.object = request
    instance.connection = self
    instance.execute
  end
  
  def policy_file_request?(data)
    if data[1..19] == "policy-file-request"
      p "Sent policy-file-request!"
      send_data '<?xml version="1.0"?>
      <!DOCTYPE cross-domain-policy SYSTEM "/xml/dtds/cross-domain-policy.dtd">
      <cross-domain-policy> 
         <site-control permitted-cross-domain-policies="master-only"/>
         <allow-access-from domain="*" to-ports="*" />
      </cross-domain-policy>'
      close_connection_after_writing
      return true
    end
    return false
  end
  
  def unbind
    if @client
      instance = CloseRequest.new
      instance.connection = self
      instance.execute
      
      clients.delete(@client.id)
      puts "-- someone disconnected from the socket server: " + clients.length.to_s
    end
  end
end

