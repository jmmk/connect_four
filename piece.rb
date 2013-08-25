class Piece
  attr_accessor :left, :right, :top, :bottom, :row, :column,
                :upright, :upleft, :downright, :downleft

  def initialize(row, column)
    @row = row
    @column = column
    @left = @right = @top = @bottom = nil
    @upright = @upleft = @downright = @downleft = nil
  end

end