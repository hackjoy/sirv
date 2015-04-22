require 'socket'
require 'uri'
require './http_protocol_helper.rb'

server = TCPServer.new('localhost', 9000)
STDERR.puts 'Ready to sirv...'

loop do
  Thread.start(server.accept) do |socket|
    request_line = socket.gets
    STDERR.puts request_line

    path = HTTPProtocolHelper.requested_file(request_line)

    if File.exist?(path) && !File.directory?(path)
      File.open(path, "rb") do |file|
      socket.print "HTTP/1.1 200 OK\r\n" +
                   "Content-Type: #{HTTPProtocolHelper.content_type(file)}\r\n" +
                   "Content-Length: #{file.size}\r\n" +
                   "Connection: close\r\n"

       socket.print "\r\n"

       # write the contents of the file to the socket
       IO.copy_stream(file, socket)
      end
    else
      response_body = "File not found\n"
      socket.print "HTTP/1.1 404 Not Found\r\n" +
                    "Content-Type: text/plain\r\n" +
                    "Content-Length: #{response_body.size}\r\n" +
                    "Connection: close\r\n"
      socket.print "\r\n"
      socket.print response_body
    end

    socket.close
  end
end
