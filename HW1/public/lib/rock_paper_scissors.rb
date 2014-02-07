class RockPaperScissors
  #
  # Exceptions this class can raise:
  class WrongNumberOfPlayersError < StandardError ; end
  class NoSuchStrategyError < StandardError ; end

  def self.winner(player1, player2)
    # YOUR CODE HERE
    p1 = player1[1].upcase
    p2 = player2[1].upcase

    strategies = ['R','P','S']
    if !strategies.include?(p1) || !strategies.include?(p2)
    	raise NoSuchStrategyError, "Strategy must be one of R,P,S"
    end

    if ["RP","PS","SR"].include?(p1+p2)
    	return player2
    else
    	return player1
    end
  end

  def self.tournament_winner(tournament)
    # YOUR CODE HERE
    if !tournament[0][0].is_a? Array
      return RockPaperScissors.winner(tournament[0],tournament[1])
    else
      return RockPaperScissors.winner(RockPaperScissors.tournament_winner(tournament[0]),RockPaperScissors.tournament_winner(tournament[1]))
    end
  end

end

#RockPaperScissors.winner(['Dave', 'R'], ['Dave', 'w'])

