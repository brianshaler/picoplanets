class Planet extends Mass
	constructor: (@x, @y, @radius) ->
		
	
	setup: () ->
		lightness = Math.random()*50
		@color = [Math.random()*lightness + 200, Math.random()*lightness + 200, Math.random()*lightness + 200]
		this
	
	color: [255, 255, 255]
	markerColor: [0, 255, 0]
