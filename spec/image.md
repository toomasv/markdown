## Images

Syntax for images is like the syntax for links, with one
difference. Instead of [link text], we have an
[image description](@).  The rules for this are the
same as for [link text], except that (a) an
image description starts with `![` rather than `[`, and
(b) an image description may contain links.
An image description has inline elements
as its contents.  When an image is rendered to HTML,
this is standardly used as the image's `alt` attribute.

```````````````````````````````` example
![foo](/url "title")
.
<p><img src="/url" alt="foo" title="title" /></p>
````````````````````````````````


```````````````````````````````` example
![foo *bar*]

[foo *bar*]: train.jpg "train & tracks"
.
<p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>
````````````````````````````````


```````````````````````````````` example
![foo ![bar](/url)](/url2)
.
<p><img src="/url2" alt="foo bar" /></p>
````````````````````````````````


```````````````````````````````` example
![foo [bar](/url)](/url2)
.
<p><img src="/url2" alt="foo bar" /></p>
````````````````````````````````


Though this spec is concerned with parsing, not rendering, it is
recommended that in rendering to HTML, only the plain string content
of the [image description] be used.  Note that in
the above example, the alt attribute's value is `foo bar`, not `foo
[bar](/url)` or `foo <a href="/url">bar</a>`.  Only the plain string
content is rendered, without formatting.

```````````````````````````````` example
![foo *bar*][]

[foo *bar*]: train.jpg "train & tracks"
.
<p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>
````````````````````````````````


```````````````````````````````` example
![foo *bar*][foobar]

[FOOBAR]: train.jpg "train & tracks"
.
<p><img src="train.jpg" alt="foo bar" title="train &amp; tracks" /></p>
````````````````````````````````


```````````````````````````````` example
![foo](train.jpg)
.
<p><img src="train.jpg" alt="foo" /></p>
````````````````````````````````


```````````````````````````````` example
My ![foo bar](/path/to/train.jpg  "title"   )
.
<p>My <img src="/path/to/train.jpg" alt="foo bar" title="title" /></p>
````````````````````````````````


```````````````````````````````` example
![foo](<url>)
.
<p><img src="url" alt="foo" /></p>
````````````````````````````````


```````````````````````````````` example
![](/url)
.
<p><img src="/url" alt="" /></p>
````````````````````````````````


Reference-style:

```````````````````````````````` example
![foo][bar]

[bar]: /url
.
<p><img src="/url" alt="foo" /></p>
````````````````````````````````


```````````````````````````````` example
![foo][bar]

[BAR]: /url
.
<p><img src="/url" alt="foo" /></p>
````````````````````````````````


Collapsed:

```````````````````````````````` example
![foo][]

[foo]: /url "title"
.
<p><img src="/url" alt="foo" title="title" /></p>
````````````````````````````````


```````````````````````````````` example
![*foo* bar][]

[*foo* bar]: /url "title"
.
<p><img src="/url" alt="foo bar" title="title" /></p>
````````````````````````````````


The labels are case-insensitive:

```````````````````````````````` example
![Foo][]

[foo]: /url "title"
.
<p><img src="/url" alt="Foo" title="title" /></p>
````````````````````````````````


As with reference links, [whitespace] is not allowed
between the two sets of brackets:

```````````````````````````````` example
![foo] 
[]

[foo]: /url "title"
.
<p><img src="/url" alt="foo" title="title" />
[]</p>
````````````````````````````````


Shortcut:

```````````````````````````````` example
![foo]

[foo]: /url "title"
.
<p><img src="/url" alt="foo" title="title" /></p>
````````````````````````````````


```````````````````````````````` example
![*foo* bar]

[*foo* bar]: /url "title"
.
<p><img src="/url" alt="foo bar" title="title" /></p>
````````````````````````````````


Note that link labels cannot contain unescaped brackets:

```````````````````````````````` example
![[foo]]

[[foo]]: /url "title"
.
<p>![[foo]]</p>
<p>[[foo]]: /url &quot;title&quot;</p>
````````````````````````````````


The link labels are case-insensitive:

```````````````````````````````` example
![Foo]

[foo]: /url "title"
.
<p><img src="/url" alt="Foo" title="title" /></p>
````````````````````````````````


If you just want a literal `!` followed by bracketed text, you can
backslash-escape the opening `[`:

```````````````````````````````` example
!\[foo]

[foo]: /url "title"
.
<p>![foo]</p>
````````````````````````````````


If you want a link after a literal `!`, backslash-escape the
`!`:

```````````````````````````````` example
\![foo]

[foo]: /url "title"
.
<p>!<a href="/url" title="title">foo</a></p>
````````````````````````````````

