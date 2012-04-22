class Chrome
	constructor: (@w, @h) ->
	
	barWidth: 200
	barHeight: 32
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
		@s.fill 255, 0, 0
		@s.rect @marginLeft + @barPadding, 
			@marginTop + @barPadding + 10, 
			((@barWidth-@barPadding*2) * (@player.oxygen) / (@player.maxOxygen)),
			@barHeight - @barPadding*2
		@drawText "oxygen", @marginLeft, @marginTop
	
	drawText: (txt, x, y) ->
		@s.textFont(@s.loadedFont, 15);
		@s.fill 0
		@s.text txt, x+1.5, y+1.5
		@s.text txt, x+.5, y+1.5
		@s.text txt, x+1.5, y+.5
		@s.fill 255
		@s.text txt, x+.5, y+.5
