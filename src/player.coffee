class Player
	constructor: () ->
	
	x: 0
	y: 0
	width: 20
	height: 30
	velocityX: 0
	velocityY: 0
	nearestPlanet: false
	jumping: false
	jump_velocity: 0
	max_jump: 40
	min_jump: 5
	max_speed: 10
	onGround: false
	
	accel: (angle, force, cap) ->
		@velocityX += (Math.cos angle) * force
		@velocityY += (Math.sin angle) * force
		if cap and Math.sqrt (Math.pow @velocityX, 2) + (Math.pow @velocityY, 2) > @max_speed
			angle = Math.PI/2 - Math.atan2 @velocityX, @velocityY
			@velocityX = (Math.cos angle) * @max_speed
			@velocityY = (Math.sin angle) * @max_speed
	
	calculatePhysics: (planets) ->
		@onGround = false
		for planet in planets
			do (planet) =>
				dist = @distanceTo(planet)
				if dist < planet.radius*2
					if dist > 0
						@velocityX *= .9
						@velocityY *= .9
						pull = (Math.sqrt (1 - (dist / (planet.radius*2))) * planet.radius*.2)
						angle = Math.PI/2 - Math.atan2 planet.x-@x, planet.y-@y
						@velocityX += (Math.cos angle) * pull
						@velocityY += (Math.sin angle) * pull
						dist = @distanceTo(planet)
					if dist <= 0
						angle = Math.PI/2 - Math.atan2 planet.x-@x, planet.y-@y
						@x = planet.x - (Math.cos angle) * planet.radius
						@y = planet.y - (Math.sin angle) * planet.radius
						@velocityX = 0
						@velocityY = 0
					if dist < 5
						@onGround = true
		this
	
	move: () ->
		@x += @velocityX
		@y += @velocityY
		#@velocityX *= .1
		#@velocityY *= .1
		this
	
	findNearestPlanet: (planets, log) ->
		@nearestPlanet = planets[0]
		nearestDistance = @distanceTo @nearestPlanet
		for planet in planets
			do (planet) =>
				dist = @distanceTo planet
				if dist < nearestDistance
					@nearestPlanet = planet
					nearestDistance = dist
				else
					#console.log "Nope! " + @distanceTo(planet) + " > " + nearestDistance if log
		@nearestPlanet
	
	startJumping: () ->
		@jumping = true
		@jump_velocity = @min_jump
		cb = =>
			#console.log "cb: "+@jump_velocity
			@jump_velocity = if @jump_velocity + 1 < @max_jump then @jump_velocity + 1 else @max_jump
			if @jumping then setTimeout cb, 10
		cb()
	
	jump: () ->
		#console.log "Jump! "+@jump_velocity
		@accel (window.rotation - Math.PI), @jump_velocity
		@jumping = false
		@jump_velocity = @min_jump
	
	draw: (@s, @g) ->
		x = @x - @g.offsetX
		y = @y - @g.offsetY
		angle = Math.atan2 x, y
		dist = Math.sqrt (Math.pow x, 2) + (Math.pow y, 2)
		angle += @g.rotation
		x = (Math.cos angle) * dist
		y = (Math.sin angle) * dist
		x += @g.w/2
		y += @g.h/2
		@s.noStroke()
		@s.fill 255, 0, 0
		@s.rect x-@width-2, y-@height, @width, @height
	
	distanceTo: (planet) ->
		(Math.sqrt (Math.pow planet.x-@x, 2) + (Math.pow planet.y-@y, 2)) - planet.radius