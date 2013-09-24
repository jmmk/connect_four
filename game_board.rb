require 'pry'

class GameBoard
  attr_reader :board, :rows, :columns, :plays

  CONNECTIONS = {
    '[0][0]' => 'downleft',
    '[0][1]' => 'bottom',
    '[0][2]' => 'downright',
    '[1][0]' => 'left',
    '[1][2]' => 'right',
    '[2][0]' => 'upleft',
    '[2][2]' => 'upright'
  }

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
    column = piece.column

    @plays[column - 1] << piece
    piece.row = get_row(column)
    @board[piece.row][column] = player.token
    set_connections(piece)
  end

  def check_connections(current_piece)
    axes = [
      [:left, :right],
      [:bottom, :top],
      [:upright, :downleft],
      [:upleft, :downright]
    ]

    axes.each do |axis|
      count = 0
      axis.each do |direction|
        count += check_line(current_piece.send(direction), direction) if current_piece.send(direction)
      end

      return true if count >= 3
    end
    false
  end

  def full?
    !@board[0].include?(' ')
  end

  private

  def get_row(column)
    @rows - @plays[column - 1].length
  end

  def valid_row?(row)
    (1..@rows).include?(row) ? true : false
  end

  def valid_column?(column)
    (1..@columns).include?(column) ? true : false
  end

  def full_column?(column)
    @plays[column - 1].length >= @rows ? true : false
  end

  def connection_columns(piece)
    column = piece.column - 1
    [column - 1, column, column + 1]
  end

  def connection_rows(piece)
    row = @plays[piece.column - 1].length - 1
    [row - 1, row, row + 1]
  end

  def set_connections(current_piece)
    columns = connection_columns(current_piece)
    rows = connection_rows(current_piece)

    rows.each_with_index do |row, r|
      columns.each_with_index do |col, c|
        break if !valid_row?(row + 1)
        next if !valid_column?(col + 1)

        piece = @plays[col][row]
        if !piece.nil? && piece != current_piece && piece.player == current_piece.player
          current_piece.send("#{CONNECTIONS["[#{r}][#{c}]"]}=", piece)
        end
      end
    end
  end

  def check_line(current_piece, direction, count = 1)
    if current_piece.send(direction)
      check_line(current_piece.send(direction), direction, count + 1)
    else
      count
    end
  end

end
