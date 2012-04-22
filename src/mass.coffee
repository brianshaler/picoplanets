class Mass
	constructor: (@x, @y, @radius, @mass) ->
	
	safe: true
	goal: false
	distance: 0
	
	color: [200, 200, 200]
	markerColor: [127, 127, 127]
	
	onContact: (player) ->
		this
	
	physics: (player) ->
		@distance = @distanceTo(player)
		if @distance < @radius*5
			if @distance > 0
				p = 1 - (Math.sin @distance / (@radius*5) * Math.PI/2)
				pull = p * (@radius+100)*.01
				angle = Math.PI/2 - Math.atan2 @x-player.x, @y-player.y
				player.velocityX += (Math.cos angle) * pull
				player.velocityY += (Math.sin angle) * pull
			else
				this.onContact player
		this
	
	draw: (@s, @g) ->
		x = @x - @g.offsetX
		y = @y - @g.offsetY
		angle = Math.atan2 x, y
		dist = Math.sqrt (Math.pow x, 2) + (Math.pow y, 2)
		angle += @g.rotation
		x = Math.cos(angle) * dist
		y = Math.sin(angle) * dist
		size = @radius * 2
		
		w2 = @g.w/2
		h2 = @g.h/2
		
		if -w2 - @radius < x < w2 + @radius and -h2 - @radius < y < h/2 + @radius
			x += w2
			y += h2
			@s.noStroke()
			@s.fill @color[0], @color[1], @color[2]
			@s.ellipse x, y, size, size
		else
			angle = Math.PI/2 - Math.atan2 x, y
			dist = @distance
			
			if (Math.abs x) > w2
				dist = Math.abs (w2 / Math.cos(angle))
				x = (Math.cos angle) * dist
				y = (Math.sin angle) * dist
			if (Math.abs y) > h2
				dist = Math.abs (h2 / Math.sin(angle))
				x = (Math.cos angle) * dist
				y = (Math.sin angle) * dist
			
			x += w2
			y += h2
			
			@s.strokeWeight(2)
			@s.stroke @markerColor[0], @markerColor[1], @markerColor[2], 222
			@s.noFill()
			x1 = (Math.cos angle+.01) * (dist-20) + w2
			y1 = (Math.sin angle+.01) * (dist-20) + h2
			x2 = (Math.cos angle) * (dist-5) + w2
			y2 = (Math.sin angle) * (dist-5) + h2
			x3 = (Math.cos angle-.01) * (dist-20) + w2
			y3 = (Math.sin angle-.01) * (dist-20) + h2
			@s.beginShape()
			@s.vertex x1, y1
			@s.vertex x2, y2
			@s.vertex x3, y3
			@s.endShape()
			#@s.line w2, h2, x, y
			#@s.ellipse x, y, 10, 10
		this
	
	distanceTo: (player) ->
		(Math.sqrt (Math.pow @x-player.x, 2) + (Math.pow @y-player.y, 2)) - @radius