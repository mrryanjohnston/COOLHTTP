# COOLHTTP

A codex for the HTTP protocol written in
[CLIPS](https://clipsrules.net/). This repo provides a way to turn
HTTP requests and responses into CLIPS objects
as well as print out HTTP requests and responses from CLIPS objects.

## Usage

Load `program.clp` into a CLIPS environment. Open a stream. The codec changes
each byte of an HTTP message into a COOL object. This is the file
`request.http`:

```
POST /search?q=clips&sort=recent HTTP/1.1
Host: example.com:8080
Accept: text/html, application/json; q=0.9
Content-Type: application/x-www-form-urlencoded
Content-Length: 28

name=Ryan&favoritefood=pizza
```

Parse the file:

```clips
(load program.clp)
(reset)
(open request.http req)
(assert (http-parse (stream req) (id req)) (http-ready (id req)))
(run)
```

The result is a tree of instances. Each class is one rule of the grammar in
RFC 9110, 9111, 9112 and 3986:

```
[gen1] of HTTP-METHOD
[gen4] of HTTP-ORIGIN-FORM
[gen11] of HTTP-HOST-HEADER
[gen23] of HTTP-ACCEPT-HEADER
[gen29] of HTTP-CONTENT-TYPE-HEADER
[gen33] of HTTP-CONTENT-LENGTH-HEADER
[gen38] of HTTP-X-WWW-FORM-URLENCODED
[gen40] of HTTP-MESSAGE
...
```

Each instance has the `id` from the start fact. A rule matches only the
objects that it uses:

```clips
(defrule log-form-field
  (http-done (id ?id))
  (object (is-a HTTP-SEQUENCE) (id ?id) (name-string ?name) (value-string ?value))
  =>
  (println ?name " = " ?value))
```

```
favoritefood = pizza
name = Ryan
```

The same classes make a message. The `pprint` handler writes the message as
HTTP. This rule sends a response to the request above:

```clips
(defrule reply
  ?done <- (http-done (id ?id) (message ?request))
  (object (is-a HTTP-CONTENT-LENGTH-HEADER) (id ?id) (value ?n))
  =>
  (retract ?done)
  (bind ?response (make-instance of HTTP-MESSAGE
    (start-line (make-instance of HTTP-STATUS-LINE
      (http-version (make-instance of HTTP-VERSION (major 1) (minor 1)))
      (status-code 200)
      (reason-phrase (make-instance of HTTP-REASON-PHRASE (value "OK")))))
    (field-lines
      (make-instance of HTTP-FIELD-LINE
        (field-name (make-instance of HTTP-FIELD-NAME (value "Content-Length")))
        (field-value (make-instance of HTTP-FIELD-VALUE
          (value (make-instance of HTTP-CONTENT-LENGTH-HEADER (value 2))))))
      (make-instance of HTTP-FIELD-LINE
        (field-name (make-instance of HTTP-FIELD-NAME (value "Content-Type")))
        (field-value (make-instance of HTTP-FIELD-VALUE
          (value (make-instance of HTTP-CONTENT-TYPE-HEADER
            (type (make-instance of HTTP-TYPE (value "text")))
            (subtype (make-instance of HTTP-SUBTYPE (value "plain")))))))))
    (message-body (make-instance of HTTP-MESSAGE-BODY
      (value (make-instance of HTTP-OCTET-STREAM (value "OK")))))))
  (println "read " ?n " body octets from " ?id ", replying:")
  (send ?response pprint t))
```

```
read 28 body octets from req, replying:
HTTP/1.1 200 OK
Content-Length: 2
Content-Type: text/plain

OK
```

Send `pprint` to the parsed request. The output is the request without the
unnecessary spaces. Give `pprint` the logical name of a socket in place of
`t` (see
[CLIPSockets](https://github.com/mrryanjohnston/CLIPSockets)
for a networking library). The rule above is then a server.

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
