Red [
    Author: "Claudio08"
	  Date: 12-May-2019
	  Title: "Switch button"
	  Purpose: {GUI - basic custom switch button}
    Needs: View
]
bits: [0 0 0 0 0 0 0 0 0 0 0 0]
view compose/deep [
	style switch-btn: base 40x90 on-create [
			face/extra: context [
				swb-color: face/color
				face/color: black
				swb-dark: swb-color - 30.30.30
				swb-off: draw 40x90 [
					fill-pen swb-dark
					box 2x2 38x88
					pen gray
					fill-pen swb-color
					polygon 2x2 38x2 33x70 5x70 
					polygon 33x70 5x70 5x77 33x77
				]
				swb-on: draw 40x90 [
					fill-pen swb-dark
					box 2x2 38x88
					pen gray
					fill-pen swb-color
					polygon 2x2 38x2 33x10 5x10 
					polygon 33x10 5x10 5x17 33x17
				]
				swb-click: func [face][ 	
							either face/data = 0 [
							face/data: 1 face/image: face/extra/swb-on
							][face/data: 0 face/image: face/extra/swb-off]
					]
		]
			face/data: 0
			face/image: face/extra/swb-off
	]
	across
	space 0x0
	switch-btn red [face/extra/swb-click face bits/1: face/data print bits]
	switch-btn orange [face/extra/swb-click face bits/2: face/data print bits]	
	switch-btn gold [face/extra/swb-click face bits/3: face/data print bits]
	switch-btn yellow [face/extra/swb-click face bits/4: face/data print bits]	
]
