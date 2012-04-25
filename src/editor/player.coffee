class Player
	img: "images/spiff/standing_left.png"
	selectorColor: "#AAEEFF"
	selectorRadius: 24
	iconWidth: 20
	iconHeight: 25
	
	constructor: (@editor, @paper, @x, @y) ->
		@selected = false
		
		@stageX = 0
		@stageY = 0
		
		@player = @paper.image @img, 0, 0, @iconWidth*@editor.scale, @iconHeight*@editor.scale
		
		@selector = @paper.circle 0, 0, @selectorRadius*@editor.scale
		@selector.attr("stroke", @selectorColor)
			.attr("stroke-width", 2)
		
		@selectorDot = @paper.circle 0, 0, 2
		@selectorDot.attr("stroke", "none")
			.attr("fill", @selectorColor)
		
		@button = @paper.circle 0, 0, @selectorRadius*@editor.scale
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
		
		_x = @stageX + @x*@editor.scale
		_y = @stageY + @y*@editor.scale
		@player.attr {x: _x-@iconWidth/2*@editor.scale, y: _y-@iconHeight*@editor.scale}
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
		@startTime = (new Date()).getTime()
		if !@selected
			@editor.deselectAll()
			@selected = true
			@startTime -= 99999
		@startX = @selector.attr("cx")/@editor.scale - @stageX*@editor.scale
		@startY = @selector.attr("cy")/@editor.scale - @stageY*@editor.scale
		@dragDistance = 0
		@draw()
	
	stopMoving: () ->
		###
		console.log "stopDragging()"
		###
		dragTime = (new Date()).getTime() - @startTime
		if @dragDistance < 4 && dragTime < 1000
			@selected = false
		@editor.redrawAll()
	
	moveHandler: (dx, dy, x, y, e) ->
		@dragDistance += (Math.abs dx) + (Math.abs dy)
		@x = @startX + dx/@editor.scale
		@y = @startY + dy/@editor.scale
		@draw()
