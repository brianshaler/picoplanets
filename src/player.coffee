`/* @pjs preload="images/standing.png"; */`
`/* @pjs preload="images/walking.png"; */`
`/* @pjs preload="images/squatting.png"; */`
`/* @pjs preload="images/flying.png"; */`

class Player
	constructor: () ->
		@currentImage = @IMG_STANDING
		cnt = 0
		cb = =>
			cnt++;
			if cnt > 0
				@walkingImage = @IMG_WALKING
			else
				@walkingImage = @IMG_STANDING
			if cnt > 3
				cnt = 0
		setInterval cb, 1000
	
	x: 0
	y: 0
	width: 20
	height: 25
	velocityX: 0
	velocityY: 0
	nearestPlanet: false
	jumping: false
	jumpVelocity: 0
	maxJump: 50
	minJump: 5
	maxSpeed: 10
	onGround: false
	
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
		d = new Date()
		t = d.getTime()
		if @onGround and !@jumping
			if @velocityX + @velocityY > 2
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
		@s.image @s[@currentImage], x-@width-2, y-@height
		#@s.noStroke()
		#@s.fill 255, 0, 0
		#@s.rect x-@width-2, y-@height, @width, @height
	
	distanceTo: (planet) ->
		(Math.sqrt (Math.pow planet.x-@x, 2) + (Math.pow planet.y-@y, 2)) - planet.radius