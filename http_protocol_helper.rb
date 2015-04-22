module HTTPProtocolHelper

  WEB_ROOT = './public'

  def self.content_type(path)
    ext = File.extname(path).split(".").last
    case ext
    when 'html' then 'text/html'
    when 'txt' then 'text/plain'
    when 'png' then 'image/png'
    when 'jpg' then 'image/jpeg'
    else 'application/octet-stream'
    end
  end

  def self.requested_file(request_line)
    request_uri  = request_line.split(" ")[1]
    request_path = URI.unescape(URI(request_uri).path)

    clean = []

    # Split the request_path into components
    parts = request_path.split("/")

    parts.each do |part|
      # skip any empty or current directory (".") request_path components
      next if part.empty? || part == '.'
      # If the request_path component goes up one directory level (".."),
      # remove the last clean component.
      # Otherwise, add the component to the Array of clean components
      part == '..' ? clean.pop : clean << part
    end

    # return the web root joined to the clean request_path
    file_path = File.join(WEB_ROOT, *clean)
    if File.directory?(file_path)
      file_path = File.join(file_path, 'index.html')
    else
      file_path
    end
  end
end
