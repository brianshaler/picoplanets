class Planet
	planetColor: "rgb(210, 210, 210)"
	goalColor: "rgb(110, 200, 130)"
	sunColor: "rgb(255, 200, 50)"
	
	selectorColor: "#AAEEFF"
	selectorPadding: 6
	hitAreaPadding: 10
	maxRadius: 120
	
	constructor: (@editor, @paper, @x, @y, @radius) ->
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
			.attr("stroke-width", 2)
		
		@button = @paper.circle 0, 0, @radius+@hitAreaPadding
		@button.attr("fill", "#0F0")
			.attr("stroke", "none")
			.attr("opacity", 0)
			.drag(@moveHandler, @startMoving, @stopMoving, this, this, this)
		
		@resizer = @paper.circle 0, 0, 4
		@resizer.attr("stroke", @selectorColor)
			.attr("stroke-width", 2)
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
		
		_x = @stageX + @x*@editor.scale
		_y = @stageY + @y*@editor.scale
		r = @radius*@editor.scale
		@planet.attr {cx: _x, cy: _y, r: r}
		@selector.attr {cx: _x, cy: _y, r: r+@selectorPadding}
		@button.attr {cx: _x, cy: _y, r: r+@hitAreaPadding}
		@resizer.attr {cx: _x + r + @selectorPadding, cy: _y}
		@resizeButton.attr {cx: _x + r + @selectorPadding, cy: _y}
		
		this
	
	startMoving: (x, y, e) ->
		@startTime = (new Date()).getTime()
		if !@selected
			@editor.deselectAll()
			@selected = true
			@startTime -= 99999
		@startX = @planet.attr("cx")/@editor.scale - @stageX*@editor.scale
		@startY = @planet.attr("cy")/@editor.scale - @stageY*@editor.scale
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
		@x = @startX + dx/@editor.scale
		@y = @startY + dy/@editor.scale
		@draw()
	
	startResizing: () ->
		###
		console.log "startDragging()"
		###
	
	stopResizing: () ->
		###
		console.log "stopDragging()"
		###
		@editor.redrawAll()
	
	resizeHandler: (dx, dy, x, y, e) ->
		_x = @planet.attr("cx")
		_y = @planet.attr("cy")
		@radius = (Math.round (Math.sqrt (Math.pow (x-_x), 2) + (Math.pow (y-_y), 2)) - @selectorPadding*2) / @editor.scale
		@radius = if @radius < @maxRadius then @radius else @maxRadius
		@draw()
	
	output: () ->
		obj = 
			type: @type
			x: @x
			y: @y
			radius: @radius
