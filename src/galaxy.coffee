class Galaxy
	planets: []
	offsetX: 0
	offsetY: 0
	w: 100
	h: 100
	rotation: 0
	
	constructor: (@w, @h, @player, @planets) ->
	
	draw: (@sketch) ->
		@drawPlanet planet for planet in @planets
		@player.draw @sketch, this, @rotation
	
	drawPlanet: (planet) ->
		planet.draw @sketch, this, @rotation