Red []
out: {# Inlines

Inlines are parsed sequentially from the beginning of the character
stream to the end (left to right, in left-to-right languages).
Thus, for example, in

```````````````````````````````` example
`hi`lo`
.
<p><code>hi</code>lo`</p>
````````````````````````````````


`hi` is parsed as code, leaving the backtick at the end as a literal
backtick.

}
foreach file [
	%backslash.md
	%entity.md
	%codespan.md
	%emph.md
	%strike.md
	%link.md
	%image.md
	%autolink.md
	%autolink2.md
	%rawhtml.md
	%rawhtml2.md
	%hardbreak.md
	%softbreak.md
	%plaintext.md
][append out read file]