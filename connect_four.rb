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
    print_board
    select_column(@player1)
    select_column(@player2)
    select_column(@player1)
    select_column(@player2)
    select_column(@player1)
    select_column(@player2)
    select_column(@player1)
    select_column(@player2)
  end

  def get_names
    print "Please enter the first player's name: "
    @player1 = Player.new(gets.chomp, "X")
    print "Please enter the second player's name: "
    @player2 = Player.new(gets.chomp, "O")
    @player2.name << '-2' if @player2.name == @player1.name
  end

  def select_column(player)
    print 'Which column would you like to play in? '
    column = validate

    @game_board.each_with_index do |row, index|
      if row[column] != ' '
        make_play(player, index - 1, column)
        break
      end
    end
   end

  def validate
    loop do
      column = gets.chomp.to_i
      if !(1..@game_board[0].length - 2).include?(column)
        print 'Invalid column, choose again: '
      elsif @game_board[0][column] != ' '
        print 'Column is full, choose again: '
      else
        return column
      end
    end
  end

  def make_play(player, row, column)
    piece = Piece.new(row,column)
    player.plays << piece
    update_board(player)
  end

  def update_board(player)
    @game_board[player.plays.last.row][player.plays.last.column] = player.token
    print_board
  end

  def print_board
    @game_board.each {|line| puts line.join(' ')}
  end

end

game = ConnectFour.new
game.start