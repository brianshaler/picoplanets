class Planet
	constructor: (@x, @y, @radius) ->
	
	draw: (@s, @g) ->
		x = @x - @g.offsetX
		y = @y - @g.offsetY
		angle = Math.atan2 x, y
		dist = Math.sqrt (Math.pow x, 2) + (Math.pow y, 2)
		angle += @g.rotation
		x = Math.cos(angle) * dist
		y = Math.sin(angle) * dist
		x += @g.w/2
		y += @g.h/2
		size = @radius * 2
		@s.noStroke()
		@s.fill 255
		@s.ellipse x, y, size, size
