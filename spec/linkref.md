## Link reference definitions

A [link reference definition](@)
consists of a [link label], indented up to three spaces, followed
by a colon (`:`), optional [whitespace] (including up to one
[line ending]), a [link destination],
optional [whitespace] (including up to one
[line ending]), and an optional [link
title], which if it is present must be separated
from the [link destination] by [whitespace].
No further [non-whitespace characters] may occur on the line.

A [link reference definition]
does not correspond to a structural element of a document.  Instead, it
defines a label which can be used in [reference links]
and reference-style [images] elsewhere in the document.  [Link
reference definitions] can come either before or after the links that use
them.

```````````````````````````````` example
[foo]: /url "title"

[foo]
.
<p><a href="/url" title="title">foo</a></p>
````````````````````````````````


```````````````````````````````` example
   [foo]: 
      /url  
           'the title'  

[foo]
.
<p><a href="/url" title="the title">foo</a></p>
````````````````````````````````


```````````````````````````````` example
[Foo*bar\]]:my_(url) 'title (with parens)'

[Foo*bar\]]
.
<p><a href="my_(url)" title="title (with parens)">Foo*bar]</a></p>
````````````````````````````````


```````````````````````````````` example
[Foo bar]:
<my url>
'title'

[Foo bar]
.
<p><a href="my%20url" title="title">Foo bar</a></p>
````````````````````````````````


The title may extend over multiple lines:

```````````````````````````````` example
[foo]: /url '
title
line1
line2
'

[foo]
.
<p><a href="/url" title="
title
line1
line2
">foo</a></p>
````````````````````````````````


However, it may not contain a [blank line]:

```````````````````````````````` example
[foo]: /url 'title

with blank line'

[foo]
.
<p>[foo]: /url 'title</p>
<p>with blank line'</p>
<p>[foo]</p>
````````````````````````````````


The title may be omitted:

```````````````````````````````` example
[foo]:
/url

[foo]
.
<p><a href="/url">foo</a></p>
````````````````````````````````


The link destination may not be omitted:

```````````````````````````````` example
[foo]:

[foo]
.
<p>[foo]:</p>
<p>[foo]</p>
````````````````````````````````


Both title and destination can contain backslash escapes
and literal backslashes:

```````````````````````````````` example
[foo]: /url\bar\*baz "foo\"bar\baz"

[foo]
.
<p><a href="/url%5Cbar*baz" title="foo&quot;bar\baz">foo</a></p>
````````````````````````````````


A link can come before its corresponding definition:

```````````````````````````````` example
[foo]

[foo]: url
.
<p><a href="url">foo</a></p>
````````````````````````````````


If there are several matching definitions, the first one takes
precedence:

```````````````````````````````` example
[foo]

[foo]: first
[foo]: second
.
<p><a href="first">foo</a></p>
````````````````````````````````


As noted in the section on [Links], matching of labels is
case-insensitive (see [matches]).

```````````````````````````````` example
[FOO]: /url

[Foo]
.
<p><a href="/url">Foo</a></p>
````````````````````````````````


```````````````````````````````` example
[ΑΓΩ]: /φου

[αγω]
.
<p><a href="/%CF%86%CE%BF%CF%85">αγω</a></p>
````````````````````````````````


Here is a link reference definition with no corresponding link.
It contributes nothing to the document.

```````````````````````````````` example
[foo]: /url
.
````````````````````````````````


Here is another one:

```````````````````````````````` example
[
foo
]: /url
bar
.
<p>bar</p>
````````````````````````````````


This is not a link reference definition, because there are
[non-whitespace characters] after the title:

```````````````````````````````` example
[foo]: /url "title" ok
.
<p>[foo]: /url &quot;title&quot; ok</p>
````````````````````````````````


This is a link reference definition, but it has no title:

```````````````````````````````` example
[foo]: /url
"title" ok
.
<p>&quot;title&quot; ok</p>
````````````````````````````````


This is not a link reference definition, because it is indented
four spaces:

```````````````````````````````` example
    [foo]: /url "title"

[foo]
.
<pre><code>[foo]: /url &quot;title&quot;
</code></pre>
<p>[foo]</p>
````````````````````````````````


This is not a link reference definition, because it occurs inside
a code block:

```````````````````````````````` example
```
[foo]: /url
```

[foo]
.
<pre><code>[foo]: /url
</code></pre>
<p>[foo]</p>
````````````````````````````````


A [link reference definition] cannot interrupt a paragraph.

```````````````````````````````` example
Foo
[bar]: /baz

[bar]
.
<p>Foo
[bar]: /baz</p>
<p>[bar]</p>
````````````````````````````````


However, it can directly follow other block elements, such as headings
and thematic breaks, and it need not be followed by a blank line.

```````````````````````````````` example
# [Foo]
[foo]: /url
> bar
.
<h1><a href="/url">Foo</a></h1>
<blockquote>
<p>bar</p>
</blockquote>
````````````````````````````````


Several [link reference definitions]
can occur one after another, without intervening blank lines.

```````````````````````````````` example
[foo]: /foo-url "foo"
[bar]: /bar-url
  "bar"
[baz]: /baz-url

[foo],
[bar],
[baz]
.
<p><a href="/foo-url" title="foo">foo</a>,
<a href="/bar-url" title="bar">bar</a>,
<a href="/baz-url">baz</a></p>
````````````````````````````````


[Link reference definitions] can occur
inside block containers, like lists and block quotations.  They
affect the entire document, not just the container in which they
are defined:

```````````````````````````````` example
[foo]

> [foo]: /url
.
<p><a href="/url">foo</a></p>
<blockquote>
</blockquote>
````````````````````````````````

