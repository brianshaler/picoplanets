class Planet extends Mass
	constructor: (@x, @y, @radius) ->
		lightness = Math.random()*40
		@color = [Math.random()*lightness + 200, Math.random()*lightness + 200, Math.random()*lightness + 200]
	
	setGoal: () ->
		@goal = true
		@color = [110, 200, 130]
		@markerColor = [0, 255, 0]
	
	setup: () ->
		this
	
	color: [255, 255, 255]
	markerColor: [222, 222, 222]
