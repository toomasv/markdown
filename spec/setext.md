## Setext headings

A [setext heading](@) consists of one or more
lines of text, each containing at least one [non-whitespace
character], with no more than 3 spaces indentation, followed by
a [setext heading underline].  The lines of text must be such
that, were they not followed by the setext heading underline,
they would be interpreted as a paragraph:  they cannot be
interpretable as a [code fence], [ATX heading][ATX headings],
[block quote][block quotes], [thematic break][thematic breaks],
[list item][list items], or [HTML block][HTML blocks].

A [setext heading underline](@) is a sequence of
`=` characters or a sequence of `-` characters, with no more than 3
spaces indentation and any number of trailing spaces.  If a line
containing a single `-` can be interpreted as an
empty [list items], it should be interpreted this way
and not as a [setext heading underline].

The heading is a level 1 heading if `=` characters are used in
the [setext heading underline], and a level 2 heading if `-`
characters are used.  The contents of the heading are the result
of parsing the preceding lines of text as CommonMark inline
content.

In general, a setext heading need not be preceded or followed by a
blank line.  However, it cannot interrupt a paragraph, so when a
setext heading comes after a paragraph, a blank line is needed between
them.

Simple examples:

```````````````````````````````` example
Foo *bar*
=========

Foo *bar*
---------
.
<h1>Foo <em>bar</em></h1>
<h2>Foo <em>bar</em></h2>
````````````````````````````````


The content of the header may span more than one line:

```````````````````````````````` example
Foo *bar
baz*
====
.
<h1>Foo <em>bar
baz</em></h1>
````````````````````````````````


The underlining can be any length:

```````````````````````````````` example
Foo
-------------------------

Foo
=
.
<h2>Foo</h2>
<h1>Foo</h1>
````````````````````````````````


The heading content can be indented up to three spaces, and need
not line up with the underlining:

```````````````````````````````` example
   Foo
---

  Foo
-----

  Foo
  ===
.
<h2>Foo</h2>
<h2>Foo</h2>
<h1>Foo</h1>
````````````````````````````````


Four spaces indent is too much:

```````````````````````````````` example
    Foo
    ---

    Foo
---
.
<pre><code>Foo
---

Foo
</code></pre>
<hr />
````````````````````````````````


The setext heading underline can be indented up to three spaces, and
may have trailing spaces:

```````````````````````````````` example
Foo
   ----      
.
<h2>Foo</h2>
````````````````````````````````


Four spaces is too much:

```````````````````````````````` example
Foo
    ---
.
<p>Foo
---</p>
````````````````````````````````


The setext heading underline cannot contain internal spaces:

```````````````````````````````` example
Foo
= =

Foo
--- -
.
<p>Foo
= =</p>
<p>Foo</p>
<hr />
````````````````````````````````


Trailing spaces in the content line do not cause a line break:

```````````````````````````````` example
Foo  
-----
.
<h2>Foo</h2>
````````````````````````````````


Nor does a backslash at the end:

```````````````````````````````` example
Foo\
----
.
<h2>Foo\</h2>
````````````````````````````````


Since indicators of block structure take precedence over
indicators of inline structure, the following are setext headings:

```````````````````````````````` example
`Foo
----
`

<a title="a lot
---
of dashes"/>
.
<h2>`Foo</h2>
<p>`</p>
<h2>&lt;a title=&quot;a lot</h2>
<p>of dashes&quot;/&gt;</p>
````````````````````````````````


The setext heading underline cannot be a [lazy continuation
line] in a list item or block quote:

```````````````````````````````` example
> Foo
---
.
<blockquote>
<p>Foo</p>
</blockquote>
<hr />
````````````````````````````````


```````````````````````````````` example
> foo
bar
===
.
<blockquote>
<p>foo
bar
===</p>
</blockquote>
````````````````````````````````


```````````````````````````````` example
- Foo
---
.
<ul>
<li>Foo</li>
</ul>
<hr />
````````````````````````````````


A blank line is needed between a paragraph and a following
setext heading, since otherwise the paragraph becomes part
of the heading's content:

```````````````````````````````` example
Foo
Bar
---
.
<h2>Foo
Bar</h2>
````````````````````````````````


But in general a blank line is not required before or after
setext headings:

```````````````````````````````` example
---
Foo
---
Bar
---
Baz
.
<hr />
<h2>Foo</h2>
<h2>Bar</h2>
<p>Baz</p>
````````````````````````````````


Setext headings cannot be empty:

```````````````````````````````` example

====
.
<p>====</p>
````````````````````````````````


Setext heading text lines must not be interpretable as block
constructs other than paragraphs.  So, the line of dashes
in these examples gets interpreted as a thematic break:

```````````````````````````````` example
---
---
.
<hr />
<hr />
````````````````````````````````


```````````````````````````````` example
- foo
-----
.
<ul>
<li>foo</li>
</ul>
<hr />
````````````````````````````````


```````````````````````````````` example
    foo
---
.
<pre><code>foo
</code></pre>
<hr />
````````````````````````````````


```````````````````````````````` example
> foo
-----
.
<blockquote>
<p>foo</p>
</blockquote>
<hr />
````````````````````````````````


If you want a heading with `> foo` as its literal text, you can
use backslash escapes:

```````````````````````````````` example
\> foo
------
.
<h2>&gt; foo</h2>
````````````````````````````````


**Compatibility note:**  Most existing Markdown implementations
do not allow the text of setext headings to span multiple lines.
But there is no consensus about how to interpret

``` markdown
Foo
bar
---
baz
```

One can find four different interpretations:

1. paragraph "Foo", heading "bar", paragraph "baz"
2. paragraph "Foo bar", thematic break, paragraph "baz"
3. paragraph "Foo bar --- baz"
4. heading "Foo bar", paragraph "baz"

We find interpretation 4 most natural, and interpretation 4
increases the expressive power of CommonMark, by allowing
multiline headings.  Authors who want interpretation 1 can
put a blank line after the first paragraph:

```````````````````````````````` example
Foo

bar
---
baz
.
<p>Foo</p>
<h2>bar</h2>
<p>baz</p>
````````````````````````````````


Authors who want interpretation 2 can put blank lines around
the thematic break,

```````````````````````````````` example
Foo
bar

---

baz
.
<p>Foo
bar</p>
<hr />
<p>baz</p>
````````````````````````````````


or use a thematic break that cannot count as a [setext heading
underline], such as

```````````````````````````````` example
Foo
bar
* * *
baz
.
<p>Foo
bar</p>
<hr />
<p>baz</p>
````````````````````````````````


Authors who want interpretation 3 can use backslash escapes:

```````````````````````````````` example
Foo
bar
\---
baz
.
<p>Foo
bar
---
baz</p>
````````````````````````````````

