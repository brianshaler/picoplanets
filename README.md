Pico Planets
===========

Built using CoffeeScript and Processing.js. Cakefile defines the order in which the files will be slammed together

To view it in action: [picoplanets.com](http://picoplanets.com/)

(Note: During the Ludum Dare judging period, the home page will only show v1.0, which includes only work completed during the initial 48 hours. In the meantime, to view the latest version, go to [picoplanets.com/latest/](http://picoplanets.com/latest/))

To compile:

	# generates ./lib/game.js
	cake build

Application structure:

	index.html # includes ./lib/game.js and runs some processing.js boilerplate
	game.coffee # main: creates levels, player, chrome (GUI), handles events, and runs processing
	+- level.coffee # levels contain local properties, a Galaxy, manages stage rotation, and delegates redraws
		+- galaxy.coffee # galaxy maintains the x/y coordinate system, stars (BG), and planets
			+- planet.coffee # extends mass.coffee, adds default (gray) and "goal" (green) colors
			+- sun.coffee # extends mass.coffee, adds yellow color, and burns player onContact()
	+- player.coffee # character's properties, restricts movement, manages sprite, and triggers success and failure events
	+- chrome.coffee # GUI, start screens, oxygen/jump indicators, etc.
	mass.coffee # basic circular object with gravity; handles physics and drawing
	