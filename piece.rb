class Piece
  attr_accessor :left, :right, :top, :bottom, :row, :column

  def initialize(row, column)
    @row = row
    @column = column
    @left = @right = @top = @bottom = nil
  end

end