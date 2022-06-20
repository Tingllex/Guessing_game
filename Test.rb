require './Leaderboard.rb'

player1 = Player.new "grzesiek", 3, Time.new.inspect
player2 = Player.new "test1", 5, Time.new.inspect
player3 = Player.new "test2", 6, Time.new.inspect

ld = Leaderboard.new
ld.save_player(player1)
ld.save_player(player2)
ld.save_player(player3)

arr = Array.new
ld.read_players(arr)
ld.sort_leaderboard(arr)
ld.print_leaderboard(arr)