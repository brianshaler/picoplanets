w = 800
h = 480
rotation = 0
planets = []
currentLevel = 0
key_dir = -1

KEY_UP = 38
KEY_DOWN = 40
KEY_LEFT = 37
KEY_RIGHT = 39
KEY_SPACE = 32

MODE_INTRO = "intro"
MODE_START = "start"
MODE_PLAY = "play"
MODE_DEAD = "dead"
MODE_FINISH = "finish"
MODE_FINAL = "final"

PI = Math.PI
HALF_PI = PI/2
TWO_PI = PI*2
NO_PIE = ":-("

playMode = MODE_INTRO



player = new Player()
chrome = new Chrome w, h

# using canvas context for custom typeface since processing.js wasn't working..
canvas = document.getElementById 'canvas'
ctx = canvas.getContext '2d'
ctx.font = '14px "AudiowideRegular"'

json = """
[{"title":"Straight Shot","description":"Get to the green planet for your oxygen runs out!\\n\\nHold SPACE to power up your jump meter, and release to jump.\\nBe careful not to jump too high!\\n\\n(hit SPACE to begin)","maxJump":40,"oxygen":1400,"planets":[{"type":"planet","x":0,"y":550,"radius":70}],"startingPosition":{"x":0,"y":480},"goal":{"type":"planet","x":0,"y":100,"radius":80}},
{"title":"Hopscotch","description":"Use LEFT/RIGHT arrow keys\\nto walk on planets.\\n\\nPlan your jumps carefully!","maxJump":40,"oxygen":1500,"planets":[{"type":"planet","x":800,"y":560,"radius":60},{"type":"planet","x":713,"y":260,"radius":90},{"type":"planet","x":1057,"y":142,"radius":90},{"type":"planet","x":397,"y":582,"radius":66},{"type":"planet","x":1209,"y":598,"radius":62},{"type":"planet","x":407,"y":242,"radius":70},{"type":"planet","x":1439,"y":366,"radius":70},{"type":"planet","x":345,"y":-68,"radius":70},{"type":"planet","x":1301,"y":-120,"radius":70},{"type":"planet","x":785,"y":-110,"radius":70},{"type":"planet","x":1201,"y":-490,"radius":70},{"type":"planet","x":755,"y":-726,"radius":70},{"type":"planet","x":1623,"y":16,"radius":70},{"type":"planet","x":477,"y":-458,"radius":70},{"type":"planet","x":1564,"y":-346,"radius":70}],"startingPosition":{"x":800,"y":500},"goal":{"type":"planet","x":914,"y":-398,"radius":102}},
{"title":"Sunburn","description":"Watch out for hazards! The sun is HOT!","maxJump":40,"oxygen":1600,"planets":[{"type":"planet","x":-100,"y":-450,"radius":60},{"type":"planet","x":100,"y":-700,"radius":70},{"type":"planet","x":300,"y":-1000,"radius":100},{"type":"planet","x":-50,"y":150,"radius":100},{"type":"sun","x":600,"y":-600,"radius":100}],"startingPosition":{"x":-50,"y":50},"goal":{"type":"planet","x":800,"y":-850,"radius":60}},
{"title":"Total Eclipse of the Target","description":"This is not a straight shot.\\n\\nUse gravity to your advantage!","maxJump":40,"oxygen":1600,"planets":[{"type":"planet","x":200,"y":-150,"radius":60},{"type":"planet","x":100,"y":700,"radius":70},{"type":"planet","x":-100,"y":-400,"radius":100},{"type":"planet","x":-50,"y":50,"radius":70},{"type":"sun","x":100,"y":300,"radius":100}],"startingPosition":{"x":100,"y":625},"goal":{"type":"planet","x":-100,"y":-950,"radius":60}},
{"title":"Danger Zone!","description":"Long jumps.\\nSmall targets.\\nBig hazards.\\n\\nOne wrong move and you're\\neither freezing in space\\nor vaporizing on the sun!","maxJump":40,"oxygen":1000,"planets":[{"type":"planet","x":800,"y":540,"radius":60},{"type":"sun","x":810,"y":-242,"radius":110},{"type":"planet","x":1073,"y":-739,"radius":96},{"type":"planet","x":431,"y":-715,"radius":98},{"type":"planet","x":669,"y":85,"radius":38},{"type":"planet","x":994,"y":41,"radius":34},{"type":"planet","x":1192,"y":-317,"radius":70},{"type":"planet","x":324,"y":-95,"radius":52},{"type":"planet","x":429,"y":-387,"radius":50},{"type":"planet","x":653,"y":-992,"radius":56},{"type":"planet","x":28,"y":-635,"radius":56},{"type":"planet","x":984,"y":-1094,"radius":66},{"type":"planet","x":1447,"y":-751,"radius":54}],"startingPosition":{"x":800,"y":480},"goal":{"type":"planet","x":802,"y":-456,"radius":32}}]
"""
levelData = JSON.parse(json)
levels = []


i = 0
for l in levelData
	do (l) =>
		planets = []
		for p in l.planets
			do (p) =>
				if p.type == "sun"
					planets.push new Sun p.x, p.y, p.radius
				else
					planets.push new Planet p.x, p.y, p.radius
		
		levels.push (new Level()).setLevelNumber(++i)
			.setTitle(l.title)
			.setDescription(l.description)
			.setStageSize(w, h)
			.setPlayer(player)
			.setPlanets(planets)
			.setGoal(new Planet l.goal.x, l.goal.y, l.goal.radius)
			.setPosition(x: l.startingPosition.x, y: l.startingPosition.y)
			.setOxygen(if l.oxygen? then l.oxygen else 1000)
			.setJump(if l.jump? then l.jump else 40)
			
###
# set up Levels (the old way)
levels = [
	(new Level()).setTitle("Level 1: Hopscotch")
		.setDescription("Get to the green planet for your oxygen runs out!\n\nUse LEFT/RIGHT arrow keys to walk around on planets.\n\nHold SPACE to jump, but watch the jump meter.\nJump too high, and you'll drift off into space!\n\n(click here or hit SPACE to begin)")
		.setStageSize(w, h)
		.setPlayer(player)
		.setPlanets([
			(new Planet -50, -120, 70),
			(new Planet 220, -40, 80),
			(new Planet -100, 280, 70),
			(new Planet 250, 260, 80)
			(new Planet -50, 550, 80),
		])
		.setGoal(
			new Planet 300, 650, 90
		).setPosition(x: -50, y: -40).setOxygen(1200)
		.setJump(40),
	(new Level()).setTitle("Level 2: Sunburn")
		.setDescription("Watch out for hazards! The sun is HOT!")
		.setStageSize(w, h)
		.setPlayer(player)
		.setPlanets([
			(new Planet -100, 450, 60),
			(new Planet 100, 700, 70),
			(new Planet 300, 1000, 100),
			(new Planet -50, -150, 100),
			(new Sun 600, 600, 100)
		])
		.setGoal(
			new Planet 800, 850, 60
		).setPosition(x: -50, y: -50).setOxygen(1400)
		.setJump(40),
	(new Level()).setTitle("Level 3: Total Eclipse of the Target")
		.setDescription("This is not a straight shot. Use gravity to your advantage!")
		.setStageSize(w, h)
		.setPlayer(player)
		.setPlanets([
			(new Planet 200, 150, 60),
			(new Planet 100, -700, 70),
			(new Planet -100, 400, 100),
			(new Planet -50, -50, 70),
			(new Sun 100, -300, 100)
		])
		.setGoal(
			new Planet -100, 950, 60
		).setPosition(x: 100, y: -625).setOxygen(1600)
		.setJump(40)
]
###
window.levels = levels


# gameplay triggers
startGame = () ->
	levels[currentLevel].start()
	playMode = MODE_PLAY

startOver = () ->
	currentLevel = 0
	startGame()

death = () ->
	playMode = MODE_DEAD

finish = () ->
	if currentLevel < levels.length - 1
		currentLevel += 1
		playMode = MODE_FINISH
	else
		playMode = MODE_FINAL

radio(player.DEAD).subscribe death
radio(player.FINISHED).subscribe finish


# interactivity / events
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
				player.accel (rotation - PI), 10
		when KEY_DOWN
			if key_dir != KEY_DOWN and 1 == 2
				key_dir = KEY_DOWN
				player.accel rotation, 10
		when KEY_LEFT
			if key_dir != KEY_LEFT and player.onGround
				#key_dir = KEY_LEFT
				player.direction = player.DIR_LEFT
				player.walking = true
				player.accel rotation - HALF_PI, 3, true
		when KEY_RIGHT
			if key_dir != KEY_RIGHT and player.onGround
				#key_dir = KEY_RIGHT
				player.direction = player.DIR_RIGHT
				player.walking = true
				player.accel rotation + HALF_PI, 3, true
		when KEY_SPACE
			if key_dir != KEY_SPACE and player.onGround
				key_dir = KEY_SPACE
				player.startJumping()
			switch playMode
				when MODE_INTRO
					playMode = MODE_START
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
	if !cont
		e.preventDefault()

canvas.onclick = (e) ->
	switch playMode
		when MODE_INTRO
			playMode = MODE_START
		when MODE_START
			startGame()
		when MODE_DEAD
			startGame()
		when MODE_FINISH
			startGame()
		when MODE_FINAL
			startOver()


# global color functionality (currently only used in chrome.coffee)
runningOutColors = [
	{p: 0, r: 255, g: 0, b: 0},
	{p: .3, r: 255, g: 255, b: 0},
	{p: .7, r: 0, g: 200, b: 0}
]

# fancy color blending based on a ruleset like above
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


# rendering stars in the background
starBrightness = 155
setPixel = (s, pixels, i) ->
	#pixels.setPixel i, (s.color 0)
	if Math.random() * 1000 < 2
		pixels.setPixel i, (s.color starBrightness)
	

# processing.js boilerplate
sketch ->
	# setup() is run once upon instantiation
	@setup = =>
		@size w, h
		@background 0
		@noFill()
		@frameRate 30
		@loadedFont = @loadFont "fonts/Audiowide-Regular.ttf"
		imgs = [player.IMG_STANDING, player.IMG_WALKING, player.IMG_SQUATTING, player.IMG_FLYING, player.IMG_BURNT]
		dirs = [player.DIR_LEFT, player.DIR_RIGHT]
		for img in imgs
			for dir in dirs
				this[img+"_"+dir] = @loadImage "images/spiff/"+img+"_"+dir+".png"
		@stars = @createImage 1000, 1000, @ARGB
		@splash = @loadImage "images/splash.png"
		p = @stars.pixels.toArray()
		setPixel this, @stars.pixels, i for pixel, i in p
		@stars.updatePixels()
		chrome.s = this
		this

	# draw() is run for every frame
	@draw = =>
		@background 0
		
		switch playMode
			when MODE_INTRO
				chrome.intro this
			when MODE_START
				chrome.drawMap this, levels[currentLevel]
				chrome.startLevel this, levels[currentLevel]
			when MODE_PLAY
				levels[currentLevel].redraw this
				chrome.draw this, player
			when MODE_DEAD
				chrome.drawMap this, levels[currentLevel]
				chrome.dead this, levels[currentLevel]
			when MODE_FINISH
				chrome.drawMap this, levels[currentLevel]
				chrome.startLevel this, levels[currentLevel]
			when MODE_FINAL
				txt = "FINISHED! Start over?"
				chrome.drawText txt, w/2 - (@textWidth txt)/2, h/2
