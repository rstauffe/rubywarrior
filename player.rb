class Player
	#measure if warrior has hit back wall yet
	@@been_back = 0
	
  def play_turn(warrior)
		#read if under attack
		is_under_attack(warrior)
		
		#check if facing "backward"
		if warrior.feel.wall?
			warrior.pivot!(:backward)
			@@been_back = 1
			
			#initial movement is toward rear wall
		elsif (warrior.feel(:backward).empty? and @@been_back == 0)
			warrior.walk!(:backward)
			
			#captive checks
		elsif warrior.feel.captive? 
			warrior.rescue!
		elsif warrior.feel(:backward).captive?
			warrior.rescue!(:backward)
			
			#retreat if sufficiently wounded and not in melee range
		elsif warrior.health < 10 and @incombat and warrior.feel.empty?
			warrior.walk!(:backward)
			
			#attack if enemy in front
		elsif (!warrior.feel.empty? and !warrior.feel.wall?)
			warrior.attack!
		elsif !warrior.feel(:backward).empty? and !warrior.feel(:backward).wall?
			warrior.attack!(:backward)
			
			#heal if below threshold
		elsif warrior.health < 16 and !@incombat
			warrior.rest!
			
			#check if at rear wall
		elsif warrior.feel(:backward).wall?
			@@been_back = 1
			warrior.walk!
			
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
