#!/usr/bin/env ruby
require './player'
require './piece'

class ConnectFour

  def initialize
    @game_board = [['|',' ',' ',' ',' ',' ',' ',' ','|'],
                  ['|',' ',' ',' ',' ',' ',' ',' ','|'],
                  ['|',' ',' ',' ',' ',' ',' ',' ','|'],
                  ['|',' ',' ',' ',' ',' ',' ',' ','|'],
                  ['|',' ',' ',' ',' ',' ',' ',' ','|'],
                  ['|',' ',' ',' ',' ',' ',' ',' ','|'],
                  [' ','1','2','3','4','5','6','7']]
  end

  def start
    get_names
    select_column(@player1)
  end

  def get_names
    print "Please enter the first player's name: "
    @player1 = Player.new(gets.chomp)
    print "Please enter the second player's name: "
    @player2 = Player.new(gets.chomp)
    @player2.name << '-2' if @player2.name == @player1.name
  end

  def select_column(player)
    print_board
    print 'Which column would you like to play in? '
    column = gets.chomp.to_i
    make_play(player, column)
  end

  def make_play(player, column)
    piece = Piece.new(1,column)
    player.plays << piece
    update_board(player)
  end

  def update_board(player)
    @game_board[@game_board.size - 2][player.plays.last.column] = "X"
    print_board
  end

  def print_board
    @game_board.each {|line| puts line.join(' ')}
  end

end

game = ConnectFour.new
game.start