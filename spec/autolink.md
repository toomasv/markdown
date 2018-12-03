## Autolinks

[Autolink](@)s are absolute URIs and email addresses inside
`<` and `>`. They are parsed as links, with the URL or email address
as the link label.

A [URI autolink](@) consists of `<`, followed by an
[absolute URI] not containing `<`, followed by `>`.  It is parsed as
a link to the URI, with the URI as the link's label.

An [absolute URI](@),
for these purposes, consists of a [scheme] followed by a colon (`:`)
followed by zero or more characters other than ASCII
[whitespace] and control characters, `<`, and `>`.  If
the URI includes these characters, they must be percent-encoded
(e.g. `%20` for a space).

For purposes of this spec, a [scheme](@) is any sequence
of 2--32 characters beginning with an ASCII letter and followed
by any combination of ASCII letters, digits, or the symbols plus
("+"), period ("."), or hyphen ("-").

Here are some valid autolinks:

```````````````````````````````` example
<http://foo.bar.baz>
.
<p><a href="http://foo.bar.baz">http://foo.bar.baz</a></p>
````````````````````````````````


```````````````````````````````` example
<http://foo.bar.baz/test?q=hello&id=22&boolean>
.
<p><a href="http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean">http://foo.bar.baz/test?q=hello&amp;id=22&amp;boolean</a></p>
````````````````````````````````


```````````````````````````````` example
<irc://foo.bar:2233/baz>
.
<p><a href="irc://foo.bar:2233/baz">irc://foo.bar:2233/baz</a></p>
````````````````````````````````


Uppercase is also fine:

```````````````````````````````` example
<MAILTO:FOO@BAR.BAZ>
.
<p><a href="MAILTO:FOO@BAR.BAZ">MAILTO:FOO@BAR.BAZ</a></p>
````````````````````````````````


Note that many strings that count as [absolute URIs] for
purposes of this spec are not valid URIs, because their
schemes are not registered or because of other problems
with their syntax:

```````````````````````````````` example
<a+b+c:d>
.
<p><a href="a+b+c:d">a+b+c:d</a></p>
````````````````````````````````


```````````````````````````````` example
<made-up-scheme://foo,bar>
.
<p><a href="made-up-scheme://foo,bar">made-up-scheme://foo,bar</a></p>
````````````````````````````````


```````````````````````````````` example
<http://../>
.
<p><a href="http://../">http://../</a></p>
````````````````````````````````


```````````````````````````````` example
<localhost:5001/foo>
.
<p><a href="localhost:5001/foo">localhost:5001/foo</a></p>
````````````````````````````````


Spaces are not allowed in autolinks:

```````````````````````````````` example
<http://foo.bar/baz bim>
.
<p>&lt;http://foo.bar/baz bim&gt;</p>
````````````````````````````````


Backslash-escapes do not work inside autolinks:

```````````````````````````````` example
<http://example.com/\[\>
.
<p><a href="http://example.com/%5C%5B%5C">http://example.com/\[\</a></p>
````````````````````````````````


An [email autolink](@)
consists of `<`, followed by an [email address],
followed by `>`.  The link's label is the email address,
and the URL is `mailto:` followed by the email address.

An [email address](@),
for these purposes, is anything that matches
the [non-normative regex from the HTML5
spec](https://html.spec.whatwg.org/multipage/forms.html#e-mail-state-(type=email)):

    /^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?
    (?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/

Examples of email autolinks:

```````````````````````````````` example
<foo@bar.example.com>
.
<p><a href="mailto:foo@bar.example.com">foo@bar.example.com</a></p>
````````````````````````````````


```````````````````````````````` example
<foo+special@Bar.baz-bar0.com>
.
<p><a href="mailto:foo+special@Bar.baz-bar0.com">foo+special@Bar.baz-bar0.com</a></p>
````````````````````````````````


Backslash-escapes do not work inside email autolinks:

```````````````````````````````` example
<foo\+@bar.example.com>
.
<p>&lt;foo+@bar.example.com&gt;</p>
````````````````````````````````


These are not autolinks:

```````````````````````````````` example
<>
.
<p>&lt;&gt;</p>
````````````````````````````````


```````````````````````````````` example
< http://foo.bar >
.
<p>&lt; http://foo.bar &gt;</p>
````````````````````````````````


```````````````````````````````` example
<m:abc>
.
<p>&lt;m:abc&gt;</p>
````````````````````````````````


```````````````````````````````` example
<foo.bar.baz>
.
<p>&lt;foo.bar.baz&gt;</p>
````````````````````````````````


```````````````````````````````` example
http://example.com
.
<p>http://example.com</p>
````````````````````````````````


```````````````````````````````` example
foo@bar.example.com
.
<p>foo@bar.example.com</p>
````````````````````````````````

<div class="extension">

