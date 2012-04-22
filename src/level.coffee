class Level
	planets: []
	startingPosition: {x: 0, y: 0}
	startingOxygen: 1000
	maxJump: 40
	rotation: 0
	
	constructor: () ->
		@galaxy = new Galaxy()
	
	setStageSize: (@w, @h) ->
		@galaxy.setStageSize @w, @h
		this
		
	setPlayer: (@player) ->
		@galaxy.player = @player
		this
	
	setPlanets: (@planets) ->
		@galaxy.planets = @planets
		this
	
	setGoal: (p) ->
		p.setGoal()
		@planets.push p
		this
	
	setPosition: (sp) ->
		@startingPosition.x = sp.x
		@startingPosition.y = sp.y
		this
	
	setOxygen: (o) ->
		@startingOxygen = o
		this
	
	setJump: (j) ->
		@startingJump = j
		this
	
	reset: () ->
		@player.x = @galaxy.offsetX = parseInt(@startingPosition.x)
		@player.y = @galaxy.offsetY = parseInt(@startingPosition.y)
		@player.velocityX = @player.velocityY = 0
		@player.oxygen = @player.maxOxygen = @startingOxygen
		@player.jumping = false
		@player.jumpVelocity = 0
		@player.onGround = false
		@player.maxJump = @maxJump
		@rotation = 0
	
	start: () ->
		@reset()
		this
	
	redraw: (@s) ->
		nearestPlanet = @player.findNearestPlanet @galaxy.planets, false
		idealRotation = (Math.PI/2 - Math.atan2 nearestPlanet.x - @player.x, nearestPlanet.y - @player.y)
		diff = Math.abs idealRotation - @rotation
		if (Math.abs idealRotation - Math.PI*2 - @rotation) < diff
			idealRotation = idealRotation - Math.PI*2
		if (Math.abs idealRotation + Math.PI*2 - @rotation) < diff
			idealRotation = idealRotation + Math.PI*2
		@rotation += (idealRotation - @rotation) * .1
		if @rotation < 0
			@rotation += Math.PI*2
		@rotation = @rotation % (Math.PI*2)
		window.rotation = @rotation
		window.galaxy = @galaxy
		@galaxy.rotation = @rotation
		@galaxy.offsetX += parseFloat(@player.x - @galaxy.offsetX) * .3
		@galaxy.offsetY += parseFloat(@player.y - @galaxy.offsetY) * .3
		@player.move().calculatePhysics(@galaxy.planets)
		@galaxy.draw @s
		this
