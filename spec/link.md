## Links

A link contains [link text] (the visible text), a [link destination]
(the URI that is the link destination), and optionally a [link title].
There are two basic kinds of links in Markdown.  In [inline links] the
destination and title are given immediately after the link text.  In
[reference links] the destination and title are defined elsewhere in
the document.

A [link text](@) consists of a sequence of zero or more
inline elements enclosed by square brackets (`[` and `]`).  The
following rules apply:

- Links may not contain other links, at any level of nesting. If
  multiple otherwise valid link definitions appear nested inside each
  other, the inner-most definition is used.

- Brackets are allowed in the [link text] only if (a) they
  are backslash-escaped or (b) they appear as a matched pair of brackets,
  with an open bracket `[`, a sequence of zero or more inlines, and
  a close bracket `]`.

- Backtick [code spans], [autolinks], and raw [HTML tags] bind more tightly
  than the brackets in link text.  Thus, for example,
  `` [foo`]` `` could not be a link text, since the second `]`
  is part of a code span.

- The brackets in link text bind more tightly than markers for
  [emphasis and strong emphasis]. Thus, for example, `*[foo*](url)` is a link.

A [link destination](@) consists of either

- a sequence of zero or more characters between an opening `<` and a
  closing `>` that contains no line breaks or unescaped
  `<` or `>` characters, or

- a nonempty sequence of characters that does not include
  ASCII space or control characters, and includes parentheses
  only if (a) they are backslash-escaped or (b) they are part of
  a balanced pair of unescaped parentheses.  (Implementations
  may impose limits on parentheses nesting to avoid performance
  issues, but at least three levels of nesting should be supported.)

A [link title](@)  consists of either

- a sequence of zero or more characters between straight double-quote
  characters (`"`), including a `"` character only if it is
  backslash-escaped, or

- a sequence of zero or more characters between straight single-quote
  characters (`'`), including a `'` character only if it is
  backslash-escaped, or

- a sequence of zero or more characters between matching parentheses
  (`(...)`), including a `)` character only if it is backslash-escaped.

Although [link titles] may span multiple lines, they may not contain
a [blank line].

An [inline link](@) consists of a [link text] followed immediately
by a left parenthesis `(`, optional [whitespace], an optional
[link destination], an optional [link title] separated from the link
destination by [whitespace], optional [whitespace], and a right
parenthesis `)`. The link's text consists of the inlines contained
in the [link text] (excluding the enclosing square brackets).
The link's URI consists of the link destination, excluding enclosing
`<...>` if present, with backslash-escapes in effect as described
above.  The link's title consists of the link title, excluding its
enclosing delimiters, with backslash-escapes in effect as described
above.

Here is a simple inline link:

```````````````````````````````` example
[link](/uri "title")
.
<p><a href="/uri" title="title">link</a></p>
````````````````````````````````


The title may be omitted:

```````````````````````````````` example
[link](/uri)
.
<p><a href="/uri">link</a></p>
````````````````````````````````


Both the title and the destination may be omitted:

```````````````````````````````` example
[link]()
.
<p><a href="">link</a></p>
````````````````````````````````


```````````````````````````````` example
[link](<>)
.
<p><a href="">link</a></p>
````````````````````````````````

The destination can only contain spaces if it is
enclosed in pointy brackets:

```````````````````````````````` example
[link](/my uri)
.
<p>[link](/my uri)</p>
````````````````````````````````

```````````````````````````````` example
[link](</my uri>)
.
<p><a href="/my%20uri">link</a></p>
````````````````````````````````

The destination cannot contain line breaks,
even if enclosed in pointy brackets:

```````````````````````````````` example
[link](foo
bar)
.
<p>[link](foo
bar)</p>
````````````````````````````````

```````````````````````````````` example
[link](<foo
bar>)
.
<p>[link](<foo
bar>)</p>
````````````````````````````````

Parentheses inside the link destination may be escaped:

```````````````````````````````` example
[link](\(foo\))
.
<p><a href="(foo)">link</a></p>
````````````````````````````````

Any number of parentheses are allowed without escaping, as long as they are
balanced:

```````````````````````````````` example
[link](foo(and(bar)))
.
<p><a href="foo(and(bar))">link</a></p>
````````````````````````````````

However, if you have unbalanced parentheses, you need to escape or use the
`<...>` form:

```````````````````````````````` example
[link](foo\(and\(bar\))
.
<p><a href="foo(and(bar)">link</a></p>
````````````````````````````````


```````````````````````````````` example
[link](<foo(and(bar)>)
.
<p><a href="foo(and(bar)">link</a></p>
````````````````````````````````


Parentheses and other symbols can also be escaped, as usual
in Markdown:

```````````````````````````````` example
[link](foo\)\:)
.
<p><a href="foo):">link</a></p>
````````````````````````````````


A link can contain fragment identifiers and queries:

```````````````````````````````` example
[link](#fragment)

[link](http://example.com#fragment)

[link](http://example.com?foo=3#frag)
.
<p><a href="#fragment">link</a></p>
<p><a href="http://example.com#fragment">link</a></p>
<p><a href="http://example.com?foo=3#frag">link</a></p>
````````````````````````````````


Note that a backslash before a non-escapable character is
just a backslash:

```````````````````````````````` example
[link](foo\bar)
.
<p><a href="foo%5Cbar">link</a></p>
````````````````````````````````


URL-escaping should be left alone inside the destination, as all
URL-escaped characters are also valid URL characters. Entity and
numerical character references in the destination will be parsed
into the corresponding Unicode code points, as usual.  These may
be optionally URL-escaped when written as HTML, but this spec
does not enforce any particular policy for rendering URLs in
HTML or other formats.  Renderers may make different decisions
about how to escape or normalize URLs in the output.

```````````````````````````````` example
[link](foo%20b&auml;)
.
<p><a href="foo%20b%C3%A4">link</a></p>
````````````````````````````````


Note that, because titles can often be parsed as destinations,
if you try to omit the destination and keep the title, you'll
get unexpected results:

```````````````````````````````` example
[link]("title")
.
<p><a href="%22title%22">link</a></p>
````````````````````````````````


Titles may be in single quotes, double quotes, or parentheses:

```````````````````````````````` example
[link](/url "title")
[link](/url 'title')
[link](/url (title))
.
<p><a href="/url" title="title">link</a>
<a href="/url" title="title">link</a>
<a href="/url" title="title">link</a></p>
````````````````````````````````


Backslash escapes and entity and numeric character references
may be used in titles:

```````````````````````````````` example
[link](/url "title \"&quot;")
.
<p><a href="/url" title="title &quot;&quot;">link</a></p>
````````````````````````````````


Titles must be separated from the link using a [whitespace].
Other [Unicode whitespace] like non-breaking space doesn't work.

```````````````````````````````` example
[link](/url "title")
.
<p><a href="/url%C2%A0%22title%22">link</a></p>
````````````````````````````````


Nested balanced quotes are not allowed without escaping:

```````````````````````````````` example
[link](/url "title "and" title")
.
<p>[link](/url &quot;title &quot;and&quot; title&quot;)</p>
````````````````````````````````


But it is easy to work around this by using a different quote type:

```````````````````````````````` example
[link](/url 'title "and" title')
.
<p><a href="/url" title="title &quot;and&quot; title">link</a></p>
````````````````````````````````


(Note:  `Markdown.pl` did allow double quotes inside a double-quoted
title, and its test suite included a test demonstrating this.
But it is hard to see a good rationale for the extra complexity this
brings, since there are already many ways---backslash escaping,
entity and numeric character references, or using a different
quote type for the enclosing title---to write titles containing
double quotes.  `Markdown.pl`'s handling of titles has a number
of other strange features.  For example, it allows single-quoted
titles in inline links, but not reference links.  And, in
reference links but not inline links, it allows a title to begin
with `"` and end with `)`.  `Markdown.pl` 1.0.1 even allows
titles with no closing quotation mark, though 1.0.2b8 does not.
It seems preferable to adopt a simple, rational rule that works
the same way in inline links and link reference definitions.)

[Whitespace] is allowed around the destination and title:

```````````````````````````````` example
[link](   /uri
  "title"  )
.
<p><a href="/uri" title="title">link</a></p>
````````````````````````````````


But it is not allowed between the link text and the
following parenthesis:

```````````````````````````````` example
[link] (/uri)
.
<p>[link] (/uri)</p>
````````````````````````````````


The link text may contain balanced brackets, but not unbalanced ones,
unless they are escaped:

```````````````````````````````` example
[link [foo [bar]]](/uri)
.
<p><a href="/uri">link [foo [bar]]</a></p>
````````````````````````````````


```````````````````````````````` example
[link] bar](/uri)
.
<p>[link] bar](/uri)</p>
````````````````````````````````


```````````````````````````````` example
[link [bar](/uri)
.
<p>[link <a href="/uri">bar</a></p>
````````````````````````````````


```````````````````````````````` example
[link \[bar](/uri)
.
<p><a href="/uri">link [bar</a></p>
````````````````````````````````


The link text may contain inline content:

```````````````````````````````` example
[link *foo **bar** `#`*](/uri)
.
<p><a href="/uri">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>
````````````````````````````````


```````````````````````````````` example
[![moon](moon.jpg)](/uri)
.
<p><a href="/uri"><img src="moon.jpg" alt="moon" /></a></p>
````````````````````````````````


However, links may not contain other links, at any level of nesting.

```````````````````````````````` example
[foo [bar](/uri)](/uri)
.
<p>[foo <a href="/uri">bar</a>](/uri)</p>
````````````````````````````````


```````````````````````````````` example
[foo *[bar [baz](/uri)](/uri)*](/uri)
.
<p>[foo <em>[bar <a href="/uri">baz</a>](/uri)</em>](/uri)</p>
````````````````````````````````


```````````````````````````````` example
![[[foo](uri1)](uri2)](uri3)
.
<p><img src="uri3" alt="[foo](uri2)" /></p>
````````````````````````````````


These cases illustrate the precedence of link text grouping over
emphasis grouping:

```````````````````````````````` example
*[foo*](/uri)
.
<p>*<a href="/uri">foo*</a></p>
````````````````````````````````


```````````````````````````````` example
[foo *bar](baz*)
.
<p><a href="baz*">foo *bar</a></p>
````````````````````````````````


Note that brackets that *aren't* part of links do not take
precedence:

```````````````````````````````` example
*foo [bar* baz]
.
<p><em>foo [bar</em> baz]</p>
````````````````````````````````


These cases illustrate the precedence of HTML tags, code spans,
and autolinks over link grouping:

```````````````````````````````` example
[foo <bar attr="](baz)">
.
<p>[foo <bar attr="](baz)"></p>
````````````````````````````````


```````````````````````````````` example
[foo`](/uri)`
.
<p>[foo<code>](/uri)</code></p>
````````````````````````````````


```````````````````````````````` example
[foo<http://example.com/?search=](uri)>
.
<p>[foo<a href="http://example.com/?search=%5D(uri)">http://example.com/?search=](uri)</a></p>
````````````````````````````````


There are three kinds of [reference link](@)s:
[full](#full-reference-link), [collapsed](#collapsed-reference-link),
and [shortcut](#shortcut-reference-link).

A [full reference link](@)
consists of a [link text] immediately followed by a [link label]
that [matches] a [link reference definition] elsewhere in the document.

A [link label](@)  begins with a left bracket (`[`) and ends
with the first right bracket (`]`) that is not backslash-escaped.
Between these brackets there must be at least one [non-whitespace character].
Unescaped square bracket characters are not allowed inside the
opening and closing square brackets of [link labels].  A link
label can have at most 999 characters inside the square
brackets.

One label [matches](@)
another just in case their normalized forms are equal.  To normalize a
label, strip off the opening and closing brackets,
perform the *Unicode case fold*, strip leading and trailing
[whitespace] and collapse consecutive internal
[whitespace] to a single space.  If there are multiple
matching reference link definitions, the one that comes first in the
document is used.  (It is desirable in such cases to emit a warning.)

The contents of the first link label are parsed as inlines, which are
used as the link's text.  The link's URI and title are provided by the
matching [link reference definition].

Here is a simple example:

```````````````````````````````` example
[foo][bar]

[bar]: /url "title"
.
<p><a href="/url" title="title">foo</a></p>
````````````````````````````````


The rules for the [link text] are the same as with
[inline links].  Thus:

The link text may contain balanced brackets, but not unbalanced ones,
unless they are escaped:

```````````````````````````````` example
[link [foo [bar]]][ref]

[ref]: /uri
.
<p><a href="/uri">link [foo [bar]]</a></p>
````````````````````````````````


```````````````````````````````` example
[link \[bar][ref]

[ref]: /uri
.
<p><a href="/uri">link [bar</a></p>
````````````````````````````````


The link text may contain inline content:

```````````````````````````````` example
[link *foo **bar** `#`*][ref]

[ref]: /uri
.
<p><a href="/uri">link <em>foo <strong>bar</strong> <code>#</code></em></a></p>
````````````````````````````````


```````````````````````````````` example
[![moon](moon.jpg)][ref]

[ref]: /uri
.
<p><a href="/uri"><img src="moon.jpg" alt="moon" /></a></p>
````````````````````````````````


However, links may not contain other links, at any level of nesting.

```````````````````````````````` example
[foo [bar](/uri)][ref]

[ref]: /uri
.
<p>[foo <a href="/uri">bar</a>]<a href="/uri">ref</a></p>
````````````````````````````````


```````````````````````````````` example
[foo *bar [baz][ref]*][ref]

[ref]: /uri
.
<p>[foo <em>bar <a href="/uri">baz</a></em>]<a href="/uri">ref</a></p>
````````````````````````````````


(In the examples above, we have two [shortcut reference links]
instead of one [full reference link].)

The following cases illustrate the precedence of link text grouping over
emphasis grouping:

```````````````````````````````` example
*[foo*][ref]

[ref]: /uri
.
<p>*<a href="/uri">foo*</a></p>
````````````````````````````````


```````````````````````````````` example
[foo *bar][ref]

[ref]: /uri
.
<p><a href="/uri">foo *bar</a></p>
````````````````````````````````


These cases illustrate the precedence of HTML tags, code spans,
and autolinks over link grouping:

```````````````````````````````` example
[foo <bar attr="][ref]">

[ref]: /uri
.
<p>[foo <bar attr="][ref]"></p>
````````````````````````````````


```````````````````````````````` example
[foo`][ref]`

[ref]: /uri
.
<p>[foo<code>][ref]</code></p>
````````````````````````````````


```````````````````````````````` example
[foo<http://example.com/?search=][ref]>

[ref]: /uri
.
<p>[foo<a href="http://example.com/?search=%5D%5Bref%5D">http://example.com/?search=][ref]</a></p>
````````````````````````````````


Matching is case-insensitive:

```````````````````````````````` example
[foo][BaR]

[bar]: /url "title"
.
<p><a href="/url" title="title">foo</a></p>
````````````````````````````````


Unicode case fold is used:

```````````````````````````````` example
[Толпой][Толпой] is a Russian word.

[ТОЛПОЙ]: /url
.
<p><a href="/url">Толпой</a> is a Russian word.</p>
````````````````````````````````


Consecutive internal [whitespace] is treated as one space for
purposes of determining matching:

```````````````````````````````` example
[Foo
  bar]: /url

[Baz][Foo bar]
.
<p><a href="/url">Baz</a></p>
````````````````````````````````


No [whitespace] is allowed between the [link text] and the
[link label]:

```````````````````````````````` example
[foo] [bar]

[bar]: /url "title"
.
<p>[foo] <a href="/url" title="title">bar</a></p>
````````````````````````````````


```````````````````````````````` example
[foo]
[bar]

[bar]: /url "title"
.
<p>[foo]
<a href="/url" title="title">bar</a></p>
````````````````````````````````


This is a departure from John Gruber's original Markdown syntax
description, which explicitly allows whitespace between the link
text and the link label.  It brings reference links in line with
[inline links], which (according to both original Markdown and
this spec) cannot have whitespace after the link text.  More
importantly, it prevents inadvertent capture of consecutive
[shortcut reference links]. If whitespace is allowed between the
link text and the link label, then in the following we will have
a single reference link, not two shortcut reference links, as
intended:

``` markdown
[foo]
[bar]

[foo]: /url1
[bar]: /url2
```

(Note that [shortcut reference links] were introduced by Gruber
himself in a beta version of `Markdown.pl`, but never included
in the official syntax description.  Without shortcut reference
links, it is harmless to allow space between the link text and
link label; but once shortcut references are introduced, it is
too dangerous to allow this, as it frequently leads to
unintended results.)

When there are multiple matching [link reference definitions],
the first is used:

```````````````````````````````` example
[foo]: /url1

[foo]: /url2

[bar][foo]
.
<p><a href="/url1">bar</a></p>
````````````````````````````````


Note that matching is performed on normalized strings, not parsed
inline content.  So the following does not match, even though the
labels define equivalent inline content:

```````````````````````````````` example
[bar][foo\!]

[foo!]: /url
.
<p>[bar][foo!]</p>
````````````````````````````````


[Link labels] cannot contain brackets, unless they are
backslash-escaped:

```````````````````````````````` example
[foo][ref[]

[ref[]: /uri
.
<p>[foo][ref[]</p>
<p>[ref[]: /uri</p>
````````````````````````````````


```````````````````````````````` example
[foo][ref[bar]]

[ref[bar]]: /uri
.
<p>[foo][ref[bar]]</p>
<p>[ref[bar]]: /uri</p>
````````````````````````````````


```````````````````````````````` example
[[[foo]]]

[[[foo]]]: /url
.
<p>[[[foo]]]</p>
<p>[[[foo]]]: /url</p>
````````````````````````````````


```````````````````````````````` example
[foo][ref\[]

[ref\[]: /uri
.
<p><a href="/uri">foo</a></p>
````````````````````````````````


Note that in this example `]` is not backslash-escaped:

```````````````````````````````` example
[bar\\]: /uri

[bar\\]
.
<p><a href="/uri">bar\</a></p>
````````````````````````````````


A [link label] must contain at least one [non-whitespace character]:

```````````````````````````````` example
[]

[]: /uri
.
<p>[]</p>
<p>[]: /uri</p>
````````````````````````````````


```````````````````````````````` example
[
 ]

[
 ]: /uri
.
<p>[
]</p>
<p>[
]: /uri</p>
````````````````````````````````


A [collapsed reference link](@)
consists of a [link label] that [matches] a
[link reference definition] elsewhere in the
document, followed by the string `[]`.
The contents of the first link label are parsed as inlines,
which are used as the link's text.  The link's URI and title are
provided by the matching reference link definition.  Thus,
`[foo][]` is equivalent to `[foo][foo]`.

```````````````````````````````` example
[foo][]

[foo]: /url "title"
.
<p><a href="/url" title="title">foo</a></p>
````````````````````````````````


```````````````````````````````` example
[*foo* bar][]

[*foo* bar]: /url "title"
.
<p><a href="/url" title="title"><em>foo</em> bar</a></p>
````````````````````````````````


The link labels are case-insensitive:

```````````````````````````````` example
[Foo][]

[foo]: /url "title"
.
<p><a href="/url" title="title">Foo</a></p>
````````````````````````````````



As with full reference links, [whitespace] is not
allowed between the two sets of brackets:

```````````````````````````````` example
[foo] 
[]

[foo]: /url "title"
.
<p><a href="/url" title="title">foo</a>
[]</p>
````````````````````````````````


A [shortcut reference link](@)
consists of a [link label] that [matches] a
[link reference definition] elsewhere in the
document and is not followed by `[]` or a link label.
The contents of the first link label are parsed as inlines,
which are used as the link's text.  The link's URI and title
are provided by the matching link reference definition.
Thus, `[foo]` is equivalent to `[foo][]`.

```````````````````````````````` example
[foo]

[foo]: /url "title"
.
<p><a href="/url" title="title">foo</a></p>
````````````````````````````````


```````````````````````````````` example
[*foo* bar]

[*foo* bar]: /url "title"
.
<p><a href="/url" title="title"><em>foo</em> bar</a></p>
````````````````````````````````


```````````````````````````````` example
[[*foo* bar]]

[*foo* bar]: /url "title"
.
<p>[<a href="/url" title="title"><em>foo</em> bar</a>]</p>
````````````````````````````````


```````````````````````````````` example
[[bar [foo]

[foo]: /url
.
<p>[[bar <a href="/url">foo</a></p>
````````````````````````````````


The link labels are case-insensitive:

```````````````````````````````` example
[Foo]

[foo]: /url "title"
.
<p><a href="/url" title="title">Foo</a></p>
````````````````````````````````


A space after the link text should be preserved:

```````````````````````````````` example
[foo] bar

[foo]: /url
.
<p><a href="/url">foo</a> bar</p>
````````````````````````````````


If you just want bracketed text, you can backslash-escape the
opening bracket to avoid links:

```````````````````````````````` example
\[foo]

[foo]: /url "title"
.
<p>[foo]</p>
````````````````````````````````


Note that this is a link, because a link label ends with the first
following closing bracket:

```````````````````````````````` example
[foo*]: /url

*[foo*]
.
<p>*<a href="/url">foo*</a></p>
````````````````````````````````


Full and compact references take precedence over shortcut
references:

```````````````````````````````` example
[foo][bar]

[foo]: /url1
[bar]: /url2
.
<p><a href="/url2">foo</a></p>
````````````````````````````````

```````````````````````````````` example
[foo][]

[foo]: /url1
.
<p><a href="/url1">foo</a></p>
````````````````````````````````

Inline links also take precedence:

```````````````````````````````` example
[foo]()

[foo]: /url1
.
<p><a href="">foo</a></p>
````````````````````````````````

```````````````````````````````` example
[foo](not a link)

[foo]: /url1
.
<p><a href="/url1">foo</a>(not a link)</p>
````````````````````````````````

In the following case `[bar][baz]` is parsed as a reference,
`[foo]` as normal text:

```````````````````````````````` example
[foo][bar][baz]

[baz]: /url
.
<p>[foo]<a href="/url">bar</a></p>
````````````````````````````````


Here, though, `[foo][bar]` is parsed as a reference, since
`[bar]` is defined:

```````````````````````````````` example
[foo][bar][baz]

[baz]: /url1
[bar]: /url2
.
<p><a href="/url2">foo</a><a href="/url1">baz</a></p>
````````````````````````````````


Here `[foo]` is not parsed as a shortcut reference, because it
is followed by a link label (even though `[bar]` is not defined):

```````````````````````````````` example
[foo][bar][baz]

[baz]: /url1
[foo]: /url2
.
<p>[foo]<a href="/url1">bar</a></p>
````````````````````````````````

