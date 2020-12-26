# MAL in Crystal

Forked from https://github.com/kanaka/mal/tree/master/impls/crystal

## Why Crystal?

My previous experiment was to build MAL in Pony. Pony is a nice language, but its type system is a bit "rigid", which slows down me. I want to experiment and iterate fast.

I want a compiled fast language, but not C. My options are:

- Go - I don't want to deal with the absence of generics
- Rust - I don't want to deal with the borrow checker
- Chez Scheme or sbcl or clasp - may be, but there is no static type checker?
- Zig
- Crystal

I decided to go with Crystal because it is a bit more flexible than Zig. Also, I heard that they want to rewrite the Ponylang compiler from C to Crystal, so I was curious.

## Ideas

Ideas I want to explore:

1. Write reader with new Pytonish syntax, which would compile input to the SExpressions, that MAL's `eval` expect
2. ...

## About Lisp syntax

There were a million attempts to create an alternative to SExpressions. See:

- [History of alternative syntaxes for Lisp](https://github.com/shaunlebron/history-of-lisp-parens/blob/master/alt-syntax.md)
- [Readable Lisp S-expressions Project](https://readable.sourceforge.io/)
- [LISP Infix Syntax Survey](http://xahlee.info/comp/lisp_sans_sexp.html)
- [wisp: Whitespace to Lisp](https://www.draketo.de/english/wisp)
- [Curly infix, Modern-expressions, and Sweet-expressions: A suite of readable formats for Lisp-like languages](https://dwheeler.com/readable/sweet-expressions.html)
- [nonelang](https://nonelang.readthedocs.io/en/latest/dataformat.html)
- [LSIP: An operator-based syntax for Racket programs; O-expressions](http://breuleux.net/blog/liso.html)
- [rhombus-brainstorming](https://github.com/racket/rhombus-brainstorming/issues/3)

## Parsers

### Crystal libs

- http://crystalshards.xyz/?filter=parser
- [arborist](https://github.com/davidkellis/arborist)
  - [ohm](https://github.com/harc/ohm/blob/master/doc/syntax-reference.md)
- [pars3k](https://github.com/voximity/pars3k)
- [crystal-pegmatite](https://github.com/jemc/crystal-pegmatite) - no documentation
- [pegasus](https://github.com/pawandubey/pegasus) - regexp

### Lisp, Sheme, Clojure BNF/EBNF

- [Clojure.g4](https://github.com/antlr/grammars-v4/blob/master/clojure/Clojure.g4)
- [Clojure.g](https://github.com/ccw-ide/ccw/blob/3738a4fd768bcb0399630b7f6a6427a3066bdaa9/clojure-antlr-grammar/src/Clojure.g)
- [r5rs](https://people.csail.mit.edu/jaffer/r5rs_9.html)
- [Formal Syntax of Scheme](https://www.scheme.com/tspl2d/grammar.html)

### Grammars

- [The Packrat Parsing and Parsing Expression Grammars Page](https://bford.info/packrat/)
- [Language Grammar](https://enqueuezero.com/language-grammar.html)
- [Confluent Orthogonal Drawingfor Syntax Diagrams](http://www.csun.edu/gd2015/slides/Sept25-15-25-Michael_Bannister.pdf)
- [Guy Steele on Computer Science Metanotation](https://www.youtube.com/watch?v=dCuZkaaou0Q)

## Brainstorming

- operator precedence rules is hard to remeber. Pony doesn't have it
- [punctuation-signs as operators are hard to search](https://www.joshwcomeau.com/operator-lookup/)
- I don't think that prefix notation is a problem, almost all functions except math operators and special operators like in [Haskell](https://imada.sdu.dk/~rolf/Edu/DM22/F06/haskell-operatorer.pdf) use it. See: [operators](https://www.fpcomplete.com/haskell/tutorial/operators/)
- In Scheme it is possible to use `[]` and `{}` in addition to `()`, which makes it more readable
- In Clojure `[]` denotes a vector (doesn't evaluate like application), `{}` denotes a hashmap, `:...` denotes a keyword (doesn't evaluate like a variable, more like Ruby's symbol)
