class Player
	constructor: () ->
		this.direction = this.DIR_RIGHT
		this.currentImage = this.IMG_STANDING
		this.walkingImage = this.IMG_WALKING
		walkcb = =>
			this.switchWalk()
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
		if this.activated
			this.velocityX += (Math.cos angle) * force
			this.velocityY += (Math.sin angle) * force
			if cap and Math.sqrt (Math.pow this.velocityX, 2) + (Math.pow this.velocityY, 2) > this.maxSpeed
				angle = Math.PI/2 - Math.atan2 this.velocityX, this.velocityY
				this.velocityX = (Math.cos angle) * this.maxSpeed
				this.velocityY = (Math.sin angle) * this.maxSpeed
	
	calculatePhysics: (planets) ->
		og = this.onGround
		this.onGround = false
		nearPlanet = false
		for planet in planets
			do (planet) =>
				if !og or planet.distance < 20
					planet.physics this
				dist = planet.distance
				if (dist < planet.radius)
					nearPlanet = true
				if dist < 10
					this.onGround = true
					this.velocityX *= .99
					this.velocityY *= .99
					
					if dist <= 0
						if !planet.safe
							this.death()
						if planet.goal
							this.finished()
						angle = Math.PI/2 - Math.atan2 planet.x-this.x, planet.y-this.y
						this.x = planet.x - (Math.cos angle) * planet.radius
						this.y = planet.y - (Math.sin angle) * planet.radius
					if dist < 5 && !this.walking
						this.velocityX *= 0.5
						this.velocityY *= 0.5
						
		if nearPlanet
			this.velocityX *= .99
			this.velocityY *= .99
		if !this.onGround
			this.walking = false
						
		this
	
	move: () ->
		if !this.burnt
			this.x += this.velocityX
			this.y += this.velocityY
		d = new Date()
		t = d.getTime()
		if this.onGround and !this.jumping
			if Math.abs(this.velocityX) + Math.abs(this.velocityY) > 0.1
				this.currentImage = this.walkingImage
			else
				this.currentImage = this.IMG_STANDING
		else
			if this.jumping
				this.currentImage = this.IMG_SQUATTING
			else
				this.currentImage = this.IMG_FLYING
		
		#this.velocityX *= .1
		#this.velocityY *= .1
		this
	
	switchWalk: () ->
		if this.walkingImage != this.IMG_WALKING
			this.walkingImage = this.IMG_WALKING
		else
			this.walkingImage = this.IMG_STANDING
	
	findNearestPlanet: (planets, log) ->
		this.nearestPlanet = planets[0]
		nearestDistance = this.nearestPlanet.distance
		for planet in planets
			do (planet) =>
				dist = planet.distance
				if dist < nearestDistance
					this.nearestPlanet = planet
					nearestDistance = dist
				else
					#console.log "Nope! " + this.distanceTo(planet) + " > " + nearestDistance if log
		this.nearestPlanet
	
	startJumping: () ->
		if this.alive and this.activated
			this.jumping = true
			this.jumpVelocity = this.minJump
			cb = =>
				#console.log "cb: "+this.jumpVelocity
				this.jumpVelocity = if this.jumpVelocity + 1 < this.maxJump then this.jumpVelocity + 1 else this.maxJump
				if this.jumping then setTimeout cb, 30
			cb()
		this
	
	jump: () ->
		if this.alive and this.activated
			#console.log "Jump! "+this.jumpVelocity
			this.accel (this.g.rotation - Math.PI), this.jumpVelocity
			this.jumping = false
			this.jumpVelocity = this.minJump
		this
	
	draw: (_s, _g) ->
		this.s = _s
		this.g = _g
		if this.activated
			if this.oxygen > 0
				this.oxygen -= 2
			else
				this.death()
		
		x = this.x - this.g.offsetX
		y = this.y - this.g.offsetY
		angle = Math.atan2 x, y
		dist = Math.sqrt (Math.pow x, 2) + (Math.pow y, 2)
		angle += this.g.rotation
		x = (Math.cos angle) * dist
		y = (Math.sin angle) * dist
		x += this.g.w/2
		y += this.g.h/2
		if !this.alive
			this.currentImage = if this.burnt then this.IMG_BURNT else this.IMG_STANDING
		this.s.image this.s[this.currentImage + "_" + this.direction], x-this.width-2, y-this.height
		#this.s.noStroke()
		#this.s.fill 255, 0, 0
		#this.s.rect x-this.width-2, y-this.height, this.width, this.height
	
	reset: () ->
		this.velocityX = this.velocityY = 0
		this.jumping = false
		this.jumpVelocity = 0
		this.onGround = false
		this.burnt = false
		this.alive = true
		this.activated = true
		this
	
	death: () ->
		cb = =>
			radio(this.DEAD).broadcast()
		setTimeout cb, 1000
	
	finished: () ->
		this.activated = false
		cb = =>
			radio(this.FINISHED).broadcast()
		setTimeout cb, 1000
		
