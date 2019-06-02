Red[
	Author:  "Claudio08"
	Date:    june 2019
	Title:   "Get Windows local language names"
	Purpose: {Basic example to retrive with Win10 API 
              local language names in a Red block!}
	Note: 	 {compiled with -r flag - tested on Win10 x64}
]
#system [
	g-loc: context [
		;https://www.pinvoke.net/default.aspx/kernel32.GetLocaleInfoEx
		#define LOCALE_NAME_MAX_LENGTH  85
		#define LOCALE_NAME_USER_DEFAULT      null
		#define LOCALE_RETURN_NUMBER          20000000h   ;-- return number instead of string
		#define LOCALE_SENGLISHDISPLAYNAME    00000072h   ;-- Display name (language + country usually) in English, eg 
		#define LOCALE_SLOCALIZEDDISPLAYNAME  00000002h   ;-- localized name of locale, eg "German (Germany)" in UI language
		#define LOCALE_SNATIVELANGUAGENAME    00000004h   ;-- native name of language, eg "Deutsch"
		;
		#import [
			"kernel32.dll" stdcall [
				;https://docs.microsoft.com/en-us/windows/desktop/api/winnls/nf-winnls-getuserdefaultlcid
				get-user: "GetUserDefaultLCID" [
					return: [integer!]
				]
				;https://docs.microsoft.com/it-it/windows/desktop/api/winnls/nf-winnls-getuserdefaultlocalename
				get-user-dname: "GetUserDefaultLocaleName" [
					lpLocaleName  [c-string!]
					cchLocaleName [integer!]
					return:       [integer!]
				] 
				; https://docs.microsoft.com/it-it/windows/desktop/api/winnls/nf-winnls-getlocaleinfoex
				get-locale-info: "GetLocaleInfoEx" [
					lpLocaleName [c-string!] ; LPCWSTR Long Pointer to Constant Wide String
					LCType       [integer!]
					lpLCData     [c-string!] ; LPWSTR
					cchData      [integer!]  
					return:      [integer!]
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
		u16len?: func [s [c-string!] return: [integer!] /local len [integer!] index-next [integer!]] [
			len: -1
			until [
				len: len + 2
				index-next: len + 1
				all [s/len = #"^@"	s/index-next = #"^@"]
			]
			return len / 2 
		]	
	  	set-value: function [result [integer!] buffer [c-string!] vals [red-block!]] [
			either result = 0 [string/load-in "error" 5 vals UTF-8] [
				string/load-in buffer u16len? buffer vals UTF-16LE	
			]
		]
		get-locale: function [/local buffer vals [red-block!] result [integer!] rs [red-string!] ] [	
			buffer: malloc  256
			vals: block/make-in null 5
			;
			;Win API-> GetUserDefaultLCID 
			result: get-user ;-- return 1040 x it
			integer/make-in vals result
			;
			;Win API-> GetUserDefaultLocaleName
			result: get-user-dname buffer LOCALE_NAME_MAX_LENGTH
			set-value result buffer vals

			;Win API-> GetLocaleInfoEx LOCALE_SNATIVELANGUAGENAME
			result: get-locale-info LOCALE_NAME_USER_DEFAULT LOCALE_SNATIVELANGUAGENAME buffer  256
			set-value result buffer vals

			;Win API-> GetLocaleInfoEx LOCALE_SLOCALIZEDDISPLAYNAME
			result: get-locale-info LOCALE_NAME_USER_DEFAULT LOCALE_SLOCALIZEDDISPLAYNAME buffer 256
			set-value result buffer vals

			;Win API-> GetLocaleInfoEx LOCALE_SENGLISHDISPLAYNAME
			result: get-locale-info LOCALE_NAME_USER_DEFAULT LOCALE_SENGLISHDISPLAYNAME buffer 256
			set-value result buffer vals

			release buffer		
			SET_RETURN(vals)
		] 
	]
]	
l-n: routine [] [g-loc/get-locale]
locale-name: l-n 
print ["returned Red" type? locale-name ": "]
probe locale-name
print ""
print ["GetUserDefaultLCID: " locale-name/1]
print ["GetUserDefaultLocaleName: " locale-name/2]
print ["LOCALE_SNATIVELANGUAGENAME: " locale-name/3]
print ["LOCALE_SLOCALIZEDDISPLAYNAME: " locale-name/4]
print ["LOCALE_SENGLISHDISPLAYNAME: " locale-name/5]
print "---end---"

comment { output example
returned Red block :
[1040 "it-IT" "italiano" "Italiano (Italia)" "Italian (Italy)"]

GetUserDefaultLCID:  1040
GetUserDefaultLocaleName:  it-IT
LOCALE_SNATIVELANGUAGENAME:  italiano
LOCALE_SLOCALIZEDDISPLAYNAME:  Italiano (Italia)
LOCALE_SENGLISHDISPLAYNAME:  Italian (Italy)
}
