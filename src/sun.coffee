class Sun extends Mass
	constructor: (@x, @y, @radius, @mass) ->
		super @x, @y, @radius, @mass
		@safe = false
		@color = [255, 200, 50]

		@markerColor = [255, 0, 0]
	
	onContact: (p) ->
		p.burnt = true
		p.alive = false
		super p
