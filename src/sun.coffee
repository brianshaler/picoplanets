class Sun extends Mass
	constructor: (@x, @y, @radius) ->
		
	setup: () ->
		this
	
	safe: false
	color: [255, 200, 50]
	
	markerColor: [255, 0, 0]
	
	draw: (@s, @g) ->
		super @s, @g
