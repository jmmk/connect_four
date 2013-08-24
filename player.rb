class Player
  attr_accessor :name, :plays, :token

  def initialize(name, token)
    @name = name
    @plays = []
    @token = token
  end

end