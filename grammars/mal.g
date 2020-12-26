Mal {
  expression_or_comment <-
    (empty* expression empty* comment?)
    / (empty* comment?)
  expression  <- list
    / vector
    / hash_map
    / string
    / number
    / quote
    / keyword
    / symbol
  list <- "(" expression_or_comment* ")"
  vector <- "[" expression_or_comment* "]"
  hash_map <- "{" empty* pair* "}"
  pair <-
    (string / keyword) empty* expression empty* comment?
  string <- "\"" char* "\""
  char <- "\\\""
    / "\\\\"
    / "\\" ("b" / "f" / "n" / "r" / "t")
    / "\\u" hex hex hex hex
    / (!"\"" .)
  hex <- digit | "a".."f" | "A".."F"
  number <- "0"
    / "-"? "1".."9" digit* ("." digit*)?
    / "-"? "0" ("." digit*)?
  digit <- "0".."9"
  empty <- "\n" / "\r" / "\t" / " " / ","
  special_char  <- "(" / ")"
    / "[" / "]"
    / "{" / "}"
    / quote_symbol
    / empty
    / "\""
    / ";"
    / ":"
  symbol <-
    (!(special_char / digit).) (!(special_char).)*
  keyword <- ":" symbol
  quote_symbol <- "'" / "`" / "~@" / "~" / "@"
  quote <- quote_symbol empty* expression
  comment <- ";" (!("\n").)* "\n"?
}
