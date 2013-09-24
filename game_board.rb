require 'pry'

class GameBoard
  attr_reader :board, :rows, :columns, :plays

  def initialize(rows, columns)
    @rows = rows
    @columns = columns
    @board = []
    @plays = Array.new(columns) { [] }
    assemble_board
  end

  def assemble_board
    (0..@columns + 1).each do |column|
      (@rows + 1).times do |row|
        if column == 0
          @board << (row == @rows ? [' '] : ['|'])
        elsif column == @columns + 1
          @board[row] << '|' if row != @rows
        else
          @board[row] << (row == @rows ? column : ' ')
        end
      end
    end
  end

  def print_board
    @board.each { |row| puts row.join(' ') }
  end

  def get_valid_column
    loop do
      column = gets.chomp.to_i
      if !valid_column?(column)
        print 'Invalid column, choose again: '
      elsif full_column?(column)
        print 'Column is full, choose again: '
      else
        return column
      end
    end
  end

  def update(player, piece)
    @plays[piece.column] << piece
    piece.row = get_row(piece.column)
    @board[piece.row - 1][piece.column] = player.token
    set_connections(piece)
  end

  def check_connections(current_piece)
    directions = [
      [:left, :right],
      [:bottom, :top],
      [:upright, :downleft],
      [:upleft, :downright]
    ]

    directions.each do |axes|
      count = 0
      axes.each do |direction|
        count += check_line(current_piece.send(direction), direction) if current_piece.send(direction)
      end

      return true if count >= 3
    end
    false
  end

  def full?
    !@board[0].include?(' ')
  end

  def get_row(column)
    @columns - @plays[column].length
  end

  private

  def valid_column?(column)
    (1..@columns).include?(column) ? true : false
  end

  def full_column?(column)
    @plays[column].length >= @rows ? true : false
  end

  def set_connections(current_piece)
    @plays.each do |row|
      row.each do |piece|
        break if piece.nil? || piece == current_piece
        next if piece.player != current_piece.player

        if piece.row == current_piece.row
          set_horizontal_connections(piece, current_piece)
        elsif piece.column == current_piece.column
          set_vertical_connections(piece, current_piece)
        end
        set_diagonal_connections(piece, current_piece)
      end
    end
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

  def check_line(current_piece, direction, count = 1)
    if current_piece.send(direction)
      # return true if count == 2
      check_line(current_piece.send(direction), direction, count + 1)
    else
      count
    end
  end

end
