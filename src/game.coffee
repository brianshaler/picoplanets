w = 800
h = 480
rotation = 0
planets = []

planets.push new Planet	0, 0, 100
planets.push new Planet	200, -300, 60
planets.push new Planet	-100, -350, 60
planets.push new Planet	300, -600, 70
planets.push new Planet	100, -1000, 100

player = new Player()
player.y = -300

galaxy = new Galaxy w, h, player, planets

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
				player.accel (window.rotation - Math.PI/2), 10, true
		when KEY_RIGHT
			if key_dir != KEY_RIGHT and player.onGround
				#key_dir = KEY_RIGHT
				player.accel (window.rotation + Math.PI/2), 10, true
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
		@standing = @loadImage("images/"+player.IMG_STANDING+".png")
		@walking = @loadImage("images/"+player.IMG_WALKING+".png")
		@squatting = @loadImage("images/"+player.IMG_SQUATTING+".png")
		@flying = @loadImage("images/"+player.IMG_FLYING+".png")
		@stars = @createImage(1000, 1000, @ARGB)
		console.log "Processing.RGB"
		console.log @ARGB
		console.log @stars.pixels
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
