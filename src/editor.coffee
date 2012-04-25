w = 800
h = 480

output = document.getElementById "output"
paper = new Raphael "canvas_div", w, h

stageX = 0
stageY = 0
dragStartX = 0
dragStartY = 0
startDraggingStage = (x, y, e) ->
	dragStartX = stageX
	dragStartY = stageY
	deselectAll()

stopDraggingStage = () ->
	# nothing

dragStage = (dx, dy, x, y, e) ->
	stageX = dragStartX + dx
	stageY = dragStartY + dy
	redrawAll()

paper.bg = paper.rect 0, 0, w, h
paper.bg.attr "fill", "#000"
paper.bg.drag dragStage, startDraggingStage, stopDraggingStage, this, this, this

planets = []

updateOutput = () ->
	obj = 
		title: "My Level"
		description: "Description"
		maxJump: 40
		oxygen: 1000
		planets: []
		startingPosition:
			x: player.x
			y: player.y
		goal: null
	
	for planet in planets
		do (planet) =>
			if planet.goal
				obj.goal = planet.output()
			else
				obj.planets.push planet.output()
	
	output.innerHTML = JSON.stringify(obj)

redrawAll = () ->
	for planet in planets
		do (planet) =>
			planet.stageX = stageX
			planet.stageY = stageY
			planet.draw()
	player.stageX = stageX
	player.stageY = stageY
	player.draw()
	player.toFront()
	updateOutput()

deselectAll = () ->
	for planet in planets
		do (planet) =>
			planet.selected = false
	player.selected = false
	redrawAll()

addMass = (obj) ->
	p = new Planet paper, w/2, h/2, 70
	for key, val of obj
		p[key] = val
	planets.push p
	redrawAll()
	p

@addPlanet = (e) ->
	addMass({x: w/2 - stageX, y: h/2 - stageY, radius: 70})
	false

@addSun = (e) ->
	addMass({x: w/2 - stageX, y: h/2 - stageY, radius: 90}).makeSun()
	false

player = new Player paper, w/2, h/2

addMass({x: w/2, y: h/2-200, radius: 70}).makeGoal()
addMass({x: w/2, y: h/2+60, radius: 60})


