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

## Linting

Run `make lint` to check that the rules follow the practices of a COOL codec.
The lint script, `lint/lint.bat`, is written in CLIPS. It decodes every
file in `tests/cases` one rule at a time and checks:

1. only one rule is on the agenda at a time while one case is decoded
2. all the cases decode together in one run, each to the file named the same
   in `tests/expected`, firing as many rules as they fired alone put together
3. no rule has an `(if` in its right hand side
4. no deffunction called from a rule's right hand side, directly or through
   another deffunction, has an `(if`

It prints one line per violation, a summary, and exits with status 1 when
it found a violation.

## The start fact and the end fact

Each construct of this codec has the prefix `http-`,
and the codec has its own start fact, so it loads next to other codecs in
one environment. Open the stream and assert the start fact with the logical
name of the stream and an id for the results, then run:

    (open "input" input)
    (assert (http-parse (stream input) (id input)) (http-ready (id input)))
    (run)

The codec announces each result with `(http-done (id) (message))`, a fact with the `id` and
the object it made; the program that matches the fact retracts it. Every
object carries the `id` in its `id` slot, where it carried the
`filename` before.

A protocol codec reads only while a `http-ready` fact for the id exists, and a complete message consumes it, so a server can poll between messages. A program that reads a file asserts the ready fact again until the codec asserts `http-eof`.

A message whose `Content-Type` is `application/json` ends after its header
lines, and its body stays on the stream: assert `(json-parse (stream ?id)
(id ?id))` and `(json-ready (id ?id))` after `http-done`, ands
[COOLJSON](https://github.com/mrryanjohnston/COOLJSON)
reads
the body from the same stream. A message with a
`Content-Length` ends when that many octets are read, and the codec reads
nothing after them, so it serves a socket whose peer waits for the reply.
