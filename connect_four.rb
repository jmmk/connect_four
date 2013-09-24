#!/usr/bin/env ruby

require './player'
require './piece'
require './game_board'
require 'pry'

class ConnectFour

  def initialize
    puts "Go for it... Connect Four!"
    @game_board = GameBoard.new(6, 7)
  end

  def start
    get_names
    @game_board.print_board
    rotate_play(@player1)
  end

  def get_names
    print "Please enter the first player's name: "
    @player1 = Player.new(gets.chomp, "X")
    print "Please enter the second player's name: "
    @player2 = Player.new(gets.chomp, "O")
    make_names_unique
  end

  def select_column(player)
    print "#{ player.name }, which column would you like to play in? "
    column = @game_board.get_valid_column
    make_play(player, column)
  end

  def make_play(player, column)
    piece = Piece.new(column, player)
    check_game_status(player, piece)
  end

  def check_game_status(player, piece)
    @game_board.update(player, piece)
    @game_board.print_board
    declare_winner(player) if @game_board.check_connections(piece)
    tie_game if @game_board.full?
  end

  def rotate_play(player)
    loop do
      select_column(player)
      player = switch_player(player)
    end
  end

  private

  def make_names_unique
    @player2.name << '-2' if @player2.name == @player1.name
  end

  def switch_player(player)
    player == @player1 ? @player2 : @player1
  end

  def tie_game
    puts "\nOH NO! It's a tie!"
    exit
  end

  def declare_winner(player)
    puts "Congratulations, #{ player.name } is the winner!"
    exit
  end

end

game = ConnectFour.new
game.start
