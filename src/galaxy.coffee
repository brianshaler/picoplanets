class Galaxy
	planets: []
	offsetX: 0
	offsetY: 0
	w: 100
	h: 100
	rotation: 0
	stars: false
	
	constructor: () ->
	
	setStageSize: (@w, @h) ->
		this
	
	draw: (@sketch) ->
		@drawStars()
		@drawPlanet planet for planet in @planets
		@player.draw @sketch, this, @rotation
	
	drawPlanet: (planet) ->
		planet.draw @sketch, this, @rotation
	
	drawStars: () ->
		@sketch.translate(@w/2, @h/2)
		@sketch.rotate(@rotation)
		@sketch.image @sketch.stars, -500, -500
		@sketch.rotate(-@rotation)
		@sketch.translate(-@w/2, -@h/2)
