

module SocketServer
  def post_init
    $clients_list ||= {}
    #$clients_list.merge!({@identifier => self})
    p $clients_list.inspect
    puts "-- someone connected to the echo server!"
  end

  def receive_data data
    #result = JSON.parse(data)
    #send_data JSON.generate [{"a"=>1}]
    #$log.info("#{result.inspect}")
    
    send_data ">>>you sent: #{data}"
    $clients_list.values.each do |client|
      client.send_data(data)
    end
  end

  def unbind
    puts "-- someone disconnected from the echo server!"
    $clients_list.delete(@identifier)
  end
end