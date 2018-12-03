## Hard line breaks

A line break (not in a code span or HTML tag) that is preceded
by two or more spaces and does not occur at the end of a block
is parsed as a [hard line break](@) (rendered
in HTML as a `<br />` tag):

```````````````````````````````` example
foo  
baz
.
<p>foo<br />
baz</p>
````````````````````````````````


For a more visible alternative, a backslash before the
[line ending] may be used instead of two spaces:

```````````````````````````````` example
foo\
baz
.
<p>foo<br />
baz</p>
````````````````````````````````


More than two spaces can be used:

```````````````````````````````` example
foo       
baz
.
<p>foo<br />
baz</p>
````````````````````````````````


Leading spaces at the beginning of the next line are ignored:

```````````````````````````````` example
foo  
     bar
.
<p>foo<br />
bar</p>
````````````````````````````````


```````````````````````````````` example
foo\
     bar
.
<p>foo<br />
bar</p>
````````````````````````````````


Line breaks can occur inside emphasis, links, and other constructs
that allow inline content:

```````````````````````````````` example
*foo  
bar*
.
<p><em>foo<br />
bar</em></p>
````````````````````````````````


```````````````````````````````` example
*foo\
bar*
.
<p><em>foo<br />
bar</em></p>
````````````````````````````````


Line breaks do not occur inside code spans

```````````````````````````````` example
`code  
span`
.
<p><code>code span</code></p>
````````````````````````````````


```````````````````````````````` example
`code\
span`
.
<p><code>code\ span</code></p>
````````````````````````````````


or HTML tags:

```````````````````````````````` example
<a href="foo  
bar">
.
<p><a href="foo  
bar"></p>
````````````````````````````````


```````````````````````````````` example
<a href="foo\
bar">
.
<p><a href="foo\
bar"></p>
````````````````````````````````


Hard line breaks are for separating inline content within a block.
Neither syntax for hard line breaks works at the end of a paragraph or
other block element:

```````````````````````````````` example
foo\
.
<p>foo\</p>
````````````````````````````````


```````````````````````````````` example
foo  
.
<p>foo</p>
````````````````````````````````


```````````````````````````````` example
### foo\
.
<h3>foo\</h3>
````````````````````````````````


```````````````````````````````` example
### foo  
.
<h3>foo</h3>
````````````````````````````````

