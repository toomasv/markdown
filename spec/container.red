Red []
out: {# Container blocks

A [container block] is a block that has other
blocks as its contents.  There are two basic kinds of container blocks:
[block quotes] and [list items].
[Lists] are meta-containers for [list items].

We define the syntax for container blocks recursively.  The general
form of the definition is:

> If X is a sequence of blocks, then the result of
> transforming X in such-and-such a way is a container of type Y
> with these blocks as its content.

So, we explain what counts as a block quote or list item by explaining
how these can be *generated* from their contents. This should suffice
to define the syntax, although it does not give a recipe for *parsing*
these constructions.  (A recipe is provided below in the section entitled
[A parsing strategy](#appendix-a-parsing-strategy).)

}
foreach file [
	%blockquote.md
	%listitem.md
	%taskitem.md
	%list.md
][append out read file]