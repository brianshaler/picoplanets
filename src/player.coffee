class Player
	constructor: () ->
		# @direction: Player's last direction to show correct version of the sprite
		@direction = @DIR_RIGHT
		# @currentImage: The current sprite may be standing, walking, squatting, flying, burnt...
		@currentImage = @IMG_STANDING
		
		# whether or not the player can control the character
		@activated = false
		# u dead yet?
		@alive = true
		# if you die a certain way...
		@burnt = false
		# player's position relative to the galactic center
		@x = 0
		@y = 0
		
		@width = 20
		@height = 25
		
		@velocityX = 0
		@velocityY = 0
		
		# cached reference to a planet, result of @findNearestPlanet()
		@nearestPlanet = false
		@jumping = false
		@jumpVelocity = 0
		@maxJump = 40
		@minJump = 10
		@maxSpeed = 3
		@onGround = false
		@walking = false
		@nearAnyPlanet = true
		
		@maxOxygen = 1000
		@oxygen = 1000
		
		@lastImageChange = 0
		
		# @walkingImage: When set to walking, this will periodically change from standing to walking and back
		@walkingImage = @IMG_WALKING
		walkcb = =>
			# toggles between standing and walking
			@switchWalk()
		setInterval walkcb, 200
		
	# static vars
	DEAD: "dead"
	FINISHED: "finished"
	DIR_RIGHT: "right"
	DIR_LEFT: "left"
	IMG_STANDING: "standing"
	IMG_WALKING: "walking"
	IMG_SQUATTING: "squatting"
	IMG_FLYING: "flying"
	IMG_BURNT: "burnt"
	
	accel: (angle, force, cap) ->
		if @activated
			@velocityX += (Math.cos angle) * force
			@velocityY += (Math.sin angle) * force
			if cap and Math.sqrt (Math.pow @velocityX, 2) + (Math.pow @velocityY, 2) > @maxSpeed
				angle = HALF_PI - Math.atan2 @velocityX, @velocityY
				@velocityX = (Math.cos angle) * @maxSpeed
				@velocityY = (Math.sin angle) * @maxSpeed
	
	###
	@calculatePhysics()
	runs through planets array, calling .physics() for each
	sets @onGround and @walking
	###
	calculatePhysics: (planets) ->
		og = @onGround
		@onGround = false
		nearPlanet = false
		@nearAnyPlanet = false
		for planet in planets
			do (planet) =>
				if !og or planet.distance < 20
					# magic happens: see mass.coffee
					# side-effect: planet.physics(player) alters player.velocityX and player.velocityY
					planet.physics this
				dist = planet.distance
				
				# within a reasonable distance of a planet
				if dist < planet.radius
					nearPlanet = true
				
				if dist < planet.radius * planet.gravitationalRange
					@nearAnyPlanet = true
				
				# practically touching ground
				if dist < 10
					@onGround = true
					@velocityX *= .99
					@velocityY *= .99
					
					if dist <= 0
						# maybe death() and finished() should be called from planet.onContact(player) ?
						if @activated
							if !planet.safe
								@death()
							if planet.goal
								@finished()
						angle = HALF_PI - Math.atan2 planet.x-@x, planet.y-@y
						@x = planet.x - (Math.cos angle) * planet.radius
						@y = planet.y - (Math.sin angle) * planet.radius
					if dist < 5 && !@walking
						@velocityX *= 0.5
						@velocityY *= 0.5
						
		if nearPlanet
			# maybe it's like an atmosphere? better for gameplay to slow down and land
			@velocityX *= .99
			@velocityY *= .99
		
		if !@onGround
			@walking = false
						
		this
	
	move: () ->
		if !@burnt
			@x += @velocityX
			@y += @velocityY
		d = new Date()
		t = d.getTime()
		if @activated and @alive
			if @onGround and !@jumping
				if (Math.abs @velocityX) + (Math.abs @velocityY) > 0.1
					@currentImage = @walkingImage
				else
					@currentImage = @IMG_STANDING
			else
				if @jumping
					@currentImage = @IMG_SQUATTING
				else
					@currentImage = @IMG_FLYING
		
		# pshaw! there's no friction in SPACE!!
		#@velocityX *= .1
		#@velocityY *= .1
		this
	
	switchWalk: () ->
		if @walkingImage != @IMG_WALKING
			@walkingImage = @IMG_WALKING
		else
			@walkingImage = @IMG_STANDING
	
	findNearestPlanet: (planets) ->
		@nearestPlanet = planets[0]
		nearestDistance = @nearestPlanet.distance
		for planet in planets
			do (planet) =>
				dist = planet.distance
				if dist < nearestDistance
					@nearestPlanet = planet
					nearestDistance = dist
		@nearestPlanet
	
	startJumping: () ->
		if @alive and @activated
			@jumping = true
			@jumpVelocity = @minJump
			cb = =>
				@jumpVelocity = if @jumpVelocity + 1 < @maxJump then @jumpVelocity + 1 else @maxJump
				if @jumping then setTimeout cb, 30
			cb()
		this
	
	jump: () ->
		if @alive and @activated
			@accel @galaxy.rotation - Math.PI, @jumpVelocity
			@jumping = false
			@jumpVelocity = @minJump
		this
	
	draw: (@sketch, @galaxy) ->
		if @activated
			if @oxygen > 0
				@oxygen -= 2
				if !@nearAnyPlanet
					@oxygen -= (@nearestPlanet.distance - @nearestPlanet.radius*@nearestPlanet.gravitationalRange) / @nearestPlanet.radius
			else
				@death()
		
		x = @x - @galaxy.offsetX
		y = @y - @galaxy.offsetY
		angle = Math.atan2 x, y
		dist = Math.sqrt (Math.pow x, 2) + (Math.pow y, 2)
		angle += @galaxy.rotation
		x = (Math.cos angle) * dist
		y = (Math.sin angle) * dist
		x += @galaxy.w/2
		y += @galaxy.h/2
		if @burnt
			@currentImage = @IMG_BURNT
		@sketch.image @sketch[@currentImage + "_" + @direction], x-@width/2, y-@height
		#@sketch.noStroke()
		#@sketch.fill 255, 0, 0
		#@sketch.rect x-@width-2, y-@height, @width, @height
	
	reset: () ->
		@velocityX = @velocityY = 0
		@jumping = false
		@jumpVelocity = 0
		@onGround = false
		@burnt = false
		@alive = true
		@activated = true
		@nearAnyPlanet = true
		this
	
	death: () ->
		@activated = false
		@alive = false
		cb = =>
			radio(@DEAD).broadcast()
		setTimeout cb, 1000
	
	finished: () ->
		@activated = false
		cb = =>
			radio(@FINISHED).broadcast()
		setTimeout cb, 400
