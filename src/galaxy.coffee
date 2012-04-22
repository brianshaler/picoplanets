class Galaxy
	planets: []
	offsetX: 0
	offsetY: 0
	w: 100
	h: 100
	rotation: 0
	stars: false
	
	constructor: () ->
	
	setStageSize: (_w, _h) ->
		this.w = _w
		this.h = _h
		this
	
	draw: (_sketch) ->
		this.sketch = _sketch
		this.drawStars()
		this.drawPlanet planet for planet in this.planets
		this.player.draw this.sketch, this, this.rotation
	
	drawPlanet: (planet) ->
		planet.draw this.sketch, this, this.rotation
	
	drawStars: () ->
		this.sketch.translate(this.w/2, this.h/2)
		this.sketch.rotate(this.rotation)
		this.sketch.image this.sketch.stars, -500, -500
		this.sketch.rotate(-this.rotation)
		this.sketch.translate(-this.w/2, -this.h/2)
