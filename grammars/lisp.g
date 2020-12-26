Lisp {
  form   <- list
          / string
          / symbol
  list    <- "(" form* ")"
  string  <- "\"" char* "\""
  char    <- "\\\""
          / "\\\\"
          / "\\" ("b" / "f" / "n" / "r" / "t")
          / "\\u" hex hex hex hex
          / (!"\"" .)
  hex     <- digit | "a".."f" | "A".."F"
  number  <- "0"
          / "-"? "1".."9" digit* ("." digit*)?
          / "-"? "0" ("." digit*)?
  digit   <- "0".."9"
  special_char  <- "(" / ")"
                / empty
                / "\""
  symbol <- (!(special_char / digit / "-").) (!(special_char).)*
}