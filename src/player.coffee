class Player
	constructor: () ->
		@direction = @DIR_RIGHT
		@currentImage = @IMG_STANDING
		@walkingImage = @IMG_WALKING
		walkcb = =>
			@switchWalk()
		setInterval walkcb, 200
	
	activated: false
	alive: true
	burnt: false
	x: 0
	y: 0
	width: 20
	height: 25
	velocityX: 0
	velocityY: 0
	nearestPlanet: false
	jumping: false
	jumpVelocity: 0
	maxJump: 40
	minJump: 10
	maxSpeed: 3
	onGround: false
	walking: false
	
	maxOxygen: 1000
	oxygen: 1000
	
	DEAD: "dead"
	FINISHED: "finished"
	
	DIR_RIGHT: "right"
	DIR_LEFT: "left"
	
	IMG_STANDING: "standing"
	IMG_WALKING: "walking"
	IMG_SQUATTING: "squatting"
	IMG_FLYING: "flying"
	IMG_BURNT: "burnt"
	
	walkingImage: ""
	currentImage: ""
	lastImageChange: 0
	
	accel: (angle, force, cap) ->
		if @activated
			@velocityX += (Math.cos angle) * force
			@velocityY += (Math.sin angle) * force
			if cap and Math.sqrt (Math.pow @velocityX, 2) + (Math.pow @velocityY, 2) > @maxSpeed
				angle = Math.PI/2 - Math.atan2 @velocityX, @velocityY
				@velocityX = (Math.cos angle) * @maxSpeed
				@velocityY = (Math.sin angle) * @maxSpeed
	
	calculatePhysics: (planets) ->
		og = @onGround
		@onGround = false
		nearPlanet = false
		for planet in planets
			do (planet) =>
				if !og or planet.distance < 20
					planet.physics this
				dist = planet.distance
				if (dist < planet.radius)
					nearPlanet = true
				if dist < 10
					@onGround = true
					@velocityX *= .99
					@velocityY *= .99
					
					if dist <= 0
						if !planet.safe
							@death()
						if planet.goal
							@finished()
						angle = Math.PI/2 - Math.atan2 planet.x-@x, planet.y-@y
						@x = planet.x - (Math.cos angle) * planet.radius
						@y = planet.y - (Math.sin angle) * planet.radius
					if dist < 5 && !@walking
						@velocityX *= 0.5
						@velocityY *= 0.5
						
		if nearPlanet
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
		if @onGround and !@jumping
			if Math.abs(@velocityX) + Math.abs(@velocityY) > 0.1
				@currentImage = @walkingImage
			else
				@currentImage = @IMG_STANDING
		else
			if @jumping
				@currentImage = @IMG_SQUATTING
			else
				@currentImage = @IMG_FLYING
		
		#@velocityX *= .1
		#@velocityY *= .1
		this
	
	switchWalk: () ->
		if @walkingImage != @IMG_WALKING
			@walkingImage = @IMG_WALKING
		else
			@walkingImage = @IMG_STANDING
	
	findNearestPlanet: (planets, log) ->
		@nearestPlanet = planets[0]
		nearestDistance = @nearestPlanet.distance
		for planet in planets
			do (planet) =>
				dist = planet.distance
				if dist < nearestDistance
					@nearestPlanet = planet
					nearestDistance = dist
				else
					#console.log "Nope! " + @distanceTo(planet) + " > " + nearestDistance if log
		@nearestPlanet
	
	startJumping: () ->
		if @alive and @activated
			@jumping = true
			@jumpVelocity = @minJump
			cb = =>
				#console.log "cb: "+@jumpVelocity
				@jumpVelocity = if @jumpVelocity + 1 < @maxJump then @jumpVelocity + 1 else @maxJump
				if @jumping then setTimeout cb, 30
			cb()
		this
	
	jump: () ->
		if @alive and @activated
			#console.log "Jump! "+@jumpVelocity
			@accel (@g.rotation - Math.PI), @jumpVelocity
			@jumping = false
			@jumpVelocity = @minJump
		this
	
	draw: (@s, @g) ->
		if @activated
			if @oxygen > 0
				@oxygen -= 2
			else
				@death()
		
		x = @x - @g.offsetX
		y = @y - @g.offsetY
		angle = Math.atan2 x, y
		dist = Math.sqrt (Math.pow x, 2) + (Math.pow y, 2)
		angle += @g.rotation
		x = (Math.cos angle) * dist
		y = (Math.sin angle) * dist
		x += @g.w/2
		y += @g.h/2
		if !@alive
			@currentImage = if @burnt then @IMG_BURNT else @IMG_STANDING
		@s.image @s[@currentImage + "_" + @direction], x-@width/2, y-@height
		#@s.noStroke()
		#@s.fill 255, 0, 0
		#@s.rect x-@width-2, y-@height, @width, @height
	
	reset: () ->
		@velocityX = @velocityY = 0
		@jumping = false
		@jumpVelocity = 0
		@onGround = false
		@burnt = false
		@alive = true
		@activated = true
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
		
