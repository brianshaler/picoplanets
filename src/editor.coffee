class @Editor
	w: 800
	h: 480
	cx: 400
	cy: 240
	
	stageX: 0
	stageY: 0
	dragStartX: 0
	dragStartY: 0
	scale: 0.5
	
	constructor: (div_id) ->
		@output = document.getElementById "output"
		@paper = new Raphael div_id, @w, @h
		
		@paper.bg = @paper.rect 0, 0, @w, @h
		@paper.bg.attr "fill", "#000"
		@paper.bg.drag @dragStage, @startDraggingStage, @stopDraggingStage, this, this, this
		
		@planets = []
		
		@cx = @w / 2 / @scale
		@cy = @h / 2 / @scale
		
		@player = new Player this, @paper, @cx, @cy
		
		@addMass({x: @cx, y: (@cy-200), radius: 70}).makeGoal()
		@addMass({x: @cx, y: (@cy+60), radius: 60})
	
	startDraggingStage: (x, y, e) ->
		@dragStartX = @stageX
		@dragStartY = @stageY
		@deselectAll()
	
	stopDraggingStage: () ->
		# nothing
	
	dragStage: (dx, dy, x, y, e) ->
		@stageX = @dragStartX + dx
		@stageY = @dragStartY + dy
		@redrawAll()
	
	updateOutput: () ->
		obj = 
			title: "My Level"
			description: "Description"
			maxJump: 40
			oxygen: 1000
			planets: []
			startingPosition:
				x: @player.x
				y: @player.y
			goal: null
		
		for planet in @planets
			do (planet) =>
				if planet.goal
					obj.goal = planet.output()
				else
					obj.planets.push planet.output()
		
		@output.innerHTML = JSON.stringify(obj)
	
	redrawAll: () ->
		for planet in @planets
			do (planet) =>
				planet.stageX = @stageX
				planet.stageY = @stageY
				planet.draw()
		@player.stageX = @stageX
		@player.stageY = @stageY
		@player.draw()
		@player.toFront()
		@updateOutput()
	
	deselectAll: () ->
		for planet in @planets
			do (planet) =>
				planet.selected = false
		@player.selected = false
		@redrawAll()
	
	addMass: (obj) ->
		p = new Planet this, @paper, @cx, @cy, 70
		for key, val of obj
			console.log "set #{key} to #{val} "+obj[key]
			p[key] = val
		@planets.push p
		@redrawAll()
		p
	
	addPlanet: (e) ->
		@addMass({x: @cx - @stageX, y: @cy - @stageY, radius: 70})
		false
	
	addSun: (e) ->
		@addMass({x: @cx - @stageX, y: @cy - @stageY, radius: 90}).makeSun()
		false
