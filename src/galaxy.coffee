class Galaxy
	planets: []
	offsetX: 0
	offsetY: 0
	w: 100
	h: 100
	rotation: 0
	stars: false
	
	constructor: (@w, @h, @player, @planets) ->
	
	draw: (@sketch) ->
		@drawStars()
		@drawPlanet planet for planet in @planets
		@player.draw @sketch, this, @rotation
	
	drawPlanet: (planet) ->
		planet.draw @sketch, this, @rotation
	
	drawStars: () ->
		
		#@sketch.pushMatrix();

		@sketch.translate(@w/2, @h/2)
		@sketch.rotate(@rotation)
		
		#@sketch.popMatrix();
		
		@sketch.image @sketch.stars, -500, -500
		@sketch.rotate(-@rotation)
		@sketch.translate(-@w/2, -@h/2)
		