## Thematic breaks

A line consisting of 0-3 spaces of indentation, followed by a sequence
of three or more matching `-`, `_`, or `*` characters, each followed
optionally by any number of spaces or tabs, forms a
[thematic break](@).

```````````````````````````````` example
***
---
___
.
<hr />
<hr />
<hr />
````````````````````````````````


Wrong characters:

```````````````````````````````` example
+++
.
<p>+++</p>
````````````````````````````````


```````````````````````````````` example
===
.
<p>===</p>
````````````````````````````````


Not enough characters:

```````````````````````````````` example
--
**
__
.
<p>--
**
__</p>
````````````````````````````````


One to three spaces indent are allowed:

```````````````````````````````` example
 ***
  ***
   ***
.
<hr />
<hr />
<hr />
````````````````````````````````


Four spaces is too many:

```````````````````````````````` example
    ***
.
<pre><code>***
</code></pre>
````````````````````````````````


```````````````````````````````` example
Foo
    ***
.
<p>Foo
***</p>
````````````````````````````````


More than three characters may be used:

```````````````````````````````` example
_____________________________________
.
<hr />
````````````````````````````````


Spaces are allowed between the characters:

```````````````````````````````` example
 - - -
.
<hr />
````````````````````````````````


```````````````````````````````` example
 **  * ** * ** * **
.
<hr />
````````````````````````````````


```````````````````````````````` example
-     -      -      -
.
<hr />
````````````````````````````````


Spaces are allowed at the end:

```````````````````````````````` example
- - - -    
.
<hr />
````````````````````````````````


However, no other characters may occur in the line:

```````````````````````````````` example
_ _ _ _ a

a------

---a---
.
<p>_ _ _ _ a</p>
<p>a------</p>
<p>---a---</p>
````````````````````````````````


It is required that all of the [non-whitespace characters] be the same.
So, this is not a thematic break:

```````````````````````````````` example
 *-*
.
<p><em>-</em></p>
````````````````````````````````


Thematic breaks do not need blank lines before or after:

```````````````````````````````` example
- foo
***
- bar
.
<ul>
<li>foo</li>
</ul>
<hr />
<ul>
<li>bar</li>
</ul>
````````````````````````````````


Thematic breaks can interrupt a paragraph:

```````````````````````````````` example
Foo
***
bar
.
<p>Foo</p>
<hr />
<p>bar</p>
````````````````````````````````


If a line of dashes that meets the above conditions for being a
thematic break could also be interpreted as the underline of a [setext
heading], the interpretation as a
[setext heading] takes precedence. Thus, for example,
this is a setext heading, not a paragraph followed by a thematic break:

```````````````````````````````` example
Foo
---
bar
.
<h2>Foo</h2>
<p>bar</p>
````````````````````````````````


When both a thematic break and a list item are possible
interpretations of a line, the thematic break takes precedence:

```````````````````````````````` example
* Foo
* * *
* Bar
.
<ul>
<li>Foo</li>
</ul>
<hr />
<ul>
<li>Bar</li>
</ul>
````````````````````````````````


If you want a thematic break in a list item, use a different bullet:

```````````````````````````````` example
- Foo
- * * *
.
<ul>
<li>Foo</li>
<li>
<hr />
</li>
</ul>
````````````````````````````````

