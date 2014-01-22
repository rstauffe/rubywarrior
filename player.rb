=begin
Instance var: @incombat, from function
Class var: @@been_back, to track if the wall has been touched
Constants: @@HEALTH, for tracking minimum and retreat health values
Array: used to pull data from warrior.look
Hash: @@HEALTH
Functions: is_under_attack
Comments: everywhere
=end

class Player
	#measure if warrior has hit back wall yet
	@@been_back = 0
	@@HEALTH = {:MIN => 16, :RETREAT => 10}
	
  def play_turn(warrior)
		#read if under attack
		is_under_attack(warrior)
		look0 = warrior.look[0]
		look1 = warrior.look[1]
		look2 = warrior.look[2]
		
		#check if at rear wall
		if warrior.feel(:backward).wall?
			@@been_back = 1
		end
		
		#check if facing "backward"
		if warrior.feel.wall?
			warrior.pivot!(:backward)
			@@been_back = 1
			
			#captive checks
		elsif warrior.feel.captive? 
			warrior.rescue!
		elsif warrior.feel(:backward).captive?
			warrior.rescue!(:backward)
			
			#attack if enemy in front
		elsif (!warrior.feel.empty? and !warrior.feel.wall?)
			warrior.attack!
			#or in rear
		elsif !warrior.feel(:backward).empty? and !warrior.feel(:backward).wall?
			warrior.attack!(:backward)
			
			#initial movement is toward rear wall
		elsif (warrior.feel(:backward).empty? and @@been_back == 0)
			warrior.walk!(:backward)
			
			#check for captive in front, to avoid shooting them
		elsif look1.captive? or (look1.empty? and look2.captive? )
			warrior.walk!			
			
		elsif (( !look0.empty? and !look1.wall? ))
			warrior.walk!(:backward)
			
		elsif look0.empty? and (!look1.empty? and !look1.wall?) or (!look1.empty? and !look2.wall?)
			warrior.shoot!
			
			#retreat if sufficiently wounded and not in melee range
		elsif warrior.health < @@HEALTH[:RETREAT] and @incombat and warrior.feel.empty?
			warrior.walk!(:backward)
			
			#heal if below threshold
		elsif warrior.health < @@HEALTH[:MIN] and !@incombat
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
