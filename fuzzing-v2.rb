require 'httparty'
require 'securerandom'
require 'thread'

clearing = `clear`
puts clearing

logo = "
     \e[38;5;31mo__ __o \e[0m                                   \e[38;5;31mo\e[0m                          
    \e[38;5;34m/v     v\                                  \e[38;5;34m_<|>_\e[0m                        
   \e[38;5;33m/>           \e[38;5;33m<\\ \e[0m                                                             
   \e[38;5;32m\\o           o       o   _\\o____  _\\o____    o    \\o__ __o     o__ __o/\e[0m        \e[38;2;255;255;0mGithub: Abo5\e[0m
    \e[38;5;36m|>_        <|>     <|>      /        /     <|>    |     |>\e[0m   \e[38;5;36m/v     |\e[0m                    
    \e[38;5;35m|          < >     < >    o/       o/      / \\   / \\   / \\  />\e[0m     / \\ 
   \e[38;5;37m<o>\e[0m          |       |    /v       /v       \\o/   \\o/   \\o/  \\      \\o/ 
    \e[38;5;96m|           o       o   />       />         |     |     |    o      |\e[0m  
   \e[38;5;91m/ \\          <\\__ __/>   \\>__o__  \\>__o__   / \\   / \\   / \\   <\\__  < >\e[0m 
                                 \\        \\                             |  
                                                                 \e[38;5;93mo__     o\e[0m  
                                                                 \e[38;5;93m<\\__ __/>\e[0m"

puts logo
puts " \e[38;2;255;255;0mto quit write ( \e[0m\e[38;2;255;105;180mexit \e[0mor \e[38;2;255;105;180m00 \e[0m\e[38;2;255;255;0m )\e[0m"
print " \e[38;2;255;255;0mEnter the URL with (\e[0m\e[38;2;255;105;180m/\e[0m\e[38;2;255;255;0m) example ( \e[0m\e[38;2;255;105;180mhttps://www.google.com/\e[0m\e[38;2;255;255;0m ): \e[0m"
url = gets.chomp

exit if url == "00" || url == "exit"

puts " random numbers: 1"
puts " wordlist: 2"
print "What do you want? Enter 1 or 2: "
option = gets.chomp

# ... الكود السابق ...

case option
when "1"
  clearing = `clear`
  puts clearing
  puts logo
  use_ssl = url.include?("https://")
  print "Enter the number of random strings: "
  count = gets.chomp.to_i

  errors_file = File.open(File.join(__dir__, "errors-list.txt"), "r")
  errors_list = errors_file.readlines.map(&:chomp)
  errors_file.close

  count.times do
    Thread.new do
      random = SecureRandom.hex
      begin
        response = HTTParty.get("#{url}#{random}", verify: use_ssl)
        sleep(0.00005)
        if response.success?
          if errors_list.any? { |error| response.body.include?(error) }
            print "\r\e[38;2;255;0;0m[-] Error Skipping...!\e[0m"
            next
          else
            puts "[+] URL: #{url}#{random}"
          end
        else
          print "\r [-] #{random} - Error Code: \e[38;2;255;0;0m#{response.code}\e[0m"
        end
      rescue StandardError => e
        print "\r[-] #{random} - Error: #{e.message}"
      end
    end.join
  end

when "2"  
  use_ssl = url.include?("https://")
  list = File.join(__dir__, "wordlist.txt")
  errors_file = File.open(File.join(__dir__, "errors-list.txt"), "r")
  errors_list = errors_file.readlines.map(&:chomp)
  errors_file.close

  File.open(list, "r") do |file|
    file.each_line do |line|
      file = line.chomp
      next if file.strip.empty?

      Thread.new do
        begin
          response = HTTParty.get("#{url}#{file}", verify: use_ssl)
          sleep(0.00005)
          if response.success?
            if errors_list.any? { |error| response.body.include?(error) }
              puts "\r\e[38;2;255;0;0m[-] Error Skipping...!\e[0m"
            else
              puts "[+] URL: #{url}#{file} - \e[38;2;0;255;0m#{response.code}\e[0m"
            end
          else
            puts "[-] #{file} - Error Code: \e[38;2;255;0;0m#{response.code}\e[0m"
          end
        rescue StandardError => e
          puts "[-] #{file} - Error: #{e.message}"
        end
      end.join
    end
  end
else
  puts "[-] Invalid option."
end
