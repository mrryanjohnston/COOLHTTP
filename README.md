# COOLHTTP

A codex for the HTTP protocol written in
[CLIPS](https://clipsrules.net/). This repo provides a way to turn
HTTP requests and responses into CLIPS objects
as well as print out HTTP requests and responses from CLIPS objects.

## Developer notes

A few "rules of thumb" I've determined from making CLIPS codecs:

1. Aim for 1 `defrule` activation on average always. The more activations you have,
   the slower things go.
2. Avoid `if` statements in the RHS of rules. Just create a new rule to handle
   the conditional.
3. Check one character at a time with `(get-char)`. Checking each character
   individually might be tedious, but it allows us the highest fidelity
   and means that we never need to "backtrack" and consider characters
   that were read in the past.

## Tests

Run the suite with:

```
make test
```

There are two directories: `cases` and `expected`.
`cases` are read into CLIPS, and a successful tests is when
a file from `case` outputs into its same named test case
in `expected`.
