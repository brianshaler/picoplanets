class Level
	constructor: () ->
		this.galaxy = new Galaxy()
		this
	
	title: ""
	description: ""
	planets: []
	startingPosition: {x: 0, y: 0}
	startingOxygen: 1000
	maxJump: 40
	rotation: 0
	
	setTitle: (t) ->
		this.title = t
		this
	
	setDescription: (d) ->
		this.description = d
		this
	
	setStageSize: (_w, _h) ->
		this.w = _w
		this.h = _h
		this.galaxy.setStageSize this.w, this.h
		this
		
	setPlayer: (_player) ->
		this.player = _player
		this.galaxy.player = this.player
		this
	
	setPlanets: (_planets) ->
		this.planets = _planets
		this.galaxy.planets = this.planets
		this
	
	setGoal: (p) ->
		p.setGoal()
		this.planets.push p
		this
	
	setPosition: (sp) ->
		this.startingPosition = sp
		this
	
	setOxygen: (o) ->
		this.startingOxygen = o
		this
	
	setJump: (j) ->
		this.startingJump = j
		this
	
	reset: () ->
		this.player.x = this.galaxy.offsetX = parseInt(this.startingPosition.x)
		this.player.y = this.galaxy.offsetY = parseInt(this.startingPosition.y)
		this.player.oxygen = this.player.maxOxygen = this.startingOxygen
		this.player.maxJump = this.maxJump
		this.player.reset()
		this.rotation = 0
	
	start: () ->
		this.reset()
		this.player.calculatePhysics this.galaxy.planets
		nearestPlanet = this.player.findNearestPlanet this.galaxy.planets, false
		idealRotation = (Math.PI/2 - Math.atan2 nearestPlanet.x - this.player.x, nearestPlanet.y - this.player.y)
		this.rotation = idealRotation
		window.rotation = this.rotation
		this
	
	redraw: (_s) ->
		this.s = _s
		nearestPlanet = this.player.findNearestPlanet this.galaxy.planets, false
		idealRotation = (Math.PI/2 - Math.atan2 nearestPlanet.x - this.player.x, nearestPlanet.y - this.player.y)
		diff = Math.abs idealRotation - this.rotation
		if (Math.abs idealRotation - Math.PI*2 - this.rotation) < diff
			idealRotation = idealRotation - Math.PI*2
		if (Math.abs idealRotation + Math.PI*2 - this.rotation) < diff
			idealRotation = idealRotation + Math.PI*2
		this.rotation += (idealRotation - this.rotation) * .08
		if this.rotation < 0
			this.rotation += Math.PI*2
		this.rotation = this.rotation % (Math.PI*2)
		this.galaxy.rotation = this.rotation
		this.galaxy.offsetX += parseFloat(this.player.x - this.galaxy.offsetX) * .3
		this.galaxy.offsetY += parseFloat(this.player.y - this.galaxy.offsetY) * .3
		if this.player.activated
			this.player.move().calculatePhysics(this.galaxy.planets)
		this.galaxy.draw this.s
		this
