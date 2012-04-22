w = 800
h = 480
rotation = 0
planets = []

MODE_START = "start"
MODE_PLAY = "play"
MODE_DEAD = "dead"

playMode = MODE_START

planets.push new Planet 0, 150, 100
planets.push new Planet 300, -350, 60
planets.push new Planet -100, -450, 60
planets.push new Planet 100, -700, 70
planets.push new Planet -100, -1000, 100
planets.push new Sun 600, -600, 100

for planet in planets
	planet.setup()
	#planet.color[0] = Math.random()*100 * 155
	#planet.color[1] = Math.random()*100 * 155
	#planet.color[2] = Math.random()*100 * 155

player = new Player()
player.y = -300

galaxy = new Galaxy w, h, player, planets
chrome = new Chrome w, h

window.player = player
window.galaxy = galaxy

KEY_UP = 38
KEY_DOWN = 40
KEY_LEFT = 37
KEY_RIGHT = 39
KEY_SPACE = 32

key_dir = -1

document.onkeyup = (e) ->
	if key_dir == KEY_SPACE
		player.jump()
	key_dir = -1
	player.walking = false

document.onkeydown = (e) ->
	cont = false
	switch e.keyCode
		when KEY_UP
			if key_dir != KEY_UP and 1 == 2
				key_dir = KEY_UP
				player.accel (window.rotation - Math.PI), 10
		when KEY_DOWN
			if key_dir != KEY_DOWN and 1 == 2
				key_dir = KEY_DOWN
				player.accel (window.rotation), 10
		when KEY_LEFT
			if key_dir != KEY_LEFT and player.onGround
				#key_dir = KEY_LEFT
				player.direction = player.DIR_LEFT
				player.walking = true
				player.accel (window.rotation - Math.PI/2), 3, true
		when KEY_RIGHT
			if key_dir != KEY_RIGHT and player.onGround
				#key_dir = KEY_RIGHT
				player.direction = player.DIR_RIGHT
				player.walking = true
				player.accel (window.rotation + Math.PI/2), 3, true
		when KEY_SPACE
			if key_dir != KEY_SPACE and player.onGround
				key_dir = KEY_SPACE
				player.startJumping()
		else
			cont = true
			#console.log e.keyCode
	if !cont
		e.preventDefault()

setPixel = (s, pixels, i) ->
	pixels.setPixel i, (s.color 0)
	if Math.random() * 1000 < 2
		pixels.setPixel i, (s.color 255, 255, 255)
	

sketch ->

	@setup = =>
		@size w, h
		@background 0
		@noFill()
		@frameRate 30
		@loadedFont = @loadFont("fonts/Audiowide-Regular.ttf")
		imgs = [player.IMG_STANDING, player.IMG_WALKING, player.IMG_SQUATTING, player.IMG_FLYING]
		dirs = [player.DIR_LEFT, player.DIR_RIGHT]
		for img in imgs
			for dir in dirs
				this[img+"_"+dir] = @loadImage("images/spiff/"+img+"_"+dir+".png")
		@stars = @createImage(1000, 1000, @ARGB)
		p = @stars.pixels.toArray()
		setPixel this, @stars.pixels, i for pixel, i in p
		@stars.updatePixels();
		this

	@draw = =>
		@background 0
		nearestPlanet = player.findNearestPlanet galaxy.planets, false
		window.nearestPlanet = nearestPlanet
		idealRotation = (Math.PI/2 - Math.atan2 nearestPlanet.x - player.x, nearestPlanet.y - player.y)
		diff = Math.abs idealRotation - rotation
		if (Math.abs idealRotation - Math.PI*2 - rotation) < diff
			idealRotation = idealRotation - Math.PI*2
		if (Math.abs idealRotation + Math.PI*2 - rotation) < diff
			idealRotation = idealRotation + Math.PI*2
		rotation += (idealRotation - rotation) * .1
		if rotation < 0
			rotation += Math.PI*2
		rotation = rotation % (Math.PI*2)
		window.rotation = rotation
		galaxy.rotation = rotation
		galaxy.offsetX += (player.x - galaxy.offsetX) * .3
		galaxy.offsetY += (player.y - galaxy.offsetY) * .3
		player.move().calculatePhysics(galaxy.planets)
		galaxy.draw this
		chrome.draw this, player
