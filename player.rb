class Player
	@@been_back = 0
	
  def play_turn(warrior)
		is_under_attack(warrior)
	
			#initial movement is toward back wall
		if (warrior.feel(:backward).empty? and @@been_back == 0)
			warrior.walk!(:backward)
			
			#captive checks
		elsif warrior.feel.captive? 
			warrior.rescue!
		elsif warrior.feel(:backward).captive?
			warrior.rescue!(:backward)
			#check if at back wall
		elsif warrior.feel(:backward).wall?
			@@been_back = 1
			warrior.walk!
		elsif warrior.health < 10 and @incombat and warrior.feel.empty?
			warrior.walk!(:backward)
			
			#attack if enemy in front
		elsif (!warrior.feel.empty?)
			warrior.attack!
		elsif !warrior.feel(:backward).empty?
			warrior.attack!(:backward)
			
			#heal if below threshold
		elsif warrior.health < 16 and warrior.health >= @health
			warrior.rest!
			#walk by default
		else
			warrior.walk!
		end
		@health = warrior.health
  end
		
	def is_under_attack(warrior)
		if @health == nil
			@health = 20
		end
		@incombat = warrior.health < @health
	end
		
end
