class Sun extends Mass
	constructor: (_x, _y, _radius, _mass) ->
		super _x, _y, _radius, _mass
	
	safe: false
	color: [255, 200, 50]
	
	markerColor: [255, 0, 0]
	
	onContact: (p) ->
		p.burnt = true
		p.alive = false
		super p
	
	draw: (_s, _g) ->
		super _s, _g
