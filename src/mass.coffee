class Mass
	constructor: (_x, _y, _radius, _mass) ->
		this.x = _x
		this.y = _y
		this.radius = _radius
		this.mass = _mass
	
	safe: true
	goal: false
	distance: 0
	
	color: [200, 200, 200]
	markerColor: [127, 127, 127]
	
	onContact: (player) ->
		this
	
	physics: (player) ->
		this.distance = this.distanceTo(player)
		if this.distance < this.radius*5
			if this.distance > 0
				p = 1 - (Math.sin this.distance / (this.radius*5) * Math.PI/2)
				pull = p * (this.radius+100)*.01
				angle = Math.PI/2 - Math.atan2 this.x-player.x, this.y-player.y
				player.velocityX += (Math.cos angle) * pull
				player.velocityY += (Math.sin angle) * pull
			else
				this.onContact player
		this
	
	draw: (s, g) ->
		this.s = s
		this.g = g
		x = this.x - g.offsetX
		y = this.y - g.offsetY
		angle = Math.atan2 x, y
		dist = Math.sqrt (Math.pow x, 2) + (Math.pow y, 2)
		angle += g.rotation
		x = Math.cos(angle) * dist
		y = Math.sin(angle) * dist
		size = this.radius * 2
		
		w2 = g.w/2
		h2 = g.h/2
		
		if -w2 - this.radius < x < w2 + this.radius and -h2 - this.radius < y < h/2 + this.radius
			x += w2
			y += h2
			s.noStroke()
			s.fill this.color[0], this.color[1], this.color[2]
			s.ellipse x, y, size, size
		else
			angle = Math.PI/2 - Math.atan2 x, y
			dist = this.distance
			
			if (Math.abs x) > w2
				dist = Math.abs (w2 / Math.cos(angle))
				x = (Math.cos angle) * dist
				y = (Math.sin angle) * dist
			if (Math.abs y) > h2
				dist = Math.abs (h2 / Math.sin(angle))
				x = (Math.cos angle) * dist
				y = (Math.sin angle) * dist
			
			x += w2
			y += h2
			
			s.strokeWeight(2)
			s.stroke this.markerColor[0], this.markerColor[1], this.markerColor[2], 222
			s.noFill()
			x1 = (Math.cos angle+.01) * (dist-20) + w2
			y1 = (Math.sin angle+.01) * (dist-20) + h2
			x2 = (Math.cos angle) * (dist-5) + w2
			y2 = (Math.sin angle) * (dist-5) + h2
			x3 = (Math.cos angle-.01) * (dist-20) + w2
			y3 = (Math.sin angle-.01) * (dist-20) + h2
			s.beginShape()
			s.vertex x1, y1
			s.vertex x2, y2
			s.vertex x3, y3
			s.endShape()
			#s.line w2, h2, x, y
			#s.ellipse x, y, 10, 10
		this
	
	distanceTo: (player) ->
		(Math.sqrt (Math.pow this.x-player.x, 2) + (Math.pow this.y-player.y, 2)) - this.radius