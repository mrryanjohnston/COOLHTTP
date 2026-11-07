# COOLHTTP API

`program.clp` is the whole codec. Everything it defines starts with `http-`
(facts, deffunctions, globals) or `HTTP-` (classes). This document lists the
facts a program asserts and matches, the instances the decoder makes, and the
message handlers that encode instances back into HTTP.

## Facts

Three deftemplates and one deffacts are the fact interface. Every other
`http-*` deftemplate (`http-message`, `http-field-line`, `http-char`, ...) is
the working state of a message being decoded. The decoder retracts all of it
when the message completes. A program does not match or assert those facts.

### `http-parse`

```clips
(http-parse (stream <logical-name>) (id <value>))
```

The start fact. `stream` is the logical name of an open file or socket. `id`
is any value the program chooses. Every instance the decoder makes for this
message carries the `id`, so the program finds its message with an object
pattern on `(id ?id)`. The stream and the id may be the same symbol.

### `http-ready`

```clips
(http-ready (id <value>))
```

The gate. The decoder reads nothing until an `http-ready` with the same `id`
as an `http-parse` exists. The first rule of a message retracts both facts.
One pair decodes one message: to read the next message on the same stream,
assert both again after the `HTTP-MESSAGE` instance exists. A message with
a `Content-Length` body, a chunked body, a multipart body, or no body ends
where the grammar says it ends. The stream stays positioned after it, so a
socket need not close.

### `http-eof`

```clips
(http-eof (id <value>))
```

The end fact. The decoder asserts it when `get-char` returns -1 before the
message is complete. It makes no `HTTP-MESSAGE` and changes no other fact or
instance: the parts of the message decoded so far stay where they are. The
program that matches `http-eof` retracts it and decides what to do with the
remains.

### `http-supported-content-type`

```clips
(deffacts http-supported-content-types
	(http-supported-content-type "application" "json")
	(http-supported-content-type "application" "octet-stream")
	(http-supported-content-type "application" "x-www-form-urlencoded"))
```

The content types the body rules know. A body with a `Content-Length` and a
`Content-Type` that is not listed here decodes as an `HTTP-OCTET-STREAM`.
Each listed type has its own body rule:

| type/subtype | body |
|---|---|
| `application/octet-stream`, or no `Content-Type` | `HTTP-OCTET-STREAM` |
| `application/x-www-form-urlencoded` | `HTTP-X-WWW-FORM-URLENCODED` |
| `application/json` | none: the body stays on the stream for COOLJSON to read after the `HTTP-MESSAGE` exists; `HTTP-MESSAGE-BODY` has `value nil` |
| `multipart/*` with a `boundary` parameter | `HTTP-MULTIPART-BODY` (not a listed fact; detected by the parameter) |
| `Transfer-Encoding: chunked` | `HTTP-CHUNKED-BODY`, whichever `Content-Type` |

A sibling codec that handles another type asserts its own
`http-supported-content-type` fact and adds a rule that consumes the LF after
the header section for that type. Adding the fact alone leaves the body
undecoded.

## Instances

### Shape

Every class is a subclass of `HTTP`, which has one slot, `id`, holding the id
from `http-parse`. Each class is one rule of the grammar in RFC 9110, 9111,
9112, 3986, 6265, 5322 and 2046, and its slots are the terms of that rule.

Slot values follow these conventions:

- **Strings.** Every token, number and name the decoder reads is a string.
  A `status-code` is `"200"`, an `HTTP-VERSION` `major` is `"1"`, a
  `Content-Length` `value` is `"49"`, a `first-2digit` of an `HTTP-TIME` is
  `"08"`. The one integer is `chunk-size` of `HTTP-CHUNK`.
- **Instances.** A slot that holds a sub-rule holds an instance name.
- **nil.** An optional term that is absent is `nil`.
- **Empty multislot.** An optional list that is absent is empty.
- **Booleans.** Flags are `TRUE` or `FALSE`.
- **Word slots.** A slot that may hold either a token or a quoted-string
  holds a string for the token and an `HTTP-QUOTED-STRING` instance for the
  quoted-string. The table below says "word" for these.

The `HTTP-MESSAGE` instance is made last. Its existence means the message is
complete and every instance under it is final. Before that point the parts
are a mix of instances and working facts.

`pprint` writes the message in canonical form, so optional whitespace from
the input is not kept.

### Message

| class | slots | notes |
|---|---|---|
| `HTTP-MESSAGE` | `start-line`, `field-lines` (multi), `message-body` | `start-line` is an `HTTP-REQUEST-LINE` or `HTTP-STATUS-LINE`. `field-lines` are `HTTP-FIELD-LINE` in input order. `message-body` is always an `HTTP-MESSAGE-BODY`. |
| `HTTP-REQUEST-LINE` | `method`, `request-target`, `http-version` | `request-target` is one of `HTTP-ORIGIN-FORM`, `HTTP-ABSOLUTE-URI`, `HTTP-AUTHORITY-FORM`, `HTTP-ASTERISK-FORM`. |
| `HTTP-STATUS-LINE` | `http-version`, `status-code`, `reason-phrase` | `status-code` is a three character string. |
| `HTTP-METHOD` | `value` | `"GET"`, `"POST"`, ... Also the elements of `Allow`. |
| `HTTP-VERSION` | `major`, `minor` | Strings. The slots `H`, `T`, `TT`, `P` exist and stay `nil`; the decoder does not use them. |
| `HTTP-REASON-PHRASE` | `value` | May be `""`. |

### Request target and URI (RFC 3986)

| class | slots | notes |
|---|---|---|
| `HTTP-ORIGIN-FORM` | `segments` (multi), `query` | `/path?query`. `segments` are `HTTP-SEGMENT`; an empty path gives no segments. `query` is an `HTTP-QUERY` or `nil`. |
| `HTTP-ABSOLUTE-URI` | `scheme`, `hier-part`, `query` | `scheme:hier-part?query` |
| `HTTP-URI` | `HTTP-ABSOLUTE-URI` + `fragment` | A URI with a `#fragment`, in a URI-reference header. |
| `HTTP-PARTIAL-URI` | `relative-part`, `query` | A relative reference in a URI-reference header. |
| `HTTP-RELATIVE-REF` | `HTTP-PARTIAL-URI` + `fragment` | |
| `HTTP-AUTHORITY-FORM` | `uri-host`, `port` | `CONNECT host:port`. `uri-host` is an `HTTP-HOST`, `port` an `HTTP-PORT`. |
| `HTTP-ASTERISK-FORM` | | `OPTIONS *` |
| `HTTP-SCHEME` | `value` | |
| `HTTP-HIER-PART` | `authority`, `path` | `authority` is an `HTTP-AUTHORITY` or `nil`. `path` is one of the `HTTP-PATH-*` classes or `nil`. |
| `HTTP-RELATIVE-PART` | `HTTP-HIER-PART` | |
| `HTTP-AUTHORITY` | `userinfo`, `host`, `port` | `userinfo` is an `HTTP-USERINFO` or `nil`; `host` an `HTTP-HOST`; `port` an `HTTP-PORT` or `nil`. |
| `HTTP-USERINFO` | `value` | Printed before `@`. |
| `HTTP-HOST` | `value` | An `HTTP-REG-NAME`, `HTTP-IPV4ADDRESS` or `HTTP-IP-LITERAL`. |
| `HTTP-REG-NAME` | `value` | `"example.com"` |
| `HTTP-IPV4ADDRESS` | `first-octet`, `second-octet`, `third-octet`, `fourth-octet` | Each an `HTTP-DEC-OCTET`. |
| `HTTP-DEC-OCTET` | `value` | String `"0"` to `"255"`. `hexdigs` is unused. |
| `HTTP-IP-LITERAL` | `value` | An `HTTP-IPV6ADDRESS`. Printed inside `[` `]`. |
| `HTTP-IPV6ADDRESS` | `parts` (multi) | `HTTP-H16` instances, at most one `"::"` string, and an `HTTP-IPV4ADDRESS` last when the address ends in dotted form. `pprint` puts `:` between adjacent instances. |
| `HTTP-H16` | `value` | One to four hex digits as a string. |
| `HTTP-PORT` | `value` | String. |
| `HTTP-PATH-ABEMPTY` | `segments` (multi) | `//authority/a/b`: begins with `/`, or is empty. |
| `HTTP-PATH-ABSOLUTE` | `segment-nz`, `segments` (multi) | `/a/b` with no authority. `segment-nz` is the first `HTTP-SEGMENT` or `nil` for a bare `/`. |
| `HTTP-PATH-NOSCHEME` | `segment-nz-nc`, `segments` (multi) | A relative path whose first segment has no `:`. |
| `HTTP-SEGMENT` | `value` | Percent-encoding is kept as read. |
| `HTTP-QUERY` | `value` | The text after `?`, not split. |
| `HTTP-FRAGMENT` | `value` | The text after `#`. |

### Field lines

| class | slots | notes |
|---|---|---|
| `HTTP-FIELD-LINE` | `field-name`, `field-value` | |
| `HTTP-FIELD-NAME` | `value` | As read, case kept. |
| `HTTP-FIELD-VALUE` | `value` | One header instance from the table below, chosen by the field name. |

The field name picks the class of the `HTTP-FIELD-VALUE` `value`. A name not
in this table gives an `HTTP-UNKNOWN-HEADER`. Names compare exactly as
listed.

| field name | class | slots |
|---|---|---|
| any other | `HTTP-UNKNOWN-HEADER` | `value`: the whole field value, trimmed |
| `Accept` | `HTTP-ACCEPT-HEADER` | `media-ranges` (multi): `HTTP-MEDIA-RANGE` |
| `Accept-Charset` | `HTTP-ACCEPT-CHARSET-HEADER` | `charsets` (multi): `HTTP-CHARSET` |
| `Accept-Encoding` | `HTTP-ACCEPT-ENCODING-HEADER` | `codings` (multi): `HTTP-CODING` |
| `Accept-Language` | `HTTP-ACCEPT-LANGUAGE-HEADER` | `language-ranges` (multi): `HTTP-LANGUAGE-RANGE` |
| `Accept-Ranges` | `HTTP-ACCEPT-RANGES-HEADER` | `tokens` (multi): strings |
| `Age` | `HTTP-AGE-HEADER` | `value`: string of digits |
| `Allow` | `HTTP-ALLOW-HEADER` | `methods` (multi): `HTTP-METHOD` |
| `Authentication-Info` | `HTTP-AUTHENTICATION-INFO-HEADER` | `auth-params` (multi): `HTTP-AUTH-PARAM` |
| `Authorization` | `HTTP-AUTHORIZATION-HEADER` | `auth-scheme`: string; `second-part` (multi): one `HTTP-TOKEN68`, or `HTTP-AUTH-PARAM`s, or empty |
| `Cache-Control` | `HTTP-CACHE-CONTROL-HEADER` | `cache-directives` (multi): `HTTP-CACHE-DIRECTIVE` |
| `Connection` | `HTTP-CONNECTION-HEADER` | `tokens` (multi): strings |
| `Content-Disposition` | `HTTP-CONTENT-DISPOSITION-HEADER` | `disposition-type`: string; `parameters` (multi): `HTTP-PARAMETER` |
| `Content-Encoding` | `HTTP-CONTENT-ENCODING-HEADER` | `tokens` (multi): strings |
| `Content-Language` | `HTTP-CONTENT-LANGUAGE-HEADER` | `language-tags` (multi): `HTTP-LANGUAGE-TAG` |
| `Content-Length` | `HTTP-CONTENT-LENGTH-HEADER` | `value`: string of digits |
| `Content-Location` | `HTTP-CONTENT-LOCATION-HEADER` | `uri-reference` |
| `Content-Range` | `HTTP-CONTENT-RANGE-HEADER` | `range-unit`: string; `range`: `HTTP-RANGE-RESP` or `HTTP-UNSATISFIED-RANGE` |
| `Content-Type` | `HTTP-CONTENT-TYPE-HEADER` | `type`: `HTTP-TYPE`; `subtype`: `HTTP-SUBTYPE`; `parameters` (multi): `HTTP-PARAMETER` |
| `Cookie` | `HTTP-COOKIE-HEADER` | `cookie-pairs` (multi): `HTTP-COOKIE-PAIR` |
| `Date` | `HTTP-DATE` | `http-date` |
| `ETag` | `HTTP-ETAG-HEADER` | `entity-tag`: `HTTP-ENTITY-TAG` |
| `Expect` | `HTTP-EXPECT-HEADER` | `expectations` (multi): `HTTP-EXPECTATION` |
| `Expires` | `HTTP-EXPIRES-HEADER` | `http-date`: a date or `HTTP-INVALID-DATE` |
| `From` | `HTTP-FROM-HEADER` | `mailbox`: `HTTP-ADDR-SPEC` or `HTTP-NAME-ADDR` |
| `Host` | `HTTP-HOST-HEADER` | `uri-host`: `HTTP-HOST`; `port`: `HTTP-PORT` or `nil` |
| `If-Match` | `HTTP-IF-MATCH-HEADER` | `entity-tags` (multi): `HTTP-ENTITY-TAG`, or the one string `"*"` |
| `If-Modified-Since` | `HTTP-IF-MODIFIED-SINCE-HEADER` | `http-date` |
| `If-None-Match` | `HTTP-IF-NONE-MATCH-HEADER` | `entity-tags` (multi): as `If-Match` |
| `If-Range` | `HTTP-IF-RANGE-HEADER` | `value`: `HTTP-ENTITY-TAG` or a date instance |
| `If-Unmodified-Since` | `HTTP-IF-UNMODIFIED-SINCE-HEADER` | `http-date` |
| `Last-Modified` | `HTTP-LAST-MODIFIED-HEADER` | `http-date` |
| `Location` | `HTTP-LOCATION-HEADER` | `uri-reference` |
| `Max-Forwards` | `HTTP-MAX-FORWARDS-HEADER` | `value`: string of digits |
| `Pragma` | `HTTP-PRAGMA-HEADER` | `cache-directives` (multi): `HTTP-CACHE-DIRECTIVE` |
| `Proxy-Authenticate` | `HTTP-PROXY-AUTHENTICATE-HEADER` | `challenges` (multi): `HTTP-CHALLENGE` |
| `Proxy-Authentication-Info` | `HTTP-PROXY-AUTHENTICATION-INFO-HEADER` | `auth-params` (multi): `HTTP-AUTH-PARAM` |
| `Proxy-Authorization` | `HTTP-PROXY-AUTHORIZATION-HEADER` | as `Authorization` |
| `Range` | `HTTP-RANGE-HEADER` | `ranges-specifier`: `HTTP-RANGES-SPECIFIER` |
| `Referer` | `HTTP-REFERER-HEADER` | `uri-reference` |
| `Retry-After` | `HTTP-RETRY-AFTER-HEADER` | `value`: a date instance or `HTTP-DELAY-SECONDS` |
| `Server` | `HTTP-SERVER-HEADER` | `values` (multi): `HTTP-PRODUCT` and `HTTP-COMMENT` |
| `Set-Cookie` | `HTTP-SET-COOKIE-HEADER` | `cookie-pair`: `HTTP-COOKIE-PAIR`; `cookie-avs` (multi): `HTTP-COOKIE-AV` |
| `TE` | `HTTP-TE-HEADER` | `t-codings` (multi): `HTTP-T-CODING` |
| `Trailer` | `HTTP-TRAILER-HEADER` | `tokens` (multi): strings |
| `Transfer-Encoding` | `HTTP-TRANSFER-ENCODING-HEADER` | `transfer-codings` (multi): `HTTP-TRANSFER-CODING` |
| `Upgrade` | `HTTP-UPGRADE-HEADER` | `protocols` (multi): `HTTP-PROTOCOL` |
| `User-Agent` | `HTTP-USER-AGENT-HEADER` | `values` (multi): `HTTP-PRODUCT` and `HTTP-COMMENT` |
| `Vary` | `HTTP-VARY-HEADER` | `tokens` (multi): strings |
| `Via` | `HTTP-VIA-HEADER` | `values` (multi): `HTTP-VIA-HEADER-VALUE` |
| `WWW-Authenticate` | `HTTP-WWW-AUTHENTICATE-HEADER` | `challenges` (multi): `HTTP-CHALLENGE` |

Several header classes share a parent that holds the slots and the `pprint`
handler. Match the parent to catch every member:

| parent | members |
|---|---|
| `HTTP-TOKEN-LIST-HEADER` (`tokens`) | `Connection`, `Accept-Ranges`, `Vary`, `Trailer`, `Content-Encoding` |
| `HTTP-URI-REFERENCE-HEADER` (`uri-reference`) | `Referer`, `Location`, `Content-Location` |
| `HTTP-PRODUCT-HEADER` (`values`) | `User-Agent`, `Server` |
| `HTTP-CACHE-DIRECTIVE-HEADER` (`cache-directives`) | `Cache-Control`, `Pragma` |
| `HTTP-DATE-HEADER` (`http-date`) | `Date` (class `HTTP-DATE`), `Last-Modified`, `If-Modified-Since`, `If-Unmodified-Since`, `Expires` |
| `HTTP-ENTITY-TAG-LIST-HEADER` (`entity-tags`) | `If-Match`, `If-None-Match` |
| `HTTP-CREDENTIALS-HEADER` (`auth-scheme`, `second-part`) | `Authorization`, `Proxy-Authorization` |
| `HTTP-AUTHENTICATE-HEADER` (`challenges`) | `WWW-Authenticate`, `Proxy-Authenticate` |
| `HTTP-AUTH-PARAMS-HEADER` (`auth-params`) | `Authentication-Info`, `Proxy-Authentication-Info` |

A `uri-reference` slot holds an `HTTP-URI`, `HTTP-ABSOLUTE-URI`,
`HTTP-RELATIVE-REF` or `HTTP-PARTIAL-URI`.

### Header value parts

| class | slots | notes |
|---|---|---|
| `HTTP-TYPE`, `HTTP-SUBTYPE` | `value` | `"text"`, `"html"` |
| `HTTP-PARAMETER` | `parameter-name`, `ext-token`, `parameter-value` | `name=value`. `parameter-value` is a word, or an `HTTP-EXT-VALUE` when `ext-token` is `TRUE` (`name*=`). `pprint` lowercases a `charset` parameter. |
| `HTTP-EXT-VALUE` | `charset`, `language`, `value-chars` | RFC 8187 `UTF-8'en'%e2%82%ac`. All strings; `language` may be `""`. Percent-encoding is kept. |
| `HTTP-QUOTED-STRING` | `value` | The text with quotes removed and escapes resolved. `pprint` re-escapes `"` and `\`. |
| `HTTP-MEDIA-RANGE` | `type`, `subtype`, `parameters` (multi), `weight` | `weight` is an `HTTP-WEIGHT` or `nil`. |
| `HTTP-WEIGHT` | `qvalue` | `;q=...`. `qvalue` is an `HTTP-QVALUE`. |
| `HTTP-QVALUE` | `first`, `decimal`, `fraction` | `"0"`/`"1"`, `TRUE` when a `.` was read, the digits after it as a string. |
| `HTTP-CODING` | `codings`, `weight` | `codings` is the string (`"gzip"`, `"*"`). |
| `HTTP-CHARSET` | `charset`, `weight` | |
| `HTTP-LANGUAGE-TAG` | `first-language`, `languages` (multi) | `en-US`: `HTTP-LANGUAGE` instances. |
| `HTTP-LANGUAGE-RANGE` | `HTTP-LANGUAGE-TAG` + `weight` | |
| `HTTP-LANGUAGE` | `value` | One subtag. |
| `HTTP-PRODUCT` | `token`, `product-version` | `product-version` is a string or `nil`. |
| `HTTP-COMMENT` | `values` (multi) | `(text (nested))`. Strings and nested `HTTP-COMMENT` instances. |
| `HTTP-VIA-HEADER-VALUE` | `received-protocol`, `received-by`, `comment` | `comment` is an `HTTP-COMMENT` or `nil`. |
| `HTTP-RECEIVED-PROTOCOL` | `protocol-name`, `protocol-version` | `protocol-name` is `nil` for a bare `1.1`. |
| `HTTP-RECEIVED-BY` | `pseudonym`, `port` | Strings; `port` may be `nil`. |
| `HTTP-T-CODING` | `value`, `weight` | |
| `HTTP-TRANSFER-CODING` | `value`, `transfer-parameters` (multi) | `transfer-parameters` are `HTTP-AUTH-PARAM`. |
| `HTTP-EXPECTATION` | `token`, `value`, `parameters` (multi) | `value` is a word or `nil`. |
| `HTTP-CACHE-DIRECTIVE` | `token`, `value` | `value` is a word or `nil`. |
| `HTTP-PROTOCOL` | `protocol-name`, `protocol-version` | `protocol-version` may be `nil`. |
| `HTTP-ADDR-SPEC` | `local-part`, `domain` | `local-part` is a word. `domain` is a string or an `HTTP-DOMAIN-LITERAL`. |
| `HTTP-NAME-ADDR` | `display-name` (multi), `addr-spec` | `display-name` words; `addr-spec` an `HTTP-ADDR-SPEC`. |
| `HTTP-DOMAIN-LITERAL` | `value` | `[192.0.2.1]` without the brackets. |

### Range

| class | slots | notes |
|---|---|---|
| `HTTP-RANGES-SPECIFIER` | `range-unit`, `range-set` | `bytes=0-499`. `range-unit` is a string. |
| `HTTP-RANGE-SET` | `range-specs` (multi) | `HTTP-RANGE-SPEC` instances. |
| `HTTP-RANGE-SPEC` | `value` | An `HTTP-INT-RANGE`, `HTTP-SUFFIX-RANGE` or `HTTP-OTHER-RANGE`. |
| `HTTP-INT-RANGE` | `first-pos`, `last-pos` | Strings; `last-pos` is `""` for an open range like `500-`. |
| `HTTP-SUFFIX-RANGE` | `suffix-length` | `-500` |
| `HTTP-OTHER-RANGE` | `value` | |
| `HTTP-RANGE-RESP` | `incl-range`, `complete-length` | `0-499/1234`. `incl-range` is an `HTTP-INT-RANGE`; `complete-length` a string, `"*"` when unknown. |
| `HTTP-UNSATISFIED-RANGE` | `complete-length` | `*/1234` |

### Authentication

| class | slots | notes |
|---|---|---|
| `HTTP-TOKEN68` | `value`, `equals` | The base64-like text and the count of trailing `=` as an integer. |
| `HTTP-AUTH-PARAM` | `left-side`, `right-side` | `realm="x"`. `right-side` is a word. |
| `HTTP-CHALLENGE` | `auth-scheme`, `second-part` (multi) | One challenge of `WWW-Authenticate`. `second-part` as in `HTTP-CREDENTIALS-HEADER`. |

### Dates

| class | slots | notes |
|---|---|---|
| `HTTP-RFC1123-DATE` | `wkday`, `date1`, `time` | `Sun, 06 Nov 1994 08:49:37 GMT` |
| `HTTP-RFC850-DATE` | `day-name-l`, `date2`, `time` | `Sunday, 06-Nov-94 08:49:37 GMT` |
| `HTTP-ASCTIME-DATE` | `day-name`, `date3`, `time`, `year` | `Sun Nov  6 08:49:37 1994`. `day-name` is an `HTTP-WKDAY`. |
| `HTTP-INVALID-DATE` | `value` | `Expires: 0`, `Expires: -1`: the text as read. |
| `HTTP-WKDAY` | `value` | `"Mon"` |
| `HTTP-DAY-NAME-L` | `value` | `"Monday"` |
| `HTTP-MONTH` | `value` | `"Jan"` |
| `HTTP-DATE1` | `first-2digit`, `month`, `last-4digit` | Day, `HTTP-MONTH`, year. |
| `HTTP-DATE2` | `day`, `month`, `year` | Two-digit year as read. |
| `HTTP-DATE3` | `month`, `day`, `padded` | `padded` is `TRUE` when the day was written with a leading space. |
| `HTTP-TIME` | `first-2digit`, `second-2digit`, `third-2digit` | Hours, minutes, seconds. |
| `HTTP-DELAY-SECONDS` | `value` | `Retry-After: 120` |

A "date instance" in this document means one of `HTTP-RFC1123-DATE`,
`HTTP-RFC850-DATE` or `HTTP-ASCTIME-DATE`.

### Entity tags

| class | slots | notes |
|---|---|---|
| `HTTP-ENTITY-TAG` | `weak`, `opaque-tag` | `W/"xyzzy"`: `weak TRUE`, `opaque-tag "xyzzy"`. |

### Cookies (RFC 6265)

| class | slots | notes |
|---|---|---|
| `HTTP-COOKIE-PAIR` | `cookie-name`, `cookie-value`, `cookie-value-quoted` | `cookie-value` has the quotes removed; `cookie-value-quoted` is `TRUE` when it had them. It may be `""`. |
| `HTTP-COOKIE-AV` | `value` | One attribute of `Set-Cookie`. `value` is one of the classes below. |
| `HTTP-EXPIRES-AV` | `rfc1123-date` | `Expires=...`, an `HTTP-RFC1123-DATE`. |
| `HTTP-MAX-AGE-AV` | `value` | String of digits. |
| `HTTP-DOMAIN-AV` | `subdomain` | An `HTTP-SUBDOMAIN`. |
| `HTTP-SUBDOMAIN` | `ldh-labels` (multi), `top-label` | `www.example.com`: each `HTTP-LDH-LABEL` `value` keeps its trailing `.` (`"www."`); `top-label` is an `HTTP-TOP-LABEL`. |
| `HTTP-LDH-LABEL`, `HTTP-TOP-LABEL` | `value` | |
| `HTTP-PATH-AV` | `value` | `Path=/` |
| `HTTP-SECURE-AV` | | `Secure` |
| `HTTP-HTTPONLY-AV` | | `HttpOnly` |
| `HTTP-SAMESITE-AV` | `value` | An `HTTP-STRICT`, `HTTP-LAX` or `HTTP-NONE` instance. |
| `HTTP-STRICT`, `HTTP-LAX`, `HTTP-NONE` | | |
| `HTTP-EXTENSION-AV` | `value` | Any other attribute, as read. |

### Body

| class | slots | notes |
|---|---|---|
| `HTTP-MESSAGE-BODY` | `value` | Always present on an `HTTP-MESSAGE`. `value` is `nil` for no body (or a JSON body left on the stream), else one of the four classes below. |
| `HTTP-OCTET-STREAM` | `value` | The body as one string. |
| `HTTP-X-WWW-FORM-URLENCODED` | `sequences` (multi) | `HTTP-SEQUENCE` instances in order. |
| `HTTP-SEQUENCE` | `name-string`, `value-string` | `name=value`. `+` and percent-encoding are kept as read. |
| `HTTP-CHUNKED-BODY` | `chunks` (multi), `last-chunk`, `trailer-section` (multi), `content` | `chunks` are `HTTP-CHUNK`; `last-chunk` an `HTTP-LAST-CHUNK`; `trailer-section` are `HTTP-FIELD-LINE` with the same header classes as the header section; `content` is the joined chunk-data decoded by `Content-Type` as an `HTTP-OCTET-STREAM` or `HTTP-X-WWW-FORM-URLENCODED`. |
| `HTTP-CHUNK` | `chunk-size`, `chunk-ext` (multi) | `chunk-size` is an integer. The chunk-data is in the body's `content`, not here. |
| `HTTP-LAST-CHUNK` | `chunk-ext` (multi) | |
| `HTTP-CHUNK-EXT` | `chunk-ext-name`, `chunk-ext-val` | `chunk-ext-val` is a word or `nil`. |
| `HTTP-MULTIPART-BODY` | `boundary`, `preamble`, `body-parts` (multi) | `boundary` is the string from the `Content-Type` parameter. `preamble` is the text before the first delimiter, often `""`. |
| `HTTP-BODY-PART` | `mime-part-headers` (multi), `content` | `mime-part-headers` are `HTTP-FIELD-LINE`. `content` is a string, or `nil` when the part had no body. |

The decoder finds where a body ends like this: a `Transfer-Encoding` that
ends in `chunked` reads chunks; a multipart body reads to its close
delimiter and ignores `Content-Length`; otherwise it reads `Content-Length`
octets; with no `Content-Length` there is no body.

### Classes the decoder never makes

These exist for encoding, as abstract parents, or as grammar that no input
reaches: `HTTP`, `HTTP-IPVFUTURE`, `HTTP-PATH-ROOTLESS`, `HTTP-RANGE-UNIT`,
`HTTP-INCL-RANGE`, and the parent header classes listed above. `HTTP-IPVFUTURE`
and `HTTP-PATH-ROOTLESS` have no `pprint` handler.

## Message handlers

### `pprint`

```clips
(send ?instance pprint <logical-name>)
```

Every class the decoder makes answers `pprint`. It writes the instance as
HTTP to the logical name: `t` for stdout, the name of an open file, or a
socket from CLIPSockets. On an `HTTP-MESSAGE` it writes the start line, each
field line, the empty line, and the body, with CRLF line ends.

`pprint` is also the encoder. A program builds the same tree with
`make-instance` and sends `pprint`. The handlers accept the decoder's
conventions and a little more:

- A `nil` optional slot and an empty multislot are omitted.
- A slot documented as a string accepts an integer where it only prints it,
  so `(status-code 200)` and a `Content-Length` `(value 2)` work.
- An `HTTP-PARAMETER` with a string `parameter-value` prints it bare; with
  an `HTTP-QUOTED-STRING` prints it quoted and escaped.
- An `HTTP-CHUNKED-BODY` with no `chunks` writes its `content` as one chunk
  with its size in hex, then `0` and CRLF. With chunks, it divides the
  content by each `chunk-size`. A `nil` `last-chunk` prints as `0`.
- An `HTTP-MULTIPART-BODY` writes `--boundary` between parts and
  `--boundary--` after the last.
- `id` is not needed on instances a program makes.

### `to-string`

```clips
(send ?content to-string)
```

Returns the body content as one string. Defined on `HTTP-OCTET-STREAM`
(its `value`), `HTTP-SEQUENCE` (`name=value`) and
`HTTP-X-WWW-FORM-URLENCODED` (sequences joined with `&`). The chunked body
handler uses it to split the content into chunk-data.

## Example

```clips
(load program.clp)
(reset)
(open request.http req)
(assert (http-parse (stream req) (id req)) (http-ready (id req)))
(run)
```

```clips
;; the request's content length, when the message is complete
(defrule content-length
  (object (is-a HTTP-MESSAGE) (id ?id))
  (object (is-a HTTP-CONTENT-LENGTH-HEADER) (id ?id) (value ?n))
  =>
  (println ?id " carries " ?n " octets"))

;; every Set-Cookie of a response
(defrule cookies
  (object (is-a HTTP-MESSAGE) (id ?id))
  (object (is-a HTTP-SET-COOKIE-HEADER) (id ?id) (cookie-pair ?p))
  (object (is-a HTTP-COOKIE-PAIR) (name ?p) (cookie-name ?n) (cookie-value ?v))
  =>
  (println ?n "=" ?v))

;; the stream closed early
(defrule truncated
  ?e <- (http-eof (id ?id))
  =>
  (retract ?e)
  (println ?id " ended before its message was complete"))
```

The README shows a full response built with `make-instance` and written with
`pprint`.
