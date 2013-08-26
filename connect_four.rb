#!/usr/bin/env ruby
require './player'
require './piece'

class ConnectFour

  def initialize
    puts "Go for it... Connect Four!"
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
    rotate_play(@player1)
  end

  def get_names
    print "Please enter the first player's name: "
    @player1 = Player.new(gets.chomp, "X")
    print "Please enter the second player's name: "
    @player2 = Player.new(gets.chomp, "O")
    @player2.name << '-2' if @player2.name == @player1.name
  end

  def select_column(player)
    print "#{ player.name }, which column would you like to play in? "
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
    tie_game if !@game_board[0].include?(' ')
    set_connections(player, player.plays.last)
  end

  def print_board
    @game_board.each {|line| puts line.join(' ')}
  end

  def rotate_play(player)
    loop do
      select_column(player)
      player = player == @player1 ? @player2 : @player1
    end
  end

  def set_connections(player, current_piece)
    player.plays.each do |piece|
      break if piece == current_piece

      if piece.row == current_piece.row
        set_horizontal_connections(piece, current_piece)
      elsif piece.column == current_piece.column
        set_vertical_connections(piece, current_piece)
      end
      set_diagonal_connections(piece, current_piece)
    end

    check_connections(player, current_piece)
  end

  def set_horizontal_connections(piece, current_piece)
      if piece.column == current_piece.column - 1
        piece.right = current_piece
        current_piece.left = piece
      elsif piece.column == current_piece.column + 1
        piece.left = current_piece
        current_piece.right = piece
      end
  end

  def set_vertical_connections(piece, current_piece)
      if piece.row == current_piece.row - 1
        piece.botttom = current_piece
        current_piece.top = piece
      elsif piece.row == current_piece.row + 1
        piece.top = current_piece
        current_piece.bottom = piece
      end
  end

  def set_diagonal_connections(piece, current_piece)
    if piece.column == current_piece.column - 1 && piece.row == current_piece.row + 1
      piece.upright = current_piece
      current_piece.downleft = piece
    elsif piece.column == current_piece.column + 1 && piece.row == current_piece.row - 1
      piece.downleft = current_piece
      current_piece.upright = piece
    elsif piece.column == current_piece.column + 1 && piece.row == current_piece.row + 1
      piece.upleft = current_piece
      current_piece.downright = piece
    elsif piece.column == current_piece.column - 1 && piece.row == current_piece.row - 1
      piece.downright = current_piece
      current_piece.upleft = piece
    end
  end

  def check_connections(player, current_piece)
    directions = [[:left, :right], [:bottom, :top],
                  [:upright, :downleft], [:upleft, :downright]]

    directions.each do |axes|
      count = 0
      count += check_line(player, current_piece.send(axes[0]), axes[0]) if current_piece.send(axes[0])
      count += check_line(player, current_piece.send(axes[1]), axes[1]) if current_piece.send(axes[1])
      winner(player) if count >= 3
    end
  end

  def check_line(player, current_piece, direction, count = 1)
    if current_piece.send(direction)
      winner(player) if count == 2
      check_line(player, current_piece.send(direction), direction, count + 1)
    else
      count
    end
  end

  def winner(player)
    puts "Congratulations, #{ player.name } is the winner!"
    exit
  end

  def tie_game
    puts "\nOH NO! It's a tie!"
    exit
  end

end

game = ConnectFour.new
game.start
