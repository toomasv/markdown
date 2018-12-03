## HTML blocks

An [HTML block](@) is a group of lines that is treated
as raw HTML (and will not be escaped in HTML output).

There are seven kinds of [HTML block], which can be defined
by their start and end conditions.  The block begins with a line that
meets a [start condition](@) (after up to three spaces
optional indentation).  It ends with the first subsequent line that
meets a matching [end condition](@), or the last line of
the document or other [container block]), if no line is encountered that meets the
[end condition].  If the first line meets both the [start condition]
and the [end condition], the block will contain just that line.

1.  **Start condition:**  line begins with the string `<script`,
`<pre`, or `<style` (case-insensitive), followed by whitespace,
the string `>`, or the end of the line.\
**End condition:**  line contains an end tag
`</script>`, `</pre>`, or `</style>` (case-insensitive; it
need not match the start tag).

2.  **Start condition:** line begins with the string `<!--`.\
**End condition:**  line contains the string `-->`.

3.  **Start condition:** line begins with the string `<?`.\
**End condition:** line contains the string `?>`.

4.  **Start condition:** line begins with the string `<!`
followed by an uppercase ASCII letter.\
**End condition:** line contains the character `>`.

5.  **Start condition:**  line begins with the string
`<![CDATA[`.\
**End condition:** line contains the string `]]>`.

6.  **Start condition:** line begins the string `<` or `</`
followed by one of the strings (case-insensitive) `address`,
`article`, `aside`, `base`, `basefont`, `blockquote`, `body`,
`caption`, `center`, `col`, `colgroup`, `dd`, `details`, `dialog`,
`dir`, `div`, `dl`, `dt`, `fieldset`, `figcaption`, `figure`,
`footer`, `form`, `frame`, `frameset`,
`h1`, `h2`, `h3`, `h4`, `h5`, `h6`, `head`, `header`, `hr`,
`html`, `iframe`, `legend`, `li`, `link`, `main`, `menu`, `menuitem`,
`nav`, `noframes`, `ol`, `optgroup`, `option`, `p`, `param`,
`section`, `source`, `summary`, `table`, `tbody`, `td`,
`tfoot`, `th`, `thead`, `title`, `tr`, `track`, `ul`, followed
by [whitespace], the end of the line, the string `>`, or
the string `/>`.\
**End condition:** line is followed by a [blank line].

7.  **Start condition:**  line begins with a complete [open tag]
or [closing tag] (with any [tag name] other than `script`,
`style`, or `pre`) followed only by [whitespace]
or the end of the line.\
**End condition:** line is followed by a [blank line].

HTML blocks continue until they are closed by their appropriate
[end condition], or the last line of the document or other [container block].
This means any HTML **within an HTML block** that might otherwise be recognised
as a start condition will be ignored by the parser and passed through as-is,
without changing the parser's state.

For instance, `<pre>` within a HTML block started by `<table>` will not affect
the parser state; as the HTML block was started in by start condition 6, it
will end at any blank line. This can be surprising:

```````````````````````````````` example
<table><tr><td>
<pre>
**Hello**,

_world_.
</pre>
</td></tr></table>
.
<table><tr><td>
<pre>
**Hello**,
<p><em>world</em>.
</pre></p>
</td></tr></table>
````````````````````````````````

In this case, the HTML block is terminated by the newline — the `**Hello**`
text remains verbatim — and regular parsing resumes, with a paragraph,
emphasised `world` and inline and block HTML following.

All types of [HTML blocks] except type 7 may interrupt
a paragraph.  Blocks of type 7 may not interrupt a paragraph.
(This restriction is intended to prevent unwanted interpretation
of long tags inside a wrapped paragraph as starting HTML blocks.)

Some simple examples follow.  Here are some basic HTML blocks
of type 6:

```````````````````````````````` example
<table>
  <tr>
    <td>
           hi
    </td>
  </tr>
</table>

okay.
.
<table>
  <tr>
    <td>
           hi
    </td>
  </tr>
</table>
<p>okay.</p>
````````````````````````````````


```````````````````````````````` example
 <div>
  *hello*
         <foo><a>
.
 <div>
  *hello*
         <foo><a>
````````````````````````````````


A block can also start with a closing tag:

```````````````````````````````` example
</div>
*foo*
.
</div>
*foo*
````````````````````````````````


Here we have two HTML blocks with a Markdown paragraph between them:

```````````````````````````````` example
<DIV CLASS="foo">

*Markdown*

</DIV>
.
<DIV CLASS="foo">
<p><em>Markdown</em></p>
</DIV>
````````````````````````````````


The tag on the first line can be partial, as long
as it is split where there would be whitespace:

```````````````````````````````` example
<div id="foo"
  class="bar">
</div>
.
<div id="foo"
  class="bar">
</div>
````````````````````````````````


```````````````````````````````` example
<div id="foo" class="bar
  baz">
</div>
.
<div id="foo" class="bar
  baz">
</div>
````````````````````````````````


An open tag need not be closed:
```````````````````````````````` example
<div>
*foo*

*bar*
.
<div>
*foo*
<p><em>bar</em></p>
````````````````````````````````



A partial tag need not even be completed (garbage
in, garbage out):

```````````````````````````````` example
<div id="foo"
*hi*
.
<div id="foo"
*hi*
````````````````````````````````


```````````````````````````````` example
<div class
foo
.
<div class
foo
````````````````````````````````


The initial tag doesn't even need to be a valid
tag, as long as it starts like one:

```````````````````````````````` example
<div *???-&&&-<---
*foo*
.
<div *???-&&&-<---
*foo*
````````````````````````````````


In type 6 blocks, the initial tag need not be on a line by
itself:

```````````````````````````````` example
<div><a href="bar">*foo*</a></div>
.
<div><a href="bar">*foo*</a></div>
````````````````````````````````


```````````````````````````````` example
<table><tr><td>
foo
</td></tr></table>
.
<table><tr><td>
foo
</td></tr></table>
````````````````````````````````


Everything until the next blank line or end of document
gets included in the HTML block.  So, in the following
example, what looks like a Markdown code block
is actually part of the HTML block, which continues until a blank
line or the end of the document is reached:

```````````````````````````````` example
<div></div>
``` c
int x = 33;
```
.
<div></div>
``` c
int x = 33;
```
````````````````````````````````


To start an [HTML block] with a tag that is *not* in the
list of block-level tags in (6), you must put the tag by
itself on the first line (and it must be complete):

```````````````````````````````` example
<a href="foo">
*bar*
</a>
.
<a href="foo">
*bar*
</a>
````````````````````````````````


In type 7 blocks, the [tag name] can be anything:

```````````````````````````````` example
<Warning>
*bar*
</Warning>
.
<Warning>
*bar*
</Warning>
````````````````````````````````


```````````````````````````````` example
<i class="foo">
*bar*
</i>
.
<i class="foo">
*bar*
</i>
````````````````````````````````


```````````````````````````````` example
</ins>
*bar*
.
</ins>
*bar*
````````````````````````````````


These rules are designed to allow us to work with tags that
can function as either block-level or inline-level tags.
The `<del>` tag is a nice example.  We can surround content with
`<del>` tags in three different ways.  In this case, we get a raw
HTML block, because the `<del>` tag is on a line by itself:

```````````````````````````````` example
<del>
*foo*
</del>
.
<del>
*foo*
</del>
````````````````````````````````


In this case, we get a raw HTML block that just includes
the `<del>` tag (because it ends with the following blank
line).  So the contents get interpreted as CommonMark:

```````````````````````````````` example
<del>

*foo*

</del>
.
<del>
<p><em>foo</em></p>
</del>
````````````````````````````````


Finally, in this case, the `<del>` tags are interpreted
as [raw HTML] *inside* the CommonMark paragraph.  (Because
the tag is not on a line by itself, we get inline HTML
rather than an [HTML block].)

```````````````````````````````` example
<del>*foo*</del>
.
<p><del><em>foo</em></del></p>
````````````````````````````````


HTML tags designed to contain literal content
(`script`, `style`, `pre`), comments, processing instructions,
and declarations are treated somewhat differently.
Instead of ending at the first blank line, these blocks
end at the first line containing a corresponding end tag.
As a result, these blocks can contain blank lines:

A pre tag (type 1):

```````````````````````````````` example
<pre language="haskell"><code>
import Text.HTML.TagSoup

main :: IO ()
main = print $ parseTags tags
</code></pre>
okay
.
<pre language="haskell"><code>
import Text.HTML.TagSoup

main :: IO ()
main = print $ parseTags tags
</code></pre>
<p>okay</p>
````````````````````````````````


A script tag (type 1):

```````````````````````````````` example
<script type="text/javascript">
// JavaScript example

document.getElementById("demo").innerHTML = "Hello JavaScript!";
</script>
okay
.
<script type="text/javascript">
// JavaScript example

document.getElementById("demo").innerHTML = "Hello JavaScript!";
</script>
<p>okay</p>
````````````````````````````````


A style tag (type 1):

```````````````````````````````` example
<style
  type="text/css">
h1 {color:red;}

p {color:blue;}
</style>
okay
.
<style
  type="text/css">
h1 {color:red;}

p {color:blue;}
</style>
<p>okay</p>
````````````````````````````````


If there is no matching end tag, the block will end at the
end of the document (or the enclosing [block quote][block quotes]
or [list item][list items]):

```````````````````````````````` example
<style
  type="text/css">

foo
.
<style
  type="text/css">

foo
````````````````````````````````


```````````````````````````````` example
> <div>
> foo

bar
.
<blockquote>
<div>
foo
</blockquote>
<p>bar</p>
````````````````````````````````


```````````````````````````````` example
- <div>
- foo
.
<ul>
<li>
<div>
</li>
<li>foo</li>
</ul>
````````````````````````````````


The end tag can occur on the same line as the start tag:

```````````````````````````````` example
<style>p{color:red;}</style>
*foo*
.
<style>p{color:red;}</style>
<p><em>foo</em></p>
````````````````````````````````


```````````````````````````````` example
<!-- foo -->*bar*
*baz*
.
<!-- foo -->*bar*
<p><em>baz</em></p>
````````````````````````````````


Note that anything on the last line after the
end tag will be included in the [HTML block]:

```````````````````````````````` example
<script>
foo
</script>1. *bar*
.
<script>
foo
</script>1. *bar*
````````````````````````````````


A comment (type 2):

```````````````````````````````` example
<!-- Foo

bar
   baz -->
okay
.
<!-- Foo

bar
   baz -->
<p>okay</p>
````````````````````````````````



A processing instruction (type 3):

```````````````````````````````` example
<?php

  echo '>';

?>
okay
.
<?php

  echo '>';

?>
<p>okay</p>
````````````````````````````````


A declaration (type 4):

```````````````````````````````` example
<!DOCTYPE html>
.
<!DOCTYPE html>
````````````````````````````````


CDATA (type 5):

```````````````````````````````` example
<![CDATA[
function matchwo(a,b)
{
  if (a < b && a < 0) then {
    return 1;

  } else {

    return 0;
  }
}
]]>
okay
.
<![CDATA[
function matchwo(a,b)
{
  if (a < b && a < 0) then {
    return 1;

  } else {

    return 0;
  }
}
]]>
<p>okay</p>
````````````````````````````````


The opening tag can be indented 1-3 spaces, but not 4:

```````````````````````````````` example
  <!-- foo -->

    <!-- foo -->
.
  <!-- foo -->
<pre><code>&lt;!-- foo --&gt;
</code></pre>
````````````````````````````````


```````````````````````````````` example
  <div>

    <div>
.
  <div>
<pre><code>&lt;div&gt;
</code></pre>
````````````````````````````````


An HTML block of types 1--6 can interrupt a paragraph, and need not be
preceded by a blank line.

```````````````````````````````` example
Foo
<div>
bar
</div>
.
<p>Foo</p>
<div>
bar
</div>
````````````````````````````````


However, a following blank line is needed, except at the end of
a document, and except for blocks of types 1--5, [above][HTML
block]:

```````````````````````````````` example
<div>
bar
</div>
*foo*
.
<div>
bar
</div>
*foo*
````````````````````````````````


HTML blocks of type 7 cannot interrupt a paragraph:

```````````````````````````````` example
Foo
<a href="bar">
baz
.
<p>Foo
<a href="bar">
baz</p>
````````````````````````````````


This rule differs from John Gruber's original Markdown syntax
specification, which says:

> The only restrictions are that block-level HTML elements —
> e.g. `<div>`, `<table>`, `<pre>`, `<p>`, etc. — must be separated from
> surrounding content by blank lines, and the start and end tags of the
> block should not be indented with tabs or spaces.

In some ways Gruber's rule is more restrictive than the one given
here:

- It requires that an HTML block be preceded by a blank line.
- It does not allow the start tag to be indented.
- It requires a matching end tag, which it also does not allow to
  be indented.

Most Markdown implementations (including some of Gruber's own) do not
respect all of these restrictions.

There is one respect, however, in which Gruber's rule is more liberal
than the one given here, since it allows blank lines to occur inside
an HTML block.  There are two reasons for disallowing them here.
First, it removes the need to parse balanced tags, which is
expensive and can require backtracking from the end of the document
if no matching end tag is found. Second, it provides a very simple
and flexible way of including Markdown content inside HTML tags:
simply separate the Markdown from the HTML using blank lines:

Compare:

```````````````````````````````` example
<div>

*Emphasized* text.

</div>
.
<div>
<p><em>Emphasized</em> text.</p>
</div>
````````````````````````````````


```````````````````````````````` example
<div>
*Emphasized* text.
</div>
.
<div>
*Emphasized* text.
</div>
````````````````````````````````


Some Markdown implementations have adopted a convention of
interpreting content inside tags as text if the open tag has
the attribute `markdown=1`.  The rule given above seems a simpler and
more elegant way of achieving the same expressive power, which is also
much simpler to parse.

The main potential drawback is that one can no longer paste HTML
blocks into Markdown documents with 100% reliability.  However,
*in most cases* this will work fine, because the blank lines in
HTML are usually followed by HTML block tags.  For example:

```````````````````````````````` example
<table>

<tr>

<td>
Hi
</td>

</tr>

</table>
.
<table>
<tr>
<td>
Hi
</td>
</tr>
</table>
````````````````````````````````


There are problems, however, if the inner tags are indented
*and* separated by spaces, as then they will be interpreted as
an indented code block:

```````````````````````````````` example
<table>

  <tr>

    <td>
      Hi
    </td>

  </tr>

</table>
.
<table>
  <tr>
<pre><code>&lt;td&gt;
  Hi
&lt;/td&gt;
</code></pre>
  </tr>
</table>
````````````````````````````````


Fortunately, blank lines are usually not necessary and can be
deleted.  The exception is inside `<pre>` tags, but as described
[above][HTML blocks], raw HTML blocks starting with `<pre>`
*can* contain blank lines.
