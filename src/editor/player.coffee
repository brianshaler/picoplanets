class Player
	img: "images/spiff/standing_left.png"
	selectorColor: "#AAEEFF"
	selectorRadius: 22
	iconWidth: 20
	iconHeight: 25
	
	constructor: (@editor, @paper, @x, @y) ->
		@selected = false
		
		@stageX = 0
		@stageY = 0
		
		@player = @paper.image @img, 0, 0, @iconWidth, @iconHeight
		
		@selector = @paper.circle 0, 0, @selectorRadius
		@selector.attr("stroke", @selectorColor)
			.attr("stroke-width", 3)
		
		@selectorDot = @paper.circle 0, 0, 3
		@selectorDot.attr("stroke", "none")
			.attr("fill", @selectorColor)
		
		@button = @paper.circle 0, 0, @selectorRadius
		@button.attr("fill", "#0F0")
			.attr("stroke", "none")
			.attr("opacity", 0)
			.drag(@moveHandler, @startMoving, @stopMoving, this, this, this)
		
		@draw()
	
	draw: () ->
		if @selected
			@selector.show()
			@selectorDot.show()
		else
			@selector.hide()
			@selectorDot.hide()
		
		_x = @stageX + @x
		_y = @stageY + @y
		@player.attr {x: _x-@iconWidth/2, y: _y-@iconHeight}
		@selector.attr {cx: _x, cy: _y}
		@selectorDot.attr {cx: _x, cy: _y}
		@button.attr {cx: _x, cy: _y}
		this
	
	toFront: () ->
		@player.toFront()
		@selector.toFront()
		@selectorDot.toFront()
		@button.toFront()
	
	startMoving: (x, y, e) ->
		if !@selected
			@editor.deselectAll()
			@selected = true
		@startX = @selector.attr("cx") - @stageX
		@startY = @selector.attr("cy") - @stageY
		@dragDistance = 0
		@startTime = (new Date()).getTime()
		@draw()
	
	stopMoving: () ->
		###
		console.log "stopDragging()"
		###
		dragTime = @startTime - (new Date()).getTime()
		if @dragDistance < 4 && dragTime < 1000
			@selected = true
	
	moveHandler: (dx, dy, x, y, e) ->
		@dragDistance += (Math.abs dx) + (Math.abs dy)
		@x = @startX + dx
		@y = @startY + dy
		@draw()
