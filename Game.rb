require 'tk'
require 'tkextlib/tile'
require './Leaderboard.rb'

root = TkRoot.new {title "Guessing Game"; background 'AntiqueWhite3'}
content = Tk::Tile::Frame.new(root) {padding "15 15 15 15"}.grid( :sticky => 'nsew')
TkGrid.columnconfigure root, 0, :weight => 1; TkGrid.rowconfigure root, 0, :weight => 1

$guess = TkVariable.new
$number = TkVariable.new
$number.value = 'Try number in range (1...1000)'
$secret_num = rand(1..1000)
$num_attempts = TkVariable.new
$num_attempts.value = 0
$nickname = TkVariable.new
$close = TkVariable.new
$close.value = ''

c1 = Tk::Tile::Label.new(content) {text 'Guess number from 1 to 1000'; background 'AntiqueWhite3'; foreground 'gray1'; font 'bold'}.grid( :column => 1, :row => 1)
$c2 = Tk::Tile::Entry.new(content) {width 10; textvariable $guess}.grid( :column => 1, :row => 3, :sticky => 'we' )
$c3 = Tk::Tile::Button.new(content) {state 'normal'; text 'Insert number'; command {calculate}}.grid( :column => 3, :row => 3, :sticky => 'e')
c4 = Tk::Tile::Label.new(content) {textvariable $number; background 'tan'; font 'bold'}.grid( :column => 4, :row => 3, :sticky => 'e')
c5 = Tk::Tile::Button.new(content) {text 'Restart game'; command {reset}}.grid( :column => 5, :row => 4, :sticky => 'e')
c6 = Tk::Tile::Label.new(content) {text 'number of attempts:'; background 'AliceBlue'}.grid( :column => 1, :row => 5, :sticky => 'w')
c7 = Tk::Tile::Label.new(content) {textvariable $num_attempts; background 'AliceBlue'; font 'bold'}.grid( :column => 2, :row => 5, :sticky => 'we')
c8 = Tk::Tile::Button.new(content) {text 'Close game'; command {close}}.grid( :column => 5, :row => 5, :sticky => 'e')

c9 = Tk::Tile::Label.new(content) {text 'Insert your nickname:'; background 'AliceBlue'}.grid( :column => 4, :row => 1, :sticky => 'e')
c10 = Tk::Tile::Entry.new(content) {width 10; textvariable $nickname}.grid( :column => 5, :row => 1, :sticky => 'e')
$c11 = Tk::Tile::Button.new(content) {state 'disabled'; text 'Add score'; command {add_player}}.grid( :column => 5, :row => 2, :sticky => 'e')
$c12 = Tk::Tile::Button.new(content) {text 'Leaderboard'; command {show_leaderboard}}.grid( :column => 5, :row => 3, :sticky => 'e')
$c13 = Tk::Tile::Label.new(content) {textvariable $close; foreground 'red'; font 'bold'}.grid( :column => 4, :row => 4, :sticky => 'w')

TkWinfo.children(content).each {|w| TkGrid.configure w, :padx => 5, :pady => 5}
$c2.focus
#root.bind("Return") {calculate}
$enjoy = Tk::Tile::Label.new(root) {text 'enjoy game :)'; font 'helvetica 9'; font 'bold'; background 'AntiqueWhite3'; foreground 'gray1'}
$enjoy.grid :padx => 10, :pady => 20

$ld = Leaderboard.new
$arr = Array.new

def calculate
  #puts "#{$secret_num}" #print into terminal secret number
  begin
    if $guess > 0 and $guess <= 1000
      $num_attempts.value = $num_attempts + 1
      check_num($guess)
    else
      $number.value = 'Try number in range (1...1000)'
      $close.value = ''
    end
    rescue
      $number.value = 'Wrong input, try again!'
      $close.value = ''
  end
end

def check_num(number)
  if number == $secret_num
    $number.value = 'YOU WIN'
    $close.value = 'YOU ARE GENIUS'
    $c3['state'] = :disabled
    $c11['state'] = :normal
  elsif number < $secret_num
    $number.value = 'too small'
    is_close
  elsif number > $secret_num
    $number.value = 'too big'
    is_close
  end
end

def is_close
  if $guess - $secret_num > -10 and $guess - $secret_num < 10
    $close.value = 'You are VERY close!'
  elsif  $guess - $secret_num > -100 and $guess - $secret_num < 100
    $close.value = 'You are close.'
  else
    $close.value = ''
  end
end

def close
  Tk.destroy(root)
end

def reset
  $secret_num = rand(1..1000)
  $number.value = 'Try number in range (1...1000)'
  $num_attempts.value = 0
  $guess.value = ''
  $c3['state'] = :normal
  $c11['state'] = :disabled
  $close.value = ''
end

def add_player
  $c11['state'] = :disabled
  if $nickname == ''
    $nickname = 'anonymous'
  end
  if $num_attempts < 10
    player = Player.new $nickname, $num_attempts, Time.new.inspect
    $ld.save_player(player)
    Tk.messageBox('icon' => 'info',
                  'type' => 'ok',
                  'title' => 'Save score',
                  'message' => "Saved successfully")
  else
    Tk.messageBox('icon' => 'error',
                  'type' => 'ok',
                  'title' => '... pathetic score',
                  'message' => "Your score is too bad :)")
  end

end

def show_leaderboard
  $ld.read_players($arr)
  $ld.sort_leaderboard($arr)
  $ld.print_leaderboard($arr)

  begin
    $win.destroy
  rescue
    # Ignored
  end
  $win = TkToplevel.new {title "Leaderboard"; width 500; height 500}
  if $arr.length == 0
    TkLabel.new($win) {
      text "NOTHING TO DISPLAY"
      pack
    }
  end
  if $arr.length > 10
    $temp = $arr.take(10)
    $temp.each {|label|
      TkLabel.new($win) {
        text "Attempts: #{label[1]}, Nickname: #{label[0]}, Date: #{label[2]}"
        pack
      }
    }
  else
    $arr.each {|label|
      TkLabel.new($win) {
        text "Attempts: #{label[1]}, Nickname: #{label[0]}, Date: #{label[2]}"
        pack
      }
    }
  end

  TkButton.new($win) {
    text 'Close'
    command "$win.destroy"
    pack
  }
  $arr = Array.new
end


Tk.mainloop
