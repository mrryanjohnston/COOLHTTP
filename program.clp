; based on HTTP as it is defined in rfc9112
(defglobal ?*digit* = (create$ 48 49 50 51 52 53 54 55 56 57)) 
(defglobal ?*upalpha* = (create$ 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90)) 
(defglobal ?*lowalpha* = (create$ 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122)) 
(defglobal ?*alpha* = (create$ ?*upalpha* ?*lowalpha*))
(defglobal ?*alphanum* = (create$ ?*alpha* ?*digit*))
(defglobal ?*unreserved* = (create$ ?*alphanum* 45 46 95 126)) ; - . _ ~
(defglobal ?*gen-delims* = (create$ 58 47 63 35 91 93 64)) ; ":" / "/" / "?" / "#" / "[" / "]" / "@"
(defglobal ?*sub-delims* = (create$ 33 36 38 39 40 41 42 43 44 59 61)) ; "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="
(defglobal ?*reserved* = (create$ ?*gen-delims* ?*sub-delims*))
(defglobal ?*hex-without-dig* = (create$ 65 66 67 68 69 70 97 98 99 100 101 102)) ; 0-9 A-F a-f
(defglobal ?*hexdig* = (create$ ?*digit* ?*hex-without-dig*))
(defglobal ?*methods* = (create$ "OPTIONS" "GET" "HEAD" "PATCH" "POST" "PUT" "DELETE" "TRACE" "CONNECT"))
;      pchar         = unreserved / pct-encoded / sub-delims / ":" / "@"
(defglobal ?*pchar* = (create$ ?*unreserved* ?*sub-delims* 58 64)) ; : @
;      reg-name    = *( unreserved / pct-encoded / sub-delims )
(defglobal ?*reg-name* = (create$ ?*unreserved* ?*sub-delims*))
(defglobal ?*reg-name-no-digits* = (create$ ?*alpha* ?*sub-delims* 45 95 126)) ; - _ ~
;     userinfo      = *( unreserved | escaped |
;                        ";" | ":" | "&" | "=" | "+" | "$" | "," )
;   userinfo      = *( unreserved / pct-encoded / sub-delims / ":" )
(defglobal ?*userinfo* = (create$ ?*unreserved* ?*sub-delims* 58))
;       scheme      = ALPHA *( ALPHA / DIGIT / "+" / "-" / "." )
(defglobal ?*scheme* = (create$ ?*alphanum* 38 45 46)) ; + - .
;    query         = *( pchar / "/" / "?" )
(defglobal ?*query* = (create$ ?*pchar* 47 63)) ; / ?

; tchar = "!" / "#" / "$" / "%" / "&" / "'" / "*" / "+" / "-" / "." /
;         "^" / "_" / "`" / "|" / "~" / DIGIT / ALPHA
(defglobal ?*tchar* = (create$ ?*alphanum* 33 35 36 37 38 39 42 43 45 46 94 95 96 124 126)) ; ! # $ % & ' * + - . ^ _ ` | ~
(defglobal ?*ctext* = (create$ ?*alphanum* 9 32 33 34 35 36 37 38 39 42 43 44 45 46 47 58 59 60 61 62 63 64 91 93 94 95 123 124 125 126)) ; HTAB SP ! " # $ % & ' * + , - . / : ; < = > ? @ [ ] ^ _ { | } ~
(defglobal ?*other-range* = (create$ ?*alphanum* 33 34 35 36 37 38 39 40 41 42 43 45 46 47 58 59 60 61 62 63 64 91 92 93 94 95 96 123 124 125 126)) ; ! " # $ % & ' ( ) * + - . / 0-9 : ; < = > ? @ A-Z [ \ ] ^ _ ` a-z { | } ~
(defglobal ?*token68* = (create$ ?*alphanum* 43 45 46 47 95 126)) ;  ALPHA / DIGIT / "+" / "/" / "-" / "." / "_" / "~"
(defglobal ?*cookie-octet* = (create$ ?*alphanum* 33 35 36 37 38 39 40 41 42 43 45 46 47 58 60 61 62 63 64 91 93 94 95 96 123 124 125 126)) ; ! # $ % & ' ( ) * + - . / : < = > ? @ [ ] ^ _ ` { | } ~

;    pct-encoded   = "%" HEXDIG HEXDIG
(deftemplate pct-encoded
	(slot name)
	(slot first))
(deftemplate escapable-sequence
	(slot name)
	(slot sequence (default ""))
	(slot pct-encoded)
	(multislot allowed-chars))

;   HTTP-message   = start-line CRLF
;                    *( field-line CRLF )
;                    CRLF
;                    [ message-body ]
(deftemplate http-message
	(slot name)
;   start-line     = request-line / status-line
	(slot start-line)
	(multislot field-lines)
	(slot message-body))

; status-line = HTTP-version SP status-code SP [ reason-phrase ]
(deftemplate status-line
	(slot name)
	(slot http-version)
	(slot status-code (default ""))
	(slot reason-phrase))

; request-line   = method SP request-target SP HTTP-version
(deftemplate request-line
	(slot name)
;   method         = token
	(slot method)
;   request-target = origin-form
;                  / absolute-form
;                  / authority-form
;                  / asterisk-form
	(slot request-target)
;   HTTP-version  = HTTP-name "/" DIGIT "." DIGIT
;   HTTP-name     = %s"HTTP"
	(slot http-version))

(deftemplate method
	(slot name)
	(slot value (default "")))

;   origin-form    = absolute-path [ "?" query ]
(deftemplate origin-form
	(slot name)
;       absolute-path = 1*( "/" segment )
	(multislot segments)
	(slot query))

; https://datatracker.ietf.org/doc/html/rfc9112#section-3.2.2
;   absolute-form  = absolute-URI
; https://datatracker.ietf.org/doc/html/rfc3986#section-4.3
;   absolute-URI  = scheme ":" hier-part [ "?" query ]
(deftemplate absolute-uri
	(slot name)
;       scheme        = ALPHA *( ALPHA / DIGIT / "+" / "-" / "." )
	(slot scheme)
	(slot hier-part)
	(slot query))

; scheme        = alpha *( alpha | digit | "+" | "-" | "." )
(deftemplate scheme
	(slot name)
	(slot value))

;   asterisk-form  = "*"

;    hier-part     = "//" authority path-abempty
;                  / path-absolute
;                  / path-rootless
;                  / path-empty
(deftemplate hier-part
	(slot name)
	(slot authority)
	(slot path))

;       authority     = [ userinfo "@" ] host [ ":" port ]
(deftemplate authority
	(slot name)
;       userinfo      = *( unreserved / pct-encoded / sub-delims / ":" )
	(slot userinfo)
;       host          = IP-literal / IPv4address / reg-name
	(slot host)
;       port          = *DIGIT
	(slot port))

(deftemplate userinfo
	(slot name)
	(slot value))

(deftemplate host
	(slot name)
	(slot value))

(deftemplate port
	(slot name)
	(slot value (default "")))

;    IP-literal    = "[" ( IPv6address / IPvFuture  ) "]"
(deftemplate ip-literal
	(slot name)
	(slot value))

;   IPv6address   =                            6( h16 ":" ) ls32
;                 /                       "::" 5( h16 ":" ) ls32
;                 / [               h16 ] "::" 4( h16 ":" ) ls32
;                 / [ *1( h16 ":" ) h16 ] "::" 3( h16 ":" ) ls32
;                 / [ *2( h16 ":" ) h16 ] "::" 2( h16 ":" ) ls32
;                 / [ *3( h16 ":" ) h16 ] "::"    h16 ":"   ls32
;                 / [ *4( h16 ":" ) h16 ] "::"              ls32
;                 / [ *5( h16 ":" ) h16 ] "::"              h16
;                 / [ *6( h16 ":" ) h16 ] "::"
(deftemplate ipv6address
	(slot name)
	(multislot parts))
;    h16           = 1*4HEXDIG
(deftemplate h16
	(slot name)
	(slot value (default "")))

;
;                                        same as ?*userinfo* 
;   IPvFuture     = "v" 1*HEXDIG "." 1*( unreserved / sub-delims / ":" )
(deftemplate ipvfuture
	(slot hexdigs)
	(slot value)) 

;       IPv4address = dec-octet "." dec-octet "." dec-octet "." dec-octet
;       dec-octet   = DIGIT                 ; 0-9
;                   / %x31-39 DIGIT         ; 10-99
;                   / "1" 2DIGIT            ; 100-199
;                   / "2" %x30-34 DIGIT     ; 200-249
;                   / "25" %x30-35          ; 250-255
(deftemplate ipv4address
	(slot name)
	(multislot octets))
(deftemplate dec-octet
	(slot name)
	(slot first-digit (default ""))
	(slot second-digit (default ""))
	(slot third-digit (default "")))

;       reg-name    = *( unreserved / pct-encoded / sub-delims )
(deftemplate reg-name
	(slot name)
	(slot value))

;       authority-form = uri-host ":" port
(deftemplate authority-form
	(slot name)
	(slot uri-host)
	(slot port))

;       path-abempty  = *( "/" segment )
(deftemplate path-abempty
	(slot name)
	(multislot segments))

;       path-absolute = "/" [ segment-nz *( "/" segment ) ]
(deftemplate path-absolute
	(slot name)
	(slot segment-nz)
	(multislot segments))

;       path-rootless = segment-nz *( "/" segment )
(deftemplate path-rootless
	(slot name)
	(slot segment-nz) ; non-zero length
	(multislot segments))

(deftemplate segment
	(slot name)
	(slot value))

(deftemplate http-version
	(slot name)
	(slot H)
	(slot T)
	(slot TT)
	(slot P)
	(slot major)
	(slot minor))

(deftemplate field-line
	(slot name)
	(slot field-name)
	(slot field-value))

(deftemplate field-name
	(slot name)
	(slot value (default "")))

(deftemplate field-value
	(slot name)
	(slot value)
	(slot possible-ows (default "")))

(deftemplate unknown-header
	(slot name)
	(slot value (default ""))
	(slot possible-ows (default "")))

(deftemplate accept-encoding-header
	(slot name)
	(multislot codings))

(deftemplate coding
	(slot name)
	(slot codings)
	(slot weight))

(deftemplate weight
	(slot name)
	(slot q)
	(slot equals)
	(slot qvalue))

(deftemplate qvalue
	(slot name)
	(slot first)
	(slot decimal)
	(slot fraction (default "")))

(deftemplate content-length-header
	(slot name)
	(slot value (default "")))

;   Max-Forwards = 1*DIGIT
(deftemplate max-forwards-header
	(slot name)
	(slot value (default "")))

(deftemplate content-type-header
	(slot name)
	(slot type)
	(slot subtype)
	(multislot parameters))

(deftemplate host-header
	(slot name)
	(slot uri-host)
	(slot port))

(deftemplate type
	(slot name)
	(slot value (default "")))

(deftemplate subtype
	(slot name)
	(slot value (default "")))

(deftemplate parameter
	(slot name)
	(slot parameter-name)
	(slot parameter-value))

(deftemplate token
	(slot name)
	(slot value (default "")))

(deftemplate quoted-string
	(slot name)
	(slot value (default "")))

(deftemplate message-body
	(slot name)
	(slot value)
	(slot length-remaining))

(deftemplate octet-stream
	(slot name)
	(slot value (default "")))

(deftemplate x-www-form-urlencoded
	(slot name)
	(multislot sequences))

(deftemplate sequence
	(slot name)
	(slot name-string (default ""))
	(slot value-string))

(deftemplate reason-phrase
	(slot name)
	(slot value (default "")))

;  Via = #( received-protocol RWS received-by [ RWS comment ] )
;   User-Agent = product *( RWS ( product / comment ) )
;   Server     = product *( RWS ( product / comment ) )
(deftemplate product-header
	(slot name)
	(multislot values) ; product / comment facts, then PRODUCT / COMMENT instances
	(slot rws (default FALSE)))

;   product         = token [ "/" product-version ]
;   product-version = token
(deftemplate product
	(slot name)
	(slot token)
	(slot product-version))

(deftemplate via-header
	(slot name)
	(multislot values))

(deftemplate via-header-value
	(slot name)
	(slot received-protocol)
	(slot received-by)
	(slot comment)
	(slot rws))

;   received-protocol = [ protocol-name "/" ] protocol-version
(deftemplate received-protocol
	(slot name)
	(slot protocol-name)
	(slot protocol-version))

;  received-by       = pseudonym [ ":" port ]
(deftemplate received-by
	(slot name)
;  pseudonym         = token
	(slot pseudonym)
	(slot port))

;comment = "(" *( ctext / quoted-pair / comment ) ")"
;ctext = HTAB / SP / %x21-27 ; '!'-'''
; / %x2A-5B ; '*'-'['
; / %x5D-7E ; ']'-'~'
; / obs-text
(deftemplate comment
	(slot name)
	(multislot values))
	
;  received-by       = pseudonym [ ":" port ]

(deftemplate accept-header
	(slot name)
	(multislot media-ranges))

(deftemplate media-range
	(slot name)
	(slot type)
	(slot subtype)
	(multislot parameters)
	(slot weight))

(deftemplate accept-language-header
	(slot name)
	(multislot language-ranges))

(deftemplate language-range
	(slot name)
	(slot first-language)
	(multislot languages)
	(slot weight))

(deftemplate language
	(slot name)
	(slot value (default "")))

(deftemplate allow-header
	(slot name)
	(multislot methods))

; Connection = #connection-option ; connection-option = token
; Accept-Ranges = 1#range-unit ; range-unit = token
; Vary = #( "*" / field-name ) ; field-name = token
; Trailer = #field-name
; Content-Encoding = #content-coding ; content-coding = token
(deftemplate token-list-header
	(slot name)
	(multislot tokens)) ; token fact while building, string once complete

(deftemplate te-header
	(slot name)
	(multislot t-codings))

(deftemplate t-coding
	(slot name)
	(slot value)
	(slot weight))

(deftemplate expect-header
	(slot name)
	(multislot expectations))

(deftemplate expectation
	(slot name)
	(slot token)
	(slot equals (default FALSE))
	(slot value)
	(multislot parameters))

; Cache-Control = #cache-directive ; cache-directive = token [ "=" ( token / quoted-string ) ]
; Pragma = #pragma-directive ; pragma-directive = "no-cache" / extension-pragma
;                            ; extension-pragma = token [ "=" ( token / quoted-string ) ]
(deftemplate cache-control-header
	(slot name)
	(multislot cache-directives))

(deftemplate cache-directive
	(slot name)
	(slot token)
	(slot equals (default FALSE))
	(slot value))

(deftemplate range-header
	(slot name)
	(slot ranges-specifier))

(deftemplate ranges-specifier
	(slot name)
	(slot range-unit)
	(slot range-set))

(deftemplate range-unit
	(slot name)
	(slot value))

(deftemplate range-set
	(slot name)
	(multislot range-specs))

(deftemplate range-spec
	(slot name)
	(slot value))

(deftemplate int-range
	(slot name)
	(slot first-pos (default ""))
	(slot last-pos))

(deftemplate suffix-range
	(slot name)
	(slot suffix-length))

(deftemplate other-range
	(slot name)
	(slot value))

(deftemplate upgrade-header
	(slot name)
	(multislot protocols))

(deftemplate protocol
	(slot name)
	(slot protocol-name)
	(slot protocol-version))

(deftemplate proxy-authorization-header
	(slot name)
	(slot auth-scheme)
	(multislot second-part))

(deftemplate token68
	(slot name)
	(slot value (default ""))
	(slot equals (default 0)))

(deftemplate auth-param
	(slot name)
	(slot left-side)
	(slot right-side))

(deftemplate cookie-header
	(slot name)
	(multislot cookie-pairs))

(deftemplate cookie-pair
	(slot name)
	(slot cookie-name)
	(slot cookie-value (default ""))
	(slot cookie-value-quoted))

(deftemplate set-cookie-header
	(slot name)
	(slot cookie-pair)
	(multislot cookie-avs))

(deftemplate cookie-av
	(slot name)
	(slot string (default ""))
	(slot value)
	(slot required-sp))

(deftemplate expires-av
	(slot name)
	(slot rfc1123-date))

(deftemplate rfc1123-date
	(slot name)
	(slot wkday)
	(slot date1)
	(slot time)
	(slot GMT (default "")))

(deftemplate wkday
	(slot name)
	(slot value (default "")))

(deftemplate date1
	(slot name)
	(slot first-2digit (default ""))
	(slot month)
	(slot last-4digit (default "")))

(deftemplate month
	(slot name)
	(slot value (default "")))

(deftemplate time
	(slot name)
	(slot first-2digit (default ""))
	(slot first-colon)
	(slot second-2digit (default ""))
	(slot second-colon)
	(slot third-2digit (default "")))

;   HTTP-date    = IMF-fixdate / obs-date
;   IMF-fixdate  = day-name "," SP date1 SP time-of-day SP GMT ; identical to rfc1123-date
;   obs-date     = rfc850-date / asctime-date
;   rfc850-date  = day-name-l "," SP date2 SP time-of-day SP GMT
;   date2        = day "-" month "-" 2DIGIT
;   asctime-date = day-name SP date3 SP time-of-day SP year
;   date3        = month SP ( 2DIGIT / ( SP 1DIGIT ))
(deftemplate http-date-header
	(slot name)
	(slot http-date)) ; day-name fact, then rfc1123-date / rfc850-date / asctime-date fact, then instance

(deftemplate day-name
	(slot name)
	(slot value (default "")))

(deftemplate rfc850-date
	(slot name)
	(slot day-name-l)
	(slot date2)
	(slot time)
	(slot GMT (default "")))

(deftemplate date2
	(slot name)
	(slot day (default ""))
	(slot month)
	(slot year (default "")))

(deftemplate asctime-date
	(slot name)
	(slot day-name)
	(slot date3)
	(slot time)
	(slot year (default "")))

(deftemplate date3
	(slot name)
	(slot month)
	(slot day (default ""))
	(slot padded (default FALSE)))

;  rfc1123-date = wkday "," SP date1 SP time SP "GMT"

(deftemplate max-age-av
	(slot name)
	(slot first-digit)
	(slot rest (default ""))
)

(deftemplate domain-av
	(slot name)
	(slot subdomain)
)

(deftemplate path-av
	(slot name)
	(slot value (default "")))

(deftemplate secure-av
	(slot name)
)

(deftemplate httponly-av
	(slot name)
)

(deftemplate samesite-av
	(slot name)
	(slot value)
)

(deftemplate lax
	(slot name)
	(slot a)
	(slot x))

(deftemplate strict
	(slot name)
	(slot t)
	(slot r)
	(slot i)
	(slot c)
	(slot last-t))

(deftemplate none
	(slot name)
	(slot o)
	(slot n)
	(slot e))

(deftemplate subdomain
	(slot name)
	(multislot ldh-labels)
	(slot top-label))

(deftemplate top-label
	(slot name)
	(slot value))

(deftemplate ldh-label
	(slot name)
	(slot value))

;cookie-av         = expires-av / max-age-av / domain-av /
;                    path-av / secure-av / httponly-av /
;                    samesite-av / extension-av

(deffacts supported-content-types
	(supported-content-type "application" "octet-stream")
	(supported-content-type "application" "x-www-form-urlencoded"))

(defclass HTTP (is-a USER) (slot filename))
(defclass HTTP-MESSAGE (is-a HTTP) (slot start-line) (multislot field-lines) (slot message-body))
(defclass REQUEST-LINE (is-a HTTP) (slot method) (slot request-target) (slot http-version))
(defclass METHOD (is-a HTTP) (slot value))
(defclass ORIGIN-FORM (is-a HTTP) (multislot segments) (slot query))
(defclass ABSOLUTE-URI (is-a HTTP) (slot scheme) (slot hier-part) (slot query))
(defclass ASTERISK-FORM (is-a HTTP))
(defclass AUTHORITY-FORM (is-a HTTP) (slot uri-host) (slot port))
(defclass SCHEME (is-a HTTP) (slot value))
(defclass USERINFO (is-a HTTP) (slot value))
(defclass HIER-PART (is-a HTTP) (slot authority) (slot path))
(defclass AUTHORITY (is-a HTTP) (slot userinfo) (slot host) (slot port))
(defclass IP-LITERAL (is-a HTTP) (slot value))
(defclass IPV6ADDRESS (is-a HTTP) (multislot parts))
(defclass H16 (is-a HTTP) (slot value))
(defclass DEC-OCTET (is-a HTTP) (slot hexdigs) (slot value)) 
(defclass IPVFUTURE (is-a HTTP) (slot hexdigs) (slot value)) 
(defclass IPV4ADDRESS (is-a HTTP) (slot first-octet) (slot second-octet) (slot third-octet) (slot fourth-octet))
(defclass REG-NAME (is-a HTTP) (slot value))
(defclass HOST (is-a HTTP) (slot value))
(defclass PORT (is-a HTTP) (slot value))
(defclass PATH-ABEMPTY (is-a HTTP) (multislot segments))
(defclass PATH-ABSOLUTE (is-a HTTP) (slot segment-nz) (multislot segments))
(defclass PATH-ROOTLESS (is-a HTTP) (slot segment-nz) (multislot segments))
(defclass SEGMENT (is-a HTTP) (slot value))
(defclass PARAMETER (is-a HTTP) (slot parameter-name) (slot parameter-value))
(defclass QUERY (is-a HTTP) (slot value))
(defclass HTTP-VERSION (is-a HTTP) (slot H) (slot T) (slot TT) (slot P) (slot major) (slot minor))
(defclass FIELD-LINE (is-a HTTP) (slot field-name) (slot field-value))
(defclass FIELD-NAME (is-a HTTP) (slot value))
(defclass FIELD-VALUE (is-a HTTP) (slot value))
(defclass TYPE (is-a HTTP) (slot value))
(defclass SUBTYPE (is-a HTTP) (slot value))
(defclass UNKNOWN-HEADER (is-a HTTP) (slot value))
(defclass ACCEPT-ENCODING-HEADER (is-a HTTP) (multislot codings))
(defclass CONTENT-LENGTH-HEADER (is-a HTTP) (slot value))
(defclass MAX-FORWARDS-HEADER (is-a HTTP) (slot value))
(defclass CONTENT-TYPE-HEADER (is-a HTTP) (slot type) (slot subtype) (multislot parameters))
(defclass VIA-HEADER (is-a HTTP) (multislot values))
(defclass VIA-HEADER-VALUE (is-a HTTP) (slot received-protocol) (slot received-by) (slot comment))
(defclass PRODUCT-HEADER (is-a HTTP) (multislot values))
(defclass USER-AGENT-HEADER (is-a PRODUCT-HEADER))
(defclass SERVER-HEADER (is-a PRODUCT-HEADER))
(defclass PRODUCT (is-a HTTP) (slot token) (slot product-version))
(defclass HOST-HEADER (is-a HTTP) (slot uri-host) (slot port))
(defclass QUOTED-STRING (is-a HTTP) (slot value))
(defclass MESSAGE-BODY (is-a HTTP) (slot value))
(defclass OCTET-STREAM (is-a HTTP) (slot value))
(defclass X-WWW-FORM-URLENCODED (is-a HTTP) (multislot sequences))
(defclass SEQUENCE (is-a HTTP) (slot name-string) (slot value-string))
(defclass STATUS-LINE (is-a HTTP) (slot http-version) (slot status-code) (slot reason-phrase))
(defclass REASON-PHRASE (is-a HTTP) (slot value))
(defclass RECEIVED-PROTOCOL (is-a HTTP) (slot protocol-name) (slot protocol-version))
(defclass RECEIVED-BY (is-a HTTP) (slot pseudonym) (slot port))
(defclass COMMENT (is-a HTTP) (multislot values))
(defclass CODING (is-a HTTP) (slot codings) (slot weight))
(defclass WEIGHT (is-a HTTP) (slot qvalue))
(defclass QVALUE (is-a HTTP) (slot first) (slot decimal) (slot fraction))
(defclass ACCEPT-HEADER (is-a HTTP) (multislot media-ranges))
(defclass MEDIA-RANGE (is-a HTTP) (slot type) (slot subtype) (multislot parameters) (slot weight))
(defclass ACCEPT-LANGUAGE-HEADER (is-a HTTP) (multislot language-ranges))
(defclass LANGUAGE-RANGE (is-a HTTP) (slot first-language) (multislot languages) (slot weight))
(defclass LANGUAGE (is-a HTTP) (slot value))
(defclass ALLOW-HEADER (is-a HTTP) (multislot methods))
(defclass TOKEN-LIST-HEADER (is-a HTTP) (multislot tokens))
(defclass CONNECTION-HEADER (is-a TOKEN-LIST-HEADER))
(defclass ACCEPT-RANGES-HEADER (is-a TOKEN-LIST-HEADER))
(defclass VARY-HEADER (is-a TOKEN-LIST-HEADER))
(defclass TRAILER-HEADER (is-a TOKEN-LIST-HEADER))
(defclass CONTENT-ENCODING-HEADER (is-a TOKEN-LIST-HEADER))
(defclass TE-HEADER (is-a HTTP) (multislot t-codings))
(defclass T-CODING (is-a HTTP) (slot value) (slot weight))
(defclass EXPECT-HEADER (is-a HTTP) (multislot expectations))
(defclass EXPECTATION (is-a HTTP) (slot token) (slot value) (multislot parameters))
(defclass CACHE-DIRECTIVE-HEADER (is-a HTTP) (multislot cache-directives))
(defclass CACHE-CONTROL-HEADER (is-a CACHE-DIRECTIVE-HEADER))
(defclass PRAGMA-HEADER (is-a CACHE-DIRECTIVE-HEADER))
(defclass CACHE-DIRECTIVE (is-a HTTP) (slot token) (slot value))
(defclass RANGE-HEADER (is-a HTTP) (slot ranges-specifier))
(defclass RANGES-SPECIFIER (is-a HTTP) (slot range-unit) (slot range-set))
(defclass RANGE-UNIT (is-a HTTP) (slot value))
(defclass RANGE-SET (is-a HTTP) (multislot range-specs))
(defclass INT-RANGE (is-a HTTP) (slot first-pos) (slot last-pos))
(defclass SUFFIX-RANGE (is-a HTTP) (slot suffix-length))
(defclass OTHER-RANGE (is-a HTTP) (slot value))
(defclass RANGE-SPEC (is-a HTTP) (slot value))
(defclass UPGRADE-HEADER (is-a HTTP) (multislot protocols))
(defclass PROTOCOL (is-a HTTP) (slot protocol-name) (slot protocol-version))
(defclass PROXY-AUTHORIZATION-HEADER (is-a HTTP) (slot auth-scheme) (multislot second-part))
(defclass TOKEN68 (is-a HTTP) (slot value) (slot equals))
(defclass AUTH-PARAM (is-a HTTP) (slot left-side) (slot right-side))
(defclass COOKIE-HEADER (is-a HTTP) (multislot cookie-pairs))
(defclass COOKIE-PAIR (is-a HTTP) (slot cookie-name) (slot cookie-value) (slot cookie-value-quoted))
(defclass SECURE-AV (is-a HTTP))
(defclass MAX-AGE-AV (is-a HTTP) (slot value))
(defclass PATH-AV (is-a HTTP) (slot value))
(defclass HTTPONLY-AV (is-a HTTP))
(defclass EXTENSION-AV (is-a HTTP) (slot value))
(defclass EXPIRES-AV (is-a HTTP) (slot rfc1123-date))
(defclass STRICT (is-a HTTP))
(defclass LAX (is-a HTTP))
(defclass NONE (is-a HTTP))
(defclass WKDAY (is-a HTTP) (slot value))
(defclass MONTH (is-a HTTP) (slot value))
(defclass DATE1 (is-a HTTP) (slot first-2digit) (slot month) (slot last-4digit))
(defclass TIME (is-a HTTP) (slot first-2digit) (slot second-2digit) (slot third-2digit))
(defclass RFC1123-DATE (is-a HTTP) (slot wkday) (slot date1) (slot time))
(defclass HTTP-DATE-HEADER (is-a HTTP) (slot http-date))
(defclass DATE-HEADER (is-a HTTP-DATE-HEADER))
(defclass LAST-MODIFIED-HEADER (is-a HTTP-DATE-HEADER))
(defclass IF-MODIFIED-SINCE-HEADER (is-a HTTP-DATE-HEADER))
(defclass IF-UNMODIFIED-SINCE-HEADER (is-a HTTP-DATE-HEADER))
(defclass DAY-NAME-L (is-a HTTP) (slot value))
(defclass RFC850-DATE (is-a HTTP) (slot day-name-l) (slot date2) (slot time))
(defclass DATE2 (is-a HTTP) (slot day) (slot month) (slot year))
(defclass ASCTIME-DATE (is-a HTTP) (slot day-name) (slot date3) (slot time) (slot year))
(defclass DATE3 (is-a HTTP) (slot month) (slot day) (slot padded))
(defclass SET-COOKIE-HEADER (is-a HTTP) (slot cookie-pair) (multislot cookie-avs))
(defclass COOKIE-AV (is-a HTTP) (slot value))
(defclass DOMAIN-AV (is-a HTTP) (slot subdomain))
(defclass SUBDOMAIN (is-a HTTP) (multislot ldh-labels) (slot top-label))
(defclass TOP-LABEL (is-a HTTP) (slot value))
(defclass LDH-LABEL (is-a HTTP) (slot value))
(defclass SAMESITE-AV (is-a HTTP) (slot value))

(defrule initialize-request
	(filename ?name)
	=>
	(assert
		(char ?name (get-char ?name))
		;(start ?name (time))
		(http-message (name ?name) (start-line (assert (request-line (name ?name) (method (assert (method (name ?name))))))))))

(defrule build-method
	?c <- (char ?name ?char&65|67|68|69|71|72|73|76|78|79|80|82|83|84|85) ; A|C|D|E|G|H|I|L|N|O|P|R|S|T|U
	?m <- (method (name ?name) (value ?value&~"H"&:(> 7 (str-length ?value))))
	=>
	(retract ?c)
	(modify ?m (value (format nil "%s%c" ?value ?char)))
	(assert (char ?name (get-char ?name))))

(defrule continue-method-when-head
	?c <- (char ?name ?char&69) ; E
	?m <- (method (name ?name) (value "H"))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?m (value "HE")))

(defrule find-http-version-instead-of-method
	?c <- (char ?name 84) ; T
	?m <- (method (name ?name) (value "H"))
	?r <- (request-line (method ?m))
	?h <- (http-message (start-line ?r))
	=>
	(retract ?c ?m ?r)
	(modify ?h (start-line (assert (status-line (name ?name) (http-version (assert (http-version (name ?name) (H TRUE) (T TRUE))))))))
	(assert (char ?name (get-char ?name))))

(defrule status-line-http-version-end
	?c <- (char ?name 32) ; SP
	?h <- (http-version (name ?name) (major ?major) (minor ?minor&~nil))
	?s <- (status-line (http-version ?h))
	=>
	(retract ?c ?h)
	(modify ?s (http-version (make-instance of HTTP-VERSION (filename ?name) (major ?major) (minor ?minor))))
	(assert (char ?name (get-char ?name))))

(defrule status-line-build-status-code
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?s <- (status-line (name ?name) (http-version ?h&:(instancep ?h)) (status-code ?status-code&:(> 3 (str-length ?status-code))))
	=>
	(retract ?c)
	(modify ?s (status-code (format nil "%s%c" ?status-code ?char)))
	(assert (char ?name (get-char ?name))))

(defrule status-line-initialize-reason-phrase
	?c <- (char ?name 32) ; SP
	?s <- (status-line (name ?name) (status-code ?status-code&:(= 3 (str-length ?status-code))) (reason-phrase nil))
	=>
	(retract ?c)
	(modify ?s (reason-phrase (assert (reason-phrase (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule build-reason-phrase
	?c <- (char ?name ?char)
	?r <- (reason-phrase (name ?name) (value ?value))
	(test (or
		(= 9 ?char)
		(= 32 ?char)
		(and (>= ?char 33) (<= ?char 126)) ; VCHAR
		(and (>= ?char 128) (<= ?char 255)))) ; obs-text
	=>
	(retract ?c)
	(modify ?r (value (format nil "%s%c" ?value ?char)))
	(assert (char ?name (get-char ?name))))

(defrule status-line-end-reason-phrase
	?c <- (char ?name 13) ; CR
	?r <- (reason-phrase (name ?name) (value ?value))
	?s <- (status-line (reason-phrase ?r))
	=>
	(retract ?c ?r)
	(modify ?s (reason-phrase (make-instance of REASON-PHRASE (filename ?name) (value ?value))))
	(assert (char ?name (get-char ?name))))

(defrule status-line-end
	?c <- (char ?name 10) ; LF
	?s <- (status-line (http-version ?http-version) (status-code ?status-code) (reason-phrase ?reason-phrase&:(instancep ?reason-phrase)))
	?h <- (http-message (name ?name) (start-line ?s))
	=>
	(retract ?c ?s)
	(modify ?h (start-line (make-instance of STATUS-LINE (filename ?name) (http-version ?http-version) (status-code ?status-code) (reason-phrase ?reason-phrase))))
	(assert (char ?name (get-char ?name))))

(defrule end-method
	?c <- (char ?name 32)
	?m <- (method (name ?name) (value ?value&:(member$ ?value ?*methods*)))
	?r <- (request-line (method ?m))
	=>
	(retract ?c ?m)
	(modify ?r (method (make-instance of METHOD (filename ?name) (value ?value))))
	(assert (char ?name (get-char ?name))))
 
;   request-target = origin-form
;                  / absolute-form
;                  / authority-form
;                  / asterisk-form
(defrule start-request-target-origin-form
	?c <- (char ?name 47) ; /
	?r <- (request-line (name ?name) (method ?method&:(instancep ?method)) (request-target nil))
	=>
	(retract ?c)
	(modify ?r (request-target (assert (origin-form (name ?name) (segments (assert (segment (name ?name) (value (assert (escapable-sequence (name ?name) (allowed-chars ?*pchar*)))))))))))
	(assert (char ?name (get-char ?name))))

(defrule start-request-target-authority-form
	(char ?name ?char&:(member$ ?char (create$ ?*alphanum* 91))) ; [
	?m <- (object (is-a METHOD) (value "CONNECT"))
	?r <- (request-line (name ?name) (method =(instance-name ?m)) (request-target nil))
	=>
	(modify ?r (request-target (assert (authority-form (name ?name) (uri-host (assert (host (name ?name)))))))))

(defrule start-request-target-absolute-form
	?c <- (char ?name ?char&:(member$ ?char ?*alpha*))
	?m <- (object (is-a METHOD) (value ~"CONNECT"&~"OPTIONS"))
	?r <- (request-line (name ?name) (method =(instance-name ?m)) (request-target nil))
	=>
	(retract ?c)
	(modify ?r (request-target (assert (absolute-uri (name ?name) (scheme (assert (scheme (name ?name) (value (format nil "%c" ?char)))))))))
	(assert (char ?name (get-char ?name))))

(defrule continue-scheme
	?c <- (char ?name ?char&:(member$ ?char ?*scheme*))
	?s <- (scheme (name ?name) (value ?value&~nil))
	=>
	(retract ?c)
	(modify ?s (value (format nil "%s%c" ?value ?char)))
	(assert (char ?name (get-char ?name))))

(defrule absolute-uri-end-scheme
	?c <- (char ?name 58) ; :
	?s <- (scheme (name ?name) (value ?value&~nil))
	?a <- (absolute-uri (scheme ?s))
	=>
	(retract ?c ?s)
	(modify ?a (scheme (make-instance of SCHEME (filename ?name) (value ?value))) (hier-part (assert (hier-part (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule hier-part-find-path-absolute-first-slash
	?c <- (char ?name 47) ; /
	?h <- (hier-part (name ?name) (authority nil) (path nil))
	=>
	(retract ?c)
	(modify ?h (path (assert (path-absolute (name ?name) (segment-nz (assert (escapable-sequence (name ?name) (allowed-chars ?*pchar*))))))))
	(assert (char ?name (get-char ?name))))

(defrule hier-part-find-second-slash-change-path-absolute-to-authority
	?c <- (char ?name 47) ; /
	?e <- (escapable-sequence (sequence ""))
	?path <- (path-absolute (name ?name) (segment-nz ?e))
	?h <- (hier-part (path ?path))
	=>
	(retract ?c ?e ?path)
	(modify ?h (path nil) (authority (assert (authority (name ?name) (host (assert (host (name ?name))))))))
	(assert (char ?name (get-char ?name))))

(defrule authority-change-host-port-to-userinfo
	(char ?name ?char&:(not (member$ ?char ?*digit*)))
	?r <- (object (is-a REG-NAME) (value ?reg-name))
	?h <- (object (is-a HOST) (value =(instance-name ?r)))
	?p <- (port (value ?port))
	?a <- (authority (name ?name) (userinfo nil) (host =(instance-name ?h)) (port ?p))
	=>
	(retract ?p)
	(unmake-instance ?r ?h)
	(modify ?a (host nil) (port nil) (userinfo (assert (escapable-sequence (name ?name) (sequence (format nil "%s:%s" ?reg-name ?port)) (allowed-chars ?*userinfo*))))))

(defrule authority-form-end-port
	(char ?name 32) ; SP
	?p <- (port (value ?port))
	?a <- (authority-form (name ?name) (uri-host ?host&:(instancep ?host)) (port ?p))
	=>
	(retract ?p)
	(modify ?a (port (make-instance of PORT (filename ?name) (value ?port)))))

(defrule authority-end-userinfo
	?c <- (char ?name 64) ; @
	?e <- (escapable-sequence (sequence ?sequence) (pct-encoded nil))
	?a <- (authority (name ?name) (userinfo ?e))
	=>
	(retract ?c ?e)
	(modify ?a (userinfo (make-instance of USERINFO (filename ?name) (value ?sequence))) (host (assert (host (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule authority-end-host
	(char ?name 32|47|58) ; SP / :
	?h <- (host (value ?host&:(instancep ?host)))
	?a <- (authority (name ?name) (host ?h))
	=>
	(retract ?h)
	(modify ?a (host (make-instance of HOST (filename ?name) (value ?host)))))

(defrule authority-form-end-host
	(char ?name 32|47|58) ; SP / :
	?h <- (host (value ?host&:(instancep ?host)))
	?a <- (authority-form (name ?name) (uri-host ?h))
	=>
	(retract ?h)
	(modify ?a (uri-host (make-instance of HOST (filename ?name) (value ?host)))))

(defrule host-detect-ip-literal
	?c <- (char ?name 91) ; [
	?h <- (host (name ?name) (value nil))
	=>
	(retract ?c)
	(modify ?h (value (assert (ip-literal (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule ip-literal-detect-ipv6address
	(char ?name ?char&:(member$ ?char ?*hexdig*))
	?i <- (ip-literal (name ?name) (value nil))
	=>
	(modify ?i (value (assert (ipv6address (name ?name) (parts (assert (h16 (name ?name)))))))))

(defrule ip-literal-detect-ipv6address-colon
	?c <- (char ?name 58)
	?i <- (ip-literal (name ?name) (value nil))
	=>
	(retract ?c)
	(modify ?i (value (assert (ipv6address (name ?name) (parts ":")))))
	(assert (char ?name (get-char ?name))))

(defrule ipv6address-detect-h16
	(char ?name ?char&:(member$ ?char ?*hex-without-dig*))
	?i <- (ipv6address (name ?name) (parts $?parts&:(> 8 (length$ ?parts))&:(= 0 (length$ ?parts))|:(eq "::" (nth$ (length$ ?parts) ?parts))|:(eq H16 (class (nth$ (length$ ?parts) ?parts))) ":"))
	=>
	(modify ?i (parts ?parts (assert (h16 (name ?name))))))

(defrule ipv6address-detect-ipv4address
	(char ?name ?char&:(member$ ?char ?*digit*))
	?i <- (ipv6address (name ?name) (parts $?parts&:(> 7 (length$ ?parts))&:(> 0 (length$ ?parts))&:(instancep (nth$ (length$ ?parts) ?parts))|:(eq "::" (nth$ (length$ ?parts) ?parts)) ":"))
	=>
	(modify ?i (parts ?parts (assert (ipv4address (name ?name) (octets (assert (dec-octet (name ?name)))))))))

(defrule ipv6address-change-ipv4address-to-h16
	?octet <- (dec-octet (name ?name) (first-digit ?first) (second-digit ?second) (third-digit ?third))
	?i4 <- (ipv4address (name ?name) (octets ?octet))
	?i <- (ipv6address (name ?name) (parts $?parts ?i4))
	(or
		(char ?name ?char&:(member$ ?char ?*hex-without-dig*))
		(char ?name 93) ; ]
		(and
			(neq nil ?third)
			(char ?name ?char&:(member$ ?char ?*hexdig*))))
	=>
	(retract ?octet ?i4)
	(bind ?value "")
	(if (neq nil ?first)
		then (bind ?value (str-cat ?value ?first)))
	(if (neq nil ?second)
		then (bind ?value (str-cat ?value ?second)))
	(if (neq nil ?third)
		then (bind ?value (str-cat ?value ?third)))
	(modify ?i (parts ?parts (assert (h16 (name ?name) (value ?value))))))

(defrule ipv6address-end-ipv4address
	(char ?name 93) ; ]
	?i4 <- (ipv4address (name ?name) (octets ?first ?second ?third ?fourth&:(instancep ?fourth)))
	?i6 <- (ipv6address (parts $?parts ?i4))
	=>
	(retract ?i6)
	(modify ?i6 (parts ?parts (make-instance of IPV4ADDRESS (filename ?name) (value (format nil "%s%s%s%s" ?first ?second ?third ?fourth))))))

(defrule continue-h16
	?c <- (char ?name ?char&:(member$ ?char ?*hexdig*))
	?h <- (h16 (name ?name) (value ?value&:(> 4 (str-length ?value))))
	=>
	(retract ?c)
	(modify ?h (value (format nil "%s%c" ?value ?char)))
	(assert (char ?name (get-char ?name))))

(defrule end-h16-in-ipv6address
	(char ?name 58|93) ; : ]
	?h <- (h16 (name ?name) (value ?value))
	?i <- (ipv6address (parts $?parts ?h))
	=>
	(retract ?h)
	(modify ?i (parts ?parts (make-instance of H16 (filename ?name) (value ?value)))))

(defrule ipv6address-detect-double-colon
	?c <- (char ?name 58) ; :
	?i <- (ipv6address (name ?name) (parts $?parts&:(> 8 (length$ ?parts))&:(= 0 (length$ ?parts))|:(instancep (nth$ (length$ ?parts) ?parts))&~:(member$ "::" ?parts) ":"))
	=>
	(retract ?c)
	(modify ?i (parts ?parts "::" ":"))
	(assert (char ?name (get-char ?name))))

(defrule ipv6address-detect-next-part
	?c <- (char ?name 58) ; :
	?i6 <- (ipv6address (name ?name) (parts $?parts&:(= 0 (length$ ?parts))|:(eq "::" (nth$ (length$ ?parts) ?parts))|:(instancep (nth$ (length$ ?parts) ?parts))))
	=>
	(retract ?c)
	(modify ?i6 (parts ?parts ":"))
	(assert (char ?name (get-char ?name))))

(defrule end-ipv6address
	(char ?name 93) ; ]
	?i6 <- (ipv6address (name ?name) (parts $?parts&:(= 0 (length$ ?parts))|:(eq "::" (nth$ (length$ ?parts) ?parts))|:(instancep (nth$ (length$ ?parts) ?parts))))
	?il <- (ip-literal (value ?i6))
	=>
	(retract ?i6)
	(modify ?il (value (make-instance of IPV6ADDRESS (filename ?name) (parts ?parts)))))
	
(defrule end-ipliteral
	?c <- (char ?name 93) ; ]
	?i <- (ip-literal (name ?name) (value ?i6&:(instancep ?i6)))
	?h <- (host (value ?i))
	=>
	(retract ?c ?i)
	(modify ?h (value (make-instance of IP-LITERAL (filename ?name) (value ?i6))))
	(assert (char ?name (get-char ?name))))

;(defrule ip-literal-detect-ipvfuture
;	?c <- (char ?name 118) ; v

(defrule host-detect-ipv4address
	(char ?name ?char&:(member$ ?char ?*digit*))
	?h <- (host (name ?name) (value nil))
	=>
	(modify ?h (value (assert (ipv4address (name ?name) (octets (assert (dec-octet (name ?name)))))))))

(defrule dec-octet-set-first-digit
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?o <- (dec-octet (name ?name) (first-digit ""))
	=>
	(retract ?c)
	(modify ?o (first-digit (format nil "%c" ?char)))
	(assert (char ?name (get-char ?name))))

(defrule dec-octet-set-second-digit-when-first-digit-is-one
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?o <- (dec-octet (name ?name) (first-digit "1") (second-digit ""))
	=>
	(retract ?c)
	(modify ?o (second-digit (format nil "%c" ?char)))
	(assert (char ?name (get-char ?name))))

(defrule dec-octet-set-second-digit-when-first-digit-is-two
	?c <- (char ?name ?char&48|49|50|51|52) ; 1 2 3 4 5
	?o <- (dec-octet (name ?name) (first-digit "2") (second-digit ""))
	=>
	(retract ?c)
	(modify ?o (second-digit (format nil "%c" ?char)))
	(assert (char ?name (get-char ?name))))

(defrule dec-octet-set-third-digit-when-first-digit-is-one
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?o <- (dec-octet (name ?name) (first-digit "1") (second-digit ~"") (third-digit ""))
	=>
	(retract ?c)
	(modify ?o (third-digit (format nil "%c" ?char)))
	(assert (char ?name (get-char ?name))))

(defrule dec-octet-set-third-digit-when-first-digit-is-two-and-second-digit-is-5
	?c <- (char ?name ?char&48|49|50|51|52) ; 1 2 3 4 5
	?o <- (dec-octet (name ?name) (first-digit "2") (second-digit "5") (third-digit ""))
	=>
	(retract ?c)
	(modify ?o (third-digit (format nil "%c" ?char)))
	(assert (char ?name (get-char ?name))))

(defrule dec-octet-set-third-digit-when-first-digit-is-two-and-second-digit-is-not-5
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?o <- (dec-octet (name ?name) (first-digit "2") (second-digit ~"5") (third-digit ""))
	=>
	(retract ?c)
	(modify ?o (third-digit (format nil "%c" ?char)))
	(assert (char ?name (get-char ?name))))

(defrule end-dec-octet
	(char ?name 32|46|58) ; SP . :
	?o <- (dec-octet (name ?name) (first-digit ?first) (second-digit ?second) (third-digit ?third))
	?i <- (ipv4address (octets $?octets ?o))
	=>
	(retract ?o)
	(modify ?i (octets ?octets (make-instance of DEC-OCTET (filename ?name) (value (format nil "%s%s%s" ?first ?second ?third))))))

(defrule ipv4address-create-octet
	?c <- (char ?name 46) ; .
	?i <- (ipv4address (name ?name) (octets $?octets&:(> 4 (length$ ?octets))&:(instancep (nth$ (length$ ?octets) ?octets))))
	=>
	(retract ?c)
	(modify ?i (octets ?octets (assert (dec-octet (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule host-end-ipv4address
	(char ?name 13|32|47|58) ; CR SP / :
	?i <- (ipv4address (name ?name) (octets ?first ?second ?third ?fourth&:(instancep ?fourth)))
	?h <- (host (value ?i))
	=>
	(retract ?i)
	(modify ?h (value (make-instance of IPV4ADDRESS (filename ?name) (value (format nil "%s%s%s%s" ?first ?second ?third ?fourth))))))

(defrule host-ipv4address-change-to-reg-name
	?i <- (ipv4address (name ?name) (octets $?octets))
	?h <- (host (value ?i))
	(or
		(char ?name ?char&:(member$ ?char (create$ ?*reg-name-no-digits* 37))) ; %
		(and
			(char ?name ~46) ; .
			(test (< 0 (length$ ?octets)))
			(test (not (instancep (nth$ (length$ ?octets) ?octets))))
			(test (neq "" (fact-slot-value (nth$ (length$ ?octets) ?octets) first-digit)))
			(test (neq "1" (fact-slot-value (nth$ (length$ ?octets) ?octets) first-digit)))
			(test (neq "2" (fact-slot-value (nth$ (length$ ?octets) ?octets) first-digit))))
		(and
			(char ?name ~48&~49&~50&~51&~52) ; 1 2 3 4 5
			(test (< 0 (length$ ?octets)))
			(test (not (instancep (nth$ (length$ ?octets) ?octets))))
			(test (eq "2" (fact-slot-value (nth$ (length$ ?octets) ?octets) first-digit)))
			(test (eq "5" (fact-slot-value (nth$ (length$ ?octets) ?octets) second-digit))))
		(and
			(char ?name ~48&~49&~50&~51&~52) ; 1 2 3 4 5
			(test (< 0 (length$ ?octets)))
			(test (not (instancep (nth$ (length$ ?octets) ?octets))))
			(test (eq "2" (fact-slot-value (nth$ (length$ ?octets) ?octets) first-digit))))
		(and
			(char ?name ~13&~32&~47&~58)
			(test (= 4 (length$ ?octets)))
			(test (instancep (nth$ 4 ?octets)))))
	=>
	(retract ?i)
	(bind ?value "")
	(do-for-all-instances ((?octet DEC-OCTET)) (member$ ?octet ?octets)
		(bind ?value (str-cat ?value (send ?octet get-value)))
		(unmake-instance ?octet))
	(do-for-fact ((?octet dec-octet)) (member$ ?octet ?octets)
		(bind ?value (str-cat ?value "." (fact-slot-value ?octet first-digit) (fact-slot-value ?octet second-digit) (fact-slot-value ?octet third-digit)))
		(retract ?octet))
	(modify ?h (value (assert (reg-name (name ?name) (value (assert (escapable-sequence (name ?name) (allowed-chars ?*reg-name*) (sequence ?value)))))))))

(defrule host-detect-reg-name
	(char ?name ?char&:(member$ ?char (create$ ?*reg-name-no-digits* 37))) ; %
	?h <- (host (name ?name) (value nil))
	=>
	(modify ?h (value (assert (reg-name (name ?name) (value (assert (escapable-sequence (name ?name) (allowed-chars ?*reg-name*)))))))))

(defrule end-reg-name
	(char ?name 13|32|47|58) ; CR SP / :
	?e <- (escapable-sequence (sequence ?sequence) (pct-encoded nil))
	?r <- (reg-name (value ?e))
	?h <- (host (name ?name) (value ?r))
	=>
	(retract ?e ?r)
	(modify ?h (value (make-instance of REG-NAME (filename ?name) (value ?sequence)))))

(defrule authority-form-start-port
	?c <- (char ?name 58) ; :
	?a <- (authority-form (name ?name) (uri-host ?host&:(instancep ?host)) (port nil))
	=>
	(retract ?c)
	(modify ?a (port (assert (port (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule authority-start-port
	?c <- (char ?name 58) ; :
	?a <- (authority (name ?name) (host ?host&:(instancep ?host)) (port nil))
	=>
	(retract ?c)
	(modify ?a (port (assert (port (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule continue-port
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?p <- (port (name ?name) (value ?start&:(> 5 (str-length ?start))))
	=>
	(retract ?c)
	(modify ?p (value (format nil "%s%c" ?start ?char)))
	(assert (char ?name (get-char ?name))))

(defrule end-authority-form
	?c <- (char ?name 32) ; SP
	?a <- (authority-form (name ?name) (uri-host ?host) (port ?p&:(instancep ?p)))
	?r <- (request-line (request-target ?a))
	=>
	(retract ?c ?a)
	(modify ?r (request-target (make-instance of AUTHORITY-FORM (filename ?name) (uri-host ?host) (port ?p))))
	(assert (char ?name (get-char ?name))))

(defrule authority-end-port
	(char ?name 32|47) ; SP /
	?p <- (port (name ?name) (value ?port))
	?a <- (authority (host ?host&:(instancep ?host)) (port ?p))
	=>
	(retract ?p)
	(modify ?a (port (make-instance of PORT (filename ?name) (value ?port)))))

(defrule end-authority
	(char ?name 32|47|63) ; SP / ?
	?a <- (authority (name ?name) (userinfo ?userinfo&nil|:(instancep ?userinfo)) (host ?host&:(instancep ?host)) (port ?port&nil|:(instancep ?port)))
	?h <- (hier-part (authority ?a))
	=>
	(retract ?a)
	(modify ?h (authority (make-instance of AUTHORITY (filename ?name) (userinfo ?userinfo) (host ?host) (port ?port)))))

(defrule start-path-abempty
	(char ?name 32|47|63) ; SP / ?
	?h <- (hier-part (name ?name) (authority ?a&:(instancep ?a)) (path nil))
	=>
	(modify ?h (path (assert (path-abempty (name ?name))))))

(defrule end-path-abempty
	(char ?name 32|63) ; SP ?
	?p <- (path-abempty (name ?name) (segments $?segments&:(= 0 (length$ ?segments))|:(instancep (nth$ (length$ ?segments) ?segments))))
	?h <- (hier-part (path ?p))
	=>
	(retract ?p)
	(modify ?h (path (make-instance of PATH-ABEMPTY (filename ?name) (segments ?segments)))))

(defrule end-hier-part
	(char ?name 32|63) ; SP ?
	?h <- (hier-part (name ?name) (authority ?authority&nil|:(instancep ?authority)) (path ?path&:(instancep ?path)))
	?a <- (absolute-uri (hier-part ?h))
	=>
	(retract ?h)
	(modify ?a (hier-part (make-instance of HIER-PART (filename ?name) (authority ?authority) (path ?path)))))

(defrule absolute-uri-start-query
	?c <- (char ?name 63) ; ?
	?a <- (absolute-uri (name ?name) (hier-part ?h&:(instancep ?h)))
	=>
	(retract ?c)
	(modify ?a (query (assert (escapable-sequence (name ?name) (allowed-chars ?*query*)))))
	(assert (char ?name (get-char ?name))))

(defrule absolute-uri-end-query
	(char ?name 32) ; SP
	?e <- (escapable-sequence (name ?name) (sequence ?sequence) (pct-encoded nil))
	?a <- (absolute-uri (query ?e))
	=>
	(retract ?e)
	(modify ?a (query (make-instance of QUERY (filename ?name) (value ?sequence)))))

(defrule start-request-target-asterisk-form
	?c <- (char ?name 42) ; *
	?m <- (object (is-a METHOD) (value "OPTIONS"))
	?r <- (request-line (name ?name) (method =(instance-name ?m)) (request-target nil))
	=>
	(retract ?c)
	(modify ?r (request-target "*"))
	(assert (char ?name (get-char ?name))))

(defrule end-request-target-asterisk-form
	?c <- (char ?name 32) ; SP
	?r <- (request-line (name ?name) (request-target "*"))
	=>
	(retract ?c)
	(modify ?r (request-target (make-instance of ASTERISK-FORM (filename ?name))))
	(assert (char ?name (get-char ?name))))

	; the type of path this segment is for (origin-form, path-abempty, path-absolute, path-rootless)
(defrule origin-form-end-of-segment
	(char ?name 32|47|63) ; SP / ?
	?es <- (escapable-sequence (sequence ?value) (pct-encoded nil))
	?s <- (segment (value ?es))
	?o <- (origin-form (name ?name) (segments $?segments ?s))
	=>
	(retract ?es ?s)
	(modify ?o (segments ?segments (make-instance of SEGMENT (filename ?name) (value ?value)))))

(defrule path-abempty-end-of-segment
	(char ?name 32|47|63) ; SP / ?
	?es <- (escapable-sequence (sequence ?value) (pct-encoded nil))
	?s <- (segment (value ?es))
	?p <- (path-abempty (name ?name) (segments $?segments ?s))
	=>
	(retract ?es ?s)
	(modify ?p (segments ?segments (make-instance of SEGMENT (filename ?name) (value ?value)))))

(defrule path-absolute-end-of-segment
	(char ?name 32|47|63) ; SP / ?
	?es <- (escapable-sequence (sequence ?value) (pct-encoded nil))
	?s <- (segment (value ?es))
	?p <- (path-absolute (name ?name) (segments $?segments ?s))
	=>
	(retract ?es ?s)
	(modify ?p (segments ?segments (make-instance of SEGMENT (filename ?name) (value ?value)))))

(defrule path-rootless-end-of-segment
	(char ?name 32|47|63) ; SP / ?
	?es <- (escapable-sequence (sequence ?value) (pct-encoded nil))
	?s <- (segment (value ?es))
	?p <- (path-rootless (name ?name) (segments $?segments ?s))
	=>
	(retract ?es ?s)
	(modify ?p (segments ?segments (make-instance of SEGMENT (filename ?name) (value ?value)))))

(defrule origin-form-find-next-segment
	?c <- (char ?name 47) ; /
	?o <- (origin-form (name ?name) (segments $?segments ?segment&:(instancep ?segment)))
	=>
	(retract ?c)
	(modify ?o (segments ?segments ?segment (assert (segment (name ?name) (value (assert (escapable-sequence (name ?name) (allowed-chars ?*pchar*))))))))
	(assert (char ?name (get-char ?name))))

(defrule path-abempty-find-next-segment
	?c <- (char ?name 47) ; /
	?p <- (path-abempty (name ?name) (segments $?segments&:(= 0 (length$ ?segments))|:(instancep (nth$ (length$ ?segments) ?segments))))
	=>
	(retract ?c)
	(modify ?p (segments ?segments (assert (segment (name ?name) (value (assert (escapable-sequence (name ?name) (allowed-chars ?*pchar*))))))))
	(assert (char ?name (get-char ?name))))
	
(defrule path-absolute-find-next-segment
	?c <- (char ?name 47) ; /
	?p <- (path-absolute (name ?name) (segments $?segments ?segment&:(instancep ?segment)))
	=>
	(retract ?c)
	(modify ?p (segments ?segments ?segment (assert (segment (name ?name) (value (assert (escapable-sequence (name ?name) (allowed-chars ?*pchar*))))))))
	(assert (char ?name (get-char ?name))))
	
(defrule path-rootless-find-next-segment
	?c <- (char ?name 47) ; /
	?p <- (path-rootless (name ?name) (segments $?segments ?segment&:(instancep ?segment)))
	=>
	(retract ?c)
	(modify ?p (segments ?segments ?segment (assert (segment (name ?name) (value (assert (escapable-sequence (name ?name) (allowed-chars ?*pchar*))))))))
	(assert (char ?name (get-char ?name))))

(defrule origin-form-start-query
	?c <- (char ?name 63) ; ?
	?a <- (origin-form (name ?name) (segments $?segments ?segment&:(instancep ?segment)) (query nil))
	=>
	(retract ?c)
	(modify ?a (query (assert (escapable-sequence (name ?name) (allowed-chars ?*query*)))))
	(assert (char ?name (get-char ?name))))

(defrule origin-form-end-query
	(char ?name 32) ; SP
	?e <- (escapable-sequence (name ?name) (sequence ?sequence) (pct-encoded nil))
	?a <- (origin-form (query ?e))
	=>
	(retract ?e)
	(modify ?a (query (make-instance of QUERY (filename ?name) (value ?sequence)))))

(defrule end-of-origin-form
	?c <- (char ?name 32) ; SP
	?o <- (origin-form (name ?name) (segments $?segments ?segment&:(instancep ?segment)) (query ?query&nil|:(instancep ?query)))
	?r <- (request-line (request-target ?o))
	=>
	(retract ?c ?o)
	(modify ?r (request-target (make-instance of ORIGIN-FORM (filename ?name) (segments ?segments ?segment) (query ?query))))
	(assert (char ?name (get-char ?name))))

(defrule end-of-absolute-uri
	?c <- (char ?name 32) ; SP
	?a <- (absolute-uri (name ?name) (scheme ?scheme) (hier-part ?hier-part&:(instancep ?hier-part)) (query ?query&nil|:(instancep ?query)))
	?r <- (request-line (request-target ?a))
	=>
	(retract ?c ?a)
	(modify ?r (request-target (make-instance of ABSOLUTE-URI (filename ?name) (scheme ?scheme) (hier-part ?hier-part) (query ?query))))
	(assert (char ?name (get-char ?name))))

(defrule char-is-allowed-char-in-escapable-sequence
	?e <- (escapable-sequence (name ?name) (sequence ?sequence) (allowed-chars $?allowed-chars) (pct-encoded nil))
	?c <- (char ?name ?char&:(member$ ?char ?allowed-chars))
	=>
	(retract ?c)
	(modify ?e (sequence (format nil "%s%c" ?sequence ?char)))
	(assert (char ?name (get-char ?name))))

(defrule pct-encoded-sequence
	?c <- (char ?name 37) ; %
	?e <- (escapable-sequence (name ?name) (sequence ?sequence) (pct-encoded nil))
	=>
	(retract ?c)
	(modify ?e (pct-encoded (assert (pct-encoded (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule pct-encoded-find-first
	?c <- (char ?name ?char&:(member$ ?char ?*hexdig*))
	?p <- (pct-encoded (name ?name) (first nil))
	=>
	(retract ?c)
	(modify ?p (first ?char))
	(assert (char ?name (get-char ?name))))

(defrule pct-encoded-find-second
	?c <- (char ?name ?char&:(member$ ?char ?*hexdig*))
	?p <- (pct-encoded (name ?name) (first ?first&~nil))
	?es <- (escapable-sequence (pct-encoded ?p) (sequence ?sequence))
	=>
	(retract ?p ?c)
	(modify ?es (sequence (format nil "%s%c%c%c" ?sequence 37 ?first ?char)) (pct-encoded nil))
	(assert (char ?name (get-char ?name))))

(defrule find-http-version
	?c <- (char ?name 72) ; H
	?r <- (request-line (name ?name) (request-target ?request-target&:(instancep ?request-target)) (http-version nil))
	=>
	(retract ?c)
	(modify ?r (http-version (assert (http-version (name ?name) (H TRUE)))))
	(assert (char ?name (get-char ?name))))

(defrule find-http-version-first-T
	?c <- (char ?name 84) ; T
	?h <- (http-version (name ?name) (H TRUE) (T nil))
	=>
	(retract ?c)
	(modify ?h (T TRUE))
	(assert (char ?name (get-char ?name))))

(defrule find-http-version-second-T
	?c <- (char ?name 84) ; T
	?h <- (http-version (name ?name) (T TRUE) (TT nil))
	=>
	(retract ?c)
	(modify ?h (TT TRUE))
	(assert (char ?name (get-char ?name))))

(defrule find-http-version-P
	?c <- (char ?name 80) ; P
	?h <- (http-version (name ?name) (TT TRUE) (P nil))
	=>
	(retract ?c)
	(modify ?h (P TRUE))
	(assert (char ?name (get-char ?name))))

(defrule find-http-version-slash
	?c <- (char ?name 47) ; /
	?h <- (http-version (name ?name) (P TRUE) (major nil))
	=>
	(retract ?c)
	(modify ?h (major ""))
	(assert (char ?name (get-char ?name))))

(defrule find-http-version-continue-major
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?h <- (http-version (name ?name) (major ?major&~nil) (minor nil))
	=>
	(retract ?c)
	(modify ?h (major (format nil "%s%c" ?major ?char)))
	(assert (char ?name (get-char ?name))))

(defrule find-http-version-period
	?c <- (char ?name 46) ; .
	?h <- (http-version (name ?name) (major ~nil) (minor nil))
	=>
	(retract ?c)
	(modify ?h (minor ""))
	(assert (char ?name (get-char ?name))))

(defrule find-http-version-continue-minor
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?h <- (http-version (name ?name) (minor ?minor&~nil))
	=>
	(retract ?c)
	(modify ?h (minor (format nil "%s%c" ?minor ?char)))
	(assert (char ?name (get-char ?name))))

(defrule request-line-http-version-end
	?c <- (char ?name 13) ; CR
	?h <- (http-version (name ?name) (major ?major) (minor ?minor&~nil))
	?r <- (request-line (http-version ?h))
	=>
	(retract ?c ?h)
	(modify ?r (http-version (make-instance of HTTP-VERSION (filename ?name) (major ?major) (minor ?minor))))
	(assert (char ?name (get-char ?name))))

(defrule request-line-end
	?c <- (char ?name 10) ; LF
	?r <- (request-line (method ?method) (request-target ?request-target) (http-version ?http-version&:(instancep ?http-version)))
	?h <- (http-message (name ?name) (start-line ?r))
	=>
	(retract ?c ?r)
	(modify ?h (start-line (make-instance of REQUEST-LINE (filename ?name) (method ?method) (request-target ?request-target) (http-version ?http-version))))
	(assert (char ?name (get-char ?name))))

(defrule detect-field-line
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?h <- (http-message (name ?name) (start-line ?s&:(instancep ?s)) (field-lines $?field-lines&:(= 0 (length$ ?field-lines))|:(instancep (nth$ (length$ ?field-lines) ?field-lines))) (message-body nil))
	=>
	(modify ?h (field-lines ?field-lines (assert (field-line (name ?name) (field-name (assert (field-name (name ?name)))))))))

(defrule continue-field-name
	?c <- (char ?name ?char&:(member$ ?char ?*tchar*))
	?f <- (field-name (name ?name) (value ?value))
	=>
	(retract ?c)
	(modify ?f (value (format nil "%s%c" ?value ?char)))
	(assert (char ?name (get-char ?name))))

(defrule end-field-name
	?c <- (char ?name 58)
	?fn <- (field-name (name ?name) (value ?value))
	?fl <- (field-line (field-name ?fn))
	=>
	(retract ?c ?fn)
	(modify ?fl (field-name (make-instance of FIELD-NAME (filename ?name) (value ?value))))
	(assert (char ?name (get-char ?name))))

(defrule ignore-ows-after-field-name
	?c <- (char ?name 9|32) ; HTAB SP
	(field-line (name ?name) (field-name ?f&:(instancep ?f)) (field-value nil))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule detect-field-value
	(char ?name ~9&~32) ; HTAB SP
	?o <- (object (is-a FIELD-NAME))
	?fl <- (field-line (name ?name) (field-name =(instance-name ?o)) (field-value nil))
	=>
	(modify ?fl (field-value (assert (field-value (name ?name))))))

(defrule detect-unknown-header
	(char ?name ?char)
	?o <- (object (is-a FIELD-NAME) (value ?field-name&~"Accept"&~"Allow"&~"Accept-Encoding"&~"Accept-Language"&~"Accept-Ranges"&~"Cache-Control"&~"Connection"&~"Content-Encoding"&~"Content-Length"&~"Content-Type"&~"Cookie"&~"Date"&~"Expect"&~"Host"&~"If-Modified-Since"&~"If-Unmodified-Since"&~"Last-Modified"&~"Max-Forwards"&~"Pragma"&~"Proxy-Authorization"&~"Range"&~"Server"&~"Set-Cookie"&~"TE"&~"Trailer"&~"Upgrade"&~"User-Agent"&~"Vary"&~"Via"))
	?fv <- (field-value (name ?name) (value nil))
	?fl <- (field-line (field-name =(instance-name ?o)) (field-value ?fv))
	(test (or
		(and (>= ?char 33) (<= ?char 126)) ; VCHAR
		(and (>= ?char 128) (<= ?char 255)))) ; obs-text
	=>
	(modify ?fv (value (assert (unknown-header (name ?name))))))

(defrule build-unknown-header
	?c <- (char ?name ?char)
	?u <- (unknown-header (name ?name) (value ?value) (possible-ows ?possible-ows))
	(test (or
		(and (>= ?char 33) (<= ?char 126)) ; VCHAR
		(and (>= ?char 128) (<= ?char 255)))) ; obs-text
	=>
	(retract ?c)
	(modify ?u (value (format nil "%s%s%c" ?value ?possible-ows ?char)) (possible-ows ""))
	(assert (char ?name (get-char ?name))))

;  set-cookie-header = "Set-Cookie:" SP set-cookie-string
;  set-cookie-string = cookie-pair *( ";" SP cookie-av )
(defrule detect-set-cookie-header
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?o <- (object (is-a FIELD-NAME) (value "Set-Cookie"))
	?fv <- (field-value (name ?name) (value nil))
	?fl <- (field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (set-cookie-header (name ?name) (cookie-pair (assert (cookie-pair (name ?name) (cookie-name (assert (token (name ?name))))))))))))

(defrule end-set-cookie-header
	(char ?name 13) ; CR
	?clh <- (set-cookie-header (name ?name) (cookie-pair ?cookie-pair&:(instancep ?cookie-pair)) (cookie-avs $?cookie-avs&:(= 0 (length$ ?cookie-avs))|:(instancep (nth$ (length$ ?cookie-avs) ?cookie-avs))))
	?fv <- (field-value (value ?clh))
	=>
	(retract ?clh)
	(modify ?fv (value (make-instance of SET-COOKIE-HEADER (filename ?name) (cookie-pair ?cookie-pair) (cookie-avs ?cookie-avs)))))

(defrule set-cookie-header-end-quoted-cookie-pair
	?c <- (char ?name 34) ; "
	?cookie-pair <- (cookie-pair (name ?name) (cookie-name ?cookie-name&:(stringp ?cookie-name)) (cookie-value ?cookie-value) (cookie-value-quoted TRUE))
	?set-cookie-header <- (set-cookie-header (cookie-pair ?cookie-pair))
	=>
	(retract ?c ?cookie-pair)
	(modify ?set-cookie-header (cookie-pair (make-instance of COOKIE-PAIR (filename ?name) (cookie-name ?cookie-name) (cookie-value ?cookie-value) (cookie-value-quoted TRUE))))
	(assert (char ?name (get-char ?name))))

(defrule set-cookie-header-end-cookie-pair
	(char ?name 13|32|59) ; CR SP ;
	?cookie-pair <- (cookie-pair (name ?name) (cookie-name ?cookie-name&:(stringp ?cookie-name)) (cookie-value ?cookie-value) (cookie-value-quoted FALSE|nil))
	?set-cookie-header <- (set-cookie-header (cookie-pair ?cookie-pair))
	=>
	(retract ?cookie-pair)
	(modify ?set-cookie-header (cookie-pair (make-instance of COOKIE-PAIR (filename ?name) (cookie-name ?cookie-name) (cookie-value ?cookie-value) (cookie-value-quoted FALSE)))))

(defrule set-cookie-header-detect-next-cookie-pair
	?c <- (char ?name 59) ; ;
	?set-cookie-header <- (set-cookie-header (name ?name) (cookie-pair ?cookie-pair&:(instancep ?cookie-pair)) (cookie-avs $?cookie-avs&:(= 0 (length$ ?cookie-avs))|:(instancep (nth$ (length$ ?cookie-avs) ?cookie-avs))))
	=>
	(retract ?c)
	(modify ?set-cookie-header (cookie-pair ?cookie-pair) (cookie-avs ?cookie-avs (assert (cookie-av (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule set-cookie-header-end-cookie-av
	(char ?name 13|59) ; CR ;
	?c <- (cookie-av (value ?value&:(instancep ?value)))
	?set-cookie-header <- (set-cookie-header (name ?name) (cookie-avs $?cookie-avs ?c))
	=>
	(retract ?c)
	(modify ?set-cookie-header (cookie-avs ?cookie-avs (make-instance of COOKIE-AV (filename ?name) (value ?value)))))

(defrule cookie-av-detect-required-sp
	?c <- (char ?name 32) ; SP
	?ca <- (cookie-av (name ?name) (required-sp nil))
	=>
	(retract ?c)
	(modify ?ca (required-sp TRUE))
	(assert (char ?name (get-char ?name))))

(defrule build-cookie-av
	?c <- (char ?name ?char&:(<= 32 ?char)&:(>= 58 ?char)|:(<= 60 ?char)&:(>= 126 ?char)&~61) ; SP : < ~ =
	?ca <- (cookie-av (name ?name) (string ?string) (value nil) (required-sp TRUE))
	=>
	(retract ?c)
	(modify ?ca (string (format nil "%s%c" ?string ?char)))
	(assert (char ?name (get-char ?name))))

(defrule cookie-av-continue-on-equals-if-unknown-attribute
	?c <- (char ?name 61) ; =
	?ca <- (cookie-av (name ?name) (string ?string&~"Expires"&~"Max-Age"&~"Domain"&~"Path"&~"SameSite") (value nil) (required-sp TRUE))
	=>
	(retract ?c)
	(modify ?ca (string (format nil "%s%c" ?string 61)))
	(assert (char ?name (get-char ?name))))

;cookie-av         = expires-av / max-age-av / domain-av /
;                    path-av / secure-av / httponly-av /
;                    samesite-av / extension-av
;  expires-av        = "Expires=" sane-cookie-date
;  sane-cookie-date  = <rfc1123-date, defined in [RFC2616], Section 3.3.1>

(defrule cookie-av-detect-expires-av
	?c <- (char ?name 61) ; =
	?ca <- (cookie-av (name ?name) (string "Expires") (value nil) (required-sp TRUE))
	=>
	(retract ?c)
	(modify ?ca (value (assert (expires-av (name ?name)))))
	(assert (char ?name (get-char ?name))))
	
;  max-age-av        = "Max-Age=" non-zero-digit *DIGIT
;                        ; In practice, both expires-av and max-age-av
;                        ; are limited to dates representable by the
;                        ; user agent.
;  non-zero-digit    = %x31-39
;                        ; digits 1 through 9
(defrule cookie-av-detect-max-age-av
	?c <- (char ?name 61) ; =
	?ca <- (cookie-av (name ?name) (string "Max-Age") (value nil) (required-sp TRUE))
	=>
	(retract ?c)
	(modify ?ca (value (assert (max-age-av (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule max-age-av-detect-first-digit
	?c <- (char ?name ?char&49|50|51|52|53|54|55|56|57) ; 1-9
	?m <- (max-age-av (name ?name) (first-digit nil))
	=>
	(retract ?c)
	(modify ?m (first-digit (format nil "%c" ?char)))
	(assert (char ?name (get-char ?name))))

(defrule max-age-av-build-rest
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?m <- (max-age-av (name ?name) (first-digit ~nil) (rest ?rest))
	=>
	(retract ?c)
	(modify ?m (rest (format nil "%s%c" ?rest ?char)))
	(assert (char ?name (get-char ?name))))

(defrule cookie-av-end-max-age-av
	(char ?name 13|59) ; CR ;
	?m <- (max-age-av (name ?name) (first-digit ?first&~nil) (rest ?rest))
	?ca <- (cookie-av (value ?m))
	=>
	(retract ?m)
	(modify ?ca (value (make-instance of MAX-AGE-AV (filename ?name) (value (format nil "%s%s" ?first ?rest))))))
	
;  domain-av         = "Domain=" domain-value
;  domain-value      = <subdomain>
;                        ; defined in [RFC1034], Section 3.5, as
;                        ; enhanced by [RFC1123], Section 2.1
(defrule cookie-av-detect-domain-av
	?c <- (char ?name 61) ; =
	?ca <- (cookie-av (name ?name) (string "Domain") (value nil) (required-sp TRUE))
	=>
	(retract ?c)
	(modify ?ca (value (assert (domain-av (name ?name)))))
	(assert (char ?name (get-char ?name))))

; derived, not actually defined formally in ABNF in an RFC
; subdomain  = *( ldh-label "." ) top-label
; ldh-label  = alphanum [ *( alphanum / "-" ) alphanum ]
; top-label  = ALPHA [ *( alphanum / "-" ) alphanum ]

(defrule domain-av-detect-subdomain
	(char ?name ?char&:(member$ ?char ?*alphanum*))
	?d <- (domain-av (name ?name) (subdomain nil))
	=>
	(modify ?d (subdomain (assert (subdomain (name ?name))))))

(defrule subdomain-detect-ldh-label
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?s <- (subdomain (name ?name) (ldh-labels $?ldh-labels&:(= 0 (length$ ?ldh-labels))|:(instancep (nth$ (length$ ?ldh-labels) ?ldh-labels))) (top-label nil))
	=>
	(retract ?c)
	(modify ?s (ldh-labels (assert (ldh-label (name ?name) (value (format nil "%c" ?char))))))
	(assert (char ?name (get-char ?name))))

(defrule subdomain-detect-top-label
	?c <- (char ?name ?char&:(member$ ?char ?*alpha*))
	?s <- (subdomain (name ?name) (ldh-labels $?ldh-labels&:(= 0 (length$ ?ldh-labels))|:(instancep (nth$ (length$ ?ldh-labels) ?ldh-labels))) (top-label nil))
	=>
	(retract ?c)
	(modify ?s (top-label (assert (top-label (name ?name) (value (format nil "%c" ?char))))))
	(assert (char ?name (get-char ?name))))

(defrule subdomain-change-top-label-to-ldh-label
	(char ?name 46) ; .
	?t <- (top-label (name ?name) (value ?value))
	?s <- (subdomain (name ?name) (ldh-labels $?ldh-labels) (top-label ?t))
	=>
	(retract ?t)
	(modify ?s (ldh-labels ?ldh-labels (assert (ldh-label (name ?name) (value ?value)))) (top-label nil)))

(defrule build-top-label
	?c <- (char ?name ?char&:(member$ ?char (create$ ?*alphanum* 45))) ; -
	?t <- (top-label (name ?name) (value ?value))
	=>
	(retract ?c)
	(modify ?t (value (format nil "%s%c" ?value ?char)))
	(assert (char ?name (get-char ?name))))

(defrule build-ldh-label
	?c <- (char ?name ?char&:(member$ ?char (create$ ?*alphanum* 45))) ; -
	?l <- (ldh-label (name ?name) (value ?value))
	=>
	(retract ?c)
	(modify ?l (value (format nil "%s%c" ?value ?char)))
	(assert (char ?name (get-char ?name))))

(defrule subdomain-end-ldh-label
	?c <- (char ?name 46) ; .
	?l <- (ldh-label (name ?name) (value ?value&:(neq (sub-string (- (str-length ?value) 1) (str-length ?value) ?value) "-")))
	?s <- (subdomain (ldh-labels $?ldh-labels ?l))
	=>
	(retract ?c ?l)
	(modify ?s (ldh-labels ?ldh-labels (make-instance of LDH-LABEL (filename ?name) (value (format nil "%s." ?value)))))
	(assert (char ?name (get-char ?name))))

(defrule subdomain-end-top-label
	(char ?name 13|59) ; CR ;
	?t <- (top-label (name ?name) (value ?value&:(neq (sub-string (- (str-length ?value) 1) (str-length ?value) ?value) "-")))
	?s <- (subdomain (top-label ?t))
	=>
	(retract ?t)
	(modify ?s (top-label (make-instance of TOP-LABEL (filename ?name) (value ?value)))))

(defrule domain-av-end-subdomain
	(char ?name 13|59) ; CR ;
	?s <- (subdomain (name ?name) (top-label ?t&:(instancep ?t)) (ldh-labels $?ldh-labels&:(= 0 (length$ ?ldh-labels))|:(instancep (nth$ (length$ ?ldh-labels) ?ldh-labels))))
	?d <- (domain-av (name ?name) (subdomain ?s))
	=>
	(retract ?s)
	(modify ?d (subdomain (make-instance of SUBDOMAIN (filename ?name) (top-label ?t) (ldh-labels ?ldh-labels)))))

(defrule cookie-av-end-domain-av
	(char ?name 13|59) ; CR ;
	?d <- (domain-av (name ?name) (subdomain ?s&:(instancep ?s)))
	?ca <- (cookie-av (name ?name) (value ?d))
	=>
	(retract ?d)
	(modify ?ca (value (make-instance of DOMAIN-AV (filename ?name) (subdomain ?s)))))

;  path-av           = "Path=" path-value
;  path-value        = <any CHAR except CTLs or ";">
(defrule cookie-av-detect-path-av
	?c <- (char ?name 61) ; =
	?ca <- (cookie-av (name ?name) (string "Path") (value nil) (required-sp TRUE))
	=>
	(retract ?c)
	(modify ?ca (value (assert (path-av (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule build-path-av
	?c <- (char ?name ?char&:(<= 32 ?char)&:(>= 58 ?char)|:(<= 60 ?char)&:(>= 126 ?char)) ; = SP : < ~
	?ca <- (path-av (name ?name) (value ?value))
	=>
	(retract ?c)
	(modify ?ca (value (format nil "%s%c" ?value ?char)))
	(assert (char ?name (get-char ?name))))

(defrule cookie-av-end-path-av
	(char ?name 13|59) ; CR ;
	?p <- (path-av (name ?name) (value ?value))
	?ca <- (cookie-av (name ?name) (value ?p))
	=>
	(retract ?p)
	(modify ?ca (value (make-instance of PATH-AV (filename ?name) (value ?value)))))

;  secure-av         = "Secure"
(defrule cookie-av-detect-secure-av
	(char ?name 13|59) ; CR ;
	?ca <- (cookie-av (name ?name) (string "Secure") (value nil) (required-sp TRUE))
	=>
	(modify ?ca (value (make-instance of SECURE-AV (filename ?name)))))

;  httponly-av       = "HttpOnly"
(defrule cookie-av-detect-httponly-av
	(char ?name 13|59) ; CR ;
	?ca <- (cookie-av (name ?name) (string "HttpOnly") (value nil) (required-sp TRUE))
	=>
	(modify ?ca (value (make-instance of HTTPONLY-AV (filename ?name)))))

;samesite-av       = "SameSite" BWS "=" BWS samesite-value
;samesite-value    = "Strict" / "Lax" / "None"
(defrule cookie-av-detect-samesite-av
	?c <- (char ?name 61) ; =
	?ca <- (cookie-av (name ?name) (string "SameSite") (value nil) (required-sp TRUE))
	=>
	(retract ?c)
	(modify ?ca (value (assert (samesite-av (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule samesite-av-detect-strict
	?c <- (char ?name 83) ; S
	?s <- (samesite-av (name ?name) (value nil))
	=>
	(retract ?c)
	(modify ?s (value (assert (strict (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule strict-detect-t
	?c <- (char ?name 116) ; t
	?l <- (strict (name ?name) (t nil))
	=>
	(retract ?c)
	(modify ?l (t TRUE))
	(assert (char ?name (get-char ?name))))

(defrule strict-detect-r
	?c <- (char ?name 114) ; r
	?l <- (strict (name ?name) (t TRUE) (r nil))
	=>
	(retract ?c)
	(modify ?l (r TRUE))
	(assert (char ?name (get-char ?name))))

(defrule strict-detect-i
	?c <- (char ?name 105) ; i
	?l <- (strict (name ?name) (t TRUE) (r TRUE) (i nil))
	=>
	(retract ?c)
	(modify ?l (i TRUE))
	(assert (char ?name (get-char ?name))))

(defrule strict-detect-c
	?c <- (char ?name 99) ; c
	?l <- (strict (name ?name) (t TRUE) (r TRUE) (i TRUE) (c nil))
	=>
	(retract ?c)
	(modify ?l (c TRUE))
	(assert (char ?name (get-char ?name))))

(defrule strict-detect-last-t
	?c <- (char ?name 116) ; t
	?l <- (strict (name ?name) (t TRUE) (r TRUE) (i TRUE) (c TRUE) (last-t nil))
	=>
	(retract ?c)
	(modify ?l (last-t TRUE))
	(assert (char ?name (get-char ?name))))

(defrule samesite-av-end-strict
	(char ?name 13|59) ; CR ;
	?st <- (strict (name ?name) (t TRUE) (r TRUE) (i TRUE) (c TRUE) (last-t TRUE))
	?s <- (samesite-av (name ?name) (value ?st))
	=>
	(retract ?st)
	(modify ?s (value (make-instance of STRICT (filename ?name)))))

(defrule samesite-av-detect-lax
	?c <- (char ?name 76) ; L
	?s <- (samesite-av (name ?name) (value nil))
	=>
	(retract ?c)
	(modify ?s (value (assert (lax (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule lax-detect-a
	?c <- (char ?name 97) ; a
	?l <- (lax (name ?name) (a nil))
	=>
	(retract ?c)
	(modify ?l (a TRUE))
	(assert (char ?name (get-char ?name))))

(defrule lax-detect-x
	?c <- (char ?name 120) ; x
	?l <- (lax (name ?name) (a TRUE) (x nil))
	=>
	(retract ?c)
	(modify ?l (x TRUE))
	(assert (char ?name (get-char ?name))))

(defrule samesite-av-end-lax
	(char ?name 13|59) ; CR ;
	?l <- (lax (name ?name) (a TRUE) (x TRUE))
	?s <- (samesite-av (name ?name) (value ?l))
	=>
	(retract ?l)
	(modify ?s (value (make-instance of LAX (filename ?name)))))

(defrule samesite-av-detect-none
	?c <- (char ?name 78) ; N
	?s <- (samesite-av (name ?name) (value nil))
	=>
	(retract ?c)
	(modify ?s (value (assert (none (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule none-detect-o
	?c <- (char ?name 111) ; o
	?l <- (none (name ?name) (o nil))
	=>
	(retract ?c)
	(modify ?l (o TRUE))
	(assert (char ?name (get-char ?name))))

(defrule none-detect-n
	?c <- (char ?name 110) ; n
	?l <- (none (name ?name) (o TRUE) (n nil))
	=>
	(retract ?c)
	(modify ?l (n TRUE))
	(assert (char ?name (get-char ?name))))

(defrule none-detect-e
	?c <- (char ?name 101) ; e
	?l <- (none (name ?name) (o TRUE) (n TRUE) (e nil))
	=>
	(retract ?c)
	(modify ?l (e TRUE))
	(assert (char ?name (get-char ?name))))

(defrule samesite-av-end-none
	(char ?name 13|59) ; CR ;
	?n <- (none (name ?name) (o TRUE) (n TRUE) (e TRUE))
	?s <- (samesite-av (name ?name) (value ?n))
	=>
	(retract ?n)
	(modify ?s (value (make-instance of NONE (filename ?name)))))

(defrule cookie-av-end-samesite-av
	(char ?name 13|59) ; CR ;
	?s <- (samesite-av (name ?name) (value ?v&:(instancep ?v)))
	?ca <- (cookie-av (name ?name) (value ?s) (required-sp TRUE))
	=>
	(retract ?s)
	(modify ?ca (value (make-instance of SAMESITE-AV (filename ?name) (value ?v)))))

;extension-av      = *av-octet
;av-octet          = %x20-3A / %x3C-7E
                      ; any CHAR except CTLs or ";"
(defrule cookie-av-end-extension-av
	(char ?name 13|59) ; CR ;
	?ca <- (cookie-av (name ?name) (string ?string&~"Expires"&~"Max-Age"&~"Domain"&~"Path"&~"SameSite"&~"Secure"&~"HttpOnly") (value nil) (required-sp TRUE))
	=>
	(retract ?ca)
	(modify ?ca (value (make-instance of EXTENSION-AV (filename ?name) (value ?string)))))

;  expires-av        = "Expires=" sane-cookie-date
;  sane-cookie-date  = <rfc1123-date, defined in [RFC2616], Section 3.3.1>
;  rfc1123-date = wkday "," SP date1 SP time SP "GMT"
;  date1        = 2DIGIT SP month SP 4DIGIT
;                      ; day month year (e.g., 02 Jun 1982)
;       time         = 2DIGIT ":" 2DIGIT ":" 2DIGIT
;                      ; 00:00:00 - 23:59:59
;       wkday        = "Mon" | "Tue" | "Wed"
;                    | "Thu" | "Fri" | "Sat" | "Sun"
;       month        = "Jan" | "Feb" | "Mar" | "Apr"
;                    | "May" | "Jun" | "Jul" | "Aug"
;                    | "Sep" | "Oct" | "Nov" | "Dec"
(defrule expires-av-build-value
	(char ?name 70|77|83|84|87) ; F M S T W
	?e <- (expires-av (name ?name) (rfc1123-date nil))
	=>
	(modify ?e (rfc1123-date (assert (rfc1123-date (name ?name))))))

(defrule rfc1123-date-detect-wkday
	(char ?name 70|77|83|84|87) ; F M S T W
	?r <- (rfc1123-date (name ?name) (wkday nil))
	=>
	(modify ?r (wkday (assert (wkday (name ?name))))))

(defrule build-wkday
	?c <- (char ?name ?char&70|77|83|84|87|114|105|111|110|97|116|117|101|104|100) ; F M S T W r i o n a t u e h d
	?w <- (wkday (name ?name) (value ?value&:(> 3 (str-length ?value))))
	=>
	(retract ?c)
	(modify ?w (value (format nil "%s%c" ?value ?char)))
	(assert (char ?name (get-char ?name))))

(defrule end-wkday
	?c <- (char ?name 44) ; ,
	?w <- (wkday (value ?value&"Fri"|"Mon"|"Sat"|"Sun"|"Tue"|"Thu"|"Wed"))
	?r <- (rfc1123-date (name ?name) (wkday ?w))
	=>
	(retract ?c ?w)
	(modify ?r (wkday (make-instance of WKDAY (filename ?name) (value ?value))))
	(assert (char ?name (get-char ?name))))

;  date1        = 2DIGIT SP month SP 4DIGIT
;       month        = "Jan" | "Feb" | "Mar" | "Apr"
;                    | "May" | "Jun" | "Jul" | "Aug"
;                    | "Sep" | "Oct" | "Nov" | "Dec"
(defrule rfc1123-date-start-date1
	?c <- (char ?name 32) ; SP
	?r <- (rfc1123-date (name ?name) (wkday ?w&:(instancep ?w)) (date1 nil))
	=>
	(retract ?c)
	(modify ?r (date1 (assert (date1 (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule date1-build-first-2digit
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?d <- (date1 (name ?name) (first-2digit ?first&:(> 2 (str-length ?first))))
	=>
	(retract ?c)
	(modify ?d (first-2digit (format nil "%s%c" ?first ?char)))
	(assert (char ?name (get-char ?name))))

(defrule date1-detect-end-first-2digit-start-month
	?c <- (char ?name 32) ; SP
	?d <- (date1 (name ?name) (first-2digit ?first&:(= 2 (str-length ?first))) (month nil))
	=>
	(retract ?c)
	(modify ?d (month (assert (month (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule build-month
	?c <- (char ?name ?char&74|97|110|70|101|98|77|114|65|112|121|117|108|103|83|79|99|116|78|111|118|68) ; J a n F e b M r A p y u l g S O c t N o v D
	?m <- (month (name ?name) (value ?value&:(> 3 (str-length ?value))))
	=>
	(retract ?c)
	(modify ?m (value (format nil "%s%c" ?value ?char)))
	(assert (char ?name (get-char ?name))))

(defrule date1-end-month
	?c <- (char ?name 32) ; SP
	?m <- (month (value ?value&"Jan"|"Feb"|"Mar"|"Apr"|"May"|"Jun"|"Jul"|"Aug"|"Sep"|"Oct"|"Nov"|"Dec"))
	?d <- (date1 (name ?name) (month ?m))
	=>
	(retract ?c ?m)
	(modify ?d (month (make-instance of MONTH (filename ?name) (value ?value))))
	(assert (char ?name (get-char ?name))))

(defrule date1-build-last-4digit
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?d <- (date1 (name ?name) (month ?m&:(instancep ?m)) (last-4digit ?last&:(> 4 (str-length ?last))))
	=>
	(retract ?c)
	(modify ?d (last-4digit (format nil "%s%c" ?last ?char)))
	(assert (char ?name (get-char ?name))))

(defrule rfc1123-end-date1
	(char ?name 32) ; SP
	?d <- (date1 (first-2digit ?first) (month ?month) (last-4digit ?last&:(= 4 (str-length ?last))))
	?r <- (rfc1123-date (name ?name) (wkday ?w&:(instancep ?w)) (date1 ?d))
	=>
	(retract ?d)
	(modify ?r (date1 (make-instance of DATE1 (filename ?name) (first-2digit ?first) (month ?month) (last-4digit ?last)))))

;       time         = 2DIGIT ":" 2DIGIT ":" 2DIGIT
;                      ; 00:00:00 - 23:59:59
(defrule rfc1123-date-start-time
	?c <- (char ?name 32) ; SP
	?r <- (rfc1123-date (name ?name) (date1 ?d&:(instancep ?d)) (time nil))
	=>
	(retract ?c)
	(modify ?r (time (assert (time (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule time-build-first-2digit
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?t <- (time (name ?name) (first-2digit ?first&:(> 2 (str-length ?first))))
	=>
	(retract ?c)
	(modify ?t (first-2digit (format nil "%s%c" ?first ?char)))
	(assert (char ?name (get-char ?name))))

(defrule time-detect-first-colon
	?c <- (char ?name 58) ; :
	?t <- (time (name ?name) (first-2digit ?first&:(= 2 (str-length ?first))) (first-colon nil))
	=>
	(retract ?c)
	(modify ?t (first-colon TRUE))
	(assert (char ?name (get-char ?name))))

(defrule time-build-second-2digit
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?t <- (time (name ?name) (first-colon TRUE) (second-2digit ?second&:(> 2 (str-length ?second))))
	=>
	(retract ?c)
	(modify ?t (second-2digit (format nil "%s%c" ?second ?char)))
	(assert (char ?name (get-char ?name))))

(defrule time-detect-second-colon
	?c <- (char ?name 58) ; :
	?t <- (time (name ?name) (second-2digit ?second&:(= 2 (str-length ?second))) (second-colon nil))
	=>
	(retract ?c)
	(modify ?t (second-colon TRUE))
	(assert (char ?name (get-char ?name))))

(defrule time-build-third-2digit
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?t <- (time (name ?name) (second-colon TRUE) (third-2digit ?third&:(> 2 (str-length ?third))))
	=>
	(retract ?c)
	(modify ?t (third-2digit (format nil "%s%c" ?third ?char)))
	(assert (char ?name (get-char ?name))))

(defrule rfc1123-date-end-time
	?c <- (char ?name 32) ; SP
	?t <- (time (name ?name) (first-2digit ?first) (second-2digit ?second) (third-2digit ?third&:(= 2 (str-length ?third))))
	?r <- (rfc1123-date (name ?name) (time ?t))
	=>
	(retract ?c ?t)
	(modify ?r (time (make-instance of TIME (filename ?name) (first-2digit ?first) (second-2digit ?second) (third-2digit ?third))))
	(assert (char ?name (get-char ?name))))

(defrule rfc1123-expect-GMT
	?c <- (char ?name ?char&71|77|84) ; G M T
	?r <- (rfc1123-date (name ?name) (time ?t&:(instancep ?t)) (GMT ?GMT&:(> 3 (str-length ?GMT))))
	=>
	(retract ?c)
	(modify ?r (GMT (format nil "%s%c" ?GMT ?char)))
	(assert (char ?name (get-char ?name))))

(defrule expires-av-end-rfc1123
	(char ?name 13|59) ; CR ;
	?r <- (rfc1123-date (name ?name) (wkday ?wkday) (date1 ?date1) (time ?time) (GMT "GMT"))
	?e <- (expires-av (name ?name) (rfc1123-date ?r))
	=>
	(retract ?r)
	(modify ?e (rfc1123-date (make-instance of RFC1123-DATE (filename ?name) (wkday ?wkday) (date1 ?date1) (time ?time)))))

(defrule cookie-av-end-expires-av
	(char ?name 13|59) ; CR ;
	?e <- (expires-av (name ?name) (rfc1123-date ?r&:(instancep ?r)))
	?ca <- (cookie-av (name ?name) (value ?e) (required-sp TRUE))
	=>
	(retract ?e)
	(modify ?ca (value (make-instance of EXPIRES-AV (filename ?name) (rfc1123-date ?r)))))

;   cookie-header     = "Cookie:" OWS cookie-string OWS
;   cookie-string     = cookie-pair *( ";" SP cookie-pair )
;   cookie-pair       = cookie-name "=" cookie-value
;   cookie-name       = token
;   cookie-value      = *cookie-octet / ( DQUOTE *cookie-octet DQUOTE )
;   cookie-octet      = %x21 / %x23-2B / %x2D-3A / %x3C-5B / %x5D-7E
;                         ; US-ASCII characters excluding CTLs,
;                         ; whitespace DQUOTE, comma, semicolon,
;                         ; and backslash
(defrule detect-cookie-header
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?o <- (object (is-a FIELD-NAME) (value "Cookie"))
	?fv <- (field-value (name ?name) (value nil))
	?fl <- (field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (cookie-header (name ?name) (cookie-pairs (assert (cookie-pair (name ?name)))))))))

(defrule cookie-pair-detect-cookie-name
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?c <- (cookie-pair (name ?name) (cookie-name nil))
	=>
	(modify ?c (cookie-name (assert (token (name ?name))))))

(defrule cookie-pair-end-cookie-name
	?c <- (char ?name 61) ; =
	?t <- (token (value ?value))
	?cookie-pair <- (cookie-pair (name ?name) (cookie-name ?t))
	=>
	(retract ?c ?t)
	(modify ?cookie-pair (cookie-name ?value))
	(assert (char ?name (get-char ?name))))

(defrule cookie-pair-detect-cookie-value
	(char ?name ?char&:(member$ ?char ?*cookie-octet*))
	?cookie-pair <- (cookie-pair (name ?name) (cookie-name ?cookie-name&:(stringp ?cookie-name)) (cookie-value "") (cookie-value-quoted nil))
	=>
	(modify ?cookie-pair (cookie-value-quoted FALSE)))

(defrule cookie-pair-detect-quoted-cookie-value
	?c <- (char ?name 34) ; "
	?cookie-pair <- (cookie-pair (name ?name) (cookie-name ?cookie-name&:(stringp ?cookie-name)) (cookie-value "") (cookie-value-quoted nil))
	=>
	(retract ?c)
	(modify ?cookie-pair (cookie-value-quoted TRUE))
	(assert (char ?name (get-char ?name))))

(defrule cookie-pair-build-cookie-value
	?c <- (char ?name ?char&:(member$ ?char ?*cookie-octet*))
	?cookie-pair <- (cookie-pair (name ?name) (cookie-name ?cookie-name&:(stringp ?cookie-name)) (cookie-value ?value) (cookie-value-quoted TRUE|FALSE))
	=>
	(retract ?c)
	(modify ?cookie-pair (cookie-value (format nil "%s%c" ?value ?char)))
	(assert (char ?name (get-char ?name))))

(defrule cookie-header-end-quoted-cookie-pair
	?c <- (char ?name 34) ; "
	?cookie-pair <- (cookie-pair (name ?name) (cookie-name ?cookie-name&:(stringp ?cookie-name)) (cookie-value ?cookie-value) (cookie-value-quoted TRUE))
	?cookie-header <- (cookie-header (cookie-pairs $?cookie-pairs ?cookie-pair))
	=>
	(retract ?c ?cookie-pair)
	(modify ?cookie-header (cookie-pairs ?cookie-pairs (make-instance of COOKIE-PAIR (filename ?name) (cookie-name ?cookie-name) (cookie-value ?cookie-value) (cookie-value-quoted TRUE))))
	(assert (char ?name (get-char ?name))))

(defrule cookie-header-end-cookie-pair
	(char ?name 13|32|59) ; CR SP ;
	?cookie-pair <- (cookie-pair (name ?name) (cookie-name ?cookie-name&:(stringp ?cookie-name)) (cookie-value ?cookie-value) (cookie-value-quoted FALSE|nil))
	?cookie-header <- (cookie-header (cookie-pairs $?cookie-pairs ?cookie-pair))
	=>
	(retract ?cookie-pair)
	(modify ?cookie-header (cookie-pairs ?cookie-pairs (make-instance of COOKIE-PAIR (filename ?name) (cookie-name ?cookie-name) (cookie-value ?cookie-value) (cookie-value-quoted FALSE)))))

(defrule cookie-header-skip-ows-after-end-cookie-pair
	?c <- (char ?name 32) ; SP
	?cookie-header <- (cookie-header (name ?name) (cookie-pairs $?cookie-pairs ?cookie-pair&:(instancep ?cookie-pair)))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule cookie-header-detect-next-cookie-pair
	?c <- (char ?name 59) ; ;
	?cookie-header <- (cookie-header (name ?name) (cookie-pairs $?cookie-pairs ?cookie-pair&:(instancep ?cookie-pair)))
	=>
	(retract ?c)
	(modify ?cookie-header (cookie-pairs ?cookie-pairs ?cookie-pair (assert (cookie-pair (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule cookie-header-skip-ows-before-next-cookie-pair
	?c <- (char ?name 32) ; SP
	?cookie-pair <- (cookie-pair (name ?name) (cookie-name nil))
	?cookie-header <- (cookie-header (cookie-pairs $?cookie-pairs ?cookie-pair))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule end-cookie-header
	(char ?name 13) ; CR
	?clh <- (cookie-header (name ?name) (cookie-pairs $?cookie-pairs ?cookie-pair&:(instancep ?cookie-pair)))
	?fv <- (field-value (value ?clh))
	=>
	(retract ?clh)
	(modify ?fv (value (make-instance of COOKIE-HEADER (filename ?name) (cookie-pairs ?cookie-pairs ?cookie-pair)))))

; Allow = #method
(defrule detect-allow-header
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?o <- (object (is-a FIELD-NAME) (value "Allow"))
	?fv <- (field-value (name ?name) (value nil))
	?fl <- (field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (allow-header (name ?name) (methods (assert (method (name ?name)))))))))

(defrule allow-header-detect-next-method
	?c <- (char ?name 44) ; ,
	?a <- (allow-header (name ?name) (methods $?methods ?method&:(instancep ?method)))
	=>
	(retract ?c)
	(modify ?a (methods ?methods ?method (assert (method (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule allow-header-skip-ows-before-method
	?c <- (char ?name 9|13|32) ; HTAB CR SP
	?method <- (method (name ?name) (value ""))
	(allow-header (name ?name) (methods $?methods ?method))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule allow-header-end-method
	(char ?name 9|13|32|44) ; HTAB CR SP ,
	?method <- (method (name ?name) (value ?value&~""))
	?a <- (allow-header (name ?name) (methods $?methods ?method))
	=>
	(retract ?method)
	(modify ?a (methods ?methods (make-instance of METHOD (filename ?name) (value ?value)))))

(defrule allow-header-skip-ows-after-method
	?c <- (char ?name 9|32) ; HTAB CR SP
	(allow-header (name ?name) (methods $?methods ?method&:(instancep ?method)))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule end-allow-header
	(char ?name 13) ; CR
	?clh <- (allow-header (name ?name) (methods $?methods&:(instancep (nth$ (length$ ?methods) ?methods))))
	?fv <- (field-value (value ?clh))
	=>
	(retract ?clh)
	(modify ?fv (value (make-instance of ALLOW-HEADER (filename ?name) (methods ?methods)))))

; Connection = #connection-option ; connection-option = token
; Accept-Ranges = 1#range-unit ; range-unit = token
; Vary = #( "*" / field-name ) ; field-name = token
; Trailer = #field-name
; Content-Encoding = #content-coding ; content-coding = token
(defrule detect-token-list-header
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?o <- (object (is-a FIELD-NAME) (value "Connection"|"Accept-Ranges"|"Vary"|"Trailer"|"Content-Encoding"))
	?fv <- (field-value (name ?name) (value nil))
	?fl <- (field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (token-list-header (name ?name) (tokens (assert (token (name ?name)))))))))

(defrule token-list-header-end-token
	(char ?name 9|13|32|44) ; HTAB CR SP ,
	?t <- (token (name ?name) (value ?value&~""))
	?h <- (token-list-header (name ?name) (tokens $?tokens ?t))
	=>
	(retract ?t)
	(modify ?h (tokens ?tokens ?value)))

(defrule token-list-header-detect-next-token
	?c <- (char ?name 44) ; ,
	?h <- (token-list-header (name ?name) (tokens $?tokens ?token&:(stringp ?token)))
	=>
	(retract ?c)
	(modify ?h (tokens ?tokens ?token (assert (token (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule token-list-header-skip-ows-before-token
	?c <- (char ?name 9|32) ; HTAB SP
	?t <- (token (name ?name) (value ""))
	(token-list-header (name ?name) (tokens $?tokens ?t))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule token-list-header-skip-ows-after-token
	?c <- (char ?name 9|32) ; HTAB SP
	(token-list-header (name ?name) (tokens $?tokens ?token&:(stringp ?token)))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule end-connection-header
	(char ?name 13) ; CR
	?h <- (token-list-header (name ?name) (tokens $?tokens&:(stringp (nth$ (length$ ?tokens) ?tokens))))
	?fv <- (field-value (value ?h))
	(field-line (field-name ?fn) (field-value ?fv))
	(object (is-a FIELD-NAME) (name ?fn) (value "Connection"))
	=>
	(retract ?h)
	(modify ?fv (value (make-instance of CONNECTION-HEADER (filename ?name) (tokens ?tokens)))))

(defrule end-accept-ranges-header
	(char ?name 13) ; CR
	?h <- (token-list-header (name ?name) (tokens $?tokens&:(stringp (nth$ (length$ ?tokens) ?tokens))))
	?fv <- (field-value (value ?h))
	(field-line (field-name ?fn) (field-value ?fv))
	(object (is-a FIELD-NAME) (name ?fn) (value "Accept-Ranges"))
	=>
	(retract ?h)
	(modify ?fv (value (make-instance of ACCEPT-RANGES-HEADER (filename ?name) (tokens ?tokens)))))

(defrule end-vary-header
	(char ?name 13) ; CR
	?h <- (token-list-header (name ?name) (tokens $?tokens&:(stringp (nth$ (length$ ?tokens) ?tokens))))
	?fv <- (field-value (value ?h))
	(field-line (field-name ?fn) (field-value ?fv))
	(object (is-a FIELD-NAME) (name ?fn) (value "Vary"))
	=>
	(retract ?h)
	(modify ?fv (value (make-instance of VARY-HEADER (filename ?name) (tokens ?tokens)))))

(defrule end-trailer-header
	(char ?name 13) ; CR
	?h <- (token-list-header (name ?name) (tokens $?tokens&:(stringp (nth$ (length$ ?tokens) ?tokens))))
	?fv <- (field-value (value ?h))
	(field-line (field-name ?fn) (field-value ?fv))
	(object (is-a FIELD-NAME) (name ?fn) (value "Trailer"))
	=>
	(retract ?h)
	(modify ?fv (value (make-instance of TRAILER-HEADER (filename ?name) (tokens ?tokens)))))

(defrule end-content-encoding-header
	(char ?name 13) ; CR
	?h <- (token-list-header (name ?name) (tokens $?tokens&:(stringp (nth$ (length$ ?tokens) ?tokens))))
	?fv <- (field-value (value ?h))
	(field-line (field-name ?fn) (field-value ?fv))
	(object (is-a FIELD-NAME) (name ?fn) (value "Content-Encoding"))
	=>
	(retract ?h)
	(modify ?fv (value (make-instance of CONTENT-ENCODING-HEADER (filename ?name) (tokens ?tokens)))))

;   Accept = #( media-range [ weight ] )
;   media-range    = ( "*/*"
;                     / ( type "/" "*" )
;                     / ( type "/" subtype )
;                   ) parameters
(defrule detect-accept-header
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?o <- (object (is-a FIELD-NAME) (value "Accept"))
	?fv <- (field-value (name ?name) (value nil))
	?fl <- (field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (accept-header (name ?name) (media-ranges (assert (media-range (name ?name)))))))))

(defrule media-range-detect-type
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?m <- (media-range (name ?name) (type nil))
	=>
	(modify ?m (type (assert (type (name ?name))))))

(defrule media-range-end-type
	?c <- (char ?name 47) ; /
	?t <- (type (name ?name) (value ?value))
	?m <- (media-range (type ?t))
	=>
	(retract ?c ?t)
	(modify ?m (type (make-instance of TYPE (filename ?name) (value ?value))))
	(assert (char ?name (get-char ?name))))

(defrule media-range-detect-subtype
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?m <- (media-range (name ?name) (type ?t&:(instancep ?t)) (subtype nil))
	=>
	(modify ?m (subtype (assert (subtype (name ?name))))))

(defrule media-range-end-subtype
	(char ?name 13|32|44|59) ; CR SP , ;
	?s <- (subtype (name ?name) (value ?value))
	?m <- (media-range (subtype ?s))
	=>
	(retract ?s)
	(modify ?m (subtype (make-instance of SUBTYPE (filename ?name) (value ?value)))))

(defrule media-range-detect-parameter
	?c <- (char ?name 59) ; ;
	?cth <- (media-range (name ?name) (subtype ?s&:(instancep ?s)) (parameters $?parameters&:(= 0 (length$ ?parameters))|:(instancep (nth$ (length$ ?parameters) ?parameters))) (weight nil))
	=>
	(retract ?c)
	(modify ?cth (parameters ?parameters (assert (parameter (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule media-range-detect-ows
	?c <- (char ?name 32) ; SP
	(media-range (name ?name) (type ?t) (subtype ?s) (parameters $?parameters&:(= 0 (length$ ?parameters))|:(instancep (nth$ (length$ ?parameters) ?parameters))))
	(test (or
		(and (eq ?t nil) (eq ?s nil))
		(and (instancep ?t) (instancep ?s))))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule media-range-end-parameter
	(char ?name 9|13|32|44|59) ; HTAB CR SP , ;
	?p <- (parameter (parameter-name ?t&:(stringp ?t)) (parameter-value ?parameter-value&:(instancep ?parameter-value)|:(stringp ?parameter-value)))
	?m <- (media-range (name ?name) (subtype ?s&:(instancep ?s)) (parameters $?parameters ?p))
	=>
	(retract ?p)
	(modify ?m (parameters ?parameters (make-instance of PARAMETER (filename ?name) (parameter-name ?t) (parameter-value ?parameter-value)))))

(defrule media-range-end-weight
	(char ?name 9|13|32|44) ; HTAB CR SP ,
	?w <- (weight (name ?name) (qvalue ?q&:(instancep ?q)))
	?m <- (media-range (name ?name) (weight ?w))
	=>
	(retract ?w)
	(modify ?m (weight (make-instance of WEIGHT (filename ?name) (qvalue ?q)))))

(defrule accept-header-end-media-range
	(char ?name 13|44) ; CR ,
	?m <- (media-range (name ?name) (type ?type) (subtype ?subtype&:(instancep ?subtype)) (parameters $?parameters&:(= 0 (length$ ?parameters))|:(instancep (nth$ (length$ ?parameters) ?parameters))) (weight ?weight&nil|:(instancep ?weight)))
	?a <- (accept-header (name ?name) (media-ranges $?media-ranges ?m))
	=>
	(retract ?m)
	(modify ?a (media-ranges ?media-ranges (make-instance of MEDIA-RANGE (filename ?name) (type ?type) (subtype ?subtype) (parameters ?parameters) (weight ?weight)))))

(defrule accept-header-start-next-media-range
	?c <- (char ?name 44) ; ,
	?a <- (accept-header (name ?name) (media-ranges $?media-ranges&:(instancep (nth$ (length$ ?media-ranges) ?media-ranges))))
	=>
	(retract ?c)
	(modify ?a (media-ranges ?media-ranges (assert (media-range (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule end-accept-header
	(char ?name 13) ; CR
	?clh <- (accept-header (name ?name) (media-ranges $?media-ranges&:(instancep (nth$ (length$ ?media-ranges) ?media-ranges))))
	?fv <- (field-value (value ?clh))
	=>
	(retract ?clh)
	(modify ?fv (value (make-instance of ACCEPT-HEADER (filename ?name) (media-ranges ?media-ranges)))))

;   Accept-Encoding  = #( codings [ weight ] )
;   codings          = content-coding / "identity" / "*"
;   content-coding = token
;   weight = OWS ";" OWS "q=" qvalue
(defrule detect-accept-encoding-header
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?o <- (object (is-a FIELD-NAME) (value "Accept-Encoding"))
	?fv <- (field-value (name ?name) (value nil))
	?fl <- (field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (accept-encoding-header (name ?name) (codings (assert (coding (name ?name) (codings (assert (token (name ?name))))))))))))

(defrule accept-encoding-header-start-next-coding
	?c <- (char ?name 44) ; ,
	?a <- (accept-encoding-header (name ?name) (codings $?codings&:(instancep (nth$ (length$ ?codings) ?codings))))
	=>
	(retract ?c)
	(modify ?a (codings ?codings (assert (coding (name ?name) (codings (assert (token (name ?name))))))))
	(assert (char ?name (get-char ?name))))

(defrule coding-end-codings
	(char ?name 9|13|32|44|59) ; HTAB CR SP , ;
	?t <- (token (value ?value&~""))
	?c <- (coding (name ?name) (codings ?t))
	=>
	(retract ?t)
	(modify ?c (codings ?value)))

(defrule coding-skip-ows-before-codings
	?c <- (char ?name 9|32) ; HTAB SP
	?t <- (token (value ""))
	(coding (name ?name) (codings ?t))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule coding-skip-ows-before-weight
	?c <- (char ?name 9|32) ; HTAB SP
	(coding (name ?name) (codings ?content-coding&:(stringp ?content-coding)) (weight nil))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule coding-detect-weight
	?ch <- (char ?name 59) ; ;
	?co <- (coding (name ?name) (codings ?content-coding&:(stringp ?content-coding)) (weight nil))
	=>
	(retract ?ch)
	(modify ?co (weight (assert (weight (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule weight-ignore-ows-before-q
	?c <- (char ?name 9|32) ; HTAB SP
	(weight (name ?name) (q nil))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule weight-detect-q
	?c <- (char ?name 113) ; q
	?w <- (weight (name ?name) (q nil))
	=>
	(retract ?c)
	(modify ?w (q TRUE))
	(assert (char ?name (get-char ?name))))
	
(defrule weight-detect-equals
	?c <- (char ?name 61) ; =
	?w <- (weight (name ?name) (q TRUE) (equals nil))
	=>
	(retract ?c)
	(modify ?w (equals TRUE))
	(assert (char ?name (get-char ?name))))

(defrule weight-detect-qvalue
	(char ?name ?char&48|49) ; 0 1
	?w <- (weight (name ?name) (equals TRUE) (qvalue nil))
	=>
	(modify ?w (qvalue (assert (qvalue (name ?name))))))

(defrule qvalue-detect-first-digit
	?c <- (char ?name ?char&48|49) ; 0 1
	?q <- (qvalue (name ?name) (first nil))
	=>
	(retract ?c)
	(modify ?q (first (format nil "%c" ?char)))
	(assert (char ?name (get-char ?name))))

(defrule qvalue-detect-decimal
	?c <- (char ?name 46) ; .
	?q <- (qvalue (name ?name) (first "0"|"1") (decimal nil))
	=>
	(retract ?c)
	(modify ?q (decimal TRUE))
	(assert (char ?name (get-char ?name))))

(defrule qvalue-detect-digit-after-0
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?q <- (qvalue (name ?name) (first "0") (decimal TRUE) (fraction ?fraction&:(> 3 (str-length ?fraction))))
	=>
	(retract ?c)
	(modify ?q (fraction (format nil "%s%c" ?fraction ?char)))
	(assert (char ?name (get-char ?name))))

(defrule qvalue-detect-0-after-1
	?c <- (char ?name 48) ; 0
	?q <- (qvalue (name ?name) (first "0"|"1") (decimal TRUE) (fraction ?fraction&:(> 3 (str-length ?fraction))))
	=>
	(retract ?c)
	(modify ?q (fraction (format nil "%s%c" ?fraction 48)))
	(assert (char ?name (get-char ?name))))

; qvalue = ( "0" [ "." *3DIGIT ] ) / ( "1" [ "." *3"0" ] )

(defrule weight-end-qvalue
	(char ?name 9|13|32|44) ; HTAB CR SP ,
	?q <- (qvalue (first ?first) (decimal ?decimal) (fraction ?fraction))
	?w <- (weight (name ?name) (qvalue ?q))
	=>
	(retract ?q)
	(modify ?w (qvalue (make-instance of QVALUE (filename ?name) (first ?first) (decimal ?decimal) (fraction ?fraction)))))

(defrule coding-end-weight
	(char ?name 9|13|32|44) ; HTAB CR SP ,
	?w <- (weight (name ?name) (qvalue ?q&:(instancep ?q)))
	?c <- (coding (name ?name) (weight ?w))
	=>
	(retract ?w)
	(modify ?c (weight (make-instance of WEIGHT (filename ?name) (qvalue ?q)))))

(defrule accept-encoding-header-end-coding
	(char ?name 9|13|32|44) ; HTAB CR SP ,
	?c <- (coding (codings ?value&:(stringp ?value)) (weight ?w&nil|:(instancep ?w)))
	?a <- (accept-encoding-header (name ?name) (codings $?codings ?c))
	=>
	(retract ?c)
	(modify ?a (codings ?codings (make-instance of CODING (filename ?name) (codings ?value) (weight ?w)))))

(defrule end-accept-encoding-header
	(char ?name 9|13|32) ; HTAB CR SP
	?clh <- (accept-encoding-header (name ?name) (codings $?codings&:(instancep (nth$ (length$ ?codings) ?codings))))
	?fv <- (field-value (value ?clh))
	=>
	(retract ?clh)
	(modify ?fv (value (make-instance of ACCEPT-ENCODING-HEADER (filename ?name) (codings ?codings)))))

;   Upgrade          = #protocol
;  protocol         = protocol-name ["/" protocol-version]
;  protocol-name    = token
;  protocol-version = token
(defrule detect-upgrade-header
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?o <- (object (is-a FIELD-NAME) (value "Upgrade"))
	?fv <- (field-value (name ?name) (value nil))
	?fl <- (field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (upgrade-header (name ?name))))))

(defrule upgrade-header-detect-protocol
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?u <- (upgrade-header (name ?name) (protocols))
	=>
	(modify ?u (protocols (assert (protocol (name ?name))))))

(defrule protocol-detect-protocol-name
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?p <- (protocol (name ?name) (protocol-name nil))
	=>
	(modify ?p (protocol-name (assert (token (name ?name))))))

(defrule protocol-end-protocol-name
	(char ?name 9|13|32|44|47) ; HTAB CR SP , /
	?t <- (token (value ?value&~""))
	?p <- (protocol (name ?name) (protocol-name ?t))
	=>
	(retract ?t)
	(modify ?p (protocol-name ?value)))

(defrule protocol-start-protocol-version
	?c <- (char ?name 47) ; /
	?p <- (protocol (name ?name) (protocol-name ?protocol-name&:(stringp ?protocol-name)) (protocol-version nil))
	=>
	(retract ?c)
	(modify ?p (protocol-version (assert (token (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule protocol-end-protocol-version
	(char ?name 9|13|32|44) ; HTAB CR SP ,
	?t <- (token (value ?value&~""))
	?p <- (protocol (name ?name) (protocol-version ?t))
	=>
	(retract ?t)
	(modify ?p (protocol-version ?value)))

(defrule upgrade-header-end-protocol
	(char ?name 9|13|32|44) ; HTAB CR SP ,
	?p <- (protocol (name ?name) (protocol-name ?protocol-name&:(stringp ?protocol-name)) (protocol-version ?protocol-version&nil|:(stringp ?protocol-version)))
	?u <- (upgrade-header (name ?name) (protocols $?protocols ?p))
	=>
	(retract ?p)
	(modify ?u (protocols ?protocols (make-instance of PROTOCOL (filename ?name) (protocol-name ?protocol-name) (protocol-version ?protocol-version)))))

(defrule upgrade-header-detect-next-protocol
	?c <- (char ?name 44) ; ,
	?u <- (upgrade-header (name ?name) (protocols $?protocols ?protocol&:(instancep ?protocol)))
	=>
	(retract ?c)
	(modify ?u (protocols ?protocols ?protocol (assert (protocol (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule upgrade-header-skip-ows-after-protocol
	?c <- (char ?name 9|32) ; HTAB SP
	(upgrade-header (name ?name) (protocols $?protocols&:(= 0 (length$ ?protocols))|:(instancep (nth$ (length$ ?protocols) ?protocols))))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule upgrade-header-skip-ows-before-protocol
	?c <- (char ?name 9|32) ; HTAB SP
	?p <- (protocol (protocol-name nil))
	(upgrade-header (name ?name) (protocols $?protocols ?p))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule end-upgrade-header
	(char ?name 13) ; CR
	?u <- (upgrade-header (protocols $?protocols&:(instancep (nth$ (length$ ?protocols) ?protocols))))
	?f <- (field-value (name ?name) (value ?u))
	=>
	(retract ?u)
	(modify ?f (value (make-instance of UPGRADE-HEADER (filename ?name) (protocols ?protocols)))))

;  Via = #( received-protocol RWS received-by [ RWS comment ] )
(defrule detect-via-header
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?o <- (object (is-a FIELD-NAME) (value "Via"))
	?fv <- (field-value (name ?name) (value nil))
	?fl <- (field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (via-header (name ?name))))))

(defrule via-header-value-skip-ows-before-received-protocol
	?c <- (char ?name 9|32) ; HTAB SP
	(via-header-value (name ?name) (received-protocol nil))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule via-header-detect-value
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?v <- (via-header (name ?name) (values $?values&:(= 0 (length$ ?values))|:(instancep (nth$ (length$ ?values) ?values))))
	=>
	(modify ?v (values ?values (assert (via-header-value (name ?name))))))

(defrule via-header-value-detect-received-protocol
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?v <- (via-header-value (name ?name) (received-protocol nil))
	=>
	(modify ?v (received-protocol (assert (received-protocol (name ?name))))))

;  received-protocol = [ protocol-name "/" ] protocol-version
(defrule received-protocol-detect-protocol-name
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?r <- (received-protocol (name ?name) (protocol-name nil) (protocol-version nil))
	=>
	(modify ?r (protocol-name (assert (token (name ?name))))))

(defrule received-protocol-end-protocol-name-start-protocol-version
	?c <- (char ?name 47) ; /
	?t <- (token (value ?value&~""))
	?r <- (received-protocol (name ?name) (protocol-name ?t))
	=>
	(retract ?c ?t)
	(modify ?r (protocol-name ?value) (protocol-version (assert (token (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule received-protocol-change-protocol-name-to-protocol-version
	(char ?name 9|32) ; HTAB SP
	?t <- (token)
	?r <- (received-protocol (name ?name) (protocol-name ?t))
	=>
	(modify ?r (protocol-name nil) (protocol-version ?t)))

(defrule via-header-value-end-received-protocol
	?c <- (char ?name 9|32) ; HTAB SP
	?t <- (token (value ?value))
	?r <- (received-protocol (protocol-name ?protocol-name) (protocol-version ?t))
	?v <- (via-header-value (name ?name) (received-protocol ?r))
	=>
	(retract ?c ?t ?r)
	(modify ?v (received-protocol (make-instance of RECEIVED-PROTOCOL (filename ?name) (protocol-name ?protocol-name) (protocol-version ?value))))
	(assert (char ?name (get-char ?name))))

(defrule via-header-skip-extra-RWS-after-received-protocol
	?c <- (char ?name 9|32) ; HTAB SP
	?v <- (via-header-value (name ?name) (received-protocol ?received-protocol&:(instancep ?received-protocol)) (received-by nil))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule via-header-value-detect-received-by
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?v <- (via-header-value (name ?name) (received-protocol ?r&:(instancep ?r)) (received-by nil))
	=>
	(modify ?v (received-by (assert (received-by (name ?name) (pseudonym (assert (token (name ?name)))))))))

(defrule received-by-end-pseudonym
	(char ?name 9|13|32|44|58) ; HTAB CR SP , :
	?t <- (token (name ?name) (value ?value))
	?r <- (received-by (name ?name) (pseudonym ?t))
	=>
	(retract ?t)
	(modify ?r (pseudonym ?value)))

(defrule received-by-detect-port
	?c <- (char ?name 58) ; :
	?r <- (received-by (name ?name) (pseudonym ?p&:(stringp ?p)) (port nil))
	=>
	(modify ?r (port (assert (port (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule received-by-end-port
	(char ?name 9|13|32|44) ; HTAB CR SP
	?p <- (port (value ?value))
	?r <- (received-by (name ?name) (pseudonym ?pseudonym) (port ?p))
	=>
	(retract ?p)
	(modify ?r (port (make-instance of PORT (filename ?name) (value ?value)))))

(defrule via-header-value-end-received-by
	(char ?name 9|13|32|44) ; HTAB CR SP ,
	?r <- (received-by (name ?name) (pseudonym ?pseudonym&:(stringp ?pseudonym)) (port ?port&nil|:(instancep ?port)))
	?v <- (via-header-value (received-by ?r))
	=>
	(retract ?r)
	(modify ?v (received-by (make-instance of RECEIVED-BY (filename ?name) (pseudonym ?pseudonym) (port ?port)))))

(defrule via-header-value-detect-RWS-before-comment
	?c <- (char ?name 9|32) ; HTAB SP
	?v <- (via-header-value (name ?name) (received-by ?r&:(instancep ?r)) (comment nil))
	=>
	(retract ?c)
	(modify ?v (rws TRUE))
	(assert (char ?name (get-char ?name))))

;   comment        = "(" *( ctext / quoted-pair / comment ) ")"
(defrule via-header-value-detect-comment
	?c <- (char ?name 40) ; (
	?v <- (via-header-value (name ?name) (received-by ?r&:(instancep ?r)) (comment nil) (rws TRUE))
	=>
	(retract ?c)
	(modify ?v (comment (assert (comment (name ?name) (values "")))))
	(assert (char ?name (get-char ?name))))

(defrule add-ctext-to-comment
	?ch <- (char ?name ?char&:(member$ ?char ?*ctext*))
	?co <- (comment (name ?name) (values $?values ?value&:(stringp ?value)))
	(not (quoted-pair ?name))
	=>
	(retract ?ch)
	(modify ?co (values ?values (format nil "%s%c" ?value ?char)))
	(assert (char ?name (get-char ?name))))

(defrule comment-end-comment
	?c <- (char ?name 41) ; )
	?c-inner <- (comment (name ?name) (values $?values-inner ?value&:(instancep ?value)|:(stringp ?value)))
	?c-outer <- (comment (name ?name) (values $?values ?c-inner))
	(not (quoted-pair ?name))
	=>
	(retract ?c ?c-inner)
	(modify ?c-outer (values ?values (make-instance of COMMENT (filename ?name) (values ?values-inner ?value)) ""))
	(assert (char ?name (get-char ?name))))

(defrule comment-detect-quoted-pair
	?ch <- (char ?name 92) ; \
	?co <- (comment (name ?name) (values $?values ?value&:(stringp ?value)))
	(not (quoted-pair ?name))
	=>
	(retract ?ch)
	(assert (quoted-pair ?name)
		(char ?name (get-char ?name))))

(defrule comment-add-quoted-pair
	?ch <- (char ?name ?char)
	?co <- (comment (name ?name) (values $?values ?value&:(stringp ?value)))
	?q <- (quoted-pair ?name)
	(test (or
		(= 9 ?char)
		(= 32 ?char)
		(and (>= ?char 33) (<= ?char 126)) ; VCHAR
		(and (>= ?char 128) (<= ?char 255)))) ; obs-text
	=>
	(retract ?ch ?q)
	(modify ?co (values ?values (format nil "%s%c%c" ?value "\\" ?char)))
	(assert (char ?name (get-char ?name))))

(defrule add-comment-to-comment
	?ch <- (char ?name 40) ; (
	?co <- (comment (name ?name) (values $?values ?value&:(instancep ?value)|:(stringp ?value)))
	(not (quoted-pair ?name))
	=>
	(retract ?ch)
	(modify ?co (values ?values ?value (assert (comment (name ?name) (values "")))))
	(assert (char ?name (get-char ?name))))

(defrule via-header-value-end-comment
	?ch <- (char ?name 41) ; )
	?co <- (comment (name ?name) (values $?values ?value&:(instancep ?value)|:(stringp ?value)))
	?v <- (via-header-value (comment ?co))
	=>
	(retract ?ch ?co)
	(modify ?v (comment (make-instance of COMMENT (filename ?name) (values ?values ?value))))
	(assert (char ?name (get-char ?name))))

(defrule via-header-end-via-header-value
	(char ?name 13|44) ; CR ,
	?vhv <- (via-header-value (received-protocol ?received-protocol&:(instancep ?received-protocol)) (received-by ?received-by&:(instancep ?received-by)) (comment ?comment&nil|:(instancep ?comment)))
	?vh <- (via-header (name ?name) (values $?values ?vhv))
	=>
	(retract ?vhv)
	(modify ?vh (values ?values (make-instance of VIA-HEADER-VALUE (filename ?name) (received-protocol ?received-protocol) (received-by ?received-by) (comment ?comment)))))

(defrule via-header-start-next-via-header-value
	?c <- (char ?name 44) ; ,
	?v <- (via-header (name ?name) (values $?values&:(instancep (nth$ (length$ ?values) ?values))))
	=>
	(retract ?c)
	(modify ?v (values ?values (assert (via-header-value (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule end-via-header
	(char ?name 13) ; CR
	?v <- (via-header (values $?values&:(instancep (nth$ (length$ ?values) ?values))))
	?f <- (field-value (name ?name) (value ?v))
	=>
	(retract ?v)
	(modify ?f (value (make-instance of VIA-HEADER (filename ?name) (values ?values)))))

;   Accept-Language = #( language-range [ weight ] )
;   language-range   = (1*8ALPHA *("-" 1*8alphanum)) / "*"

;   User-Agent = product *( RWS ( product / comment ) )
;   Server     = product *( RWS ( product / comment ) )
;   product         = token [ "/" product-version ]
;   product-version = token
;   comment         = "(" *( ctext / quoted-pair / comment ) ")"
(defrule detect-user-agent-header
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?o <- (object (is-a FIELD-NAME) (value "User-Agent"))
	?fv <- (field-value (name ?name) (value nil))
	?fl <- (field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (product-header (name ?name) (values (assert (product (name ?name) (token (assert (token (name ?name))))))))))))

(defrule detect-server-header
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?o <- (object (is-a FIELD-NAME) (value "Server"))
	?fv <- (field-value (name ?name) (value nil))
	?fl <- (field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (product-header (name ?name) (values (assert (product (name ?name) (token (assert (token (name ?name))))))))))))

(defrule product-end-token-start-product-version
	?c <- (char ?name 47) ; /
	?t <- (token (name ?name) (value ?value&~""))
	?p <- (product (name ?name) (token ?t))
	=>
	(retract ?c ?t)
	(modify ?p (token ?value) (product-version (assert (token (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule product-end-token
	(char ?name 9|13|32) ; HTAB CR SP
	?t <- (token (name ?name) (value ?value&~""))
	?p <- (product (name ?name) (token ?t))
	=>
	(retract ?t)
	(modify ?p (token ?value)))

(defrule product-end-product-version
	(char ?name 9|13|32) ; HTAB CR SP
	?t <- (token (name ?name) (value ?value&~""))
	?p <- (product (name ?name) (product-version ?t))
	=>
	(retract ?t)
	(modify ?p (product-version ?value)))

(defrule product-header-end-product
	(char ?name 9|13|32) ; HTAB CR SP
	?p <- (product (name ?name) (token ?token&:(stringp ?token)) (product-version ?product-version&nil|:(stringp ?product-version)))
	?ph <- (product-header (name ?name) (values $?values ?p))
	=>
	(retract ?p)
	(modify ?ph (values ?values (make-instance of PRODUCT (filename ?name) (token ?token) (product-version ?product-version)))))

; RWS is required between products and comments. It also absorbs any
; trailing OWS before the CR that ends the field line.
(defrule product-header-detect-RWS
	?c <- (char ?name 9|32) ; HTAB SP
	?ph <- (product-header (name ?name) (values $?values ?v&:(instancep ?v)))
	=>
	(retract ?c)
	(modify ?ph (rws TRUE))
	(assert (char ?name (get-char ?name))))

(defrule product-header-detect-next-product
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?ph <- (product-header (name ?name) (rws TRUE) (values $?values ?v&:(instancep ?v)))
	=>
	(modify ?ph (rws FALSE) (values ?values ?v (assert (product (name ?name) (token (assert (token (name ?name)))))))))

(defrule product-header-detect-comment
	?c <- (char ?name 40) ; (
	?ph <- (product-header (name ?name) (rws TRUE) (values $?values ?v&:(instancep ?v)))
	=>
	(retract ?c)
	(modify ?ph (rws FALSE) (values ?values ?v (assert (comment (name ?name) (values "")))))
	(assert (char ?name (get-char ?name))))

(defrule product-header-end-comment
	?ch <- (char ?name 41) ; )
	?co <- (comment (name ?name) (values $?values ?value&:(instancep ?value)|:(stringp ?value)))
	?ph <- (product-header (name ?name) (values $?vs ?co))
	(not (quoted-pair ?name))
	=>
	(retract ?ch ?co)
	(modify ?ph (values ?vs (make-instance of COMMENT (filename ?name) (values ?values ?value))))
	(assert (char ?name (get-char ?name))))

(defrule end-user-agent-header
	(char ?name 13) ; CR
	?ph <- (product-header (name ?name) (values $?values&:(instancep (nth$ (length$ ?values) ?values))))
	?fv <- (field-value (value ?ph))
	(field-line (field-name ?fn) (field-value ?fv))
	(object (is-a FIELD-NAME) (name ?fn) (value "User-Agent"))
	=>
	(retract ?ph)
	(modify ?fv (value (make-instance of USER-AGENT-HEADER (filename ?name) (values ?values)))))

(defrule end-server-header
	(char ?name 13) ; CR
	?ph <- (product-header (name ?name) (values $?values&:(instancep (nth$ (length$ ?values) ?values))))
	?fv <- (field-value (value ?ph))
	(field-line (field-name ?fn) (field-value ?fv))
	(object (is-a FIELD-NAME) (name ?fn) (value "Server"))
	=>
	(retract ?ph)
	(modify ?fv (value (make-instance of SERVER-HEADER (filename ?name) (values ?values)))))

(defrule detect-accept-language-header
	(char ?name ?char&:(member$ ?char (create$ ?*alpha* 42))) ; *
	?o <- (object (is-a FIELD-NAME) (value "Accept-Language"))
	?fv <- (field-value (name ?name) (value nil))
	?fl <- (field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (accept-language-header (name ?name) (language-ranges (assert (language-range (name ?name) (first-language (assert (language (name ?name))))))))))))

(defrule language-range-detect-first-language
	(char ?name ?char&:(member$ ?char (create$ ?*alpha* 42))) ; *
	?lr <- (language-range (name ?name) (first-language nil))
	=>
	(modify ?lr (first-language (assert (language (name ?name))))))

(defrule language-range-detect-asterisk
	?c <- (char ?name 42) ; *
	?l <- (language (value ""))
	?lr <- (language-range (name ?name) (first-language ?l))
	=>
	(retract ?c)
	(modify ?l (value "*"))
	(assert (char ?name (get-char ?name))))

(defrule language-range-build-first-language
	?c <- (char ?name ?char&:(member$ ?char ?*alpha*))
	?l <- (language (value ?value&~"*"))
	?lr <- (language-range (name ?name) (first-language ?l))
	=>
	(retract ?c)
	(modify ?l (value (format nil "%s%c" ?value ?char)))
	(assert (char ?name (get-char ?name))))

(defrule language-range-end-first-language
	(char ?name 9|13|32|44|59) ; HTAB CR SP , ;
	?l <- (language (value ?value&:(< 0 (str-length ?value))))
	?lr <- (language-range (name ?name) (first-language ?l))
	=>
	(retract ?l)
	(modify ?lr (first-language (make-instance of LANGUAGE (filename ?name) (value ?value)))))

(defrule language-range-end-first-language-and-detect-next-language
	?c <- (char ?name 45) ; -
	?l <- (language (value ?value&:(< 0 (str-length ?value))))
	?lr <- (language-range (name ?name) (first-language ?l))
	=>
	(retract ?c ?l)
	(modify ?lr (first-language (make-instance of LANGUAGE (filename ?name) (value ?value))) (languages (assert (language (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule language-range-end-weight
	(char ?name 9|13|32|44) ; HTAB CR SP ,
	?w <- (weight (name ?name) (qvalue ?q&:(instancep ?q)))
	?l <- (language-range (name ?name) (weight ?w))
	=>
	(retract ?w)
	(modify ?l (weight (make-instance of WEIGHT (filename ?name) (qvalue ?q)))))

(defrule language-range-end-language
	(char ?name 9|13|32|44|59) ; HTAB CR SP , ;
	?l <- (language (value ?value&:(< 0 (str-length ?value))))
	?lr <- (language-range (name ?name) (languages $?languages ?l))
	=>
	(retract ?l)
	(modify ?lr (languages ?languages (make-instance of LANGUAGE (filename ?name) (value ?value)))))

(defrule language-range-end-language-and-detect-next-language
	?c <- (char ?name 45) ; -
	?l <- (language (value ?value&:(< 0 (str-length ?value))))
	?lr <- (language-range (name ?name) (languages $?languages ?l))
	=>
	(retract ?c)
	(modify ?lr (languages ?languages (make-instance of LANGUAGE (filename ?name) (value ?value)) (assert (language (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule language-range-build-language
	?c <- (char ?name ?char&:(member$ ?char ?*alphanum*))
	?l <- (language (name ?name) (value ?value))
	?lr <- (language-range (languages $? ?l))
	=>
	(retract ?c)
	(modify ?l (value (format nil "%s%c" ?value ?char)))
	(assert (char ?name (get-char ?name))))

(defrule language-range-ignore-ows-before-weight
	?c <- (char ?name 9|32) ; HTAB SP
	?l <- (language-range (name ?name) (first-language ?first-language&:(instancep ?first-language)) (languages $?languages&:(= 0 (length$ ?languages))|:(instancep (nth$ (length$ ?languages) ?languages))) (weight nil))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule language-range-ignore-ows-after-weight
	?c <- (char ?name 9|32) ; HTAB SP
	?l <- (language-range (name ?name) (first-language ?first-language&:(instancep ?first-language)) (languages $?languages&:(= 0 (length$ ?languages))|:(instancep (nth$ (length$ ?languages) ?languages))) (weight ?weight&:(instancep ?weight)))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule language-range-detect-weight
	?c <- (char ?name 59) ; ;
	?l <- (language-range (name ?name) (first-language ?first-language&:(instancep ?first-language)) (languages $?languages&:(= 0 (length$ ?languages))|:(instancep (nth$ (length$ ?languages) ?languages))) (weight nil))
	=>
	(retract ?c)
	(modify ?l (weight (assert (weight (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule accept-language-header-end-language-range
	(char ?name 13|44) ; CR ,
	?l <- (language-range (name ?name) (first-language ?first-language&:(instancep ?first-language)) (languages $?languages&:(= 0 (length$ ?languages))|:(instancep (nth$ (length$ ?languages) ?languages))) (weight ?weight&nil|:(instancep ?weight)))
	?a <- (accept-language-header (language-ranges $?language-ranges ?l))
	=>
	(retract ?l)
	(modify ?a (language-ranges ?language-ranges (make-instance of LANGUAGE-RANGE (filename ?name) (first-language ?first-language) (languages ?languages) (weight ?weight)))))

(defrule accept-language-header-ignore-ows-between-language-ranges
	?c <- (char ?name 9|32) ; HTAB SP
	?l <- (language-range (first-language nil))
	?a <- (accept-language-header (name ?name) (language-ranges $?language-ranges ?l))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule accept-language-header-start-next-language-range
	?c <- (char ?name 44) ; ,
	?a <- (accept-language-header (name ?name) (language-ranges $?language-ranges&:(instancep (nth$ (length$ ?language-ranges) ?language-ranges))))
	=>
	(retract ?c)
	(modify ?a (language-ranges ?language-ranges (assert (language-range (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule end-accept-language-header
	(char ?name 13) ; CR
	?clh <- (accept-language-header (name ?name) (language-ranges $?language-ranges&:(instancep (nth$ (length$ ?language-ranges) ?language-ranges))))
	?fv <- (field-value (value ?clh))
	=>
	(retract ?clh)
	(modify ?fv (value (make-instance of ACCEPT-LANGUAGE-HEADER (filename ?name) (language-ranges ?language-ranges)))))

;RWS = 1*( SP / HTAB )
;  Via = #( received-protocol RWS received-by [ RWS comment ] )
;
;  received-protocol = [ protocol-name "/" ] protocol-version
;                    ; see Section 7.8
;  received-by       = pseudonym [ ":" port ]
;  pseudonym         = token

(defrule detect-content-length-header
	(char ?name ?char&:(member$ ?char ?*digit*))
	?o <- (object (is-a FIELD-NAME) (value "Content-Length"))
	?fv <- (field-value (name ?name) (value nil))
	?fl <- (field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (content-length-header (name ?name))))))

;   Max-Forwards = 1*DIGIT
(defrule detect-max-forwards-header
	(char ?name ?char&:(member$ ?char ?*digit*))
	?o <- (object (is-a FIELD-NAME) (value "Max-Forwards"))
	?fv <- (field-value (name ?name) (value nil))
	?fl <- (field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (max-forwards-header (name ?name))))))

;   Content-Type = media-type
;     media-type = type "/" subtype parameters
;     type       = token
;     subtype    = token
;          token = 1*tchar
(defrule detect-content-type-header-type
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?o <- (object (is-a FIELD-NAME) (value "Content-Type"))
	?fv <- (field-value (name ?name) (value nil))
	?fl <- (field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (content-type-header (name ?name) (type (assert (type (name ?name)))))))))

(defrule detect-host-header
	(char ?name ?char&:(member$ ?char (create$ 91 ?*reg-name*))) ; [
	?o <- (object (is-a FIELD-NAME) (value "Host"))
	?fv <- (field-value (name ?name) (value nil))
	?fl <- (field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (host-header (name ?name) (uri-host (assert (host (name ?name)))))))))

(defrule build-type
	?c <- (char ?name ?char&:(member$ ?char ?*tchar*))
	?t <- (type (name ?name) (value ?type))
	=>
	(retract ?c)
	(modify ?t (value (format nil "%s%c" ?type ?char)))
	(assert (char ?name (get-char ?name))))

(defrule content-type-end-type
	?c <- (char ?name 47) ; /
	?t <- (type (name ?name) (value ?value))
	?ct <- (content-type-header (type ?t))
	=>
	(retract ?c ?t)
	(modify ?ct (type (make-instance of TYPE (filename ?name) (value ?value))))
	(assert (char ?name (get-char ?name))))

(defrule content-type-detect-subtype
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?c <- (content-type-header (name ?name) (type ?t&:(instancep ?t)) (subtype nil))
	=>
	(modify ?c (subtype (assert (subtype (name ?name))))))

(defrule build-subtype
	?c <- (char ?name ?char&:(member$ ?char ?*tchar*))
	?s <- (subtype (name ?name) (value ?subtype))
	=>
	(retract ?c)
	(modify ?s (value (format nil "%s%c" ?subtype ?char)))
	(assert (char ?name (get-char ?name))))

(defrule content-type-end-subtype
	(char ?name 13|32|59) ; CR SP ;
	?s <- (subtype (name ?name) (value ?value))
	?c <- (content-type-header (subtype ?s))
	=>
	(retract ?s)
	(modify ?c (subtype (make-instance of SUBTYPE (filename ?name) (value ?value)))))

(defrule content-type-detect-parameter
	?c <- (char ?name 59) ; ;
	?cth <- (content-type-header (name ?name) (subtype ?s&:(instancep ?s)) (parameters $?parameters&:(= 0 (length$ ?parameters))|:(instancep (nth$ (length$ ?parameters) ?parameters))))
	=>
	(retract ?c)
	(modify ?cth (parameters ?parameters (assert (parameter (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule content-type-detect-ows
	?c <- (char ?name 32) ; SP
	(content-type-header (name ?name) (subtype ?s&:(instancep ?s)) (parameters $?parameters&:(= 0 (length$ ?parameters))|:(instancep (nth$ (length$ ?parameters) ?parameters))))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule parameter-detect-ows
	?c <- (char ?name 32) ; SP
	(parameter (name ?name) (parameter-name nil))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule parameter-detect-parameter-name
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?p <- (parameter (name ?name) (parameter-name nil))
	=>
	(modify ?p (parameter-name (assert (token (name ?name))))))

(defrule build-token
	?c <- (char ?name ?char&:(member$ ?char ?*tchar*))
	?t <- (token (name ?name) (value ?value))
	=>
	(retract ?c)
	(modify ?t (value (format nil "%s%c" ?value ?char)))
	(assert (char ?name (get-char ?name))))

(defrule parameter-end-parameter-name
	?c <- (char ?name 61) ; =
	?t <- (token (name ?name) (value ?value&~""&~"q"))
	?p <- (parameter (parameter-name ?t))
	=>
	(retract ?c ?t)
	(modify ?p (parameter-name ?value))
	(assert (char ?name (get-char ?name))))

(defrule media-range-parameter-change-to-weight
	?c <- (char ?name 61) ; =
	?t <- (token (name ?name) (value "q"))
	?p <- (parameter (parameter-name ?t))
	?m <- (media-range (parameters $?parameters ?p))
	=>
	(retract ?c ?t ?p)
	(modify ?m (parameters ?parameters) (weight (assert (weight (name ?name) (q TRUE) (equals TRUE)))))
	(assert (char ?name (get-char ?name))))

(defrule parameter-detect-parameter-value-token
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?p <- (parameter (name ?name) (parameter-name ?parameter-name&:(stringp ?parameter-name)) (parameter-value nil))
	=>
	(modify ?p (parameter-value (assert (token (name ?name))))))

(defrule parameter-end-parameter-value-token
	(char ?name 9|13|32|44|59) ; HTAB CR SP , ;
	?t <- (token (name ?name) (value ?value&~""))
	?p <- (parameter (parameter-value ?t))
	=>
	(retract ?t)
	(modify ?p (parameter-value ?value)))

(defrule parameter-detect-parameter-value-quoted-string
	?c <- (char ?name 34) ; "
	?p <- (parameter (name ?name) (parameter-name ?t&:(stringp ?t)) (parameter-value nil))
	=>
	(retract ?c)
	(modify ?p (parameter-value (assert (quoted-string (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule quoted-string-detect-quoted-pair
	?c <- (char ?name 92) ; \
	?q <- (quoted-string (name ?name) (value ?value))
	(not (quoted-pair ?name))
	=>
	(retract ?c)
	(assert (quoted-pair ?name)
		(char ?name (get-char ?name))))

;   quoted-string = DQUOTE *( qdtext / quoted-pair ) DQUOTE
;        qdtext   = HTAB / SP / "!" / %x23-5B / %x5D-7E / obs-text
(defrule build-quoted-string
	?c <- (char ?name ?char)
	?q <- (quoted-string (name ?name) (value ?value))
	(not (quoted-pair ?name))
	(test (or
		(= ?char 9) ; HTAB
		(= ?char 32) ; SP
		(= ?char 33) ; !
		(and (>= ?char 35) (<= ?char 91)) ; %x23-5B
		(and (>= ?char 93) (<= ?char 126)) ; %x5D-7E
		(and (>= ?char 128) (<= ?char 255)))) ; obs-text
	=>
	(retract ?c)
	(modify ?q (value (format nil "%s%c" ?value ?char)))
	(assert (char ?name (get-char ?name))))

;   quoted-pair = "\" ( HTAB / SP / VCHAR / obs-text )
(defrule build-quoted-string-quoted-pair
	?c <- (char ?name ?char)
	?qp <- (quoted-pair ?name)
	?q <- (quoted-string (name ?name) (value ?value))
	(test (or
		(= ?char 9) ; HTAB
		(= ?char 32) ; SP
		(and (>= ?char 33) (<= ?char 126)) ; VCHAR
		(and (>= ?char 128) (<= ?char 255)))) ; obs-text
	=>
	(retract ?c ?qp)
	(modify ?q (value (format nil "%s%c" ?value ?char)))
	(assert (char ?name (get-char ?name))))

(defrule parameter-end-parameter-value-quoted-string
	?c <- (char ?name 34) ; "
	?q <- (quoted-string (name ?name) (value ?value&:(stringp ?value)))
	?p <- (parameter (parameter-name ?t&:(stringp ?t)) (parameter-value ?q))
	(not (quoted-pair ?name))
	=>
	(retract ?c ?q)
	(modify ?p (parameter-value (make-instance of QUOTED-STRING (filename ?name) (value ?value))))
	(assert (char ?name (get-char ?name))))

(defrule content-type-header-end-parameter
	(char ?name 9|13|32|59) ; HTAB CR SP ;
	?p <- (parameter (parameter-name ?t&:(stringp ?t)) (parameter-value ?parameter-value&:(instancep ?parameter-value)|:(stringp ?parameter-value)))
	?c <- (content-type-header (name ?name) (subtype ?s&:(instancep ?s)) (parameters $?parameters ?p))
	=>
	(retract ?p)
	(modify ?c (parameters ?parameters (make-instance of PARAMETER (filename ?name) (parameter-name ?t) (parameter-value ?parameter-value)))))

(defrule parameter-detect-parameter-value-token
	(char ?name ?char&:(member$ ?char (create$ ?*tchar*)))
	?p <- (parameter (name ?name) (parameter-name ?t&:(stringp ?t)) (parameter-value nil))
	=>
	(modify ?p (parameter-value (assert (token (name ?name))))))

(defrule host-header-end-host
	(char ?name 13|32|58) ; CR SP :
	?h <- (host (value ?value&:(instancep ?value)))
	?hh <- (host-header (name ?name) (uri-host ?h))
	=>
	(retract ?h)
	(modify ?hh (uri-host (make-instance of HOST (filename ?name) (value ?value)))))

(defrule host-header-detect-port
	?c <- (char ?name 58)
	?hh <- (host-header (name ?name) (uri-host ?h&:(instancep ?h)) (port nil))
	=>
	(retract ?c)
	(modify ?hh (port (assert (port (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule host-header-end-port
	(char ?name 13|32) ; CR SP
	?p <- (port (value ?value))
	?hh <- (host-header (name ?name) (port ?p))
	=>
	(retract ?p)
	(modify ?hh (port (make-instance of PORT (filename ?name) (value ?value)))))

(defrule build-content-length-header
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?clh <- (content-length-header (name ?name) (value ?content-length-header))
	=>
	(retract ?c)
	(modify ?clh (value (format nil "%s%c" ?content-length-header ?char)))
	(assert (char ?name (get-char ?name))))

(defrule build-max-forwards-header
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?mfh <- (max-forwards-header (name ?name) (value ?max-forwards-header))
	=>
	(retract ?c)
	(modify ?mfh (value (format nil "%s%c" ?max-forwards-header ?char)))
	(assert (char ?name (get-char ?name))))

(defrule unknown-header-allow-ows
	?c <- (char ?name ?char&9|32) ; HTAB SP
	?u <- (unknown-header (name ?name) (value ?unknown-header&~"") (possible-ows ?possible-ows))
	?f <- (field-value (value ?u))
	=>
	(retract ?c)
	(modify ?u (possible-ows (format nil "%s%c" ?possible-ows ?char)))
	(assert (char ?name (get-char ?name))))

(defrule end-unknown-header
	(char ?name 13)
	?u <- (unknown-header (name ?name) (value ?value))
	?fv <- (field-value (value ?u))
	=>
	(retract ?u)
	(modify ?fv (value (make-instance of UNKNOWN-HEADER (filename ?name) (value ?value)))))

(defrule end-content-length-header
	(char ?name 13|32) ; CR SP
	?clh <- (content-length-header (name ?name) (value ?content-length-header))
	?fv <- (field-value (value ?clh))
	=>
	(retract ?clh)
	(modify ?fv (value (make-instance of CONTENT-LENGTH-HEADER (filename ?name) (value ?content-length-header)))))

(defrule end-max-forwards-header
	(char ?name 9|13|32) ; HTAB CR SP
	?mfh <- (max-forwards-header (name ?name) (value ?max-forwards-header))
	?fv <- (field-value (value ?mfh))
	=>
	(retract ?mfh)
	(modify ?fv (value (make-instance of MAX-FORWARDS-HEADER (filename ?name) (value ?max-forwards-header)))))

;   Date                = HTTP-date
;   Last-Modified       = HTTP-date
;   If-Modified-Since   = HTTP-date
;   If-Unmodified-Since = HTTP-date
;   HTTP-date    = IMF-fixdate / obs-date
;   IMF-fixdate  = day-name "," SP date1 SP time-of-day SP GMT ; identical to rfc1123-date
;   obs-date     = rfc850-date / asctime-date
;   rfc850-date  = day-name-l "," SP date2 SP time-of-day SP GMT
;   asctime-date = day-name SP date3 SP time-of-day SP year
;   day-name     = %s"Mon" / %s"Tue" / %s"Wed" / %s"Thu" / %s"Fri" / %s"Sat" / %s"Sun"
;   day-name-l   = %s"Monday" / %s"Tuesday" / %s"Wednesday" / %s"Thursday"
;                / %s"Friday" / %s"Saturday" / %s"Sunday"
; The three forms are told apart by what follows the day name:
; "," after 3 letters -> IMF-fixdate, "," after a full name -> rfc850-date, SP after 3 letters -> asctime-date
(defrule detect-http-date-header
	(char ?name 70|77|83|84|87) ; F M S T W
	?o <- (object (is-a FIELD-NAME) (value "Date"|"Last-Modified"|"If-Modified-Since"|"If-Unmodified-Since"))
	?fv <- (field-value (name ?name) (value nil))
	?fl <- (field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-date-header (name ?name) (http-date (assert (day-name (name ?name)))))))))

(defrule build-day-name
	?c <- (char ?name ?char&77|111|110|100|97|121|84|117|101|115|87|104|114|70|105|83|116) ; M o n d a y T u e s W h r F i S t
	?d <- (day-name (name ?name) (value ?value&:(> 9 (str-length ?value))))
	=>
	(retract ?c)
	(modify ?d (value (format nil "%s%c" ?value ?char)))
	(assert (char ?name (get-char ?name))))

(defrule day-name-end-imf-fixdate
	?c <- (char ?name 44) ; ,
	?d <- (day-name (name ?name) (value ?value&"Mon"|"Tue"|"Wed"|"Thu"|"Fri"|"Sat"|"Sun"))
	?h <- (http-date-header (name ?name) (http-date ?d))
	=>
	(retract ?c ?d)
	(modify ?h (http-date (assert (rfc1123-date (name ?name) (wkday (make-instance of WKDAY (filename ?name) (value ?value)))))))
	(assert (char ?name (get-char ?name))))

(defrule day-name-end-rfc850-date
	?c <- (char ?name 44) ; ,
	?d <- (day-name (name ?name) (value ?value&"Monday"|"Tuesday"|"Wednesday"|"Thursday"|"Friday"|"Saturday"|"Sunday"))
	?h <- (http-date-header (name ?name) (http-date ?d))
	=>
	(retract ?c ?d)
	(modify ?h (http-date (assert (rfc850-date (name ?name) (day-name-l (make-instance of DAY-NAME-L (filename ?name) (value ?value)))))))
	(assert (char ?name (get-char ?name))))

(defrule day-name-end-asctime-date
	?c <- (char ?name 32) ; SP
	?d <- (day-name (name ?name) (value ?value&"Mon"|"Tue"|"Wed"|"Thu"|"Fri"|"Sat"|"Sun"))
	?h <- (http-date-header (name ?name) (http-date ?d))
	=>
	(retract ?c ?d)
	(modify ?h (http-date (assert (asctime-date (name ?name) (day-name (make-instance of WKDAY (filename ?name) (value ?value))) (date3 (assert (date3 (name ?name) (month (assert (month (name ?name)))))))))))
	(assert (char ?name (get-char ?name))))

; IMF-fixdate: the rfc1123-date rules above carry the fact through "GMT"
(defrule http-date-header-end-rfc1123-date
	(char ?name 9|13|32) ; HTAB CR SP
	?r <- (rfc1123-date (name ?name) (wkday ?wkday) (date1 ?date1) (time ?time) (GMT "GMT"))
	?h <- (http-date-header (name ?name) (http-date ?r))
	=>
	(retract ?r)
	(modify ?h (http-date (make-instance of RFC1123-DATE (filename ?name) (wkday ?wkday) (date1 ?date1) (time ?time)))))

;   rfc850-date  = day-name-l "," SP date2 SP time-of-day SP GMT
;   date2        = day "-" month "-" 2DIGIT
;                ; e.g., 02-Jun-82
(defrule rfc850-date-start-date2
	?c <- (char ?name 32) ; SP
	?r <- (rfc850-date (name ?name) (day-name-l ?d&:(instancep ?d)) (date2 nil))
	=>
	(retract ?c)
	(modify ?r (date2 (assert (date2 (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule date2-build-day
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?d <- (date2 (name ?name) (day ?day&:(> 2 (str-length ?day))))
	=>
	(retract ?c)
	(modify ?d (day (format nil "%s%c" ?day ?char)))
	(assert (char ?name (get-char ?name))))

(defrule date2-end-day-start-month
	?c <- (char ?name 45) ; -
	?d <- (date2 (name ?name) (day ?day&:(= 2 (str-length ?day))) (month nil))
	=>
	(retract ?c)
	(modify ?d (month (assert (month (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule date2-end-month
	?c <- (char ?name 45) ; -
	?m <- (month (value ?value&"Jan"|"Feb"|"Mar"|"Apr"|"May"|"Jun"|"Jul"|"Aug"|"Sep"|"Oct"|"Nov"|"Dec"))
	?d <- (date2 (name ?name) (month ?m))
	=>
	(retract ?c ?m)
	(modify ?d (month (make-instance of MONTH (filename ?name) (value ?value))))
	(assert (char ?name (get-char ?name))))

(defrule date2-build-year
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?d <- (date2 (name ?name) (month ?m&:(instancep ?m)) (year ?year&:(> 2 (str-length ?year))))
	=>
	(retract ?c)
	(modify ?d (year (format nil "%s%c" ?year ?char)))
	(assert (char ?name (get-char ?name))))

(defrule rfc850-date-end-date2
	(char ?name 32) ; SP
	?d <- (date2 (day ?day) (month ?month) (year ?year&:(= 2 (str-length ?year))))
	?r <- (rfc850-date (name ?name) (date2 ?d))
	=>
	(retract ?d)
	(modify ?r (date2 (make-instance of DATE2 (filename ?name) (day ?day) (month ?month) (year ?year)))))

(defrule rfc850-date-start-time
	?c <- (char ?name 32) ; SP
	?r <- (rfc850-date (name ?name) (date2 ?d&:(instancep ?d)) (time nil))
	=>
	(retract ?c)
	(modify ?r (time (assert (time (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule rfc850-date-end-time
	?c <- (char ?name 32) ; SP
	?t <- (time (name ?name) (first-2digit ?first) (second-2digit ?second) (third-2digit ?third&:(= 2 (str-length ?third))))
	?r <- (rfc850-date (name ?name) (time ?t))
	=>
	(retract ?c ?t)
	(modify ?r (time (make-instance of TIME (filename ?name) (first-2digit ?first) (second-2digit ?second) (third-2digit ?third))))
	(assert (char ?name (get-char ?name))))

(defrule rfc850-date-expect-GMT
	?c <- (char ?name ?char&71|77|84) ; G M T
	?r <- (rfc850-date (name ?name) (time ?t&:(instancep ?t)) (GMT ?GMT&:(> 3 (str-length ?GMT))))
	=>
	(retract ?c)
	(modify ?r (GMT (format nil "%s%c" ?GMT ?char)))
	(assert (char ?name (get-char ?name))))

(defrule http-date-header-end-rfc850-date
	(char ?name 9|13|32) ; HTAB CR SP
	?r <- (rfc850-date (name ?name) (day-name-l ?day-name-l) (date2 ?date2) (time ?time) (GMT "GMT"))
	?h <- (http-date-header (name ?name) (http-date ?r))
	=>
	(retract ?r)
	(modify ?h (http-date (make-instance of RFC850-DATE (filename ?name) (day-name-l ?day-name-l) (date2 ?date2) (time ?time)))))

;   asctime-date = day-name SP date3 SP time-of-day SP year
;   date3        = month SP ( 2DIGIT / ( SP 1DIGIT ))
;                ; e.g., Jun  2
(defrule date3-end-month
	?c <- (char ?name 32) ; SP
	?m <- (month (value ?value&"Jan"|"Feb"|"Mar"|"Apr"|"May"|"Jun"|"Jul"|"Aug"|"Sep"|"Oct"|"Nov"|"Dec"))
	?d <- (date3 (name ?name) (month ?m))
	=>
	(retract ?c ?m)
	(modify ?d (month (make-instance of MONTH (filename ?name) (value ?value))))
	(assert (char ?name (get-char ?name))))

(defrule date3-detect-padding
	?c <- (char ?name 32) ; SP
	?d <- (date3 (name ?name) (month ?m&:(instancep ?m)) (day "") (padded FALSE))
	=>
	(retract ?c)
	(modify ?d (padded TRUE))
	(assert (char ?name (get-char ?name))))

(defrule date3-build-2digit-day
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?d <- (date3 (name ?name) (month ?m&:(instancep ?m)) (day ?day&:(> 2 (str-length ?day))) (padded FALSE))
	=>
	(retract ?c)
	(modify ?d (day (format nil "%s%c" ?day ?char)))
	(assert (char ?name (get-char ?name))))

(defrule date3-build-1digit-day
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?d <- (date3 (name ?name) (day "") (padded TRUE))
	=>
	(retract ?c)
	(modify ?d (day (format nil "%c" ?char)))
	(assert (char ?name (get-char ?name))))

(defrule asctime-date-end-date3-2digit
	(char ?name 32) ; SP
	?d <- (date3 (month ?month) (day ?day&:(= 2 (str-length ?day))) (padded FALSE))
	?a <- (asctime-date (name ?name) (date3 ?d))
	=>
	(retract ?d)
	(modify ?a (date3 (make-instance of DATE3 (filename ?name) (month ?month) (day ?day) (padded FALSE)))))

(defrule asctime-date-end-date3-1digit
	(char ?name 32) ; SP
	?d <- (date3 (month ?month) (day ?day&:(= 1 (str-length ?day))) (padded TRUE))
	?a <- (asctime-date (name ?name) (date3 ?d))
	=>
	(retract ?d)
	(modify ?a (date3 (make-instance of DATE3 (filename ?name) (month ?month) (day ?day) (padded TRUE)))))

(defrule asctime-date-start-time
	?c <- (char ?name 32) ; SP
	?a <- (asctime-date (name ?name) (date3 ?d&:(instancep ?d)) (time nil))
	=>
	(retract ?c)
	(modify ?a (time (assert (time (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule asctime-date-end-time
	?c <- (char ?name 32) ; SP
	?t <- (time (name ?name) (first-2digit ?first) (second-2digit ?second) (third-2digit ?third&:(= 2 (str-length ?third))))
	?a <- (asctime-date (name ?name) (time ?t))
	=>
	(retract ?c ?t)
	(modify ?a (time (make-instance of TIME (filename ?name) (first-2digit ?first) (second-2digit ?second) (third-2digit ?third))))
	(assert (char ?name (get-char ?name))))

(defrule asctime-date-build-year
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?a <- (asctime-date (name ?name) (time ?t&:(instancep ?t)) (year ?year&:(> 4 (str-length ?year))))
	=>
	(retract ?c)
	(modify ?a (year (format nil "%s%c" ?year ?char)))
	(assert (char ?name (get-char ?name))))

(defrule http-date-header-end-asctime-date
	(char ?name 9|13|32) ; HTAB CR SP
	?a <- (asctime-date (name ?name) (day-name ?day-name) (date3 ?date3) (time ?time) (year ?year&:(= 4 (str-length ?year))))
	?h <- (http-date-header (name ?name) (http-date ?a))
	=>
	(retract ?a)
	(modify ?h (http-date (make-instance of ASCTIME-DATE (filename ?name) (day-name ?day-name) (date3 ?date3) (time ?time) (year ?year)))))

(defrule end-date-header
	(char ?name 9|13|32) ; HTAB CR SP
	?h <- (http-date-header (name ?name) (http-date ?d&:(instancep ?d)))
	?fv <- (field-value (value ?h))
	(field-line (field-name ?fn) (field-value ?fv))
	(object (is-a FIELD-NAME) (name ?fn) (value "Date"))
	=>
	(retract ?h)
	(modify ?fv (value (make-instance of DATE-HEADER (filename ?name) (http-date ?d)))))

(defrule end-last-modified-header
	(char ?name 9|13|32) ; HTAB CR SP
	?h <- (http-date-header (name ?name) (http-date ?d&:(instancep ?d)))
	?fv <- (field-value (value ?h))
	(field-line (field-name ?fn) (field-value ?fv))
	(object (is-a FIELD-NAME) (name ?fn) (value "Last-Modified"))
	=>
	(retract ?h)
	(modify ?fv (value (make-instance of LAST-MODIFIED-HEADER (filename ?name) (http-date ?d)))))

(defrule end-if-modified-since-header
	(char ?name 9|13|32) ; HTAB CR SP
	?h <- (http-date-header (name ?name) (http-date ?d&:(instancep ?d)))
	?fv <- (field-value (value ?h))
	(field-line (field-name ?fn) (field-value ?fv))
	(object (is-a FIELD-NAME) (name ?fn) (value "If-Modified-Since"))
	=>
	(retract ?h)
	(modify ?fv (value (make-instance of IF-MODIFIED-SINCE-HEADER (filename ?name) (http-date ?d)))))

(defrule end-if-unmodified-since-header
	(char ?name 9|13|32) ; HTAB CR SP
	?h <- (http-date-header (name ?name) (http-date ?d&:(instancep ?d)))
	?fv <- (field-value (value ?h))
	(field-line (field-name ?fn) (field-value ?fv))
	(object (is-a FIELD-NAME) (name ?fn) (value "If-Unmodified-Since"))
	=>
	(retract ?h)
	(modify ?fv (value (make-instance of IF-UNMODIFIED-SINCE-HEADER (filename ?name) (http-date ?d)))))

(defrule end-content-type-header
	(char ?name 13)
	?cth <- (content-type-header (name ?name) (type ?type&:(instancep ?type)) (subtype ?subtype&:(instancep ?subtype)) (parameters $?parameters&:(= 0 (length$ ?parameters))|:(instancep (nth$ (length$ ?parameters) ?parameters))))
	?f <- (field-value (value ?cth))
	=>
	(retract ?cth)
	(modify ?f (value (make-instance of CONTENT-TYPE-HEADER (filename ?name) (type ?type) (subtype ?subtype) (parameters ?parameters)))))

(defrule end-host-header
	(char ?name 13|32) ; CR SP
	?hh <- (host-header (name ?name) (uri-host ?h&:(instancep ?h)) (port ?p&nil|:(instancep ?p)))
	?f <- (field-value (value ?hh))
	=>
	(retract ?hh)
	(modify ?f (value (make-instance of HOST-HEADER (filename ?name) (uri-host ?h) (port ?p)))))

;
;  Proxy-Authorization = credentials
;  credentials = auth-scheme [ 1*SP ( token68 / [ auth-param *( OWS "," OWS auth-param ) ] ) ]
;  auth-scheme = token
;  token68 = 1*( ALPHA / DIGIT / "-" / "." / "_" / "~" / "+" / "/" ) *"="
;  auth-param = token BWS "=" BWS ( token / quoted-string )
(defrule detect-proxy-authorization-header
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?o <- (object (is-a FIELD-NAME) (value "Proxy-Authorization"))
	?fv <- (field-value (name ?name) (value nil))
	?fl <- (field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (proxy-authorization-header (name ?name) (auth-scheme (assert (token (name ?name)))))))))

(defrule proxy-authorization-header-end-auth-scheme
	(char ?name 9|13|32) ; HTAB CR SP
	?t <- (token (value ?value))
	?p <- (proxy-authorization-header (name ?name) (auth-scheme ?t))
	=>
	(retract ?t)
	(modify ?p (auth-scheme ?value))
	(assert (char ?name (get-char ?name))))

(defrule proxy-authorization-detect-second-part-after-auth-scheme
	?c <- (char ?name 32) ; SP
	?p <- (proxy-authorization-header (name ?name) (auth-scheme ?auth-scheme&:(stringp ?auth-scheme)) (second-part))
	=>
	(retract ?c)
	(modify ?p (second-part (assert (token68 (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule proxy-authorization-skip-sp-after-auth-scheme
	?c <- (char ?name 32) ; SP
	?t <- (token68 (name ?name) (value ""))
	(proxy-authorization-header (name ?name) (second-part ?t))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule build-token68
	?c <- (char ?name ?char&:(member$ ?char ?*token68*))
	?t <- (token68 (name ?name) (value ?value) (equals 0))
	=>
	(retract ?c)
	(modify ?t (value (format nil "%s%c" ?value ?char)))
	(assert (char ?name (get-char ?name))))

(defrule token68-detect-equals
	?c <- (char ?name 61) ; =
	?t <- (token68 (name ?name) (value ?value) (equals ?equals))
	=>
	(retract ?c)
	(modify ?t (equals (+ 1 ?equals)))
	(assert (char ?name (get-char ?name))))

(defrule proxy-authorization-end-token68
	(char ?name 9|13|32) ; HTAB CR SP
	?t <- (token68 (name ?name) (value ?value&~"") (equals ?equals))
	?p <- (proxy-authorization-header (name ?name) (second-part ?t))
	=>
	(retract ?t)
	(modify ?p (second-part (make-instance of TOKEN68 (filename ?name) (value ?value) (equals ?equals)))))

(defrule proxy-authorization-change-token68-to-auth-param
	(char ?name ?char&~:(member$ ?char ?*token68*)&:(member$ ?char ?*tchar*))
	?t <- (token68 (name ?name) (value ?value) (equals 0))
	?p <- (proxy-authorization-header (name ?name) (second-part ?t))
	=>
	(retract ?t)
	(modify ?p (second-part (assert (auth-param (name ?name) (left-side (assert (token (name ?name) (value ?value)))))))))

(defrule proxy-authorization-change-token68-to-auth-param-after-equals
	(char ?name ?char&~:(member$ ?char ?*token68*)&:(member$ ?char ?*tchar*))
	?t <- (token68 (name ?name) (value ?value&~:(str-index "/" ?value)) (equals 1))
	?p <- (proxy-authorization-header (name ?name) (second-part ?t))
	=>
	(retract ?t)
	(modify ?p (second-part (assert (auth-param (name ?name) (left-side ?value) (right-side (assert (token (name ?name)))))))))

(defrule auth-param-end-left-side
	?c <- (char ?name 61) ; =
	?t <- (token (value ?value))
	?a <- (auth-param (name ?name) (left-side ?t))
	=>
	(retract ?c ?t)
	(modify ?a (left-side ?value) (right-side (assert (token (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule auth-param-end-left-side
	(char ?name 9|13|32|44) ; HTAB CR SP ,
	?t <- (token (value ?value))
	?a <- (auth-param (name ?name) (right-side ?t))
	=>
	(retract ?t)
	(modify ?a (right-side ?value)))

(defrule proxy-authorization-header-end-auth-param
	(char ?name 9|13|32|44) ; HTAB CR SP ,
	?a <- (auth-param (name ?name) (left-side ?left-side) (right-side ?right-side&:(stringp ?right-side)))
	?p <- (proxy-authorization-header (name ?name) (second-part $?auth-params ?a))
	=>
	(retract ?a)
	(modify ?p (second-part ?auth-params (make-instance of AUTH-PARAM (filename ?name) (left-side ?left-side) (right-side ?right-side)))))

(defrule proxy-authorization-header-detext-next-auth-param
	?c <- (char ?name 44) ; ,
	?auth-param <- (object (is-a AUTH-PARAM))
	?p <- (proxy-authorization-header (name ?name) (second-part $?auth-params ?auth-param))
	=>
	(retract ?c)
	(modify ?p (second-part ?auth-params ?auth-param (assert (auth-param (name ?name) (left-side (assert (token (name ?name)))))))))

(defrule proxy-authorization-header-skip-ows-after-auth-param
	?c <- (char ?name 9|32) ; HTAB SP
	?clh <- (proxy-authorization-header (name ?name) (auth-scheme ?auth-scheme) (second-part $?auth-params&:(instancep (nth$ (length$ ?auth-params) ?auth-params))))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule end-proxy-authorization-header
	(char ?name 13) ; CR
	?clh <- (proxy-authorization-header (name ?name) (auth-scheme ?auth-scheme) (second-part $?auth-params&:(instancep (nth$ (length$ ?auth-params) ?auth-params))))
	?fv <- (field-value (value ?clh))
	=>
	(retract ?clh)
	(modify ?fv (value (make-instance of PROXY-AUTHORIZATION-HEADER (filename ?name) (auth-scheme ?auth-scheme) (second-part ?auth-params)))))

;   TE                 = #t-codings
;  t-codings          = "trailers" / ( transfer-coding [ weight ] )
;  transfer-coding    = token *( OWS ";" OWS transfer-parameter )
;  transfer-parameter = token BWS "=" BWS ( token / quoted-string )

(defrule detect-te-header
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?o <- (object (is-a FIELD-NAME) (value "TE"))
	?fv <- (field-value (name ?name) (value nil))
	?fl <- (field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (te-header (name ?name) (t-codings (assert (t-coding (name ?name) (value (assert (token (name ?name))))))))))))

(defrule t-coding-end-value
	(char ?name 9|13|32|44|59) ; HTAB CR SP , ;
	?t <- (token (name ?name) (value ?value))
	?t-coding <- (t-coding (name ?name) (value ?t))
	=>
	(retract ?t)
	(modify ?t-coding (value ?value)))

(defrule t-coding-ignore-ows-before-weight
	?c <- (char ?name 9|32) ; HTAB SP
	?l <- (t-coding (name ?name) (value ?value&:(stringp ?value)) (weight nil))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule t-coding-detect-weight
	?c <- (char ?name 59) ; ;
	?t <- (t-coding (name ?name) (value ?value&:(stringp ?value)&~"trailers") (weight nil))
	=>
	(retract ?c)
	(modify ?t (weight (assert (weight (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule t-coding-end-weight
	(char ?name 9|13|32|44) ; HTAB CR SP ,
	?w <- (weight (name ?name) (qvalue ?q&:(instancep ?q)))
	?t <- (t-coding (name ?name) (weight ?w))
	=>
	(retract ?w)
	(modify ?t (weight (make-instance of WEIGHT (filename ?name) (qvalue ?q)))))

(defrule te-header-end-t-coding
	(char ?name 9|13|32|44) ; HTAB CR SP ,
	?t <- (t-coding (name ?name) (value ?value&:(stringp ?value)) (weight ?w&nil|:(instancep ?w)))
	?te <- (te-header (t-codings $?t-codings ?t))
	=>
	(retract ?t)
	(modify ?te (t-codings ?t-codings (make-instance of T-CODING (filename ?name) (value ?value) (weight ?w)))))

(defrule te-header-detect-next-t-coding
	?c <- (char ?name 44) ; ,
	?t <- (te-header (name ?name) (t-codings $?t-codings ?t-coding&:(instancep ?t-coding)))
	=>
	(retract ?c)
	(modify ?t (t-codings ?t-codings ?t-coding (assert (t-coding (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule te-header-ignore-ows-before-next-t-coding
	?c <- (char ?name 9|32) ; HTAB SP
	?t <- (t-coding (name ?name) (value nil))
	?te <- (te-header (t-codings $?t-codings ?t))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule te-header-ignore-ows-after-last-t-coding
	?c <- (char ?name 9|32) ; HTAB SP
	?clh <- (te-header (name ?name) (t-codings $?t-codings&:(instancep (nth$ (length$ ?t-codings) ?t-codings))))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule te-header-detect-next-t-coding-value
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?t <- (t-coding (name ?name) (value nil))
	=>
	(modify ?t (value (assert (token (name ?name))))))

(defrule end-te-header
	(char ?name 13) ; CR
	?clh <- (te-header (name ?name) (t-codings $?t-codings&:(instancep (nth$ (length$ ?t-codings) ?t-codings))))
	?fv <- (field-value (value ?clh))
	=>
	(retract ?clh)
	(modify ?fv (value (make-instance of TE-HEADER (filename ?name) (t-codings ?t-codings)))))

; range-set = range-spec *( OWS "," OWS range-spec )
; range-spec = int-range / suffix-range / other-range
; range-unit = token
; ranges-specifier = range-unit "=" range-set
;  Range = ranges-specifier
(defrule detect-range-header
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?o <- (object (is-a FIELD-NAME) (value "Range"))
	?fv <- (field-value (name ?name) (value nil))
	?fl <- (field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (range-header (name ?name) (ranges-specifier (assert (ranges-specifier (name ?name) (range-unit (assert (token (name ?name))))))))))))

(defrule ranges-specifier-end-range-unit
	?c <- (char ?name 61) ; =
	?t <- (token (name ?name) (value ?value))
	?r <- (ranges-specifier (name ?name) (range-unit ?t))
	=>
	(retract ?c ?t)
	(modify ?r (range-unit ?value) (range-set (assert (range-set (name ?name)))))
	(assert (char ?name (get-char ?name))))

; int-range = first-pos "-" [ last-pos ]
; other-range = 1*( %x21-2B ; '!'-'+'
;                 / %x2D-7E ; '-'-'~'
;                 )
;suffix-range = "-" suffix-length
; 
; first-pos = 1*DIGIT
; last-pos = 1*DIGIT
; suffix-length = 1*DIGIT
(defrule range-set-detect-first-range-spec
	(char ?name ?char&:(member$ ?char ?*other-range*))
	?r <- (range-set (name ?name) (range-specs))
	=>
	(modify ?r (range-specs (assert (range-spec (name ?name))))))

(defrule range-spec-detect-int-range
	(char ?name ?char&:(member$ ?char ?*digit*))
	?r <- (range-spec (name ?name) (value nil))
	=>
	(modify ?r (value (assert (int-range (name ?name))))))

(defrule range-spec-int-range-change-to-other-range-during-first-pos
	(char ?name ?char&~45&~:(member$ ?char ?*digit*)&:(member$ ?char ?*other-range*))
	?i <- (int-range (first-pos ?first-pos&~"") (last-pos nil))
	?r <- (range-spec (name ?name) (value ?i))
	=>
	(retract ?i)
	(modify ?r (value (assert (other-range (name ?name) (value ?first-pos))))))

(defrule range-spec-int-range-change-to-other-range-during-last-pos
	(char ?name ?char&~:(member$ ?char ?*digit*)&:(member$ ?char ?*other-range*))
	?i <- (int-range (first-pos ?first-pos) (last-pos ?last-pos&~nil))
	?r <- (range-spec (name ?name) (value ?i))
	=>
	(retract ?i)
	(modify ?r (value (assert (other-range (name ?name) (value (format nil "%s-%s" ?first-pos ?last-pos)))))))

(defrule range-spec-suffix-range-change-to-other-range
	(char ?name ?char&~:(member$ ?char ?*digit*)&:(member$ ?char ?*other-range*))
	?s <- (suffix-range (name ?name) (suffix-length ?suffix-length))
	?r <- (range-spec (value ?o))
	=>
	(retract ?s)
	(modify ?r (value (assert (other-range (name ?name) (value (format nil "-%s" ?suffix-length)))))))

(defrule range-spec-detect-suffix-range
	?c <- (char ?name 45) ; -
	?r <- (range-spec (name ?name) (value nil))
	=>
	(retract ?c)
	(modify ?r (value (assert (suffix-range (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule range-spec-detect-other-range
	?c <- (char ?name ?char&~45&~:(member$ ?char ?*digit*)&:(member$ ?char ?*other-range*)) ; -
	?r <- (range-spec (name ?name) (value nil))
	=>
	(retract ?c)
	(modify ?r (value (assert (other-range (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule build-other-range
	?c <- (char ?name ?char&:(member$ ?char ?*other-range*))
	?o <- (other-range (name ?name) (value ?value))
	=>
	(retract ?c)
	(modify ?o (value (format nil "%s%c" ?value ?char)))
	(assert (char ?name (get-char ?name))))

(defrule end-other-range
	(char ?name 9|13|32|44) ; HTAB CR SP ,
	?o <- (other-range (name ?name) (value ?value))
	?r <- (range-spec (value ?o))
	=>
	(retract ?o)
	(modify ?r (value (make-instance of OTHER-RANGE (filename ?name) (value ?value)))))

(defrule build-suffix-range
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?s <- (suffix-range (name ?name) (suffix-length ?suffix-length))
	=>
	(retract ?c)
	(modify ?s (suffix-length (format nil "%s%c" ?suffix-length ?char)))
	(assert (char ?name (get-char ?name))))

(defrule end-suffix-range
	(char ?name 9|13|32|44) ; HTAB CR SP ,
	?s <- (suffix-range (name ?name) (suffix-length ?suffix-length))
	?r <- (range-spec (value ?s))
	=>
	(retract ?s)
	(modify ?r (value (make-instance of SUFFIX-RANGE (filename ?name) (suffix-length ?suffix-length)))))

(defrule int-range-build-first-pos
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?i <- (int-range (name ?name) (first-pos ?value) (last-pos nil))
	=>
	(retract ?c)
	(modify ?i (first-pos (format nil "%s%c" ?value ?char)))
	(assert (char ?name (get-char ?name))))

(defrule int-range-detect-last-pos
	?c <- (char ?name 45) ; -
	?i <- (int-range (name ?name) (first-pos ?value) (last-pos nil))
	=>
	(retract ?c)
	(modify ?i (last-pos ""))
	(assert (char ?name (get-char ?name))))

(defrule int-range-build-last-pos
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?i <- (int-range (name ?name) (last-pos ?value&~nil))
	=>
	(retract ?c)
	(modify ?i (last-pos (format nil "%s%c" ?value ?char)))
	(assert (char ?name (get-char ?name))))

(defrule end-int-range
	(char ?name 9|13|32|44) ; HTAB CR SP ,
	?i <- (int-range (name ?name) (first-pos ?first-pos) (last-pos ?last-pos&~nil))
	?r <- (range-spec (value ?i))
	=>
	(retract ?i)
	(modify ?r (value (make-instance of INT-RANGE (filename ?name) (first-pos ?first-pos) (last-pos ?last-pos)))))

(defrule end-range-spec
	(char ?name 9|13|32|44) ; HTAB CR SP ,
	?r <- (range-spec (value ?value&:(instancep ?value)))
	?range-set <- (range-set (range-specs $?range-specs ?r))
	=>
	(retract ?r)
	(modify ?range-set (range-specs ?range-specs (make-instance of RANGE-SPEC (filename ?name) (value ?value)))))

(defrule range-set-skip-ows-after-range-spec
	?c <- (char ?name 9|32) ; HTAB SP
	(range-set (range-specs $?range-specs ?range-spec&:(instancep ?range-spec)))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule range-set-detect-next-range-spec
	?c <- (char ?name 44)
	?r <- (range-set (name ?name) (range-specs $?range-specs ?range-spec&:(instancep ?range-spec)))
	=>
	(retract ?c)
	(modify ?r (range-specs ?range-specs ?range-spec (assert (range-spec (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule range-set-skip-ows-before-next-range-spec
	?c <- (char ?name 9|32) ; HTAB SP
	?r <- (range-spec (value nil))
	(range-set (range-specs $?range-specs ?r))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule end-range-set
	(char ?name 13) ; CR
	?r <- (range-set (name ?name) (range-specs $?range-specs ?range-spec&:(instancep ?range-spec)))
	?ranges-specifier <- (ranges-specifier (range-set ?r))
	=>
	(retract ?r)
	(modify ?ranges-specifier (range-set (make-instance of RANGE-SET (filename ?name) (range-specs ?range-specs ?range-spec)))))

(defrule end-ranges-specifier
	(char ?name 13) ; CR
	?ranges-specifier <- (ranges-specifier (range-unit ?u&:(stringp ?u)) (range-set ?r&:(instancep ?r)))
	?range-header <- (range-header (name ?name) (ranges-specifier ?ranges-specifier))
	=>
	(retract ?ranges-specifier)
	(modify ?range-header (ranges-specifier (make-instance of RANGES-SPECIFIER (filename ?name) (range-unit ?u) (range-set ?r)))))

(defrule end-range-header
	(char ?name 13) ; CR
	?r <- (range-header (name ?name) (ranges-specifier ?ranges-specifier&:(instancep ?ranges-specifier)))
	?fv <- (field-value (value ?r))
	=>
	(retract ?r)
	(modify ?fv (value (make-instance of RANGE-HEADER (filename ?name) (ranges-specifier ?ranges-specifier)))))

(defrule ignore-ows-at-end-of-field-value
	?c <- (char ?name 9|32) ; HTAB SP
	(field-value (name ?name) (value ?v&:(instancep ?v)))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule end-field-value
	?c <- (char ?name 13) ; CR
	?fv <- (field-value (name ?name) (value ?v&:(instancep ?v)))
	?fl <- (field-line (field-value ?fv))
	=>
	(retract ?c ?fv)
	(modify ?fl (field-value (make-instance of FIELD-VALUE (filename ?name) (value ?v))))
	(assert (char ?name (get-char ?name))))

(defrule end-field-line
	?c <- (char ?name 10) ; LF
	?f <- (field-line (field-name ?field-name) (field-value ?field-value&:(instancep ?field-value)))
	?h <- (http-message (name ?name) (field-lines $?field-lines ?f))
	=>
	(retract ?c ?f)
	(modify ?h (field-lines ?field-lines (make-instance of FIELD-LINE (filename ?name) (field-name ?field-name) (field-value ?field-value))))
	(assert (char ?name (get-char ?name))))

(defrule http-message-detect-message-body
	?c <- (char ?name 13) ; CR
	?h <- (http-message (name ?name) (start-line ?start-line&:(instancep ?start-line)) (field-lines $?field-lines&:(= 0 (length$ ?field-lines))|:(instancep (nth$ (length$ ?field-lines) ?field-lines))) (message-body nil))
	=>
	(retract ?c)
	(modify ?h (message-body (assert (message-body (name ?name)))))
	(assert (char ?name (get-char ?name))))

;   Expect      = #expectation
;    expectation = token [ "=" ( token / quoted-string ) parameters ]
;     parameters = *( OWS ";" OWS [ parameter ] )
(defrule detect-expect-header
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?o <- (object (is-a FIELD-NAME) (value "Expect"))
	?fv <- (field-value (name ?name) (value nil))
	?fl <- (field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (expect-header (name ?name) (expectations (assert (expectation (name ?name) (token (assert (token (name ?name))))))))))))

(defrule expect-header-skip-ows-before-expectation
	?c <- (char ?name 9|32) ; HTAB SP
	?t <- (token (name ?name) (value ""))
	?e <- (expectation (name ?name) (token ?t))
	(expect-header (name ?name) (expectations $?expectations ?e))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule expectation-end-token
	(char ?name 9|13|32|44|59|61) ; HTAB CR SP , ; =
	?t <- (token (name ?name) (value ?value&~""))
	?e <- (expectation (name ?name) (token ?t))
	=>
	(retract ?t)
	(modify ?e (token ?value)))

(defrule expectation-detect-equals
	?c <- (char ?name 61) ; =
	?e <- (expectation (name ?name) (token ?token&:(stringp ?token)) (equals FALSE))
	=>
	(retract ?c)
	(modify ?e (equals TRUE))
	(assert (char ?name (get-char ?name))))

(defrule expectation-detect-value-token
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?e <- (expectation (name ?name) (equals TRUE) (value nil))
	=>
	(modify ?e (value (assert (token (name ?name))))))

(defrule expectation-end-value-token
	(char ?name 9|13|32|44|59) ; HTAB CR SP , ;
	?t <- (token (name ?name) (value ?value&~""))
	?e <- (expectation (name ?name) (value ?t))
	=>
	(retract ?t)
	(modify ?e (value ?value)))

(defrule expectation-detect-value-quoted-string
	?c <- (char ?name 34) ; "
	?e <- (expectation (name ?name) (equals TRUE) (value nil))
	=>
	(retract ?c)
	(modify ?e (value (assert (quoted-string (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule expectation-end-value-quoted-string
	?c <- (char ?name 34) ; "
	?q <- (quoted-string (name ?name) (value ?value&:(stringp ?value)))
	?e <- (expectation (name ?name) (value ?q))
	(not (quoted-pair ?name))
	=>
	(retract ?c ?q)
	(modify ?e (value (make-instance of QUOTED-STRING (filename ?name) (value ?value))))
	(assert (char ?name (get-char ?name))))

(defrule expectation-detect-parameter
	?c <- (char ?name 59) ; ;
	?e <- (expectation (name ?name) (token ?token&:(stringp ?token)) (value ?value&nil|:(stringp ?value)|:(instancep ?value)) (parameters $?parameters&:(= 0 (length$ ?parameters))|:(instancep (nth$ (length$ ?parameters) ?parameters))))
	=>
	(retract ?c)
	(modify ?e (parameters ?parameters (assert (parameter (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule expectation-end-parameter
	(char ?name 9|13|32|44|59) ; HTAB CR SP , ;
	?p <- (parameter (parameter-name ?pn&:(stringp ?pn)) (parameter-value ?pv&:(stringp ?pv)|:(instancep ?pv)))
	?e <- (expectation (name ?name) (parameters $?parameters ?p))
	=>
	(retract ?p)
	(modify ?e (parameters ?parameters (make-instance of PARAMETER (filename ?name) (parameter-name ?pn) (parameter-value ?pv)))))

(defrule expect-header-end-expectation
	(char ?name 13|44) ; CR ,
	?e <- (expectation (name ?name) (token ?token&:(stringp ?token)) (value ?value&nil|:(stringp ?value)|:(instancep ?value)) (parameters $?parameters&:(= 0 (length$ ?parameters))|:(instancep (nth$ (length$ ?parameters) ?parameters))))
	?eh <- (expect-header (name ?name) (expectations $?expectations ?e))
	=>
	(retract ?e)
	(modify ?eh (expectations ?expectations (make-instance of EXPECTATION (filename ?name) (token ?token) (value ?value) (parameters ?parameters)))))

; OWS is allowed after a completed expectation, both before the "," that
; starts the next one and before the ";" that starts a parameter, so the
; expectation is not ended here -- only the whitespace is consumed.
(defrule expectation-skip-ows-after-token
	?c <- (char ?name 9|32) ; HTAB SP
	?e <- (expectation (name ?name) (token ?token&:(stringp ?token)) (value ?value&nil|:(stringp ?value)|:(instancep ?value)) (equals ?equals&:(or (eq ?equals FALSE) (neq ?value nil))) (parameters $?parameters&:(= 0 (length$ ?parameters))|:(instancep (nth$ (length$ ?parameters) ?parameters))))
	(expect-header (name ?name) (expectations $?expectations ?e))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule expect-header-detect-next-expectation
	?c <- (char ?name 44) ; ,
	?eh <- (expect-header (name ?name) (expectations $?expectations ?e&:(instancep ?e)))
	=>
	(retract ?c)
	(modify ?eh (expectations ?expectations ?e (assert (expectation (name ?name) (token (assert (token (name ?name))))))))
	(assert (char ?name (get-char ?name))))

(defrule end-expect-header
	(char ?name 13) ; CR
	?eh <- (expect-header (name ?name) (expectations $?expectations&:(instancep (nth$ (length$ ?expectations) ?expectations))))
	?fv <- (field-value (value ?eh))
	=>
	(retract ?eh)
	(modify ?fv (value (make-instance of EXPECT-HEADER (filename ?name) (expectations ?expectations)))))

;   Cache-Control   = #cache-directive
;    cache-directive = token [ "=" ( token / quoted-string ) ]
;   Pragma           = #pragma-directive
;    pragma-directive = "no-cache" / extension-pragma
;    extension-pragma = token [ "=" ( token / quoted-string ) ]
; Pragma (RFC 9111 5.4, deprecated) shares the cache-directive grammar, so the
; same cache-control-header fact and rules build both; only the end rule differs.
(defrule detect-cache-control-header
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?o <- (object (is-a FIELD-NAME) (value "Cache-Control"|"Pragma"))
	?fv <- (field-value (name ?name) (value nil))
	?fl <- (field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (cache-control-header (name ?name) (cache-directives (assert (cache-directive (name ?name) (token (assert (token (name ?name))))))))))))

(defrule cache-control-header-skip-ows-before-cache-directive
	?c <- (char ?name 9|32) ; HTAB SP
	?t <- (token (name ?name) (value ""))
	?cd <- (cache-directive (name ?name) (token ?t))
	(cache-control-header (name ?name) (cache-directives $?cache-directives ?cd))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule cache-directive-end-token
	(char ?name 9|13|32|44|61) ; HTAB CR SP , =
	?t <- (token (name ?name) (value ?value&~""))
	?cd <- (cache-directive (name ?name) (token ?t))
	=>
	(retract ?t)
	(modify ?cd (token ?value)))

(defrule cache-directive-detect-equals
	?c <- (char ?name 61) ; =
	?cd <- (cache-directive (name ?name) (token ?token&:(stringp ?token)) (equals FALSE))
	=>
	(retract ?c)
	(modify ?cd (equals TRUE))
	(assert (char ?name (get-char ?name))))

(defrule cache-directive-detect-value-token
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?cd <- (cache-directive (name ?name) (equals TRUE) (value nil))
	=>
	(modify ?cd (value (assert (token (name ?name))))))

(defrule cache-directive-end-value-token
	(char ?name 9|13|32|44) ; HTAB CR SP ,
	?t <- (token (name ?name) (value ?value&~""))
	?cd <- (cache-directive (name ?name) (value ?t))
	=>
	(retract ?t)
	(modify ?cd (value ?value)))

(defrule cache-directive-detect-value-quoted-string
	?c <- (char ?name 34) ; "
	?cd <- (cache-directive (name ?name) (equals TRUE) (value nil))
	=>
	(retract ?c)
	(modify ?cd (value (assert (quoted-string (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule cache-directive-end-value-quoted-string
	?c <- (char ?name 34) ; "
	?q <- (quoted-string (name ?name) (value ?value&:(stringp ?value)))
	?cd <- (cache-directive (name ?name) (value ?q))
	(not (quoted-pair ?name))
	=>
	(retract ?c ?q)
	(modify ?cd (value (make-instance of QUOTED-STRING (filename ?name) (value ?value))))
	(assert (char ?name (get-char ?name))))

; OWS is allowed after a completed cache-directive, before the "," that starts
; the next one, so the directive is not ended here -- only the whitespace is
; consumed.
(defrule cache-directive-skip-ows-after-token
	?c <- (char ?name 9|32) ; HTAB SP
	?cd <- (cache-directive (name ?name) (token ?token&:(stringp ?token)) (value ?value&nil|:(stringp ?value)|:(instancep ?value)) (equals ?equals&:(or (eq ?equals FALSE) (neq ?value nil))))
	(cache-control-header (name ?name) (cache-directives $?cache-directives ?cd))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name))))

(defrule cache-control-header-end-cache-directive
	(char ?name 13|44) ; CR ,
	?cd <- (cache-directive (name ?name) (token ?token&:(stringp ?token)) (value ?value&nil|:(stringp ?value)|:(instancep ?value)) (equals ?equals&:(or (eq ?equals FALSE) (neq ?value nil))))
	?cch <- (cache-control-header (name ?name) (cache-directives $?cache-directives ?cd))
	=>
	(retract ?cd)
	(modify ?cch (cache-directives ?cache-directives (make-instance of CACHE-DIRECTIVE (filename ?name) (token ?token) (value ?value)))))

(defrule cache-control-header-detect-next-cache-directive
	?c <- (char ?name 44) ; ,
	?cch <- (cache-control-header (name ?name) (cache-directives $?cache-directives ?cd&:(instancep ?cd)))
	=>
	(retract ?c)
	(modify ?cch (cache-directives ?cache-directives ?cd (assert (cache-directive (name ?name) (token (assert (token (name ?name))))))))
	(assert (char ?name (get-char ?name))))

(defrule end-cache-control-header
	(char ?name 13) ; CR
	?cch <- (cache-control-header (name ?name) (cache-directives $?cache-directives&:(instancep (nth$ (length$ ?cache-directives) ?cache-directives))))
	?fv <- (field-value (value ?cch))
	(field-line (field-name ?fn) (field-value ?fv))
	(object (is-a FIELD-NAME) (name ?fn) (value "Cache-Control"))
	=>
	(retract ?cch)
	(modify ?fv (value (make-instance of CACHE-CONTROL-HEADER (filename ?name) (cache-directives ?cache-directives)))))

(defrule end-pragma-header
	(char ?name 13) ; CR
	?cch <- (cache-control-header (name ?name) (cache-directives $?cache-directives&:(instancep (nth$ (length$ ?cache-directives) ?cache-directives))))
	?fv <- (field-value (value ?cch))
	(field-line (field-name ?fn) (field-value ?fv))
	(object (is-a FIELD-NAME) (name ?fn) (value "Pragma"))
	=>
	(retract ?cch)
	(modify ?fv (value (make-instance of PRAGMA-HEADER (filename ?name) (cache-directives ?cache-directives)))))

(defrule message-body-set-length-remaining
	(char ?name 10) ; LF
	?m <- (message-body (name ?name) (length-remaining nil))
	(object (is-a CONTENT-LENGTH-HEADER) (filename ?name) (value ?value&~"0"))
	=>
	(modify ?m (length-remaining (string-to-field ?value))))

(defrule message-body-determine-empty
	?c <- (char ?name 10) ; LF
	?m <- (message-body (name ?name) (length-remaining nil))
	(or
		(not (object (is-a CONTENT-LENGTH-HEADER) (filename ?name)))
		(object (is-a CONTENT-LENGTH-HEADER) (filename ?name) (value "0")))
	=>
	(retract ?c)
	(modify ?m (length-remaining 0))
	(assert (char ?name (get-char ?name))))

(defrule message-body-detect-application-octet-stream
	?c <- (char ?name 10) ; LF
	?m <- (message-body (name ?name) (length-remaining ?length-remaining&~nil&:(> ?length-remaining 0)) (value nil))
	(or
		(not (object (is-a CONTENT-TYPE-HEADER) (filename ?name)))
		(and
			(object (is-a TYPE) (filename ?name) (value "application"))
			(object (is-a SUBTYPE) (filename ?name) (value "octet-stream")))
		(and
			(object (is-a TYPE) (filename ?name) (value ?type))
			(object (is-a SUBTYPE) (filename ?name) (value ?subtype))
			(not (supported-content-type ?type ?subtype))))
	=>
	(retract ?c)
	(modify ?m (value (assert (octet-stream (name ?name)))))
	(assert (char ?name (get-char ?name))))

(defrule message-body-detect-application-x-www-form-urlencoded
	?c <- (char ?name 10) ; LF
	?m <- (message-body (name ?name) (length-remaining ?length-remaining&~nil&:(> ?length-remaining 0)) (value nil))
	(object (is-a TYPE) (filename ?name) (value "application"))
	(object (is-a SUBTYPE) (filename ?name) (value "x-www-form-urlencoded"))
	=>
	(retract ?c)
	(modify ?m (value (assert (x-www-form-urlencoded (name ?name) (sequences (assert (sequence (name ?name))))))))
	(assert (char ?name (get-char ?name))))

(defrule build-octet-stream
	?c <- (char ?name ?char)
	?o <- (octet-stream (name ?name) (value ?value))
	?m <- (message-body (length-remaining ?length-remaining&~nil&:(> ?length-remaining 0)) (value ?o))
	=>
	(retract ?c)
	(modify ?o (value (format nil "%s%c" ?value ?char)))
	(modify ?m (length-remaining (- ?length-remaining 1)))
	(assert (char ?name (get-char ?name))))

(defrule x-www-form-urlencoded-build-name-string
	?c <- (char ?name ?char&~61) ; =
	?sequence <- (sequence (name ?name) (name-string ?name-string) (value-string nil))
	?x <- (x-www-form-urlencoded (sequences $?sequences ?sequence))
	?m <- (message-body (length-remaining ?length-remaining&~nil&:(> ?length-remaining 0)) (value ?x))
	=>
	(retract ?c)
	(modify ?sequence (name-string (format nil "%s%c" ?name-string ?char)))
	(modify ?m (length-remaining (- ?length-remaining 1)))
	(assert (char ?name (get-char ?name))))

(defrule x-www-form-urlencoded-end-name-string
	?c <- (char ?name 61) ; =
	?sequence <- (sequence (name ?name) (name-string ?name-string) (value-string nil))
	?x <- (x-www-form-urlencoded (sequences $?sequences ?sequence))
	?m <- (message-body (length-remaining ?length-remaining&~nil&:(> ?length-remaining 0)) (value ?x))
	=>
	(retract ?c)
	(modify ?sequence (value-string ""))
	(modify ?m (length-remaining (- ?length-remaining 1)))
	(assert (char ?name (get-char ?name))))

(defrule x-www-form-urlencoded-build-value-string
	?c <- (char ?name ?char&~38) ; &
	?sequence <- (sequence (name ?name) (value-string ?value-string&~nil))
	?x <- (x-www-form-urlencoded (sequences $?sequences ?sequence))
	?m <- (message-body (length-remaining ?length-remaining&~nil&:(> ?length-remaining 0)) (value ?x))
	=>
	(retract ?c)
	(modify ?sequence (value-string (format nil "%s%c" ?value-string ?char)))
	(modify ?m (length-remaining (- ?length-remaining 1)))
	(assert (char ?name (get-char ?name))))

(defrule x-www-form-urlencoded-end-sequence-and-start-next-sequence
	?c <- (char ?name 38) ; &
	?sequence <- (sequence (name ?name) (name-string ?name-string) (value-string ?value-string))
	?x <- (x-www-form-urlencoded (sequences $?sequences ?sequence))
	?m <- (message-body (length-remaining ?length-remaining&~nil&:(> ?length-remaining 0)) (value ?x))
	=>
	(retract ?c ?sequence)
	(modify ?x (sequences ?sequences (make-instance of SEQUENCE (filename ?name) (name-string ?name-string) (value-string ?value-string)) (assert (sequence (name ?name)))))
	(modify ?m (length-remaining (- ?length-remaining 1)))
	(assert (char ?name (get-char ?name))))

(defrule end-octet-stream
	(char ?name -1)
	?o <- (octet-stream (name ?name) (value ?value))
	?m <- (message-body (length-remaining 0) (value ?o))
	=>
	(retract ?o)
	(modify ?m (value (make-instance of OCTET-STREAM (filename ?name) (value ?value)))))

(defrule x-www-form-urlencoded-end-sequence
	(char ?name -1)
	?sequence <- (sequence (name ?name) (name-string ?name-string) (value-string ?value-string))
	?x <- (x-www-form-urlencoded (sequences $?sequences ?sequence))
	?m <- (message-body (length-remaining 0) (value ?x))
	=>
	(retract ?sequence)
	(modify ?x (sequences ?sequences (make-instance of SEQUENCE (filename ?name) (name-string ?name-string) (value-string ?value-string)))))

(defrule end-x-www-form-urlencoded
	(char ?name -1)
	?x <- (x-www-form-urlencoded (name ?name) (sequences $?sequences&:(= 0 (length$ ?sequences))|:(instancep (nth$ (length$ ?sequences) ?sequences))))
	?m <- (message-body (length-remaining 0) (value ?x))
	=>
	(retract ?x)
	(modify ?m (value (make-instance of X-WWW-FORM-URLENCODED (filename ?name) (sequences ?sequences)))))

(defrule http-message-end-message-body
	(char ?name -1)
	?m <- (message-body (value ?value&nil|:(instancep ?value)) (length-remaining 0))
	?h <- (http-message (name ?name) (message-body ?m))
	=>
	(retract ?m)
	(modify ?h (message-body (make-instance of MESSAGE-BODY (filename ?name) (value ?value)))))

(defrule end-http-message
	(char ?name -1)
	;(start ?name ?start)
	?h <- (http-message (name ?name) (start-line ?s) (field-lines $?f) (message-body ?m&:(instancep ?m)))
=>
;(println ?name ": " (- (time) ?start))
(retract ?h)
(make-instance of HTTP-MESSAGE (filename ?name) (start-line ?s) (field-lines $?f) (message-body ?m)))

; Serializes a quoted-string value, re-escaping the DQUOTE and "\" that
; quoted-pair strips out when the value is parsed.
(deffunction print-quoted-string (?t ?value)
	(printout ?t "\"")
	(bind ?i 1)
	(while (<= ?i (str-length ?value))
		(bind ?c (sub-string ?i ?i ?value))
		(if (or (eq ?c "\"") (eq ?c "\\")) then (printout ?t "\\"))
		(printout ?t ?c)
		(bind ?i (+ ?i 1)))
	(printout ?t "\""))

(defmessage-handler METHOD pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler PARAMETER pprint primary (?t)
(if (instancep ?self:parameter-value)
then (printout ?t ?self:parameter-name "=")
     (print-quoted-string ?t (send ?self:parameter-value get-value))
else (if (eq "charset" (lowcase ?self:parameter-name))
     then (printout ?t (lowcase ?self:parameter-name) "=" (lowcase ?self:parameter-value))
     else (printout ?t ?self:parameter-name "=" ?self:parameter-value))))

(defmessage-handler SEGMENT pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler SCHEME pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler USERINFO pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler HOST pprint primary (?t)
(send ?self:value pprint ?t))

(defmessage-handler IP-LITERAL pprint primary (?t)
(printout ?t "[")
(send ?self:value pprint ?t)
(printout ?t "]"))

(defmessage-handler IPV6ADDRESS pprint primary (?t)
(if (neq ?self:parts nil) then
(bind ?parts ?self:parts)
(bind ?len (length$ ?parts))
(bind ?i 0)
(foreach ?part ?parts
(bind ?i (+ ?i 1))
(if (instancep ?part) then
(send ?part pprint ?t)
(if (< ?i ?len) then (printout ?t ":") else (printout ?t))
else (printout ?t ":") (if (= 1 ?len) then (printout ?t ":"))))))

(defmessage-handler H16 pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler REG-NAME pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler PORT pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler QUERY pprint primary (?t)
(printout ?t "?" ?self:value))

(defmessage-handler PATH-ABSOLUTE pprint primary (?t)
(printout ?t "/")
(if (neq ?self:segments nil) then
(bind ?segs ?self:segments)
(bind ?len (length$ ?segs))
(bind ?i 0)
(foreach ?seg ?segs
(bind ?i (+ ?i 1))
(send ?seg pprint ?t)
(if (< ?i ?len) then (printout ?t "/") else (printout ?t)))))

(defmessage-handler PATH-ABEMPTY pprint primary (?t)
(printout ?t "/")
(if (neq ?self:segments nil) then
(bind ?segs ?self:segments)
(bind ?len (length$ ?segs))
(bind ?i 0)
(foreach ?seg ?segs
(bind ?i (+ ?i 1))
(send ?seg pprint ?t)
(if (< ?i ?len) then (printout ?t "/") else (printout ?t)))))

(defmessage-handler ORIGIN-FORM pprint primary (?t)
(printout ?t "/")
(if (neq ?self:segments nil) then
(bind ?segs ?self:segments)
(bind ?len (length$ ?segs))
(bind ?i 0)
(foreach ?seg ?segs
(bind ?i (+ ?i 1))
(send ?seg pprint ?t)
(if (< ?i ?len) then (printout ?t "/") else (printout ?t))))
(if (neq ?self:query nil) then
(send ?self:query pprint ?t)))

(defmessage-handler AUTHORITY pprint primary (?t)
(if (neq ?self:userinfo nil)
then (send ?self:userinfo pprint ?t) (printout ?t "@"))
(if (neq ?self:host nil)
then (send ?self:host pprint ?t))
(if (neq ?self:port nil)
then (printout ?t ":") (send ?self:port pprint ?t)))

(defmessage-handler AUTHORITY-FORM pprint primary (?t)
(if (neq ?self:uri-host nil)
then (send ?self:uri-host pprint ?t))
(if (neq ?self:port nil)
then (printout ?t ":") (send ?self:port pprint ?t)))

(defmessage-handler HIER-PART pprint primary (?t)
(if (neq ?self:authority nil)
then (printout ?t "//") (send ?self:authority pprint ?t))
(if (neq ?self:path nil)
then (send ?self:path pprint ?t)))

(defmessage-handler ABSOLUTE-URI pprint primary (?t)
(send ?self:scheme pprint ?t)
(printout ?t ":")
(send ?self:hier-part pprint ?t)
(if (neq ?self:query nil)
then (send ?self:query pprint ?t)))

(defmessage-handler ASTERISK-FORM pprint primary (?t)
(printout ?t "*"))

(defmessage-handler HTTP-VERSION pprint primary (?t)
(printout ?t "HTTP/" ?self:major "." ?self:minor))

(defmessage-handler REQUEST-LINE pprint primary (?t)
(send ?self:method pprint ?t)
(printout ?t " ")
(send ?self:request-target pprint ?t)
(printout ?t " ")
(send ?self:http-version pprint ?t)
(printout ?t crlf))

(defmessage-handler STATUS-LINE pprint primary (?t)
(send ?self:http-version pprint ?t)
(printout ?t " " ?self:status-code " ")
(send ?self:reason-phrase pprint ?t)
(printout ?t crlf))

(defmessage-handler REASON-PHRASE pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler FIELD-LINE pprint primary (?t)
(send ?self:field-name pprint ?t)
(printout ?t ": ")
(send ?self:field-value pprint ?t)
(printout ?t crlf))

(defmessage-handler FIELD-NAME pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler FIELD-VALUE pprint primary (?t)
(send ?self:value pprint ?t))

(defmessage-handler MESSAGE-BODY pprint primary (?t)
(if (neq ?self:value nil)
then (send ?self:value pprint ?t)))

(defmessage-handler HTTP-MESSAGE pprint primary (?t)
(send ?self:start-line pprint ?t)
(if (neq ?self:field-lines nil)
then (foreach ?f ?self:field-lines
     (send ?f pprint ?t)))
(printout ?t crlf)
(if (neq ?self:message-body nil)
then (send ?self:message-body pprint ?t)))

(defmessage-handler UNKNOWN-HEADER pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler ACCEPT-ENCODING-HEADER pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:codings
     (bind ?i (+ ?i 1))
     (send ?f pprint ?t)
     (if (< ?i (length$ ?self:codings)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler CONTENT-LENGTH-HEADER pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler MAX-FORWARDS-HEADER pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler CONTENT-TYPE-HEADER pprint primary (?t)
(send ?self:type pprint ?t)
(printout ?t "/")
(send ?self:subtype pprint ?t)
(if (neq ?self:parameters nil)
then (foreach ?f ?self:parameters
     (printout ?t ";")
     (send ?f pprint ?t))))

(defmessage-handler HOST-HEADER pprint primary (?t)
(send ?self:uri-host pprint ?t)
(if (neq ?self:port nil)
then (printout ?t ":") (send ?self:port pprint ?t)))

(defmessage-handler VIA-HEADER pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:values
     (bind ?i (+ ?i 1))
	(send ?f pprint ?t)
        (if (< ?i (length$ ?self:values)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler VIA-HEADER-VALUE pprint primary (?t)
	(send ?self:received-protocol pprint ?t)
	(printout ?t " ")
	(send ?self:received-by pprint ?t)
	(if (neq ?self:comment nil) then
		(printout ?t " ")
		(send ?self:comment pprint ?t)))

(defmessage-handler RECEIVED-PROTOCOL pprint primary (?t)
	(if (neq ?self:protocol-name nil)
		then (printout ?t ?self:protocol-name "/"))
	(printout ?t ?self:protocol-version))

(defmessage-handler RECEIVED-BY pprint primary (?t)
	(printout ?t ?self:pseudonym)
	(if (neq ?self:port nil)
		then (printout ?t ":" ?self:port)))

(defmessage-handler COMMENT pprint primary (?t)
	(printout ?t "(")
	(foreach ?f ?self:values
		(if (stringp ?f)
			then (printout ?t ?f)
			else (send ?f pprint ?t)))
	(printout ?t ")"))

(defmessage-handler PRODUCT-HEADER pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:values
     (bind ?i (+ ?i 1))
     (send ?f pprint ?t)
     (if (< ?i (length$ ?self:values)) then (printout ?t " ") else (printout ?t))))

(defmessage-handler PRODUCT pprint primary (?t)
	(printout ?t ?self:token)
	(if (neq ?self:product-version nil)
		then (printout ?t "/" ?self:product-version)))

(defmessage-handler TYPE pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler SUBTYPE pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler OCTET-STREAM pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler X-WWW-FORM-URLENCODED pprint primary (?t)
(if (neq ?self:sequences nil)
then (bind ?len (length$ ?self:sequences))
   (bind ?i 0)
   (foreach ?f ?self:sequences
     (bind ?i (+ ?i 1))
     (send ?f pprint ?t)
     (if (< ?i ?len) then (printout ?t "&") else (printout ?t)))))

(defmessage-handler SEQUENCE pprint primary (?t)
(printout ?t ?self:name-string "=" ?self:value-string))

(defmessage-handler CODING pprint primary (?t)
(printout ?t ?self:codings)
(if (neq ?self:weight nil)
then (printout ?t ";") (send ?self:weight pprint ?t)))

(defmessage-handler WEIGHT pprint primary (?t)
(printout ?t "q=")
(send ?self:qvalue pprint ?t))

(defmessage-handler QVALUE pprint primary (?t)
(printout ?t ?self:first)
(if (neq ?self:decimal nil)
then (printout ?t "." ?self:fraction)))

(defmessage-handler ACCEPT-HEADER pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:media-ranges
     (bind ?i (+ ?i 1))
     (send ?f pprint ?t)
     (if (< ?i (length$ ?self:media-ranges)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler MEDIA-RANGE pprint primary (?t)
	(send ?self:type pprint ?t)
	(printout ?t "/")
	(send ?self:subtype pprint ?t)
	(if (neq ?self:parameters nil)
	then (foreach ?f ?self:parameters
	     (printout ?t ";")
	     (send ?f pprint ?t)))
	(if (neq ?self:weight nil)
	then
	     (printout ?t ";")
	     (send ?self:weight pprint ?t)))

(defmessage-handler ACCEPT-LANGUAGE-HEADER pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:language-ranges
     (bind ?i (+ ?i 1))
     (send ?f pprint ?t)
     (if (< ?i (length$ ?self:language-ranges)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler LANGUAGE-RANGE pprint primary (?t)
	(send ?self:first-language pprint ?t)
	(bind ?i 0)
	(if (<> 0 (length$ ?self:languages))
	then
	     (printout ?t "-")
	     (foreach ?f ?self:languages
	     (bind ?i (+ ?i 1))
	     (send ?f pprint ?t)
	     (if (< ?i (length$ ?self:languages)) then (printout ?t "-") else (printout ?t))))
	(if (neq ?self:weight nil)
	then
	     (printout ?t ";")
	     (send ?self:weight pprint ?t)))

(defmessage-handler LANGUAGE pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler ALLOW-HEADER pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:methods
     (bind ?i (+ ?i 1))
     (send ?f pprint ?t)
     (if (< ?i (length$ ?self:methods)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler TOKEN-LIST-HEADER pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:tokens
     (bind ?i (+ ?i 1))
     (printout ?t ?f)
     (if (< ?i (length$ ?self:tokens)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler EXPECT-HEADER pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:expectations
     (bind ?i (+ ?i 1))
     (send ?f pprint ?t)
     (if (< ?i (length$ ?self:expectations)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler EXPECTATION pprint primary (?t)
	(printout ?t ?self:token)
	(if (neq ?self:value nil)
	then
	     (printout ?t "=")
	     (if (instancep ?self:value)
	     then (print-quoted-string ?t (send ?self:value get-value))
	     else (printout ?t ?self:value)))
	(foreach ?f ?self:parameters
	     (printout ?t ";")
	     (send ?f pprint ?t)))

(defmessage-handler CACHE-DIRECTIVE-HEADER pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:cache-directives
     (bind ?i (+ ?i 1))
     (send ?f pprint ?t)
     (if (< ?i (length$ ?self:cache-directives)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler CACHE-DIRECTIVE pprint primary (?t)
	(printout ?t ?self:token)
	(if (neq ?self:value nil)
	then
	     (printout ?t "=")
	     (if (instancep ?self:value)
	     then (print-quoted-string ?t (send ?self:value get-value))
	     else (printout ?t ?self:value))))

(defmessage-handler TE-HEADER pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:t-codings
     (bind ?i (+ ?i 1))
     (send ?f pprint ?t)
     (if (< ?i (length$ ?self:t-codings)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler T-CODING pprint primary (?t)
(printout ?t ?self:value)
(if (neq ?self:weight nil)
then (printout ?t ";") (send ?self:weight pprint ?t)))

(defmessage-handler RANGE-HEADER pprint primary (?t)
(send ?self:ranges-specifier pprint ?t))

(defmessage-handler RANGES-SPECIFIER pprint primary (?t)
(printout ?t ?self:range-unit "=")
(send ?self:range-set pprint ?t))

(defmessage-handler RANGE-UNIT pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler RANGE-SET pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:range-specs
     (bind ?i (+ ?i 1))
     (send ?f pprint ?t)
     (if (< ?i (length$ ?self:range-specs)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler RANGE-SPEC pprint primary (?t)
(send ?self:value pprint ?t))

(defmessage-handler INT-RANGE pprint primary (?t)
(printout ?t ?self:first-pos "-" ?self:last-pos))

(defmessage-handler SUFFIX-RANGE pprint primary (?t)
(printout ?t "-" ?self:suffix-length))

(defmessage-handler OTHER-RANGE pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler UPGRADE-HEADER pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:protocols
     (bind ?i (+ ?i 1))
     (send ?f pprint ?t)
     (if (< ?i (length$ ?self:protocols)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler PROTOCOL pprint primary (?t)
	(printout ?t ?self:protocol-name)
	(if (neq ?self:protocol-version nil)
		then (printout ?t "/" ?self:protocol-version)))

(defmessage-handler PROXY-AUTHORIZATION-HEADER pprint primary (?t)
	(printout ?t ?self:auth-scheme " ")
	(bind ?i 0)
	(foreach ?f ?self:second-part
		(bind ?i (+ ?i 1))
		(send ?f pprint ?t)
		(if (< ?i (length$ ?self:second-part)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler TOKEN68 pprint primary (?t)
	(printout ?t ?self:value)
	(bind ?i 0)
	(while (< ?i ?self:equals)
		(bind ?i (+ 1 ?i))
		(printout ?t "=")))

(defmessage-handler AUTH-PARAM pprint primary (?t)
	(printout ?t ?self:left-side "=" ?self:right-side))

(defmessage-handler COOKIE-HEADER pprint primary (?t)
	(bind ?i 0)
	(foreach ?f ?self:cookie-pairs
		(bind ?i (+ ?i 1))
		(send ?f pprint ?t)
		(if (< ?i (length$ ?self:cookie-pairs)) then (printout ?t "; ") else (printout ?t))))

(defmessage-handler COOKIE-PAIR pprint primary (?t)
(printout ?t ?self:cookie-name "=")
(if ?self:cookie-value-quoted then (printout ?t "\""))
(printout ?t ?self:cookie-value)
(if ?self:cookie-value-quoted then (printout ?t "\"")))

(defmessage-handler SET-COOKIE-HEADER pprint primary (?t)
	(send ?self:cookie-pair pprint ?t)
	(bind ?i 0)
	(foreach ?f ?self:cookie-avs
		(printout ?t "; ")
		(send ?f pprint ?t)))

(defmessage-handler COOKIE-AV pprint primary (?t)
	(send ?self:value pprint ?t))

(defmessage-handler SECURE-AV pprint primary (?t)
(printout ?t "Secure"))

(defmessage-handler MAX-AGE-AV pprint (?t)
(printout ?t "Max-Age=" ?self:value))

(defmessage-handler PATH-AV pprint (?t)
(printout ?t "Path=" ?self:value))

(defmessage-handler HTTPONLY-AV pprint (?t)
(printout ?t "HttpOnly"))

(defmessage-handler EXTENSION-AV pprint (?t)
(printout ?t ?self:value))

(defmessage-handler EXPIRES-AV pprint (?t)
(printout ?t "Expires=")
(send ?self:rfc1123-date pprint ?t))

(defmessage-handler RFC1123-DATE pprint (?t)
(send ?self:wkday pprint ?t)
(printout ?t ", ")
(send ?self:date1 pprint ?t)
(printout ?t " ")
(send ?self:time pprint ?t)
(printout ?t " GMT"))

(defmessage-handler HTTP-DATE-HEADER pprint primary (?t)
(send ?self:http-date pprint ?t))

(defmessage-handler DAY-NAME-L pprint (?t)
(printout ?t ?self:value))

(defmessage-handler RFC850-DATE pprint (?t)
(send ?self:day-name-l pprint ?t)
(printout ?t ", ")
(send ?self:date2 pprint ?t)
(printout ?t " ")
(send ?self:time pprint ?t)
(printout ?t " GMT"))

(defmessage-handler DATE2 pprint (?t)
(printout ?t ?self:day "-")
(send ?self:month pprint ?t)
(printout ?t "-" ?self:year))

(defmessage-handler ASCTIME-DATE pprint (?t)
(send ?self:day-name pprint ?t)
(printout ?t " ")
(send ?self:date3 pprint ?t)
(printout ?t " ")
(send ?self:time pprint ?t)
(printout ?t " " ?self:year))

(defmessage-handler DATE3 pprint (?t)
(send ?self:month pprint ?t)
(printout ?t " ")
(if ?self:padded then (printout ?t " "))
(printout ?t ?self:day))

(defmessage-handler WKDAY pprint (?t)
(printout ?t ?self:value))

(defmessage-handler DATE1 pprint (?t)
(printout ?t ?self:first-2digit " ")
(send ?self:month pprint ?t)
(printout ?t " " ?self:last-4digit))

(defmessage-handler MONTH pprint (?t)
(printout ?t ?self:value))

(defmessage-handler TIME pprint (?t)
(printout ?t ?self:first-2digit ":" ?self:second-2digit ":" ?self:third-2digit))

(defmessage-handler DOMAIN-AV pprint (?t)
(printout ?t "Domain=")
(send ?self:subdomain pprint ?t))

(defmessage-handler SUBDOMAIN pprint (?t)
	(foreach ?f ?self:ldh-labels
		(send ?f pprint ?t))
	(send ?self:top-label pprint ?t))

(defmessage-handler TOP-LABEL pprint (?t)
(printout ?t ?self:value))

(defmessage-handler LDH-LABEL pprint (?t)
(printout ?t ?self:value))

(defmessage-handler SAMESITE-AV pprint (?t)
(printout ?t "SameSite=")
(send ?self:value pprint ?t))

(defmessage-handler LAX pprint (?t)
(printout ?t "Lax"))

(defmessage-handler STRICT pprint (?t)
(printout ?t "Strict"))

(defmessage-handler NONE pprint (?t)
(printout ?t "None"))
