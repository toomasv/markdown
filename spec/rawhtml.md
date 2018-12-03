## Raw HTML

Text between `<` and `>` that looks like an HTML tag is parsed as a
raw HTML tag and will be rendered in HTML without escaping.
Tag and attribute names are not limited to current HTML tags,
so custom tags (and even, say, DocBook tags) may be used.

Here is the grammar for tags:

A [tag name](@) consists of an ASCII letter
followed by zero or more ASCII letters, digits, or
hyphens (`-`).

An [attribute](@) consists of [whitespace],
an [attribute name], and an optional
[attribute value specification].

An [attribute name](@)
consists of an ASCII letter, `_`, or `:`, followed by zero or more ASCII
letters, digits, `_`, `.`, `:`, or `-`.  (Note:  This is the XML
specification restricted to ASCII.  HTML5 is laxer.)

An [attribute value specification](@)
consists of optional [whitespace],
a `=` character, optional [whitespace], and an [attribute
value].

An [attribute value](@)
consists of an [unquoted attribute value],
a [single-quoted attribute value], or a [double-quoted attribute value].

An [unquoted attribute value](@)
is a nonempty string of characters not
including [whitespace], `"`, `'`, `=`, `<`, `>`, or `` ` ``.

A [single-quoted attribute value](@)
consists of `'`, zero or more
characters not including `'`, and a final `'`.

A [double-quoted attribute value](@)
consists of `"`, zero or more
characters not including `"`, and a final `"`.

An [open tag](@) consists of a `<` character, a [tag name],
zero or more [attributes], optional [whitespace], an optional `/`
character, and a `>` character.

A [closing tag](@) consists of the string `</`, a
[tag name], optional [whitespace], and the character `>`.

An [HTML comment](@) consists of `<!--` + *text* + `-->`,
where *text* does not start with `>` or `->`, does not end with `-`,
and does not contain `--`.  (See the
[HTML5 spec](http://www.w3.org/TR/html5/syntax.html#comments).)

A [processing instruction](@)
consists of the string `<?`, a string
of characters not including the string `?>`, and the string
`?>`.

A [declaration](@) consists of the
string `<!`, a name consisting of one or more uppercase ASCII letters,
[whitespace], a string of characters not including the
character `>`, and the character `>`.

A [CDATA section](@) consists of
the string `<![CDATA[`, a string of characters not including the string
`]]>`, and the string `]]>`.

An [HTML tag](@) consists of an [open tag], a [closing tag],
an [HTML comment], a [processing instruction], a [declaration],
or a [CDATA section].

Here are some simple open tags:

```````````````````````````````` example
<a><bab><c2c>
.
<p><a><bab><c2c></p>
````````````````````````````````


Empty elements:

```````````````````````````````` example
<a/><b2/>
.
<p><a/><b2/></p>
````````````````````````````````


[Whitespace] is allowed:

```````````````````````````````` example
<a  /><b2
data="foo" >
.
<p><a  /><b2
data="foo" ></p>
````````````````````````````````


With attributes:

```````````````````````````````` example
<a foo="bar" bam = 'baz <em>"</em>'
_boolean zoop:33=zoop:33 />
.
<p><a foo="bar" bam = 'baz <em>"</em>'
_boolean zoop:33=zoop:33 /></p>
````````````````````````````````


Custom tag names can be used:

```````````````````````````````` example
Foo <responsive-image src="foo.jpg" />
.
<p>Foo <responsive-image src="foo.jpg" /></p>
````````````````````````````````


Illegal tag names, not parsed as HTML:

```````````````````````````````` example
<33> <__>
.
<p>&lt;33&gt; &lt;__&gt;</p>
````````````````````````````````


Illegal attribute names:

```````````````````````````````` example
<a h*#ref="hi">
.
<p>&lt;a h*#ref=&quot;hi&quot;&gt;</p>
````````````````````````````````


Illegal attribute values:

```````````````````````````````` example
<a href="hi'> <a href=hi'>
.
<p>&lt;a href=&quot;hi'&gt; &lt;a href=hi'&gt;</p>
````````````````````````````````


Illegal [whitespace]:

```````````````````````````````` example
< a><
foo><bar/ >
<foo bar=baz
bim!bop />
.
<p>&lt; a&gt;&lt;
foo&gt;&lt;bar/ &gt;
&lt;foo bar=baz
bim!bop /&gt;</p>
````````````````````````````````


Missing [whitespace]:

```````````````````````````````` example
<a href='bar'title=title>
.
<p>&lt;a href='bar'title=title&gt;</p>
````````````````````````````````


Closing tags:

```````````````````````````````` example
</a></foo >
.
<p></a></foo ></p>
````````````````````````````````


Illegal attributes in closing tag:

```````````````````````````````` example
</a href="foo">
.
<p>&lt;/a href=&quot;foo&quot;&gt;</p>
````````````````````````````````


Comments:

```````````````````````````````` example
foo <!-- this is a
comment - with hyphen -->
.
<p>foo <!-- this is a
comment - with hyphen --></p>
````````````````````````````````


```````````````````````````````` example
foo <!-- not a comment -- two hyphens -->
.
<p>foo &lt;!-- not a comment -- two hyphens --&gt;</p>
````````````````````````````````


Not comments:

```````````````````````````````` example
foo <!--> foo -->

foo <!-- foo--->
.
<p>foo &lt;!--&gt; foo --&gt;</p>
<p>foo &lt;!-- foo---&gt;</p>
````````````````````````````````


Processing instructions:

```````````````````````````````` example
foo <?php echo $a; ?>
.
<p>foo <?php echo $a; ?></p>
````````````````````````````````


Declarations:

```````````````````````````````` example
foo <!ELEMENT br EMPTY>
.
<p>foo <!ELEMENT br EMPTY></p>
````````````````````````````````


CDATA sections:

```````````````````````````````` example
foo <![CDATA[>&<]]>
.
<p>foo <![CDATA[>&<]]></p>
````````````````````````````````


Entity and numeric character references are preserved in HTML
attributes:

```````````````````````````````` example
foo <a href="&ouml;">
.
<p>foo <a href="&ouml;"></p>
````````````````````````````````


Backslash escapes do not work in HTML attributes:

```````````````````````````````` example
foo <a href="\*">
.
<p>foo <a href="\*"></p>
````````````````````````````````


```````````````````````````````` example
<a href="\"">
.
<p>&lt;a href=&quot;&quot;&quot;&gt;</p>
````````````````````````````````


<div class="extension">

