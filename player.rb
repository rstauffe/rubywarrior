class Player
  def play_turn(warrior)
		if warrior.feel.captive?
			warrior.rescue!
		elsif (!warrior.feel.empty?)
			warrior.attack!
		elsif warrior.health < 13 and warrior.health >= @health
			warrior.rest!
		else
			warrior.walk!
		end
		@health = warrior.health
  end
end
