class Planet extends Mass
	constructor: (_x, _y, _radius, _mass) ->
		lightness = Math.random()*40
		this.color = [Math.random()*lightness + 200, Math.random()*lightness + 200, Math.random()*lightness + 200]
		super _x, _y, _radius, _mass
	
	setGoal: () ->
		this.goal = true
		this.color = [110, 200, 130]
		this.markerColor = [0, 255, 0]
	
	color: [255, 255, 255]
	markerColor: [222, 222, 222]
