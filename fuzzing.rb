gems = ['httparty', 'securerandom', 'thread']

def install_gems(gems)
  gems.each do |gem|
     success = system("gem install #{gem}")
    if success
      puts "Installed gem: #{gem}" 
    else
      puts "Failed to install gem: #{gem}"
    end
  end
end

install_gems(gems)

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
                                                                 \e[38;5;93m<\\__ __/>\e[0m 
"

puts logo
puts " \e[38;2;255;255;0mto quit write ( \e[0m\e[38;2;255;105;180mexit \e[0mor \e[38;2;255;105;180m00 \e[0m\e[38;2;255;255;0m )\e[0m"

print " \e[38;2;255;255;0mEnter the URL with (\e[0m\e[38;2;255;105;180m/\e[0m\e[38;2;255;255;0m) example ( \e[0m\e[38;2;255;105;180mhttps://www.google.com/\e[0m\e[38;2;255;255;0m ): \e[0m"
url = gets.chomp

exit if url == "00" || url == "exit"

puts " random numbers: 1"
puts " wordlist: 2"

print "What do you want? Enter 1 or 2: "
option = gets.chomp
proxy_list = proxies = File.readlines(File.join(__dir__, 'proxy.txt'), chomp: true)

thread = []
loop do 
  
threads << Thread.new {
  case option
  when "1"
    clearing = `clear`
    puts clearing
    puts logo

    use_ssl = url.include?("https://")

    print "Enter the number of random strings: "
    count = gets.chomp.to_i

    print "Enter the output file name for errors (e.g., Errors.txt): "
    errors_output_file = File.join(__dir__, gets.chomp)

    print "Enter the output file name for hits (e.g., Hits.txt): "
    hits_output_file = File.join(__dir__, gets.chomp)

    # قراءة محتوى ملف errors-list.txt
    errors_file = File.open(File.join(__dir__, "errors-list.txt"), "r")
    errors_list = errors_file.readlines.map(&:chomp)
    errors_file.close

    File.open(errors_output_file, "a") do |file|
      count.times do
        random = SecureRandom.hex
        proxy_list.each do |proxy|
          proxy_host, proxy_port = proxy.split(":")
          begin
            response = HTTParty.get("#{url}#{random}", verify: use_ssl, http_proxyaddr: proxy_host, http_proxyport: proxy_port)
            if response.code == 200
              if errors_list.any? { |error| response.body.include?(error) }
                puts "\e[38;2;255;0;0m[-] Error Skipping...!\e[0m"
                next  # التخطي إلى التالي إذا تم العثور على أي خطأ متطابق
              else
                puts "[+] URL: #{url}#{random}"
                File.open(hits_output_file, "a") do |file|
                  file.puts response
                end
              end
            else
              puts "[-] #{random} - Error Code: \e[38;2;255;0;0m#{response.code}\e[0m"
            end
          rescue StandardError => e
            puts "[-] #{random} - Error: #{e.message}"
          end
        end
      end
    end

  when "2"
    clearing = `clear`
    puts clearing
    puts logo

    #print " Enter the name of the wordlist, e.g., (file.txt): "
    list = File.join(__dir__, "wordlist.txt")

    print "Enter the output file name for errors (e.g., Errors.txt): "
    errors_output_file = File.join(__dir__, gets.chomp)

    print "Enter the output file name for hits (e.g., Hits.txt): "
    hits_output_file = File.join(__dir__, gets.chomp)

    use_ssl = url.include?("https://")

    # قراءة محتوى ملف errors-list.txt
    errors_file = File.open(File.join(__dir__, "errors-list.txt"), "r")
    errors_list = errors_file.readlines.map(&:chomp)
    errors_file.close

    File.open(list, "r").each_line do |line|
      file = line.chomp
      proxy_list.each do |proxy|
        proxy_host, proxy_port = proxy.split(":")
        begin
          response = HTTParty.get("#{url}#{file}", verify: use_ssl, http_proxyaddr: proxy_host, http_proxyport: proxy_port)
          sleep(0.00005)

          if response.code == 200
            if errors_list.any? { |error| response.body.include?(error) }
              puts "\e[38;2;255;0;0m[-] Error Skipping...!\e[0m"
              File.open(errors_output_file, "a") do |file|
                file.puts response
              end
            else
              puts "[+] URL: #{url}#{file} - \e[38;2;0;255;0m#{response.code}\e[0m"
              File.open(hits_output_file, "a") do |file|
                file.puts response
              end
            end
          else
            puts "[-] #{file} - Error Code: \e[38;2;255;0;0m#{response.code}\e[0m"
          end
        rescue StandardError => e
          puts "[-] #{file} - Error: #{e.message}"
        end
      end
    end

  else
    puts "[-] Invalid option."
  end 
  }
end

threads.each(&:join)ع