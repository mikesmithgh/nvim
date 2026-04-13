; extends

((tag
  (name) @comment.todo @nospell
  ("(" @punctuation.bracket
    (user) @constant
    ")" @punctuation.bracket)?
  ":" @punctuation.delimiter)
  (#any-of? @comment.todo "FUTURE"))

("text" @comment.todo @nospell
  (#any-of? @comment.todo "FUTURE"))
