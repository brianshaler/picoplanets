class Mass
	constructor: (@x, @y, @radius, @mass) ->
		@safe = true
		@goal = false
		@distance = 0
		@color = [200, 200, 200]
		@markerColor = [127, 127, 127]
		
		# used in physics()
		@gravitationalRange = 5
		@normalizeGravity = 100
		@weakness = 0.01
	
	onContact: (player) ->
		this
	
	physics: (player) ->
		@distance = @distanceTo player
		# only perform physics if close enough
		if @distance < @radius * @gravitationalRange
			if @distance > 0
				p = 1 - (Math.sin @distance / (@radius * @gravitationalRange) * HALF_PI)
				pull = p * (@radius + @normalizeGravity) * @weakness
				angle = HALF_PI - Math.atan2 @x-player.x, @y-player.y
				player.velocityX += (Math.cos angle) * pull
				player.velocityY += (Math.sin angle) * pull
			else
				@onContact player
		this
	
	draw: (@sketch, @galaxy) ->
		# start with x/y relative to player's position
		x = @x - @galaxy.offsetX
		y = @y - @galaxy.offsetY
		# angle from center to planet + rotation
		angle = Math.atan2 x, y
		angle += @galaxy.rotation
		# recalculate x/y based on new angle and original distance
		dist = Math.sqrt (Math.pow x, 2) + (Math.pow y, 2)
		x = (Math.cos angle) * dist
		y = (Math.sin angle) * dist
		size = @radius * 2
		
		w2 = @galaxy.w/2
		h2 = @galaxy.h/2
		
		if -w2 - @radius < x < w2 + @radius and -h2 - @radius < y < h/2 + @radius
			x += w2
			y += h2
			@sketch.noStroke()
			@sketch.fill @color[0], @color[1], @color[2]
			@sketch.ellipse x, y, size, size
		else
			angle = HALF_PI - Math.atan2 x, y
			dist = @distance
			
			if (Math.abs x) > w2
				dist = Math.abs (w2 / (Math.cos angle))
				x = (Math.cos angle) * dist
				y = (Math.sin angle) * dist
			if (Math.abs y) > h2
				dist = Math.abs (h2 / (Math.sin angle))
				x = (Math.cos angle) * dist
				y = (Math.sin angle) * dist
			
			x += w2
			y += h2
			
			@sketch.strokeWeight 2
			alpha = 222
			if !@goal and @safe
				alpha -= (@distance-h2) / 1
				alpha = if alpha > 0 then alpha else 0
			@sketch.stroke @markerColor[0], @markerColor[1], @markerColor[2], alpha
			@sketch.noFill()
			# base of the arrow is 0.01 radians +/- the angle to the tip of the arrow
			# lazy way of drawing an arrow!
			arrowLength = 12
			x1 = (Math.cos angle+.01) * (dist-arrowLength) + w2
			y1 = (Math.sin angle+.01) * (dist-arrowLength) + h2
			x2 = (Math.cos angle) * (dist-5) + w2
			y2 = (Math.sin angle) * (dist-5) + h2
			x3 = (Math.cos angle-.01) * (dist-arrowLength) + w2
			y3 = (Math.sin angle-.01) * (dist-arrowLength) + h2
			@sketch.beginShape()
			@sketch.vertex x1, y1
			@sketch.vertex x2, y2
			@sketch.vertex x3, y3
			@sketch.endShape()
			#@sketch.line w2, h2, x, y
			#@sketch.ellipse x, y, 10, 10
		this
	
	distanceTo: (player) ->
		(Math.sqrt (Math.pow @x-player.x, 2) + (Math.pow @y-player.y, 2)) - @radius
