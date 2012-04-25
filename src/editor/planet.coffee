class Planet
	planetColor: "rgb(210, 210, 210)"
	goalColor: "rgb(110, 200, 130)"
	sunColor: "rgb(255, 200, 50)"
	
	selectorColor: "#AAEEFF"
	selectorPadding: 8
	hitAreaPadding: 10
	
	constructor: (@paper, @x, @y, @radius) ->
		@goal = false
		@type = "planet"
		@selected = false
		@color = [200, 200, 200]
		
		@stageX = 0
		@stageY = 0
		
		@planet = @paper.circle 0, 0, @radius
		@planet.attr("stroke", "none")
			.attr("fill", @planetColor)
		
		@selector = @paper.circle 0, 0, @radius+@selectorPadding
		@selector.attr("stroke", @selectorColor)
			.attr("stroke-width", 3)
		
		@button = @paper.circle 0, 0, @radius+@hitAreaPadding
		@button.attr("fill", "#0F0")
			.attr("stroke", "none")
			.attr("opacity", 0)
			.drag(@moveHandler, @startMoving, @stopMoving, this, this, this)
		
		@resizer = @paper.circle 0, 0, 5
		@resizer.attr("stroke", @selectorColor)
			.attr("stroke-width", 3)
			.attr("fill", "#000")
		
		@resizeButton = @paper.circle 0, 0, 10
		@resizeButton.attr("fill", "#0F0")
			.attr("stroke", "none")
			.attr("opacity", 0)
			.drag(@resizeHandler, @startResizing, @stopResizing, this, this, this)
		
		@draw()
	
	makeSun: () ->
		@planet.attr "fill", @sunColor
		@type = "sun"
		this
	
	makeGoal: () ->
		@planet.attr "fill", @goalColor
		@goal = true
		this
	
	draw: () ->
		if @selected
			@selector.show()
			@resizer.show()
			@resizeButton.show()
		else
			@selector.hide()
			@resizer.hide()
			@resizeButton.hide()
		
		_x = @stageX + @x
		_y = @stageY + @y
		@planet.attr {cx: _x, cy: _y, r: @radius}
		@selector.attr {cx: _x, cy: _y, r: @radius+@selectorPadding}
		@button.attr {cx: _x, cy: _y, r: @radius+@hitAreaPadding}
		@resizer.attr {cx: _x + @radius + @selectorPadding, cy: _y}
		@resizeButton.attr {cx: _x + @radius + @selectorPadding, cy: _y}
		
		this
	
	startMoving: (x, y, e) ->
		if !@selected
			deselectAll()
			@selected = true
		@startX = @planet.attr("cx") - @stageX
		@startY = @planet.attr("cy") - @stageY
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
		@x = @startX + dx
		@y = @startY + dy
		@draw()
	
	startResizing: () ->
		###
		console.log "startDragging()"
		###
	
	stopResizing: () ->
		###
		console.log "stopDragging()"
		###
	
	resizeHandler: (dx, dy, x, y, e) ->
		_x = @planet.attr("cx")
		_y = @planet.attr("cy")
		@radius = (Math.sqrt (Math.pow (x-_x), 2) + (Math.pow (y-_y), 2)) - @selectorPadding*2
		@draw()
	
	output: () ->
		obj = 
			type: @type
			x: @x
			y: @y
			radius: @radius
