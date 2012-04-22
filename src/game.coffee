w = 800
h = 480
rotation = 0
planets = []

MODE_START = "start"
MODE_PLAY = "play"
MODE_DEAD = "dead"
MODE_FINISH = "finish"
MODE_FINAL = "final"

playMode = MODE_START

player = new Player()
chrome = new Chrome w, h

levels = [
	(new Level()).setStageSize(w, h)
		.setPlayer(player)
		.setPlanets([
			(new Planet -100, -450, 60),
			(new Planet 100, -700, 70),
			(new Planet 300, -1000, 100),
			(new Planet -50, 150, 100),
			(new Sun 600, -600, 100)
		])
		.setGoal(
			new Planet 800, -850, 60
		).setPosition({
			x: 0, y: 0
		}).setOxygen(1000)
		.setJump(40),
	(new Level()).setStageSize(w, h)
		.setPlayer(player)
		.setPlanets([
			(new Planet 200, -150, 60),
			(new Planet 100, 700, 70),
			(new Planet -100, -400, 100),
			(new Planet -50, 50, 70),
			(new Sun 100, 300, 100)
		])
		.setGoal(
			new Planet -100, -950, 60
		).setPosition({
			x: 100, y: 600
		}).setOxygen(1000)
		.setJump(40)
]
window.levels = levels

currentLevel = 0

KEY_UP = 38
KEY_DOWN = 40
KEY_LEFT = 37
KEY_RIGHT = 39
KEY_SPACE = 32

key_dir = -1

startGame = () ->
	levels[currentLevel].start()
	playMode = MODE_PLAY

startOver = () ->
	currentLevel = 0
	startGame()

death = () ->
	#levels[currentLevel].reset()
	playMode = MODE_DEAD

finish = () ->
	#levels[currentLevel].reset()
	if currentLevel < levels.length - 1
		currentLevel += 1
		playMode = MODE_FINISH
	else
		playMode = MODE_FINAL

radio(player.DEAD).subscribe(death)
radio(player.FINISHED).subscribe(finish)

document.onkeyup = (e) ->
	if key_dir == KEY_SPACE
		player.jump()
	key_dir = -1
	player.walking = false

document.onkeydown = (e) ->
	player = levels[currentLevel].player
	rotation = levels[currentLevel].rotation
	cont = false
	switch e.keyCode
		when KEY_UP
			if key_dir != KEY_UP and 1 == 2
				key_dir = KEY_UP
				player.accel (rotation - Math.PI), 10
		when KEY_DOWN
			if key_dir != KEY_DOWN and 1 == 2
				key_dir = KEY_DOWN
				player.accel (rotation), 10
		when KEY_LEFT
			if key_dir != KEY_LEFT and player.onGround
				#key_dir = KEY_LEFT
				player.direction = player.DIR_LEFT
				player.walking = true
				player.accel (rotation - Math.PI/2), 3, true
		when KEY_RIGHT
			if key_dir != KEY_RIGHT and player.onGround
				#key_dir = KEY_RIGHT
				player.direction = player.DIR_RIGHT
				player.walking = true
				player.accel (rotation + Math.PI/2), 3, true
		when KEY_SPACE
			if key_dir != KEY_SPACE and player.onGround
				key_dir = KEY_SPACE
				player.startJumping()
			switch playMode
				when MODE_START
					startGame()
				when MODE_DEAD
					startGame()
				when MODE_FINISH
					startGame()
				when MODE_FINAL
					startOver()
		else
			cont = true
			#console.log e.keyCode
	if !cont
		e.preventDefault()

canvas = document.getElementById('canvas')

canvas.onclick = (e) ->
	switch playMode
		when MODE_START
			startGame()
		when MODE_DEAD
			startGame()
		when MODE_FINISH
			startGame()
		when MODE_FINAL
			startOver()


runningOutColors = [
	{p: 0, r: 255, g: 0, b: 0},
	{p: .3, r: 255, g: 255, b: 0},
	{p: .7, r: 0, g: 200, b: 0}
]

getColor = (val, min, max, rules) ->
	p = (val-min)/(max-min)
	if p < 0 then p = 0
	if p > 1 then p = 1
	
	lower = 0
	for rule, i in rules
		if rule.p <= p then lower = i
	
	if lower < 0 then lower = 0
	
	upper = if lower < rules.length - 1 then lower + 1 else rules.length - 1
	
	c1 = rules[lower]
	c2 = rules[upper]
	
	v = if c2.p > c1.p then (p-c1.p) / (c2.p-c1.p) else 0
	
	c = {
		r: c1.r + v*(c2.r-c1.r), 
		g: c1.g + v*(c2.g-c1.g), 
		b: c1.b + v*(c2.b-c1.b)
	}


setPixel = (s, pixels, i) ->
	#pixels.setPixel i, (s.color 0)
	if Math.random() * 1000 < 2
		pixels.setPixel i, (s.color 255, 255, 255)
	

sketch ->

	@setup = =>
		@size w, h
		@background 0
		@noFill()
		@frameRate 30
		@loadedFont = @loadFont("fonts/Audiowide-Regular.ttf")
		imgs = [player.IMG_STANDING, player.IMG_WALKING, player.IMG_SQUATTING, player.IMG_FLYING, player.IMG_BURNT]
		dirs = [player.DIR_LEFT, player.DIR_RIGHT]
		for img in imgs
			for dir in dirs
				this[img+"_"+dir] = @loadImage("images/spiff/"+img+"_"+dir+".png")
		@stars = @createImage(1000, 1000, @ARGB)
		p = @stars.pixels.toArray()
		setPixel this, @stars.pixels, i for pixel, i in p
		@stars.updatePixels();
		chrome.s = this
		this

	@draw = =>
		@background 0
		
		switch playMode
			when MODE_START
				chrome.startLevel this, levels[currentLevel]
			when MODE_PLAY
				levels[currentLevel].redraw(this)
				chrome.draw this, player
			when MODE_DEAD
				chrome.dead this, levels[currentLevel]
			when MODE_FINISH
				txt = "Good job! Go on to level "+(currentLevel+1)
				chrome.drawText txt, w/2 - @textWidth(txt)/2, h/2
			when MODE_FINAL
				txt = "FINISHED! Start over?"
				chrome.drawText txt, w/2 - @textWidth(txt)/2, h/2
