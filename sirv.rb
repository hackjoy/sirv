require 'socket'

server = TCPServer.new('localhost', 9000)
puts 'Ready to sirv...'

loop do
  # allow client to make TCP connection
  Thread.start(server.accept) do |client|
    STDERR.puts client.gets

    response = 'Hello world!\n'

    # http protocol is whitespace sensitive
    client.print "HTTP/1.1 200 OK\r\n" +
                 "Content-Type: text/plain\r\n" +
                 "Content-Length: #{response.bytesize}\r\n" +
                 "Connection: close\r\n"
    client.print "\r\n"
    client.print response
    client.close
  end
end
