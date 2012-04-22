class Chrome
	constructor: (@w, @h) ->
	
	barWidth: 200
	barHeight: 26
	barPadding: 4
	
	marginTop: 40
	marginBottom: 40
	marginLeft: 40
	marginRight: 40
	
	draw: (@s, @player) ->
		# jump status
		@s.stroke 255
		@s.fill 0
		@s.rect @w - @barWidth - @marginRight, @marginTop + 10, @barWidth, @barHeight
		if @player.jumping
			@s.noStroke()
			@s.fill 255, 0, 0
			@s.rect @w - @barWidth - @marginRight + @barPadding, 
				@marginTop + @barPadding + 10, 
				((@barWidth-@barPadding*2) * (@player.jumpVelocity-@player.minJump) / (@player.maxJump-@player.minJump)),
				@barHeight - @barPadding*2
		@drawText "jump meter", @w - @barWidth - @marginRight, @marginTop
		
		@s.stroke 255
		@s.fill 0
		@s.rect @marginLeft, @marginTop + 10, @barWidth, @barHeight
		@s.noStroke()
		c = getColor @player.oxygen, 0, @player.maxOxygen, runningOutColors
		@s.fill c.r, c.g, c.b
		@s.rect @marginLeft + @barPadding, 
			@marginTop + @barPadding + 10, 
			((@barWidth-@barPadding*2) * (@player.oxygen) / (@player.maxOxygen)),
			@barHeight - @barPadding*2
		@drawText "oxygen", @marginLeft, @marginTop
	
	startLevel: (@s) ->
		@s.textAlign(@s.CENTER);
		txt = "Pico Planets"
		@drawText txt, @w/2, @h/2 - 20, 24

		txt = "Try to get to the green planet before your oxygen runs out!\n
Watch out for hazards. The sun is HOT!\n
Hold SPACE to jump. Don't jump too high, or you might drift off into space!\n
When you're on a planet, you can walk around using the left and right arrow keys.\n
Click anywhere or hit SPACE to begin"
		@drawText txt, @w/2, @h/2
		
		@s.textAlign(@s.LEFT);
	
	dead: (@s) ->
		txt = "DEAD! Start over?"
		@drawText txt, @w/2 - @s.textWidth(txt)/2, @h/2
	
	drawText: (txt, x, y, size) ->
		if !size
			size = 15
		@s.textFont(@s.loadedFont, size);
		@s.fill 0
		@s.text txt, x+1.5, y+1.5
		@s.text txt, x+.5, y+1.5
		@s.text txt, x+1.5, y+.5
		@s.fill 255
		@s.text txt, x+.5, y+.5
