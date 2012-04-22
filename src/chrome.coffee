class Chrome
	constructor: (@w, @h) ->
	
	barWidth: 200
	barHeight: 26
	barPadding: 4
	
	marginTop: 40
	marginBottom: 40
	marginLeft: 40
	marginRight: 40
	
	mapX: 40
	mapY: 40
	mapWidth: 200
	mapHeight: 400
	
	draw: (@s, @player) ->
		# jump status
		@s.stroke 255
		@s.fill 0
		@s.rect @w - @barWidth - @marginRight, @marginTop + 10, @barWidth, @barHeight
		if @player.jumping
			@s.noStroke()
			@s.fill 255, 0, 0
			@s.rect @w - @barWidth - @marginRight + @barPadding, 
				@marginTop + @barPadding + 10, 
				((@barWidth-@barPadding*2) * (@player.jumpVelocity-@player.minJump) / (@player.maxJump-@player.minJump)),
				@barHeight - @barPadding*2
		@drawText "jump meter", @w - @barWidth - @marginRight, @marginTop
		
		@s.stroke 255
		@s.fill 0
		@s.rect @marginLeft, @marginTop + 10, @barWidth, @barHeight
		@s.noStroke()
		c = getColor @player.oxygen, 0, @player.maxOxygen, runningOutColors
		@s.fill c.r, c.g, c.b
		@s.rect @marginLeft + @barPadding, 
			@marginTop + @barPadding + 10, 
			((@barWidth-@barPadding*2) * (@player.oxygen) / (@player.maxOxygen)),
			@barHeight - @barPadding*2
		@drawText "oxygen", @marginLeft, @marginTop
	
	drawMap: (@s, level) ->
		min_x = max_x = min_y = max_y = -1
		
		#@s.fill 100, 100, 100
		#@s.rect 0, 0, @mapWidth, @mapHeight
		
		for planet in level.planets
			do (planet) =>
				x = planet.x
				y = planet.y * -1
				min_x = if min_x == -1 or x - planet.radius < min_x then x - planet.radius else min_x
				max_x = if max_x == -1 or x + planet.radius > max_x then x + planet.radius else max_x
				min_y = if min_y == -1 or y - planet.radius < min_y then y - planet.radius else min_y
				max_y = if max_y == -1 or y + planet.radius > max_y then y + planet.radius else max_y
		
		scale = @mapWidth / (max_x - min_x)
		if (max_y - min_y) * scale > @mapHeight
			scale = @mapHeight / (max_y - min_y)
		
		paddingLeft = (@mapWidth - (max_x - min_x) * scale)/2
		paddingTop = (@mapHeight - (max_y - min_y) * scale)/2
		
		###
		@s.stroke 255
		@s.beginShape()
		for planet in level.planets
			do (planet) =>
				x = paddingLeft + (planet.x - min_x) * scale
				y = paddingTop + (-planet.y - min_y) * scale
				@s.vertex 0, 0
				@s.vertex x, y
		@s.endShape()
		###
		
		for planet in level.planets
			do (planet) =>
				x = @mapX + paddingLeft + (planet.x - min_x) * scale
				y = @mapY + paddingTop + (-planet.y - min_y) * scale
				size = planet.radius*2 * scale
				@s.noStroke()
				@s.fill planet.color[0], planet.color[1], planet.color[2]
				@s.ellipse x, y, size, size
		
		x = @mapX + paddingLeft + (level.startingPosition.x - min_x) * scale
		y = @mapY + paddingTop + (-level.startingPosition.y - min_y) * scale
		@s.image @s["flying_left"], x-20/2, y-25
	
	startLevel: (@s, level) ->
		@s.textAlign(@s.CENTER);
		@drawText level.title, @w/2+100, @h/2 - 24, 24
		@drawText level.description, @w/2+100, @h/2
		@s.textAlign(@s.LEFT);
	
	dead: (@s) ->
		@s.textAlign(@s.CENTER);
		txt = "DEAD! Try again?"
		@drawText txt, @w/2+100, @h/2
		@s.textAlign(@s.LEFT);
	
	drawText: (txt, x, y, size) ->
		if !size
			size = 15
		@s.textFont(@s.loadedFont, size);
		@s.fill 0
		@s.text txt, x+1.5, y+1.5
		@s.text txt, x+.5, y+1.5
		@s.text txt, x+1.5, y+.5
		@s.fill 255
		@s.text txt, x+.5, y+.5
