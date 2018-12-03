## Backslash escapes

Any ASCII punctuation character may be backslash-escaped:

```````````````````````````````` example
\!\"\#\$\%\&\'\(\)\*\+\,\-\.\/\:\;\<\=\>\?\@\[\\\]\^\_\`\{\|\}\~
.
<p>!&quot;#$%&amp;'()*+,-./:;&lt;=&gt;?@[\]^_`{|}~</p>
````````````````````````````````


Backslashes before other characters are treated as literal
backslashes:

```````````````````````````````` example
\→\A\a\ \3\φ\«
.
<p>\→\A\a\ \3\φ\«</p>
````````````````````````````````


Escaped characters are treated as regular characters and do
not have their usual Markdown meanings:

```````````````````````````````` example
\*not emphasized*
\<br/> not a tag
\[not a link](/foo)
\`not code`
1\. not a list
\* not a list
\# not a heading
\[foo]: /url "not a reference"
.
<p>*not emphasized*
&lt;br/&gt; not a tag
[not a link](/foo)
`not code`
1. not a list
* not a list
# not a heading
[foo]: /url &quot;not a reference&quot;</p>
````````````````````````````````


If a backslash is itself escaped, the following character is not:

```````````````````````````````` example
\\*emphasis*
.
<p>\<em>emphasis</em></p>
````````````````````````````````


A backslash at the end of the line is a [hard line break]:

```````````````````````````````` example
foo\
bar
.
<p>foo<br />
bar</p>
````````````````````````````````


Backslash escapes do not work in code blocks, code spans, autolinks, or
raw HTML:

```````````````````````````````` example
`` \[\` ``
.
<p><code>\[\`</code></p>
````````````````````````````````


```````````````````````````````` example
    \[\]
.
<pre><code>\[\]
</code></pre>
````````````````````````````````


```````````````````````````````` example
~~~
\[\]
~~~
.
<pre><code>\[\]
</code></pre>
````````````````````````````````


```````````````````````````````` example
<http://example.com?find=\*>
.
<p><a href="http://example.com?find=%5C*">http://example.com?find=\*</a></p>
````````````````````````````````


```````````````````````````````` example
<a href="/bar\/)">
.
<a href="/bar\/)">
````````````````````````````````


But they work in all other contexts, including URLs and link titles,
link references, and [info strings] in [fenced code blocks]:

```````````````````````````````` example
[foo](/bar\* "ti\*tle")
.
<p><a href="/bar*" title="ti*tle">foo</a></p>
````````````````````````````````


```````````````````````````````` example
[foo]

[foo]: /bar\* "ti\*tle"
.
<p><a href="/bar*" title="ti*tle">foo</a></p>
````````````````````````````````


```````````````````````````````` example
``` foo\+bar
foo
```
.
<pre><code class="language-foo+bar">foo
</code></pre>
````````````````````````````````

