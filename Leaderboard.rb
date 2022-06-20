require './Player.rb'

class Leaderboard
  #zapis do pliku
  def save_player(player)
    f = File.open("scoreboard.csv", "a+") do |save|
      save << [%|"#{player.name.to_s}"|, %|"#{player.attempts.to_s}"|, %|"#{player.date.to_s}"|].join(',')
      save << "\n"
    end
    f.close
  end

  #odczyt z pliku
  def read_players(arr)
    f = File.open("scoreboard.csv", "r")
    f.each_line { |line|
      words = line.split(',')
      player = Player.new
      player.name = words[0].tr_s('""', '').strip
      player.attempts = words[1].tr_s('""', '').strip
      player.date = words[2].tr_s('""', '').strip
      arr.push(player)
    }
  end

  def sort_leaderboard(arr)
    arr.sort! {|a, b| a.attempts <=> b.attempts }
  end

  def print_leaderboard(arr)
    puts "\n###---LEADERBOARD---###\n"
    arr.each { |player|
      player.print_records
    }
  end

end



#testowanie
#File.foreach('scoreboard.txt') do |line|
#  puts line
#end

#if file
#  file.write(player1.name, player1.attempts, player1.date)
#else
#  puts "Unable to open file"
#end


#result = []
#f = File.open("textfile.txt", "r")
#f.each_line {|line| result << line.split(",") }