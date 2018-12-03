Red []
out: {# Leaf blocks

This section describes the different kinds of leaf block that make up a
Markdown document.

}
foreach file [
	%break.md
	%atx.md
	%setext.md
	%icode.md
	%fcode.md
	%html.md
	%linkref.md
	%para.md
	%blank.md
	%table.md
][append out read file]