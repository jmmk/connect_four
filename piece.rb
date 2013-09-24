class Piece
  attr_reader :player
  attr_accessor :left, :right, :top, :bottom, :row, :column,
                :upright, :upleft, :downright, :downleft

  def initialize(column, player)
    @player = player
    @column = column
    @left = @right = @top = @bottom = nil
    @upright = @upleft = @downright = @downleft = nil
  end

end
