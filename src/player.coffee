`/* @pjs preload="images/standing.png"; */`
`/* @pjs preload="images/walking.png"; */`
`/* @pjs preload="images/squatting.png"; */`
`/* @pjs preload="images/flying.png"; */`

class Player
	constructor: () ->
		@direction = @DIR_RIGHT
		@currentImage = @IMG_STANDING
		@walkingImage = @IMG_WALKING
		cb = =>
			@switchWalk()
			
		setInterval cb, 200
	
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
	maxSpeed: 20
	onGround: false
	
	DIR_RIGHT: "right"
	DIR_LEFT: "left"
	
	IMG_STANDING: "standing"
	IMG_WALKING: "walking"
	IMG_SQUATTING: "squatting"
	IMG_FLYING: "flying"
	walkingImage: ""
	currentImage: ""
	lastImageChange: 0
	
	accel: (angle, force, cap) ->
		@velocityX += (Math.cos angle) * force
		@velocityY += (Math.sin angle) * force
		if cap and Math.sqrt (Math.pow @velocityX, 2) + (Math.pow @velocityY, 2) > @maxSpeed
			angle = Math.PI/2 - Math.atan2 @velocityX, @velocityY
			@velocityX = (Math.cos angle) * @maxSpeed
			@velocityY = (Math.sin angle) * @maxSpeed
	
	calculatePhysics: (planets) ->
		@onGround = false
		for planet in planets
			do (planet) =>
				dist = @distanceTo(planet)
				if dist < planet.radius*3
					if dist > 0
						@velocityX *= .99
						@velocityY *= .99
						pull = (Math.sqrt (1 - (dist / (planet.radius*3))) * (planet.radius+100)*.05)
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
					if dist < 10
						@onGround = true
						@velocityX *= .99
						@velocityY *= .99
		this
	
	move: () ->
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
		@jumpVelocity = @minJump
		cb = =>
			#console.log "cb: "+@jumpVelocity
			@jumpVelocity = if @jumpVelocity + 1 < @maxJump then @jumpVelocity + 1 else @maxJump
			if @jumping then setTimeout cb, 30
		cb()
	
	jump: () ->
		#console.log "Jump! "+@jumpVelocity
		@accel (window.rotation - Math.PI), @jumpVelocity
		@jumping = false
		@jumpVelocity = @minJump
	
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
		@s.image @s[@currentImage + "_" + @direction], x-@width-2, y-@height
		#@s.noStroke()
		#@s.fill 255, 0, 0
		#@s.rect x-@width-2, y-@height, @width, @height
	
	distanceTo: (planet) ->
		(Math.sqrt (Math.pow planet.x-@x, 2) + (Math.pow planet.y-@y, 2)) - planet.radius