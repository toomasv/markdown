Red []
title: "Markdown by Red"
scanner: context [

	;;; Words
	debug: true
	new: func [elem][make elem! [element: elem]]
	elem!: object [
		parent: none 
		element: none 
		children: make block! 50
		open?: yes
		options: none
		flags: none
		open-block: func [elem /with data /only /local child][
			append children child: new elem
			child/parent: self
			if with [append child/children data]
			either only [child/open?: no][latest: :child]
		]
		open: func [elem data /only][
			either only [
				open-block/with/only elem data
			][
				open-block/with elem data
			]
		]
		add: func [data][append children data]
		close: has [child][
			if open? [
				open?: no
				child: self
				while [all [
					child/children
					not empty? child/children
					object? child: last child/children
					child/open?
				]][child/close]
				if self/parent [latest: self/parent]
			]
		]
	]
	out: none ;latest: new 'doc
	leaf: make block! 100
	open: make block! 10
	item-lens: make block! 10
	item-elems: make block! 10
	text: mark: start-num: umark: omark: imark: lists: open-list: none
	s: e: k: l: m: i: j: none
	item-len: 0
	bcount: 0
	item-open?: no
	first-item?: yes
	first-line?: no
	li-empty-line?: no
	current-level: 0
	items-num: make map! 10
	space-removed?: no
	ic-space-removed?: no
	bq-level: 0
	blocks: [li ul ol blockquote doc]
	stop?: no
	next?: no
	list-in-para?: no
	
	;;; Funcs
	
	get-length: func [s e][(index? e) - (index? s)]
	
	map: func [block fn][collect [forall block [keep fn block/1]]]
	
	to-line-end: func [s][mold copy/part s either end: find/tail s newline [end][tail s]]
	
	;opened-elements: has [el][el: out while [all [object? el el/open?]][prin ["/" el/element] el: last el/children]]
	
	check: [
		(stop?: no next?: no list-in-para?: no)
		(if debug [prin "(check) "])
		(if debug [print [
			"bcount:" bcount "elem:" elem/element pick ["open" "closed"] elem/open? "latest:" latest/element "str:"
			if all [not find blocks elem/element elem/open?][mold copy/part either string? el: last elem/children [el]["none"] 30];["s:" mold copy/part s 30]
		]])
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;	if (find [ul ol] elem/element)[
	;		(if debug [prin "(check ul) "])
	;		(if debug [print ["opts:" mold elem/options]])
	;		[
	;			blank
	;			(if debug [print ["Consume blank:" bcount]])
	;			(stop?: yes)
	;		]
	;	]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;|	if (elem/element = 'ol)[
	;		(if debug [prin "(check ol) "])
	;		(if debug [print ["opts:" mold elem/options]])
	;	]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	;|
		if (elem/element = 'li) (
			if debug [prin "(check li) "]
			len: elem/options/len 
			if debug [print ["opts:" mold elem/options]]
		)[
			;remove 
			len sp
			;(space-removed?: yes)
			(if debug [print ["Consume " len "spaces. bcount:" bcount]]) 
			(
				if all [
					bcount > 0 
					any [elem = latest latest/parent = elem elem/parent = latest]
				][elem/parent/options/type: 'loose]
				if debug [print "Set list type to 'loose. "]
			)
		|	;(space-removed?: no)
			(if debug [prin "Space consume failed, "])
		;	if (empty? elem/children) 
		;	(if debug [print ["item still empty."]])
			;line-end e:
			blank e:
				;(bcount: bcount + 1)
				(if debug [print ["line-end. bcount:" bcount]])
				[	if (all [latest/element = 'para])(; latest/parent = elem]) (
						latest/close
						;elem/parent/options/type: 'loose
						if debug [print ["Close para. Latest:" latest/element]]
						;stop?: yes 
					) 
				|	if (all [find [indented-code fenced-code] latest/element latest/parent = elem]) (
						latest/add newline
						if debug [print ["Add newline"]]
						;stop?: yes 
					) 
				|	if (all [find [ul ol] latest/element elem/parent = latest])
				|	if (bcount > 2)(				; According to spec should be open, but example contradicts (Listitems, ex 233)
						elem/close 
						if debug [print ["Close li. Latest:" latest/element]]
						;stop?: yes 
					)
				|	;(elem/parent/options/type: 'loose)
				]	(stop?: yes)
		|	thematic-break (remove/part s e)
		| 	ahead [
				check-bullet 
				(if debug [prin "bullet ahead. "])
				[
					if (										; Bullet in continuation para
						all [
							;latest/element = 'para 
							;elem = latest/parent
							mark = elem/parent/options/mark
							;any [
							;	blist = 'ul 
							;	all [blist = 'ol start-num = "1"]
							;]
						]
					)(
						;latest/parent/close
						;if debug [print "Bullet in para continuation. Close para, li."]
						if bcount > 0 [elem/parent/options/type: 'loose]
						elem/close
						if debug [print ["Close li. Latest:" latest/element]]
						;stop?: yes
					) break
				| 	if (
						any [									; List change
							blist <> elem/parent/element		; current item-type is incompatible with open list type
							all [ 								; or ordered list mark is incompatible
								'ol = elem/parent/element 
								any [
									not find to-string l/1 digit
									m/1 <> elem/parent/options/mark
								]
							]
							all [								; or unordered list mark changes
								'ul = elem/parent/element
								l/1 <> elem/parent/options/mark
							]
						]
					)( 
						if debug [print ["List change, close" elem/parent/element "(latest" latest/element ") block."]]
						elem/parent/close						; then close current list
						if debug [print ["New latest:" latest/element]]
					)
				|	(	[
							elem/close
							if debug [print ["New item ahead, close current item. Latest:" latest/element]]
							stop?: yes
						]
					)
				]
			] ;(print "chk Ahead")
		| 	not ahead line-end 
			if (all [
				elem/children 
				not empty? elem/children 
				object? el: last elem/children 
				el/element = 'para
				el/open?
			]) (if debug [print ["para last element."]])
		|	(if debug [prin ["close list" elem/parent/element]])
			(elem/parent/close) 
			(if debug [print [". Latest:" latest/element]])
		] ;print "chk Parse passed"
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	|	if (elem/element = 'blockquote) [
			(if debug [prin "(check blockquote) "])
			check-blockquote 
			(if debug [print ["Consume BQ mark. "]])
		|	doc-end (out/close)
			(if debug [print ["End of input. Close doc."]])
		|	[	if (find [fenced-code indented-code] latest/element)
				(if debug [prin ["Ahead" latest/element ". "]])
			|	line-end
				(if debug [prin ["Blank ahead. "]])
			|	ahead [
					check-thematic-break
					(if debug [prin ["Thematic break ahead. "]])
				|	check-bullet
					(if debug [prin ["Bullet ahead. "]])
				]
			] (elem/close)
			(if debug [print "Close blockquote. Latest:" latest/element])
		|	if (latest/element = 'para) 
				(if debug [print "Continue with para."])
				line ;(next?: yes)
		|	(elem/close)
			(if debug [print "Match none. Close blockquote. Latest:" latest/element])
		]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	|	if (elem/element = 'indented-code) [
			(if debug [prin "(check icode) "])
			check-indented line (stop?: yes)
			(if debug [print "Consume space."])
		;|	doc-end (out/close)
		;	(if debug [print ["End of input. Close doc."]])
		|	blank (latest/add newline stop?: yes)
		|	(latest/close)
			(if debug [print "Close idented-code. Latest:" latest/element])
		]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	|	if (elem/element = 'fenced-code) [
			(if debug [prin "(check fcode) "])
			ahead [check-code-fence e:]
			;(probe latest/options probe reduce [mark ilen flen])
			if (all [
				mark = latest/options/mark 
				flen >= latest/options/len
				info = none
			]) (latest/close stop?: yes) :e 
			(if debug [print "Close fenced-code. Latest:" latest/element])
		;|	doc-end (out/close)
		;	(if debug [print ["End of input. Close doc."]])
		|	[	if (0 < ilen: elem/options/ilen)
				ahead [some sp e:]
				[	if (ilen < get-length s e)
					ilen skip
				|	:e
				]
			|	none
			]
			line (stop?: yes)
		]
	;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
	|	if (elem/element = 'para) [
			(if debug [prin "(check para) "])
			[	blank
				(if debug [prin "Consume blank. "])
			|	underline (
					if debug [prin "Setext heading. "]
					level: pick [1 2] mark = #"="
					level: to-word rejoin ["h" level]
					elem/element: level
					if debug [prin ["Set latest element to" level ". "]]
				)
			|	ahead [
					check-code-fence 
					(if debug [prin ["Fenced code ahead. "]])
				|	check-thematic-break
					(if debug [prin ["Thematic break ahead. "]])
				|	check-heading
					(if debug [prin ["Heading ahead. "]])
				|	check-blockquote
					(if debug [prin ["Blockquote ahead. "]])
				]
			]	(elem/close stop?: yes)
				(if debug [print ["Close" elem/element ". Latest:" latest/element]])
			| 	ahead check-bullet
				; After para listitem cannot be empty, and if it's ordered, has to start with 1
				if (all [not li-empty-line? any [blist = 'ul start-num = "1"]]) [
					(if debug [prin ["Bullet ahead. Close para. Set `list-in-para` flag."]])
					(
						elem/close
						list-in-para?: yes
					)
				]
		|	line (stop?: yes)
		]
	|
	]
	;;; RULES
	rule: [s: rule-start (elem: out) opt preliminary baseline]
	preliminary: [s: (probe elem/element)
		(if debug [print ["(prelim start) Line:" to-line-end s]])
		[ahead normalized-indent | none]				; change tabs in the beginning of line into spaces
		(if debug [print [
			"(prelim cont) stop?:" stop? 
			"elem:" attempt/safer [either object? elem [elem/element]["none"]]
			either find blocks elem/element [reduce [
				"empty?:" attempt/safer [empty? elem/children]
				"last child:" attempt/safer [either object? lst: last elem/children [lst/element]["none"]]
				"open?:" attempt/safer [lst/open?]
			]][reduce [
				"open?:" attempt/safer [elem/open?]
			]]
		]])
		
		if (
			any [
			next?
			all [
				elem/children 
				not empty? elem/children 
				object? el: last elem/children 
				el/open?
				elem: el
			]
		]) check [if (stop?) rule | opt preliminary]
	]

	baseline: [s: 
		doc-end (out/close)
		(if debug [print ["End of input. Close doc."]])
	|	[	(if debug [print ["(baseline start) Line:" to-line-end s either object? elem [elem/element][]]])
			;(if first-line? [first-line?: no]) ;For the case block element was just created in last round
			blank 
		|	(bcount: 0) 			; Not blank, restart blank-count (for list items separation)
			thematic-break 			; <hr />
		|	bullet					; Any list
		|	blockquote				; You know it
		|	example-code			; Special syntax handling for examples / tests
		|	indented 				; Indented code should be dealt with immediately
		| 	code-fence 				; Deal with start or end of the fenced code
		|	heading 				; One-line headings (ATX)
		|	html					; Direct html code
		|	line 	 				; Catch-all default line
		] 
		rule
	]
	
	;;; Charsets
	space: charset " ^-"
	non-space: complement space
	hr-mark: charset "-_*"
	setext-char: charset "=-"
	non-backtick: complement charset "`^/"
	upper: charset [#"A" - #"Z"]
	digit: charset "0123456789"
	ws: charset " ^-^/"
	non-ws: complement ws

	;;; Helper rules
	ending: [newline | end]; (close 'all)]
	line-end: [any space newline]
	doc-end: [any space end]
	line-start: [0 3 sp]
	tab2sp: [change [tab | #"→"] "    "]
	normalized-indent: [4 sp any [sp | tab2sp] | any sp tab2sp any [sp | tab2sp]]
	int: [some digit]
	rule-start: [(
		either tail? s [out/close][
			if debug [print "^/Rule-start."]
		]
	)]
	
	;;; Leaf rules
	blank: [any space ending (					
		bcount: bcount + 1 
		if debug [print ["Blank" bcount]]
	)]
	
	;; Code-fence
	info-string: [
		copy info any non-backtick ending (
			info: first split trim/head/tail info sp
			if empty? info [info: none]
		)
	]
	check-code-fence: [
		line-start
		[k: set mark ["```" | "~~~"] any mark] e: 
		(
			ilen: get-length s k
			flen: get-length k e
		)
		info-string
	]
	code-fence: [
		check-code-fence
		(
			latest/open-block 'fenced-code
			if debug [print "(code-fence) Open fenced code block."]
			latest/options: compose [mark: (mark) ilen: (ilen) len: (flen) info: (info)]
			elem: out
		) ;rule
	]
	
	;; Indented code
	check-indented: [4 sp]
	indented: [
		check-indented (
			latest/open-block 'indented-code
			if debug [print "(indented-code) Open indented code block."]
		) line 
	]
	
	;; Thematic break
	check-thematic-break: [
		line-start
		set mark hr-mark any space
		2 [mark any space]
		any [mark | space]
		ending
	]
	thematic-break: [
		if (not find [fenced-code indented-code] latest/element) 
		check-thematic-break e: (
			if find [para li blockquote ul ol] latest/element [
				if debug [prin "(them-break) "] 
				switch/default latest/element [
					li [
						if debug [print ["Close latest/parent" latest/parent/element]]
						latest/close
					]
					para [probe latest/parent/element
						either latest/parent/element = 'li [
							if debug [print ["Close latest/parent/parent" latest/parent/parent/element]]
							latest/parent/parent/close
						][
							if debug [print ["Close latest" latest/element]]
							latest/close
						]
					]
				][
					if debug [print ["Close latest" latest/element]]
					latest/close
				]
			]
			latest/open-block/only 'thematic-break
			if debug [print ". Open/only thematic break."]
		)
	]
	
	;;; Headings
	;; ATX heading 
	hstart: [line-start s: 1 6 #"#" e:]
	hend: [some space #"#" any #"#" any space ending | ending] ; blank?
	htext: [any space ahead not [some #"#" any space ending] copy text to hend];if (not empty? text)
	check-heading: [
		hstart [(text: copy "") k: sp [htext | :k] hend | ending] 
		(level: none level: get-length s e)
	]
	heading: [
		check-heading (
			level: to-word rejoin ["h" level]
			latest/open/only level tx: trim/head/tail copy text 
			if debug [print ["(heading) Open/only" level tx]]
			clear text
		)
	]
	
	;; Setext heading
	underline: [
		line-start 
		set mark setext-char 
		any mark 
		any space
		ending 
	]
	
	;;; Paragraph continuation
	;para-cont: [
	;	thru ending
	;]
	
	;;; Default line
	line: [copy text thru ending e: (
		either find blocks latest/element [		; If it is first line after blank or ended element, open provisional `para`
			if debug [prin ["(line) Open para" mold text "in" latest/element]]
			latest/open 'para copy text 
			if debug [print [". Latest:" latest/element]]
			;elem: :latest
			;next?: yes
		][
			latest/add copy text 
			if debug [print ["(line) Add line" mold text "to " latest/element]]
		]
		clear text ;probe reduce [e head e tail? e]
		if tail? e [
			out/close 
			if debug [probe "(line) End of input, close all."]
		]										; If we are in the end of input close all
	)]

	;;; For examples in spec + testing
	example-code: [
		"```````````````````````````````` example^/"
		copy code1 to "^/.^/" 3 skip						; Codes are separated by single dot on a line
		copy code2 to
		["^/````````````````````````````````" e:]
		(
			latest/open/only 'example reduce [code1 code2] ;probe select last latest/children 'children
			if debug [print "(example) Open/only example"]
		) 	; Send both pieces of example code
		:e
	]
	
	;;; BLOCK RULES
	;; Bullet-list
	obullet: [l: int m: [dot | #")"] (blist: 'ol)]
	ubullet: [l: [#"*" | #"-" | #"+"] m: (blist: 'ul)]
	check-bullet: [
		line-start [obullet | ubullet] k: (li-empty-line?: no) 							; Check for bullet and initialize `empty-item?`
		[any space ending (li-empty-line?: yes) | sp e1: any sp] e:
		;[ahead blank if (not (latest/element = 'para)) (probe "ho") (li-empty-line?: yes) | sp e1: any sp] e:	; If item is not empty (blank line) it should have space before following text
		(
			i: get-length s k 															; Length from start ogf line to the end of marker
			j: get-length k e															; Length from the end of marker to start of text
			item-len: either li-empty-line? [i + 1][either j > 4 [i + 1][i + j]]
			imark: copy/part l m  											; `imark` is the provided marker (for checking num)
			mark: either blist = 'ul [l/1][m/1]								; `mark` is list-specific (ul: "+*-" ol: ").")
			if blist = 'ol [start-num: to-integer copy/part l m]
		)
		if (any [blist = 'ul start-num < 1000000000]) (
			if blist = 'ol [start-num: to-string start-num]
		)
		;not if (all [latest/element = 'para li-empty-line?])   ;; !! More complicated
		[if (j > 4) :e1 |]
	]
	bullet: [
		check-bullet 
		(if debug [prin "(bullet) "])
		;[	if (latest/element = 'li) [
		;		if (mark = latest/parent/options/mark)
		;			(latest/close)
		;			(if debug ["Close li. Latest:" latest/element])
		;	|	(if debug [prin ["Close parent" latest/parent/element]])
		;		(latest/parent/close)
		;		(if debug [print [". Latest:" latest/element]])
		;	]
		;|	none
		;]
		[	if (find [doc blockquote li para] latest/element) (
				if latest/element = 'para [
					latest/close
					if debug [prin ["Close para. Latest:" latest/element]]
				]
				latest/open-block blist
				if debug [prin ["Open" latest/element "block. Line:" to-line-end s]]
				latest/options: compose [type: tight mark: (mark)]									; and register current marks
				if blist = 'ol [
					append latest/options compose [start: (start-num)]
				]
			)
		| 	none
		]
		[	if (find [ul ol] latest/element) (
				latest/open-block 'li
				if debug [prin ["Open li block. Line:" to-line-end s]]
				latest/options: compose either blist = 'ol [
					[len: (item-len) empty?: (li-empty-line?) num: (start-num)]
				][
					[len: (item-len) empty?: (li-empty-line?)]
				]
				if debug [print ["Opts:" mold latest/options]]
				;first-line?: yes
			) [if (not li-empty-line?) baseline | blank (latest/parent/close) |] (stop?: yes)
		|	(cause-error 'user 'message reduce [
				rejoin ["Bullet seen in wrong place! Latest: " latest/element ", line: " to-line-end s]
			])
		]
	]
	
	;; Blockquote
	check-blockquote: [line-start ["> " | #">" ahead [non-space | end]]]
	blockquote: [(bqs: 0) 
		check-blockquote (
			latest/open-block 'blockquote
			if debug [print "(blockquote) Open blockquote."]
			
		) baseline (stop?: yes)
	]
	
	;; HTML
	check-html: [
		
		copy html-code [line-start [
			[["<script" | "<pre" | "<style"] [">" | sp | lf] thru [["</script>" | "</pre>" | "</style>"] blank | doc-end]]
		|	["<!--" thru ["-->" blank | doc-end]]
		|	["<?" thru ["?>" blank | doc-end]]
		|	["<!" upper thru [">" blank | doc-end]]
		|	["<![CDATA[" thru ["]]>" blank | doc-end]]
		|	[["<" | "</"]
			["address" | "article" | "aside" | "base" | "basefont" | "blockquote" | "body" | "caption" | 
			"center" | "col" | "colgroup" | "dd" | "details" | "dialog" | "dir" | "div" | "dl" | "dt" |
			"fieldset" | "figcaption" | "figure" | "footer" | "form" | "frame" | "frameset" |
			"h1" | "h2" | "h3" | "h4" | "h5" | "h6" | "head" | "header" | "hr" | "html" | "iframe" |
			"legend" | "li" | "link" | "main" | "menu" | "menuitem" | "nav" | "noframes" | "ol" |
			"optgroup" | "option" | "p" | "param" | "section" | "source" | "summary" | "table" |
			"tbody" | "td" | "tfoot" | "th" | "thead" | "title" | "tr" | "track" | "ul"]
			[ws | ">" | "/>"] thru [newline blank | doc-end]]
		|	[["<" thru ">"] ws thru [newline blank | doc-end]]
		]]
	]
	html: [
		check-html
		(latest/open/only 'html html-code)
	]
	
	;;; Emitters
	emit: func ['word data][
		if block? word [word: do word] ;????
		if string? data [trim/tail data]
		append latest/children [parent: :latest element: word children: data]
	]
	
	;;; SCAN
	scan-doc: func [str [string!]][
		out: latest: new 'doc 
		text: mark: start-num: umark: omark: imark: open-list: none
		s: e: k: l: m: i: j: none
		item-len: 0
		bcount: 0
		item-open?: no
		first-item?: yes
		first-line?: no
		current-level: 0
		space-removed?: no
		bq-level: 0
		
		parse str [some rule (out/close)]
		out
	]
]

html: context [
	
	;;; Words
	template: read %template.tpl
	out: make string! 10000
	toc: make string! 1000
	inside?: no
	notoc: false
	space: charset " ^-"
	sdoc: none

	show-tree: func [elem [object!] /tabs cnt /local ch el x][
		cnt: any [cnt 0]
		el: elem/element
		switch el [
			doc 					[foreach x elem/children [show-tree x]]
			ul ol li blockquote 	[
				emit [to-tag el] foreach x elem/children [show-doc x] emit [head insert to-tag el #"/"]
			]
			li [
				either all [1 = length? elem/children elem/children/1/element = 'para] [
					emit [<li> concat elem/children/1/children </li>]
				][
					emit [<li>] foreach x elem/children [show-doc x] emit [</li>]
				]
			]
			para 
			h1 h2 h3 h4 h5 h6	
			fenced-code 			
			indented-code			
			example 				
			thematic-break			[loop cnt [prin tab] print [elem/element elem/open? mold elem/children/1]]
		]
	]

	
	show-doc: func [elem [object!] /local ch el x][
		el: elem/element
		switch el [
			doc 					[foreach x elem/children [show-doc x]]
			ul blockquote 	[
				emit [to-tag el] 
				foreach x elem/children [show-doc x] 
				emit [head insert to-tag el #"/"]
			]
			ol 	[
				emit [either "1" <> elem/options/start [
					head insert back tail copy <ol start=""> elem/options/start
				][[<ol>]]]
				foreach x elem/children [show-doc x] 
				emit [</ol>]
			]
			li 	[
				case [
					empty? elem/children [emit [<li></li>]]
					all [
						1 = length? elem/children
						elem/children/1/element = 'para
						elem/parent/options/type = 'tight
					][emit [<li> get-para elem/children/1/children </li>]]
					;elem/parent/options/type = 'tight [
					;	append out {<li>}
					;	foreach x elem/children [show-doc x]
					;	emit [</li>]
					;]
					true [
						emit [<li>] 
						foreach x elem/children [show-doc x] 
						emit [</li>]
					]
				]
			]
			para [
				either all [
					elem/parent/element = 'li
					elem/parent/parent/options/type = 'tight
				][;probe "tight para"
					if #"^/" = last out [remove back tail out]
					emit [get-para elem/children]
				][
					emit [<p> get-para elem/children </p>]
				]
			]
			h1 h2 h3 h4 h5 h6 		[emit-heading el concat elem/children]
			fenced-code 			[emit-fcode elem/children elem/options]
			;fenced-code 			[emit-code repend copy "" elem/children]
			indented-code			[emit-icode elem/children]
			example 				[emit-example elem/children]
			thematic-break			[emit [<hr />]]
			html					[emit-html elem/children/1]
		]
	]
	
	;;; Generate HTML
	gen-html: func [doc [object!] /no-template /no-toc][
		sdoc: :doc
		if no-toc [notoc: true]
		clear out
		count: 0
		
		show-doc doc
		if all [not no-template template] [
			; Template varwords all begin with $
			tmp: copy template ; in case it gets reused
			replace/all tmp "$title" title
			replace/all tmp "$date" now/date
			replace tmp "$toc" toc
			replace tmp "$content" out
			out: tmp
		]
		;show-tree sdoc
		out	
	]

	concat: func [data][trim/head/tail repend copy "" data]
	
	;;; Helper-funcs
	to-ref-text: func [text][
		replace/all lowercase copy text [" (" | ") " | #")" | #" "] #"-"
	]
	to-ref-link: func [text [string!]][
		reduce [
			head insert find/tail copy <a href="#"> {="#} to-ref-text text
			text
			</a>
		]
	]
	
	;;; Emitters
	emit-heading: func [level text][
		tag: to-tag level 
		end-tag: head insert copy tag #"/"
		unless notoc [tag: append copy tag reduce [{ id="} to-ref-text text {"}]]
		emit [tag escape-html/end-slash text end-tag] 
		unless notoc [
			append toc switch level [
				h1 [
					either empty? toc [
						append copy [#"^/" <ul><li>] to-ref-link text
					][
						append copy [</li></ul> #"^/" <ul>] to-ref-link text
					]
				]
				h2 [head insert next next copy [#"^/" <li></li>] to-ref-link text]
			]
		]
	]
	emit: func [data][insert insert tail out reduce data newline]
	get-para: func [data][
		escape-html replace/all concat data [newline some space] newline
	]
	emit-icode: func [lines][
		emit [
			<pre><code> 
			escape-html/only replace repend copy "" lines [any newline end] lf 
			</code></pre>
		]
	]
	emit-fcode: func [lines options /local info][
		emit [
			<pre> either info: options/info [repend copy <code class=> [{"language-} info {"}]][<code>]
			either "^/" = tx: escape-html/only replace repend copy "" lines [any newline end] lf [][tx]
			</code></pre>
		]
	]
	emit-code: func [text /class cls /local code-tag][
		code-tag: copy <code>
		if class [append code-tag rejoin [{ class="} cls {"}]]
		emit [<pre> code-tag text either newline = last text [][newline] </code></pre>]
	]
	emit-html: func [text /local pre? s][
		if newline = last text [remove back tail text]
		parse text [
			"</pre>" (pre?: no)
		|	"<pre" [sp | ">"] (pre?: yes)
		|	[s: lf any [tab | sp] e: lf] if (not pre?) (remove/part s e)
		]
		emit text
	]

	escape-html: func [text /only /end-slash][
		; Convert to avoid special HTML chars:
		;foreach [from to] html-codes [replace/all text from to]
		parse text [some [s: 
			change #"&" "&amp;"
		|	change #"<" "&lt;"
		| 	change #">" "&gt;"
		|	change {"} "&quot;"
		|	if (not only) [
				some #"`" e: (
					len1: (index? e) - (index? s)
					either inside? [
						if  len1 >= len [
							while [find [#" " #"^/"] first back s][s: back s]
							e: change/part s {</code>} e
							inside?: no 
						]
					][
						while [find [#" " #"^/"] first e][e: next e]
						e: change/part s {<code>} e 
						len: len1 
						inside?: yes
					]
				) :e
				| [#"[" copy link-text to #"]" skip (anc: "") opt [#"(" copy anc to #")" skip]] e: (
					e: change/part s rejoin [{<a href="} anc {">} link-text {</a>}] e
				) :e
				| [if (end-slash) [#"\" end] | change [#"\" [newline | end] | some sp newline] ({<br />^/}) | remove #"\"]
			]
		|	skip
		]]
		text
	]

	;;; EXAMPLES
	example-num: 0
	count: 0
	emit-example: func [example /local code][
		example-num: example-num + 1
		emit rejoin [{<div class="example" id="example-} example-num {">}]
		emit <div class="examplenum">
		emit rejoin [{<a href="#example-} example-num {">Example } example-num {</a>}]
		emit </div>
		emit <div class="column">
		emit-code/class format-space copy probe example/1 "language-markdown"
		emit </div>
		emit <div class="column">
		emit-code/class c1: escape-html/only probe example/2 "language-html"
		emit </div>
		code: escape-html/only html2/gen-html/no-template/no-toc scanner2/scan-doc example/1
		;unless newline = last code [append code newline]
		if newline = last code [remove back tail code]
		class: either c1 = code ["column correct"]["column wrong"]
		emit head insert back tail copy <div class=""> class
		count: count + 1 
		;if count <= 10 [probe c1 probe code print "----------------------"]
		emit-code/class code "language-html"
		emit {</div>^/</div>}
	]
	format-space: func [text][
		replace/all text #" " {<span class="space"> </span>}
	]
	;;; <<< EXAMPLES
	
]
scanner2: make scanner []
html2: make object! load mold body-of html
text-file: either file? file: system/script/args [
	system/script/args: none
	file: append %spec/ file
	either "red" = find/last/tail file dot [
		do file
	][ 
		read file
	]
][
	read %spec-tmp.txt;https://github.github.com/gfm/spec.txt ;https://spec.commonmark.org/0.28/spec.txt
]
doc: html/gen-html scanner/scan-doc text-file
write %out.html doc
browse %out.html