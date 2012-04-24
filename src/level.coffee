class Level
	constructor: () ->
		@galaxy = new Galaxy()
		@title = ""
		@description = ""
		@planets = []
		@startingPosition = x: 0, y: 0
		@startingOxygen = 1000
		@maxJump = 40
		@rotation = 0
		this
	
	setTitle: (t) ->
		@title = t
		this
	
	setDescription: (d) ->
		@description = d
		this
	
	setStageSize: (_w, _h) ->
		@w = _w
		@h = _h
		@galaxy.setStageSize @w, @h
		this
		
	setPlayer: (_player) ->
		@player = _player
		@galaxy.player = @player
		this
	
	setPlanets: (_planets) ->
		@planets = _planets
		@galaxy.planets = @planets
		this
	
	setGoal: (p) ->
		p.setGoal()
		@planets.push p
		this
	
	setPosition: (sp) ->
		@startingPosition = sp
		this
	
	setOxygen: (o) ->
		@startingOxygen = o
		this
	
	setJump: (j) ->
		@startingJump = j
		this
	
	reset: () ->
		@player.x = @galaxy.offsetX = parseInt @startingPosition.x
		@player.y = @galaxy.offsetY = parseInt @startingPosition.y
		@player.oxygen = @player.maxOxygen = @startingOxygen
		@player.maxJump = @maxJump
		@player.reset()
		@rotation = 0
	
	start: () ->
		@reset()
		@player.calculatePhysics @galaxy.planets
		nearestPlanet = @player.findNearestPlanet @galaxy.planets, false
		idealRotation = HALF_PI - Math.atan2 nearestPlanet.x - @player.x, nearestPlanet.y - @player.y
		@rotation = idealRotation
		window.rotation = @rotation
		this
	
	redraw: (@sketch) ->
		nearestPlanet = @player.findNearestPlanet @galaxy.planets, false
		idealRotation = HALF_PI - Math.atan2 nearestPlanet.x - @player.x, nearestPlanet.y - @player.y
		diff = Math.abs idealRotation - @rotation
		if (Math.abs idealRotation - TWO_PI - @rotation) < diff
			idealRotation = idealRotation - TWO_PI
		if (Math.abs idealRotation + TWO_PI - @rotation) < diff
			idealRotation = idealRotation + TWO_PI
		@rotation += (idealRotation - @rotation) * .08
		if @rotation < 0
			@rotation += TWO_PI
		@rotation = @rotation % (TWO_PI)
		@galaxy.rotation = @rotation
		@galaxy.offsetX += (parseFloat @player.x - @galaxy.offsetX) * .3
		@galaxy.offsetY += (parseFloat @player.y - @galaxy.offsetY) * .3
		@player.move().calculatePhysics @galaxy.planets
		@galaxy.draw @sketch
		this
