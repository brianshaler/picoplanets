class Planet extends Mass
	constructor: (@x, @y, @radius) ->
		
	
	setup: () ->
		lightness = Math.random()*50
		@color = [Math.random()*lightness + 200, Math.random()*lightness + 200, Math.random()*lightness + 200]
		if @goal
			@color = [200, 255, 222]
			@markerColor = [0, 255, 0]
		this
	
	color: [255, 255, 255]
	markerColor: [222, 222, 222]
