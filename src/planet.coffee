class Planet extends Mass
	constructor: (@x, @y, @radius, @mass) ->
		super @x, @y, @radius, @mass
		@goal = false
		@markerColor = [222, 222, 222]
		lightness = Math.random()*50
		@color = [Math.random()*lightness + 180, Math.random()*lightness + 180, Math.random()*lightness + 180]
	
	setGoal: () ->
		@goal = true
		@color = [110, 200, 130]
		@markerColor = [0, 255, 0]
