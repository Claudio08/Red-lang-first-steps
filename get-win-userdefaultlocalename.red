Red[
	Author:  "Claudio08"
	Date:    june 2019
	Title:   "Get Windows GetUserDefaultLocaleName"
	Purpose: {Basic example to retrive with Win10 API 
			  user default local name as Red string!}
	Note:	 {Red 0.6.4 compiled with -r flag - tested on Win10 x64}
]
#system [
	g-loc: context [
		;https://www.pinvoke.net/default.aspx/kernel32.GetLocaleInfoEx
		#define LOCALE_NAME_MAX_LENGTH  85
		#import [
		;https://docs.microsoft.com/it-it/windows/desktop/api/winnls/nf-winnls-getuserdefaultlocalename
			"kernel32.dll" stdcall [
				get-user-dname: "GetUserDefaultLocaleName"[
				lpLocaleName  [c-string!]
				cchLocaleName [integer!]
				return:       [integer!]
				]
			]
 			"msvcrt.dll" cdecl [
				malloc: "malloc" [
					size    [integer!]
					return: [c-string!]
				]
				release: "free" [
					block   [c-string!]
				]
			]		
		]
		;u16len? credit: https://github.com/NjinN/Recode/blob/master/Red/flappyBird/mci-cmd.red
		u16len?: func [s [c-string!] return: [integer!] /local len [integer!] index-next [integer!]][
			len: -1
			until [
				len: len + 2
				index-next: len + 1
				all [s/len = #"^@"	s/index-next = #"^@"]
			]
			return len / 2 
		]		
		get-locale: function [/local buffer rs [red-string!]] [	
			buffer: malloc  256
			;Win API-> GetUserDefaultLocaleName	
			either (get-user-dname buffer LOCALE_NAME_MAX_LENGTH) = 0 [
				rs: string/load "error" 5 UTF-8
				][
				rs: string/load buffer u16len? buffer UTF-16LE
			]
			release buffer
			SET_RETURN(rs)
		] 
	]
]	
l-n: routine [] [g-loc/get-locale]
locale-name: l-n 
print "GetUserDefaultLocaleName"
print ["returned Red" type? locale-name ": " locale-name]


comment { output example
GetUserDefaultLocaleName
returned Red string : it-IT
}
