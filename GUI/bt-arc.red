Red[
	Author:  "Claudio08"
	Date:    may 2019
	Title:   "Arc button"
	Purpose: {GUI - basic experiment to create a custom arc button with shape}
	Note: 	 {not resizible button - tested on Red 0.6.4 Win10}
	Needs: View
]
extend system/view/VID/styles [
	rounded-btn: [
		template: [
			type: 'base
			size: 100x90 
			font: make font! [name: "arial" style: 'bold size: 12]
			color: transparent
			extra:  context [
				btn-size: none
				btn-text: none
				btn-text-xy: 3x10				
				;--- btn-colors: [1-pen 2-fill 3-text 4-pen 5-fill 6-text] 
				btn-colors: [black gray black black gray black] 
				btn-border-width: 2
				;--- btn-lines: [1-vert-length 2-horiz-length]
				btn-lines: [30 60]
				;--- btn-arc: [1-start 2-end 3-x 4-y 5-angle]
				btn-arc: [2x30 70x40 5 6 70]
				btn-image: [] ;--- contains 2 images
				;
				btn-transparent: function [img alpha][ ; Works on Windows, but not on Mac?
					tr: copy at enbase/base to-binary alpha 16 7
					append/dup tr tr to-integer log-2 length? img
					append tr copy/part tr 2 * (length? img) - length? tr
					make image! reduce [img/size img/rgb debase/base tr 16]
				]				
				btn-draw: function [face btn /local ret][
					ret: compose/deep [
						line-width (face/extra/btn-border-width)
						pen (face/extra/btn-colors/(btn + 1))
						fill-pen (face/extra/btn-colors/(btn + 2))
						shape [
							move 2x30 
							'vline (face/extra/btn-lines/1)
							'arc 10x10 10 10 0  
							'hline (face/extra/btn-lines/2)
							move (face/extra/btn-arc/1) ;--- start arc
							'arc (face/extra/btn-arc/2) (face/extra/btn-arc/3) (face/extra/btn-arc/4) (face/extra/btn-arc/5) sweep
							move 0x0
						]
						font (face/font) pen (face/extra/btn-colors/(btn + 3))
						text (face/extra/btn-arc/1 + face/extra/btn-text-xy) (face/extra/btn-text)
					]
					ret
				]
			]
			actors: [
				on-down: func [face event /local col][
					do-actor face event 'click
					col: pick face/image event/offset
					if (col = reduce face/extra/btn-colors/2) [
						face/image: face/extra/btn-image/2
					]
				]
				on-up: func [face event][
					face/image: face/extra/btn-image/1
				]
			]
		]
		init: [
			face/extra/btn-text: face/text
			face/text: none
			;
			either face/color = transparent [
				append face/extra/btn-image face/extra/btn-transparent draw 100x90 [] 255
			][
			;--- only for test
				append face/extra/btn-image draw 100x90 compose [fill-pen (face/color) pen off box 0x0 (100x90)]
			]
			append face/extra/btn-image copy face/extra/btn-image/1
			;
			face/extra/btn-image/1: draw face/extra/btn-image/1 compose/deep [(compose face/extra/btn-draw face 0)]
			face/extra/btn-image/2: draw face/extra/btn-image/2 compose/deep [(compose face/extra/btn-draw face 3)]
			;
			face/image: face/extra/btn-image/1
		]
	]	
]

view [
	title "arc button" backdrop white
	across space 1x1 
	rounded-btn "RED^/language" with[extra/btn-colors: [gray red white black white black] extra/btn-border-width: 6 extra/btn-text-xy: 1x1] on-click []
	rounded-btn "RED" font [size: 20] with[extra/btn-colors: [gray green white black white black]] on-click []
]

