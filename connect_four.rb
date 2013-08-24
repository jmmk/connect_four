#!/usr/bin/env ruby
require './player'

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
    @game_board.each {|line| puts line.join(' ')}
    print 'Which column would you like to play in? '
    column = gets.chomp
    make_play(player, column)
  end

  def make_play(player, column)
    player.plays << Piece.new(0,column)
  end


end

game = ConnectFour.new
game.start