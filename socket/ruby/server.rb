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
  attr_accessor :player
  
  def self.players
    $list
  end
  
  def post_init
    $list ||= {}
    puts "-- someone connected to the echo server!"
  end

  def receive_data data
    
    if data[1..19] == "policy-file-request"
      send_data '<?xml version="1.0"?>
      <!DOCTYPE cross-domain-policy SYSTEM "/xml/dtds/cross-domain-policy.dtd">
      <cross-domain-policy> 
         <site-control permitted-cross-domain-policies="master-only"/>
         <allow-access-from domain="*" to-ports="*" />
      </cross-domain-policy>'
      p "sent policy file"
      close_connection_after_writing
      return
    end
    
    # parse received data
    request = JSON.parse(data)

    # create instance from className
    class_name = request["className"]
    instance = Object.const_get(class_name).new
    instance.object = request
    instance.connection = self
    instance.execute
  end

  def player=(value)
    @player = value
    $list[value.id] = self
    p "-- new user is added:" + $list.length.to_s
  end
  
  def unbind
    if @player
      instance = CloseRequest.new
      instance.connection = self
      instance.execute
    
      $list.delete(@player.id)
      puts "-- someone disconnected from the socket server: " + $list.length.to_s
    end
  end
end

