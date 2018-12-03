# markdown
Markdown (gfm) to html in red

To try it on some part of spec:

    do/args %markdown.red %spec/list.md

To try it on on your own <input>

    do/args %markdown.red <input>

If you put your input in %spec-tmp.txt:

    do %markdown.red

To see debug info, edit %markdown.red line 6

    debug: true
