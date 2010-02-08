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
    instance = CloseRequest.new
    instance.connection = self
    instance.execute
    
    $list.delete(@player.id)
    puts "-- someone disconnected from the socket server: " + $list.length.to_s
  end
end

