; based on HTTP as it is defined in rfc9112
(defglobal ?*http-digit* = (create$ 48 49 50 51 52 53 54 55 56 57)) 
(defglobal ?*http-upalpha* = (create$ 65 66 67 68 69 70 71 72 73 74 75 76 77 78 79 80 81 82 83 84 85 86 87 88 89 90)) 
(defglobal ?*http-lowalpha* = (create$ 97 98 99 100 101 102 103 104 105 106 107 108 109 110 111 112 113 114 115 116 117 118 119 120 121 122)) 
(defglobal ?*http-alpha* = (create$ ?*http-upalpha* ?*http-lowalpha*))
(defglobal ?*http-alphanum* = (create$ ?*http-alpha* ?*http-digit*))
(defglobal ?*http-unreserved* = (create$ ?*http-alphanum* 45 46 95 126)) ; - . _ ~
(defglobal ?*http-gen-delims* = (create$ 58 47 63 35 91 93 64)) ; ":" / "/" / "?" / "#" / "[" / "]" / "@"
(defglobal ?*http-sub-delims* = (create$ 33 36 38 39 40 41 42 43 44 59 61)) ; "!" / "$" / "&" / "'" / "(" / ")" / "*" / "+" / "," / ";" / "="
(defglobal ?*http-reserved* = (create$ ?*http-gen-delims* ?*http-sub-delims*))
(defglobal ?*http-hex-without-dig* = (create$ 65 66 67 68 69 70 97 98 99 100 101 102)) ; 0-9 A-F a-f
(defglobal ?*http-hexdig* = (create$ ?*http-digit* ?*http-hex-without-dig*))
(defglobal ?*http-methods* = (create$ "OPTIONS" "GET" "HEAD" "PATCH" "POST" "PUT" "DELETE" "TRACE" "CONNECT"))
;      pchar         = unreserved / pct-encoded / sub-delims / ":" / "@"
(defglobal ?*http-pchar* = (create$ ?*http-unreserved* ?*http-sub-delims* 58 64)) ; : @
;      reg-name    = *( unreserved / pct-encoded / sub-delims )
(defglobal ?*http-reg-name* = (create$ ?*http-unreserved* ?*http-sub-delims*))
(defglobal ?*http-reg-name-no-digits* = (create$ ?*http-alpha* ?*http-sub-delims* 45 95 126)) ; - _ ~
;     userinfo      = *( unreserved | escaped |
;                        ";" | ":" | "&" | "=" | "+" | "$" | "," )
;   userinfo      = *( unreserved / pct-encoded / sub-delims / ":" )
(defglobal ?*http-userinfo* = (create$ ?*http-unreserved* ?*http-sub-delims* 58))
;       scheme      = ALPHA *( ALPHA / DIGIT / "+" / "-" / "." )
(defglobal ?*http-scheme* = (create$ ?*http-alphanum* 43 45 46)) ; + - .
;    query         = *( pchar / "/" / "?" )
(defglobal ?*http-query* = (create$ ?*http-pchar* 47 63)) ; / ?
;      segment-nz-nc = 1*( unreserved / pct-encoded / sub-delims / "@" )
;                    ; non-zero-length segment without any colon ":"
(defglobal ?*http-segment-nz-nc* = (create$ ?*http-unreserved* ?*http-sub-delims* 64)) ; @
(defglobal ?*http-segment-nz-nc-no-alpha* = (create$ ?*http-digit* ?*http-sub-delims* 45 46 64 95 126)) ; - . @ _ ~

;   attr-char = ALPHA / DIGIT / "!" / "#" / "$" / "&" / "+" / "-" / "." / "^" / "_" / "`" / "|" / "~"
(defglobal ?*http-attr-char* = (create$ ?*http-alphanum* 33 35 36 38 43 45 46 94 95 96 124 126))
;   mime-charsetc = ALPHA / DIGIT / "!" / "#" / "$" / "%" / "&" / "+" / "-" / "^" / "_" / "`" / "{" / "}" / "~"
(defglobal ?*http-mime-charsetc* = (create$ ?*http-alphanum* 33 35 36 37 38 43 45 94 95 96 123 125 126))

;   atext = ALPHA / DIGIT / "!" / "#" / "$" / "%" / "&" / "'" / "*" / "+" / "-" / "/" / "=" / "?" / "^" / "_" / "`" / "{" / "|" / "}" / "~"
(defglobal ?*http-atext* = (create$ ?*http-alphanum* 33 35 36 37 38 39 42 43 45 47 61 63 94 95 96 123 124 125 126))

; tchar = "!" / "#" / "$" / "%" / "&" / "'" / "*" / "+" / "-" / "." /
;         "^" / "_" / "`" / "|" / "~" / DIGIT / ALPHA
(defglobal ?*http-tchar* = (create$ ?*http-alphanum* 33 35 36 37 38 39 42 43 45 46 94 95 96 124 126)) ; ! # $ % & ' * + - . ^ _ ` | ~
(defglobal ?*http-ctext* = (create$ ?*http-alphanum* 9 32 33 34 35 36 37 38 39 42 43 44 45 46 47 58 59 60 61 62 63 64 91 93 94 95 123 124 125 126)) ; HTAB SP ! " # $ % & ' * + , - . / : ; < = > ? @ [ ] ^ _ { | } ~
(defglobal ?*http-other-range* = (create$ ?*http-alphanum* 33 34 35 36 37 38 39 40 41 42 43 45 46 47 58 59 60 61 62 63 64 91 92 93 94 95 96 123 124 125 126)) ; ! " # $ % & ' ( ) * + - . / 0-9 : ; < = > ? @ A-Z [ \ ] ^ _ ` a-z { | } ~
(defglobal ?*http-token68* = (create$ ?*http-alphanum* 43 45 46 47 95 126)) ;  ALPHA / DIGIT / "+" / "/" / "-" / "." / "_" / "~"
(defglobal ?*http-cookie-octet* = (create$ ?*http-alphanum* 33 35 36 37 38 39 40 41 42 43 45 46 47 58 60 61 62 63 64 91 93 94 95 96 123 124 125 126)) ; ! # $ % & ' ( ) * + - . / : < = > ? @ [ ] ^ _ ` { | } ~

;    pct-encoded   = "%" HEXDIG HEXDIG
(deftemplate http-pct-encoded
	(slot name)
	(slot first))
(deftemplate http-escapable-sequence
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
(deftemplate http-status-line
	(slot name)
	(slot http-version)
	(slot status-code (default ""))
	(slot reason-phrase))

; request-line   = method SP request-target SP HTTP-version
(deftemplate http-request-line
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

(deftemplate http-method
	(slot name)
	(slot value (default "")))

;   origin-form    = absolute-path [ "?" query ]
(deftemplate http-origin-form
	(slot name)
;       absolute-path = 1*( "/" segment )
	(multislot segments)
	(slot query))

; https://datatracker.ietf.org/doc/html/rfc9112#section-3.2.2
;   absolute-form  = absolute-URI
; https://datatracker.ietf.org/doc/html/rfc3986#section-4.3
;   absolute-URI  = scheme ":" hier-part [ "?" query ]
(deftemplate http-absolute-uri
	(slot name)
;       scheme        = ALPHA *( ALPHA / DIGIT / "+" / "-" / "." )
	(slot scheme)
	(slot hier-part)
	(slot query)
;   URI           = scheme ":" hier-part [ "?" query ] [ "#" fragment ]
;   an absolute-URI with a fragment is a URI (used by Location)
	(slot fragment))

; https://datatracker.ietf.org/doc/html/rfc9110#section-4.1
;   partial-URI   = relative-part [ "?" query ]
; https://datatracker.ietf.org/doc/html/rfc3986#section-4.2
;   relative-ref  = relative-part [ "?" query ] [ "#" fragment ]
;   relative-part = "//" authority path-abempty
;                 / path-absolute
;                 / path-noscheme
;                 / path-empty
; a relative-part is built by the hier-part rules (the forms they share)
(deftemplate http-partial-uri
	(slot name)
	(slot relative-part)
	(slot query)
	(slot fragment))

; Referer  = absolute-URI / partial-URI
; Location = URI-reference
(deftemplate http-uri-reference-header
	(slot name)
	(slot uri-reference))

; scheme        = alpha *( alpha | digit | "+" | "-" | "." )
(deftemplate http-scheme
	(slot name)
	(slot value))

;   asterisk-form  = "*"

;    hier-part     = "//" authority path-abempty
;                  / path-absolute
;                  / path-rootless
;                  / path-empty
(deftemplate http-hier-part
	(slot name)
	(slot authority)
	(slot path))

;       authority     = [ userinfo "@" ] host [ ":" port ]
(deftemplate http-authority
	(slot name)
;       userinfo      = *( unreserved / pct-encoded / sub-delims / ":" )
	(slot userinfo)
;       host          = IP-literal / IPv4address / reg-name
	(slot host)
;       port          = *DIGIT
	(slot port))

(deftemplate http-userinfo
	(slot name)
	(slot value))

(deftemplate http-host
	(slot name)
	(slot value))

(deftemplate http-port
	(slot name)
	(slot value (default "")))

;    IP-literal    = "[" ( IPv6address / IPvFuture  ) "]"
(deftemplate http-ip-literal
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
(deftemplate http-ipv6address
	(slot name)
	(multislot parts))
;    h16           = 1*4HEXDIG
(deftemplate http-h16
	(slot name)
	(slot value (default "")))

;
;                                        same as ?*userinfo* 
;   IPvFuture     = "v" 1*HEXDIG "." 1*( unreserved / sub-delims / ":" )
(deftemplate http-ipvfuture
	(slot hexdigs)
	(slot value)) 

;       IPv4address = dec-octet "." dec-octet "." dec-octet "." dec-octet
;       dec-octet   = DIGIT                 ; 0-9
;                   / %x31-39 DIGIT         ; 10-99
;                   / "1" 2DIGIT            ; 100-199
;                   / "2" %x30-34 DIGIT     ; 200-249
;                   / "25" %x30-35          ; 250-255
(deftemplate http-ipv4address
	(slot name)
	(multislot octets))
(deftemplate http-dec-octet
	(slot name)
	(slot first-digit (default ""))
	(slot second-digit (default ""))
	(slot third-digit (default "")))

(deffunction http-dec-octet-accepts-digit (?first ?second ?third ?char)
	"whether a dec-octet holding these digits so far may take the digit ?char next"
	(if (eq ?first "") then TRUE
	else (if (eq ?second "") then (neq ?first "0")
	else (if (neq ?third "") then FALSE
	else (if (eq ?first "1") then TRUE
	else (if (neq ?first "2") then FALSE
	else (if (eq ?second "5") then (>= 53 ?char) ; 0-5
	else (neq FALSE (member$ ?second (create$ "0" "1" "2" "3" "4"))))))))))

;       reg-name    = *( unreserved / pct-encoded / sub-delims )
(deftemplate http-reg-name
	(slot name)
	(slot value))

;       authority-form = uri-host ":" port
(deftemplate http-authority-form
	(slot name)
	(slot uri-host)
	(slot port))

;       path-abempty  = *( "/" segment )
(deftemplate http-path-abempty
	(slot name)
	(multislot segments))

;       path-absolute = "/" [ segment-nz *( "/" segment ) ]
(deftemplate http-path-absolute
	(slot name)
	(slot segment-nz)
	(multislot segments))

;       path-noscheme = segment-nz-nc *( "/" segment )
(deftemplate http-path-noscheme
	(slot name)
	(slot segment-nz-nc)
	(multislot segments))

;       path-rootless = segment-nz *( "/" segment )
(deftemplate http-path-rootless
	(slot name)
	(slot segment-nz) ; non-zero length
	(multislot segments))

(deftemplate http-segment
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

(deftemplate http-field-line
	(slot name)
	(slot field-name)
	(slot field-value))

(deftemplate http-field-name
	(slot name)
	(slot value (default "")))

(deftemplate http-field-value
	(slot name)
	(slot value)
	(slot possible-ows (default "")))

(deftemplate http-unknown-header
	(slot name)
	(slot value (default ""))
	(slot possible-ows (default "")))

(deftemplate http-accept-encoding-header
	(slot name)
	(multislot codings))

(deftemplate http-coding
	(slot name)
	(slot codings)
	(slot weight))

(deftemplate http-accept-charset-header
	(slot name)
	(multislot charsets))

(deftemplate http-charset
	(slot name)
	(slot charset)
	(slot weight))

(deftemplate http-weight
	(slot name)
	(slot q)
	(slot equals)
	(slot qvalue))

(deftemplate http-qvalue
	(slot name)
	(slot first)
	(slot decimal)
	(slot fraction (default "")))

(deftemplate http-content-length-header
	(slot name)
	(slot value (default "")))

;   Max-Forwards = 1*DIGIT
(deftemplate http-max-forwards-header
	(slot name)
	(slot value (default "")))

(deftemplate http-content-type-header
	(slot name)
	(slot type)
	(slot subtype)
	(multislot parameters))

; https://datatracker.ietf.org/doc/html/rfc6266#section-4.1
;   content-disposition = "Content-Disposition" ":" disposition-type *( ";" disposition-parm )
;   disposition-type    = "inline" | "attachment" | disp-ext-type ; disp-ext-type = token
;   disposition-parm    = filename-parm | disp-ext-parm
;   filename-parm       = "filename" "=" value | "filename*" "=" ext-value
;   disp-ext-parm       = token "=" value | ext-token "=" ext-value
(deftemplate http-content-disposition-header
	(slot name)
	(slot disposition-type)
	(multislot parameters))

; https://datatracker.ietf.org/doc/html/rfc8187#section-3.2.1
;   ext-value   = charset "'" [ language ] "'" value-chars
;   value-chars = *( pct-encoded / attr-char )
;   attr-char   = ALPHA / DIGIT / "!" / "#" / "$" / "&" / "+" / "-" / "." / "^" / "_" / "`" / "|" / "~"
; language is nil until the first "'" has been read, value-chars until the second
(deftemplate http-ext-value
	(slot name)
	(slot charset (default ""))
	(slot language)
	(slot value-chars))

(deftemplate http-host-header
	(slot name)
	(slot uri-host)
	(slot port))

(deftemplate http-type
	(slot name)
	(slot value (default "")))

(deftemplate http-subtype
	(slot name)
	(slot value (default "")))

(deftemplate http-parameter
	(slot name)
	(slot parameter-name)
;  ext-token = <the characters in token, followed by "*"> : set when the "*" is read
	(slot ext-token (default FALSE))
	(slot parameter-value))

(deftemplate http-token
	(slot name)
	(slot value (default "")))

(deftemplate http-quoted-string
	(slot name)
	(slot value (default "")))

(deftemplate http-message-body
	(slot name)
	(slot value)
	(slot length-remaining))

(deftemplate http-octet-stream
	(slot name)
	(slot value (default "")))

(deftemplate http-x-www-form-urlencoded
	(slot name)
	(multislot sequences))

(deftemplate http-sequence
	(slot name)
	(slot name-string (default ""))
	(slot value-string))

(deftemplate http-reason-phrase
	(slot name)
	(slot value (default "")))

;  Via = #( received-protocol RWS received-by [ RWS comment ] )
;   User-Agent = product *( RWS ( product / comment ) )
;   Server     = product *( RWS ( product / comment ) )
(deftemplate http-product-header
	(slot name)
	(multislot values) ; product / comment facts, then PRODUCT / COMMENT instances
	(slot rws (default FALSE)))

;   product         = token [ "/" product-version ]
;   product-version = token
(deftemplate http-product
	(slot name)
	(slot token)
	(slot product-version))

(deftemplate http-via-header
	(slot name)
	(multislot values))

(deftemplate http-via-header-value
	(slot name)
	(slot received-protocol)
	(slot received-by)
	(slot comment)
	(slot rws))

;   received-protocol = [ protocol-name "/" ] protocol-version
(deftemplate http-received-protocol
	(slot name)
	(slot protocol-name)
	(slot protocol-version))

;  received-by       = pseudonym [ ":" port ]
(deftemplate http-received-by
	(slot name)
;  pseudonym         = token
	(slot pseudonym)
	(slot port))

;comment = "(" *( ctext / quoted-pair / comment ) ")"
;ctext = HTAB / SP / %x21-27 ; '!'-'''
; / %x2A-5B ; '*'-'['
; / %x5D-7E ; ']'-'~'
; / obs-text
(deftemplate http-comment
	(slot name)
	(multislot values))
	
;  received-by       = pseudonym [ ":" port ]

(deftemplate http-accept-header
	(slot name)
	(multislot media-ranges))

(deftemplate http-media-range
	(slot name)
	(slot type)
	(slot subtype)
	(multislot parameters)
	(slot weight))

(deftemplate http-accept-language-header
	(slot name)
	(multislot language-ranges))

(deftemplate http-content-language-header
	(slot name)
	(multislot language-tags))

; From = mailbox ; https://datatracker.ietf.org/doc/html/rfc5322#section-3.4
;   mailbox       = name-addr / addr-spec
;   name-addr     = [display-name] angle-addr
;   angle-addr    = "<" addr-spec ">"
;   display-name  = phrase = 1*word ; word = atom / quoted-string
;   addr-spec     = local-part "@" domain
;   local-part    = dot-atom / quoted-string
;   domain        = dot-atom / domain-literal
;   dot-atom-text = 1*atext *("." 1*atext)
(deftemplate http-from-header
	(slot name)
	(slot mailbox))

; angle-addr is nil before any "<", open after it and closed after the ">"
(deftemplate http-mailbox
	(slot name)
	(multislot display-name)
	(slot local-part)
	(slot domain)
	(slot angle-addr))

(deftemplate http-dot-atom
	(slot name)
	(slot value (default "")))

;   domain-literal = "[" *dtext "]" ; dtext = %d33-90 / %d94-126
(deftemplate http-domain-literal
	(slot name)
	(slot value (default "")))

(deftemplate http-language-range
	(slot name)
	(slot first-language)
	(multislot languages)
	(slot weight))

(deftemplate http-language
	(slot name)
	(slot value (default "")))

(deftemplate http-allow-header
	(slot name)
	(multislot methods))

; Connection = #connection-option ; connection-option = token
; Accept-Ranges = 1#range-unit ; range-unit = token
; Vary = #( "*" / field-name ) ; field-name = token
; Trailer = #field-name
; Content-Encoding = #content-coding ; content-coding = token
(deftemplate http-token-list-header
	(slot name)
	(multislot tokens)) ; token fact while building, string once complete

(deftemplate http-te-header
	(slot name)
	(multislot t-codings))

(deftemplate http-t-coding
	(slot name)
	(slot value)
	(slot weight))

(deftemplate http-expect-header
	(slot name)
	(multislot expectations))

(deftemplate http-expectation
	(slot name)
	(slot token)
	(slot equals (default FALSE))
	(slot value)
	(multislot parameters))

; Cache-Control = #cache-directive ; cache-directive = token [ "=" ( token / quoted-string ) ]
; Pragma = #pragma-directive ; pragma-directive = "no-cache" / extension-pragma
;                            ; extension-pragma = token [ "=" ( token / quoted-string ) ]
(deftemplate http-cache-control-header
	(slot name)
	(multislot cache-directives))

(deftemplate http-cache-directive
	(slot name)
	(slot token)
	(slot equals (default FALSE))
	(slot value))

(deftemplate http-range-header
	(slot name)
	(slot ranges-specifier))

(deftemplate http-ranges-specifier
	(slot name)
	(slot range-unit)
	(slot range-set))

(deftemplate http-range-unit
	(slot name)
	(slot value))

(deftemplate http-range-set
	(slot name)
	(multislot range-specs))

(deftemplate http-range-spec
	(slot name)
	(slot value))

(deftemplate http-int-range
	(slot name)
	(slot first-pos (default ""))
	(slot last-pos))

(deftemplate http-suffix-range
	(slot name)
	(slot suffix-length))

(deftemplate http-other-range
	(slot name)
	(slot value))

; Content-Range = range-unit SP ( range-resp / unsatisfied-range )
; range-resp = incl-range "/" ( complete-length / "*" )
; unsatisfied-range = "*/" complete-length
(deftemplate http-content-range-header
	(slot name)
	(slot range-unit)
	(slot range))

(deftemplate http-range-resp
	(slot name)
	(slot incl-range)
	(slot complete-length))

(deftemplate http-unsatisfied-range
	(slot name)
	(slot complete-length))

(deftemplate http-upgrade-header
	(slot name)
	(multislot protocols))

(deftemplate http-protocol
	(slot name)
	(slot protocol-name)
	(slot protocol-version))

(deftemplate http-proxy-authorization-header
	(slot name)
	(slot auth-scheme)
	(multislot second-part))

(deftemplate http-token68
	(slot name)
	(slot value (default ""))
	(slot equals (default 0)))

(deftemplate http-auth-param
	(slot name)
	(slot left-side)
	(slot right-side))

(deftemplate http-cookie-header
	(slot name)
	(multislot cookie-pairs))

(deftemplate http-cookie-pair
	(slot name)
	(slot cookie-name)
	(slot cookie-value (default ""))
	(slot cookie-value-quoted))

(deftemplate http-set-cookie-header
	(slot name)
	(slot cookie-pair)
	(multislot cookie-avs))

(deftemplate http-cookie-av
	(slot name)
	(slot string (default ""))
	(slot value)
	(slot required-sp))

(deftemplate http-expires-av
	(slot name)
	(slot rfc1123-date))

(deftemplate http-rfc1123-date
	(slot name)
	(slot wkday)
	(slot date1)
	(slot time)
	(slot GMT (default "")))

(deftemplate http-wkday
	(slot name)
	(slot value (default "")))

(deftemplate http-date1
	(slot name)
	(slot first-2digit (default ""))
	(slot month)
	(slot last-4digit (default "")))

(deftemplate http-month
	(slot name)
	(slot value (default "")))

(deftemplate http-time
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

(deftemplate http-day-name
	(slot name)
	(slot value (default "")))

(deftemplate http-rfc850-date
	(slot name)
	(slot day-name-l)
	(slot date2)
	(slot time)
	(slot GMT (default "")))

(deftemplate http-date2
	(slot name)
	(slot day (default ""))
	(slot month)
	(slot year (default "")))

(deftemplate http-asctime-date
	(slot name)
	(slot day-name)
	(slot date3)
	(slot time)
	(slot year (default "")))

(deftemplate http-date3
	(slot name)
	(slot month)
	(slot day (default ""))
	(slot padded (default FALSE)))

;   ETag          = entity-tag
;   entity-tag    = [ weak ] opaque-tag
;   weak          = %s"W/" ; case-sensitive
;   opaque-tag    = DQUOTE *etagc DQUOTE
;   etagc         = %x21 / %x23-7E / obs-text ; VCHAR except double quotes, plus obs-text
;   If-Match      = "*" / #entity-tag
;   If-None-Match = "*" / #entity-tag
;   If-Range      = entity-tag / HTTP-date
(deftemplate http-entity-tag
	(slot name)
	(slot weak (default FALSE)) ; FALSE, "W" once W seen, TRUE after "W/"
	(slot opaque-tag)) ; nil before DQUOTE, string while building

(deftemplate http-etag-header
	(slot name)
	(slot entity-tag)) ; entity-tag fact, then instance

(deftemplate http-entity-tag-list-header ; If-Match / If-None-Match
	(slot name)
	(multislot entity-tags)) ; entity-tag facts while building, instances once complete, or the string "*"

(deftemplate http-if-range-header
	(slot name)
	(slot value)) ; W while peeking, entity-tag fact / http-date-header fact, then instance

;  rfc1123-date = wkday "," SP date1 SP time SP "GMT"

(deftemplate http-max-age-av
	(slot name)
	(slot first-digit)
	(slot rest (default ""))
)

(deftemplate http-domain-av
	(slot name)
	(slot subdomain)
)

(deftemplate http-path-av
	(slot name)
	(slot value (default "")))

(deftemplate http-secure-av
	(slot name)
)

(deftemplate http-httponly-av
	(slot name)
)

(deftemplate http-samesite-av
	(slot name)
	(slot value)
)

(deftemplate http-lax
	(slot name)
	(slot a)
	(slot x))

(deftemplate http-strict
	(slot name)
	(slot t)
	(slot r)
	(slot i)
	(slot c)
	(slot last-t))

(deftemplate http-none
	(slot name)
	(slot o)
	(slot n)
	(slot e))

(deftemplate http-subdomain
	(slot name)
	(multislot ldh-labels)
	(slot top-label))

(deftemplate http-top-label
	(slot name)
	(slot value))

(deftemplate http-ldh-label
	(slot name)
	(slot value))

;cookie-av         = expires-av / max-age-av / domain-av /
;                    path-av / secure-av / httponly-av /
;                    samesite-av / extension-av

(deffacts http-supported-content-types
	(http-supported-content-type "application" "json")
	(http-supported-content-type "application" "octet-stream")
	(http-supported-content-type "application" "x-www-form-urlencoded"))

(defclass HTTP (is-a USER) (slot id))
(defclass HTTP-MESSAGE (is-a HTTP) (slot start-line) (multislot field-lines) (slot message-body))
(defclass HTTP-REQUEST-LINE (is-a HTTP) (slot method) (slot request-target) (slot http-version))
(defclass HTTP-METHOD (is-a HTTP) (slot value))
(defclass HTTP-ORIGIN-FORM (is-a HTTP) (multislot segments) (slot query))
(defclass HTTP-ABSOLUTE-URI (is-a HTTP) (slot scheme) (slot hier-part) (slot query))
(defclass HTTP-URI (is-a HTTP-ABSOLUTE-URI) (slot fragment))
(defclass HTTP-PARTIAL-URI (is-a HTTP) (slot relative-part) (slot query))
(defclass HTTP-RELATIVE-REF (is-a HTTP-PARTIAL-URI) (slot fragment))
(defclass HTTP-FRAGMENT (is-a HTTP) (slot value))
(defclass HTTP-ASTERISK-FORM (is-a HTTP))
(defclass HTTP-AUTHORITY-FORM (is-a HTTP) (slot uri-host) (slot port))
(defclass HTTP-SCHEME (is-a HTTP) (slot value))
(defclass HTTP-USERINFO (is-a HTTP) (slot value))
(defclass HTTP-HIER-PART (is-a HTTP) (slot authority) (slot path))
(defclass HTTP-RELATIVE-PART (is-a HTTP-HIER-PART))
(defclass HTTP-AUTHORITY (is-a HTTP) (slot userinfo) (slot host) (slot port))
(defclass HTTP-IP-LITERAL (is-a HTTP) (slot value))
(defclass HTTP-IPV6ADDRESS (is-a HTTP) (multislot parts))
(defclass HTTP-H16 (is-a HTTP) (slot value))
(defclass HTTP-DEC-OCTET (is-a HTTP) (slot hexdigs) (slot value)) 
(defclass HTTP-IPVFUTURE (is-a HTTP) (slot hexdigs) (slot value)) 
(defclass HTTP-IPV4ADDRESS (is-a HTTP) (slot first-octet) (slot second-octet) (slot third-octet) (slot fourth-octet))
(defclass HTTP-REG-NAME (is-a HTTP) (slot value))
(defclass HTTP-HOST (is-a HTTP) (slot value))
(defclass HTTP-PORT (is-a HTTP) (slot value))
(defclass HTTP-PATH-ABEMPTY (is-a HTTP) (multislot segments))
(defclass HTTP-PATH-ABSOLUTE (is-a HTTP) (slot segment-nz) (multislot segments))
(defclass HTTP-PATH-NOSCHEME (is-a HTTP) (slot segment-nz-nc) (multislot segments))
(defclass HTTP-PATH-ROOTLESS (is-a HTTP) (slot segment-nz) (multislot segments))
(defclass HTTP-SEGMENT (is-a HTTP) (slot value))
(defclass HTTP-PARAMETER (is-a HTTP) (slot parameter-name) (slot ext-token) (slot parameter-value))
(defclass HTTP-QUERY (is-a HTTP) (slot value))
(defclass HTTP-VERSION (is-a HTTP) (slot H) (slot T) (slot TT) (slot P) (slot major) (slot minor))
(defclass HTTP-FIELD-LINE (is-a HTTP) (slot field-name) (slot field-value))
(defclass HTTP-FIELD-NAME (is-a HTTP) (slot value))
(defclass HTTP-FIELD-VALUE (is-a HTTP) (slot value))
(defclass HTTP-TYPE (is-a HTTP) (slot value))
(defclass HTTP-SUBTYPE (is-a HTTP) (slot value))
(defclass HTTP-UNKNOWN-HEADER (is-a HTTP) (slot value))
(defclass HTTP-ACCEPT-ENCODING-HEADER (is-a HTTP) (multislot codings))
(defclass HTTP-ACCEPT-CHARSET-HEADER (is-a HTTP) (multislot charsets))
(defclass HTTP-CONTENT-LENGTH-HEADER (is-a HTTP) (slot value))
(defclass HTTP-MAX-FORWARDS-HEADER (is-a HTTP) (slot value))
(defclass HTTP-CONTENT-TYPE-HEADER (is-a HTTP) (slot type) (slot subtype) (multislot parameters))
(defclass HTTP-CONTENT-DISPOSITION-HEADER (is-a HTTP) (slot disposition-type) (multislot parameters))
(defclass HTTP-EXT-VALUE (is-a HTTP) (slot charset) (slot language) (slot value-chars))
(defclass HTTP-VIA-HEADER (is-a HTTP) (multislot values))
(defclass HTTP-VIA-HEADER-VALUE (is-a HTTP) (slot received-protocol) (slot received-by) (slot comment))
(defclass HTTP-PRODUCT-HEADER (is-a HTTP) (multislot values))
(defclass HTTP-USER-AGENT-HEADER (is-a HTTP-PRODUCT-HEADER))
(defclass HTTP-SERVER-HEADER (is-a HTTP-PRODUCT-HEADER))
(defclass HTTP-PRODUCT (is-a HTTP) (slot token) (slot product-version))
(defclass HTTP-HOST-HEADER (is-a HTTP) (slot uri-host) (slot port))
(defclass HTTP-URI-REFERENCE-HEADER (is-a HTTP) (slot uri-reference))
(defclass HTTP-REFERER-HEADER (is-a HTTP-URI-REFERENCE-HEADER))
(defclass HTTP-LOCATION-HEADER (is-a HTTP-URI-REFERENCE-HEADER))
(defclass HTTP-QUOTED-STRING (is-a HTTP) (slot value))
(defclass HTTP-MESSAGE-BODY (is-a HTTP) (slot value))
(defclass HTTP-OCTET-STREAM (is-a HTTP) (slot value))
(defclass HTTP-X-WWW-FORM-URLENCODED (is-a HTTP) (multislot sequences))
(defclass HTTP-SEQUENCE (is-a HTTP) (slot name-string) (slot value-string))
(defclass HTTP-STATUS-LINE (is-a HTTP) (slot http-version) (slot status-code) (slot reason-phrase))
(defclass HTTP-REASON-PHRASE (is-a HTTP) (slot value))
(defclass HTTP-RECEIVED-PROTOCOL (is-a HTTP) (slot protocol-name) (slot protocol-version))
(defclass HTTP-RECEIVED-BY (is-a HTTP) (slot pseudonym) (slot port))
(defclass HTTP-COMMENT (is-a HTTP) (multislot values))
(defclass HTTP-CODING (is-a HTTP) (slot codings) (slot weight))
(defclass HTTP-CHARSET (is-a HTTP) (slot charset) (slot weight))
(defclass HTTP-WEIGHT (is-a HTTP) (slot qvalue))
(defclass HTTP-QVALUE (is-a HTTP) (slot first) (slot decimal) (slot fraction))
(defclass HTTP-ACCEPT-HEADER (is-a HTTP) (multislot media-ranges))
(defclass HTTP-MEDIA-RANGE (is-a HTTP) (slot type) (slot subtype) (multislot parameters) (slot weight))
(defclass HTTP-ACCEPT-LANGUAGE-HEADER (is-a HTTP) (multislot language-ranges))
(defclass HTTP-CONTENT-LANGUAGE-HEADER (is-a HTTP) (multislot language-tags))
(defclass HTTP-FROM-HEADER (is-a HTTP) (slot mailbox))
(defclass HTTP-ADDR-SPEC (is-a HTTP) (slot local-part) (slot domain))
(defclass HTTP-NAME-ADDR (is-a HTTP) (multislot display-name) (slot addr-spec))
(defclass HTTP-DOMAIN-LITERAL (is-a HTTP) (slot value))
(defclass HTTP-LANGUAGE-TAG (is-a HTTP) (slot first-language) (multislot languages))
(defclass HTTP-LANGUAGE-RANGE (is-a HTTP-LANGUAGE-TAG) (slot weight))
(defclass HTTP-LANGUAGE (is-a HTTP) (slot value))
(defclass HTTP-ALLOW-HEADER (is-a HTTP) (multislot methods))
(defclass HTTP-TOKEN-LIST-HEADER (is-a HTTP) (multislot tokens))
(defclass HTTP-CONNECTION-HEADER (is-a HTTP-TOKEN-LIST-HEADER))
(defclass HTTP-ACCEPT-RANGES-HEADER (is-a HTTP-TOKEN-LIST-HEADER))
(defclass HTTP-VARY-HEADER (is-a HTTP-TOKEN-LIST-HEADER))
(defclass HTTP-TRAILER-HEADER (is-a HTTP-TOKEN-LIST-HEADER))
(defclass HTTP-CONTENT-ENCODING-HEADER (is-a HTTP-TOKEN-LIST-HEADER))
(defclass HTTP-TE-HEADER (is-a HTTP) (multislot t-codings))
(defclass HTTP-T-CODING (is-a HTTP) (slot value) (slot weight))
(defclass HTTP-EXPECT-HEADER (is-a HTTP) (multislot expectations))
(defclass HTTP-EXPECTATION (is-a HTTP) (slot token) (slot value) (multislot parameters))
(defclass HTTP-CACHE-DIRECTIVE-HEADER (is-a HTTP) (multislot cache-directives))
(defclass HTTP-CACHE-CONTROL-HEADER (is-a HTTP-CACHE-DIRECTIVE-HEADER))
(defclass HTTP-PRAGMA-HEADER (is-a HTTP-CACHE-DIRECTIVE-HEADER))
(defclass HTTP-CACHE-DIRECTIVE (is-a HTTP) (slot token) (slot value))
(defclass HTTP-RANGE-HEADER (is-a HTTP) (slot ranges-specifier))
(defclass HTTP-RANGES-SPECIFIER (is-a HTTP) (slot range-unit) (slot range-set))
(defclass HTTP-RANGE-UNIT (is-a HTTP) (slot value))
(defclass HTTP-RANGE-SET (is-a HTTP) (multislot range-specs))
(defclass HTTP-INT-RANGE (is-a HTTP) (slot first-pos) (slot last-pos))
(defclass HTTP-SUFFIX-RANGE (is-a HTTP) (slot suffix-length))
(defclass HTTP-OTHER-RANGE (is-a HTTP) (slot value))
(defclass HTTP-RANGE-SPEC (is-a HTTP) (slot value))
(defclass HTTP-CONTENT-RANGE-HEADER (is-a HTTP) (slot range-unit) (slot range))
(defclass HTTP-RANGE-RESP (is-a HTTP) (slot incl-range) (slot complete-length))
(defclass HTTP-INCL-RANGE (is-a HTTP-INT-RANGE))
(defclass HTTP-UNSATISFIED-RANGE (is-a HTTP) (slot complete-length))
(defclass HTTP-UPGRADE-HEADER (is-a HTTP) (multislot protocols))
(defclass HTTP-PROTOCOL (is-a HTTP) (slot protocol-name) (slot protocol-version))
(defclass HTTP-CREDENTIALS-HEADER (is-a HTTP) (slot auth-scheme) (multislot second-part))
(defclass HTTP-AUTHORIZATION-HEADER (is-a HTTP-CREDENTIALS-HEADER))
(defclass HTTP-PROXY-AUTHORIZATION-HEADER (is-a HTTP-CREDENTIALS-HEADER))
(defclass HTTP-TOKEN68 (is-a HTTP) (slot value) (slot equals))
(defclass HTTP-AUTH-PARAM (is-a HTTP) (slot left-side) (slot right-side))
(defclass HTTP-COOKIE-HEADER (is-a HTTP) (multislot cookie-pairs))
(defclass HTTP-COOKIE-PAIR (is-a HTTP) (slot cookie-name) (slot cookie-value) (slot cookie-value-quoted))
(defclass HTTP-SECURE-AV (is-a HTTP))
(defclass HTTP-MAX-AGE-AV (is-a HTTP) (slot value))
(defclass HTTP-PATH-AV (is-a HTTP) (slot value))
(defclass HTTP-HTTPONLY-AV (is-a HTTP))
(defclass HTTP-EXTENSION-AV (is-a HTTP) (slot value))
(defclass HTTP-EXPIRES-AV (is-a HTTP) (slot rfc1123-date))
(defclass HTTP-STRICT (is-a HTTP))
(defclass HTTP-LAX (is-a HTTP))
(defclass HTTP-NONE (is-a HTTP))
(defclass HTTP-WKDAY (is-a HTTP) (slot value))
(defclass HTTP-MONTH (is-a HTTP) (slot value))
(defclass HTTP-DATE1 (is-a HTTP) (slot first-2digit) (slot month) (slot last-4digit))
(defclass HTTP-TIME (is-a HTTP) (slot first-2digit) (slot second-2digit) (slot third-2digit))
(defclass HTTP-RFC1123-DATE (is-a HTTP) (slot wkday) (slot date1) (slot time))
(defclass HTTP-DATE-HEADER (is-a HTTP) (slot http-date))
(defclass HTTP-DATE (is-a HTTP-DATE-HEADER))
(defclass HTTP-LAST-MODIFIED-HEADER (is-a HTTP-DATE-HEADER))
(defclass HTTP-IF-MODIFIED-SINCE-HEADER (is-a HTTP-DATE-HEADER))
(defclass HTTP-IF-UNMODIFIED-SINCE-HEADER (is-a HTTP-DATE-HEADER))
(defclass HTTP-DAY-NAME-L (is-a HTTP) (slot value))
(defclass HTTP-RFC850-DATE (is-a HTTP) (slot day-name-l) (slot date2) (slot time))
(defclass HTTP-DATE2 (is-a HTTP) (slot day) (slot month) (slot year))
(defclass HTTP-ASCTIME-DATE (is-a HTTP) (slot day-name) (slot date3) (slot time) (slot year))
(defclass HTTP-DATE3 (is-a HTTP) (slot month) (slot day) (slot padded))
(defclass HTTP-ENTITY-TAG (is-a HTTP) (slot weak) (slot opaque-tag))
(defclass HTTP-ETAG-HEADER (is-a HTTP) (slot entity-tag))
(defclass HTTP-ENTITY-TAG-LIST-HEADER (is-a HTTP) (multislot entity-tags))
(defclass HTTP-IF-MATCH-HEADER (is-a HTTP-ENTITY-TAG-LIST-HEADER))
(defclass HTTP-IF-NONE-MATCH-HEADER (is-a HTTP-ENTITY-TAG-LIST-HEADER))
(defclass HTTP-IF-RANGE-HEADER (is-a HTTP) (slot value)) ; ENTITY-TAG or an RFC1123-DATE / RFC850-DATE / ASCTIME-DATE instance
(defclass HTTP-SET-COOKIE-HEADER (is-a HTTP) (slot cookie-pair) (multislot cookie-avs))
(defclass HTTP-COOKIE-AV (is-a HTTP) (slot value))
(defclass HTTP-DOMAIN-AV (is-a HTTP) (slot subdomain))
(defclass HTTP-SUBDOMAIN (is-a HTTP) (multislot ldh-labels) (slot top-label))
(defclass HTTP-TOP-LABEL (is-a HTTP) (slot value))
(defclass HTTP-LDH-LABEL (is-a HTTP) (slot value))
(defclass HTTP-SAMESITE-AV (is-a HTTP) (slot value))

;;; the start fact: a program asserts it with the
;;; logical name of an open file or socket and an id for the result, then
;;; asserts http-ready for the id and runs.  The codec reads one message.
(deftemplate http-parse
	(slot stream)
	(slot id))

;;; the codec reads only after a ready fact for the id exists (9.3 of the
;;; plan); the start of a message consumes it
(deftemplate http-ready
	(slot id))

;;; one stream that the codec reads: the id of its facts and its logical name
(deftemplate http-stream
	(slot id)
	(slot stream))

(deffunction http-read (?name)
	"one character of the stream with an id; the stream can have a name of its own"
	(bind ?stream ?name)
	(do-for-fact ((?s http-stream)) (eq ?s:id ?name) (bind ?stream ?s:stream))
	(get-char ?stream))


;;; the end fact: the message.  The program that matches it retracts it.
(deftemplate http-done
	(slot id)
	(slot message)
	(slot stream))                     ; the logical name the message came from; a body codec reads on from it

(defrule http-initialize-request
	?p <- (http-parse (stream ?stream) (id ?name))
	?r <- (http-ready (id ?name))
	=>
	(retract ?p ?r)
	(assert
		(http-stream (id ?name) (stream ?stream))
		(http-char ?name (http-read ?name))
		;(start ?name (time))
		(http-message (name ?name) (start-line (assert (http-request-line (name ?name) (method (assert (http-method (name ?name))))))))))

(defrule http-build-method
	?c <- (http-char ?name ?char&65|67|68|69|71|72|73|76|78|79|80|82|83|84|85) ; A|C|D|E|G|H|I|L|N|O|P|R|S|T|U
	?m <- (http-method (name ?name) (value ?value&~"H"&:(> 7 (str-length ?value))))
	=>
	(retract ?c)
	(modify ?m (value (format nil "%s%c" ?value ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-continue-method-when-head
	?c <- (http-char ?name ?char&69) ; E
	?m <- (http-method (name ?name) (value "H"))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name)))
	(modify ?m (value "HE")))

(defrule http-find-http-version-instead-of-method
	?c <- (http-char ?name 84) ; T
	?m <- (http-method (name ?name) (value "H"))
	?r <- (http-request-line (method ?m))
	?h <- (http-message (start-line ?r))
	=>
	(retract ?c ?m ?r)
	(modify ?h (start-line (assert (http-status-line (name ?name) (http-version (assert (http-version (name ?name) (H TRUE) (T TRUE))))))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-status-line-http-version-end
	?c <- (http-char ?name 32) ; SP
	?h <- (http-version (name ?name) (major ?major) (minor ?minor&~nil))
	?s <- (http-status-line (http-version ?h))
	=>
	(retract ?c ?h)
	(modify ?s (http-version (make-instance of HTTP-VERSION (id ?name) (major ?major) (minor ?minor))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-status-line-build-status-code
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?s <- (http-status-line (name ?name) (http-version ?h&:(instancep ?h)) (status-code ?status-code&:(> 3 (str-length ?status-code))))
	=>
	(retract ?c)
	(modify ?s (status-code (format nil "%s%c" ?status-code ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-status-line-initialize-reason-phrase
	?c <- (http-char ?name 32) ; SP
	?s <- (http-status-line (name ?name) (status-code ?status-code&:(= 3 (str-length ?status-code))) (reason-phrase nil))
	=>
	(retract ?c)
	(modify ?s (reason-phrase (assert (http-reason-phrase (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-build-reason-phrase
	?c <- (http-char ?name ?char)
	?r <- (http-reason-phrase (name ?name) (value ?value))
	(test (or
		(= 9 ?char)
		(= 32 ?char)
		(and (>= ?char 33) (<= ?char 126)) ; VCHAR
		(and (>= ?char 128) (<= ?char 255)))) ; obs-text
	=>
	(retract ?c)
	(modify ?r (value (format nil "%s%c" ?value ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-status-line-end-reason-phrase
	?c <- (http-char ?name 13) ; CR
	?r <- (http-reason-phrase (name ?name) (value ?value))
	?s <- (http-status-line (reason-phrase ?r))
	=>
	(retract ?c ?r)
	(modify ?s (reason-phrase (make-instance of HTTP-REASON-PHRASE (id ?name) (value ?value))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-status-line-end
	?c <- (http-char ?name 10) ; LF
	?s <- (http-status-line (http-version ?http-version) (status-code ?status-code) (reason-phrase ?reason-phrase&:(instancep ?reason-phrase)))
	?h <- (http-message (name ?name) (start-line ?s))
	=>
	(retract ?c ?s)
	(modify ?h (start-line (make-instance of HTTP-STATUS-LINE (id ?name) (http-version ?http-version) (status-code ?status-code) (reason-phrase ?reason-phrase))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-method
	?c <- (http-char ?name 32)
	?m <- (http-method (name ?name) (value ?value&:(member$ ?value ?*http-methods*)))
	?r <- (http-request-line (method ?m))
	=>
	(retract ?c ?m)
	(modify ?r (method (make-instance of HTTP-METHOD (id ?name) (value ?value))))
	(assert (http-char ?name (http-read ?name))))
 
;   request-target = origin-form
;                  / absolute-form
;                  / authority-form
;                  / asterisk-form
(defrule http-start-request-target-origin-form
	?c <- (http-char ?name 47) ; /
	?r <- (http-request-line (name ?name) (method ?method&:(instancep ?method)) (request-target nil))
	=>
	(retract ?c)
	(modify ?r (request-target (assert (http-origin-form (name ?name) (segments (assert (http-segment (name ?name) (value (assert (http-escapable-sequence (name ?name) (allowed-chars ?*http-pchar*)))))))))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-start-request-target-authority-form
	(http-char ?name ?char&:(member$ ?char (create$ ?*http-alphanum* 91))) ; [
	?m <- (object (is-a HTTP-METHOD) (value "CONNECT"))
	?r <- (http-request-line (name ?name) (method =(instance-name ?m)) (request-target nil))
	=>
	(modify ?r (request-target (assert (http-authority-form (name ?name) (uri-host (assert (http-host (name ?name)))))))))

(defrule http-start-request-target-absolute-form
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-alpha*))
	?m <- (object (is-a HTTP-METHOD) (value ~"CONNECT"&~"OPTIONS"))
	?r <- (http-request-line (name ?name) (method =(instance-name ?m)) (request-target nil))
	=>
	(retract ?c)
	(modify ?r (request-target (assert (http-absolute-uri (name ?name) (scheme (assert (http-scheme (name ?name) (value (format nil "%c" ?char)))))))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-continue-scheme
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-scheme*))
	?s <- (http-scheme (name ?name) (value ?value&~nil))
	=>
	(retract ?c)
	(modify ?s (value (format nil "%s%c" ?value ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-absolute-uri-end-scheme
	?c <- (http-char ?name 58) ; :
	?s <- (http-scheme (name ?name) (value ?value&~nil))
	?a <- (http-absolute-uri (scheme ?s))
	=>
	(retract ?c ?s)
	(modify ?a (scheme (make-instance of HTTP-SCHEME (id ?name) (value ?value))) (hier-part (assert (http-hier-part (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-hier-part-find-path-absolute-first-slash
	?c <- (http-char ?name 47) ; /
	?h <- (http-hier-part (name ?name) (authority nil) (path nil))
	=>
	(retract ?c)
	(modify ?h (path (assert (http-path-absolute (name ?name) (segment-nz (assert (http-escapable-sequence (name ?name) (allowed-chars ?*http-pchar*))))))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-hier-part-find-second-slash-change-path-absolute-to-authority
	?c <- (http-char ?name 47) ; /
	?e <- (http-escapable-sequence (sequence ""))
	?path <- (http-path-absolute (name ?name) (segment-nz ?e))
	?h <- (http-hier-part (path ?path))
	=>
	(retract ?c ?e ?path)
	(modify ?h (path nil) (authority (assert (http-authority (name ?name) (host (assert (http-host (name ?name))))))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-authority-change-host-port-to-userinfo
	(http-char ?name ?char&~9&~13&~32&~35&~47&~63&:(not (member$ ?char ?*http-digit*))) ; HTAB CR SP # / ?
	?r <- (object (is-a HTTP-REG-NAME) (value ?reg-name))
	?h <- (object (is-a HTTP-HOST) (value =(instance-name ?r)))
	?p <- (http-port (value ?port))
	?a <- (http-authority (name ?name) (userinfo nil) (host =(instance-name ?h)) (port ?p))
	=>
	(retract ?p)
	(unmake-instance ?r ?h)
	(modify ?a (host nil) (port nil) (userinfo (assert (http-escapable-sequence (name ?name) (sequence (format nil "%s:%s" ?reg-name ?port)) (allowed-chars ?*http-userinfo*))))))

;   authority = [ userinfo "@" ] host [ ":" port ] : an "@" right after the
;   host means what was read was the userinfo, not the host
(defrule http-authority-change-host-to-userinfo
	(http-char ?name 64) ; @
	?r <- (object (is-a HTTP-REG-NAME) (value ?reg-name))
	?h <- (object (is-a HTTP-HOST) (value =(instance-name ?r)))
	?a <- (http-authority (name ?name) (userinfo nil) (host =(instance-name ?h)) (port nil))
	=>
	(unmake-instance ?r ?h)
	(modify ?a (host nil) (userinfo (assert (http-escapable-sequence (name ?name) (sequence ?reg-name) (allowed-chars ?*http-userinfo*))))))

(defrule http-authority-form-end-port
	(http-char ?name 32) ; SP
	?p <- (http-port (value ?port))
	?a <- (http-authority-form (name ?name) (uri-host ?host&:(instancep ?host)) (port ?p))
	=>
	(retract ?p)
	(modify ?a (port (make-instance of HTTP-PORT (id ?name) (value ?port)))))

(defrule http-authority-end-userinfo
	?c <- (http-char ?name 64) ; @
	?e <- (http-escapable-sequence (sequence ?sequence) (pct-encoded nil))
	?a <- (http-authority (name ?name) (userinfo ?e))
	=>
	(retract ?c ?e)
	(modify ?a (userinfo (make-instance of HTTP-USERINFO (id ?name) (value ?sequence))) (host (assert (http-host (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-authority-end-host
	(http-char ?name 9|13|32|47|58|64) ; HTAB CR SP / : @
	?h <- (http-host (value ?host&:(instancep ?host)))
	?a <- (http-authority (name ?name) (host ?h))
	=>
	(retract ?h)
	(modify ?a (host (make-instance of HTTP-HOST (id ?name) (value ?host)))))

(defrule http-authority-form-end-host
	(http-char ?name 32|47|58) ; SP / :
	?h <- (http-host (value ?host&:(instancep ?host)))
	?a <- (http-authority-form (name ?name) (uri-host ?h))
	=>
	(retract ?h)
	(modify ?a (uri-host (make-instance of HTTP-HOST (id ?name) (value ?host)))))

(defrule http-host-detect-ip-literal
	?c <- (http-char ?name 91) ; [
	?h <- (http-host (name ?name) (value nil))
	=>
	(retract ?c)
	(modify ?h (value (assert (http-ip-literal (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-ip-literal-detect-ipv6address
	(http-char ?name ?char&:(member$ ?char ?*http-hexdig*))
	?i <- (http-ip-literal (name ?name) (value nil))
	=>
	(modify ?i (value (assert (http-ipv6address (name ?name) (parts (assert (http-h16 (name ?name)))))))))

(defrule http-ip-literal-detect-ipv6address-colon
	?c <- (http-char ?name 58)
	?i <- (http-ip-literal (name ?name) (value nil))
	=>
	(retract ?c)
	(modify ?i (value (assert (http-ipv6address (name ?name) (parts ":")))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-ipv6address-detect-h16
	(http-char ?name ?char&:(member$ ?char ?*http-hex-without-dig*))
	?i <- (http-ipv6address (name ?name) (parts $?parts&:(> 8 (length$ ?parts))&:(= 0 (length$ ?parts))|:(eq "::" (nth$ (length$ ?parts) ?parts))|:(eq HTTP-H16 (class (nth$ (length$ ?parts) ?parts))) ":"))
	=>
	(modify ?i (parts ?parts (assert (http-h16 (name ?name))))))

(defrule http-ipv6address-detect-ipv4address
	(http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?i <- (http-ipv6address (name ?name) (parts $?parts&:(> 7 (length$ ?parts))&:(< 0 (length$ ?parts))&:(instancep (nth$ (length$ ?parts) ?parts))|:(eq "::" (nth$ (length$ ?parts) ?parts)) ":"))
	=>
	(modify ?i (parts ?parts (assert (http-ipv4address (name ?name) (octets (assert (http-dec-octet (name ?name)))))))))

(defrule http-ipv6address-detect-last-h16
	(http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?i <- (http-ipv6address (name ?name) (parts $?parts&:(= 7 (length$ ?parts))&:(instancep (nth$ 7 ?parts)) ":"))
	=>
	(modify ?i (parts ?parts (assert (http-h16 (name ?name))))))

(defrule http-ipv6address-change-one-digit-ipv4address-to-h16
	?octet <- (http-dec-octet (name ?name) (first-digit ?first) (second-digit ""))
	(http-char ?name ?char&58|93|:(member$ ?char ?*http-hex-without-dig*)|:(not (http-dec-octet-accepts-digit ?first "" "" ?char))) ; : ]
	?i4 <- (http-ipv4address (name ?name) (octets ?octet))
	?i <- (http-ipv6address (name ?name) (parts $?parts ?i4))
	=>
	(retract ?octet ?i4)
	(modify ?i (parts ?parts (assert (http-h16 (name ?name) (value ?first))))))

(defrule http-ipv6address-change-two-digit-ipv4address-to-h16
	?octet <- (http-dec-octet (name ?name) (first-digit ?first) (second-digit ?second&~"") (third-digit ""))
	(http-char ?name ?char&58|93|:(member$ ?char ?*http-hex-without-dig*)|:(not (http-dec-octet-accepts-digit ?first ?second "" ?char))) ; : ]
	?i4 <- (http-ipv4address (name ?name) (octets ?octet))
	?i <- (http-ipv6address (name ?name) (parts $?parts ?i4))
	=>
	(retract ?octet ?i4)
	(modify ?i (parts ?parts (assert (http-h16 (name ?name) (value (str-cat ?first ?second)))))))

(defrule http-ipv6address-change-three-digit-ipv4address-to-h16
	(http-char ?name ?char&58|93|:(member$ ?char ?*http-hexdig*)) ; : ]
	?octet <- (http-dec-octet (name ?name) (first-digit ?first) (second-digit ?second) (third-digit ?third&~""))
	?i4 <- (http-ipv4address (name ?name) (octets ?octet))
	?i <- (http-ipv6address (name ?name) (parts $?parts ?i4))
	=>
	(retract ?octet ?i4)
	(modify ?i (parts ?parts (assert (http-h16 (name ?name) (value (str-cat ?first ?second ?third)))))))

(defrule http-ipv6address-end-dec-octet
	(http-char ?name 93) ; ]
	?o <- (http-dec-octet (name ?name) (first-digit ?first&~"") (second-digit ?second) (third-digit ?third))
	?i4 <- (http-ipv4address (name ?name) (octets ?a ?b ?c ?o))
	(http-ipv6address (name ?name) (parts $? ?i4))
	=>
	(retract ?o)
	(modify ?i4 (octets ?a ?b ?c (make-instance of HTTP-DEC-OCTET (id ?name) (value (str-cat ?first ?second ?third))))))

(defrule http-ipv6address-end-ipv4address
	(http-char ?name 93) ; ]
	?i4 <- (http-ipv4address (name ?name) (octets ?first ?second ?third ?fourth&:(instancep ?fourth)))
	?i6 <- (http-ipv6address (parts $?parts ?i4))
	=>
	(retract ?i4)
	(modify ?i6 (parts ?parts (make-instance of HTTP-IPV4ADDRESS (id ?name) (first-octet ?first) (second-octet ?second) (third-octet ?third) (fourth-octet ?fourth)))))

(defrule http-continue-h16
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-hexdig*))
	?h <- (http-h16 (name ?name) (value ?value&:(> 4 (str-length ?value))))
	=>
	(retract ?c)
	(modify ?h (value (format nil "%s%c" ?value ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-h16-in-ipv6address
	(http-char ?name 58|93) ; : ]
	?h <- (http-h16 (name ?name) (value ?value))
	?i <- (http-ipv6address (parts $?parts ?h))
	=>
	(retract ?h)
	(modify ?i (parts ?parts (make-instance of HTTP-H16 (id ?name) (value ?value)))))

(defrule http-ipv6address-detect-double-colon
	?c <- (http-char ?name 58) ; :
	?i <- (http-ipv6address (name ?name) (parts $?parts&:(> 8 (length$ ?parts))&:(= 0 (length$ ?parts))|:(instancep (nth$ (length$ ?parts) ?parts))&~:(member$ "::" ?parts) ":"))
	=>
	(retract ?c)
	(modify ?i (parts ?parts "::" ":"))
	(assert (http-char ?name (http-read ?name))))

(defrule http-ipv6address-detect-next-part
	?c <- (http-char ?name 58) ; :
	?i6 <- (http-ipv6address (name ?name) (parts $?parts&:(= 0 (length$ ?parts))|:(eq "::" (nth$ (length$ ?parts) ?parts))|:(instancep (nth$ (length$ ?parts) ?parts))))
	=>
	(retract ?c)
	(modify ?i6 (parts ?parts ":"))
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-ipv6address
	(http-char ?name 93) ; ]
	?i6 <- (http-ipv6address (name ?name) (parts $?parts&:(= 0 (length$ ?parts))|:(eq "::" (nth$ (length$ ?parts) ?parts))|:(instancep (nth$ (length$ ?parts) ?parts))))
	?il <- (http-ip-literal (value ?i6))
	=>
	(retract ?i6)
	(modify ?il (value (make-instance of HTTP-IPV6ADDRESS (id ?name) (parts ?parts)))))

(defrule http-end-ipv6address-after-double-colon
	(http-char ?name 93) ; ]
	?i6 <- (http-ipv6address (name ?name) (parts $?parts "::" ":"))
	?il <- (http-ip-literal (value ?i6))
	=>
	(retract ?i6)
	(modify ?il (value (make-instance of HTTP-IPV6ADDRESS (id ?name) (parts ?parts "::")))))
	
(defrule http-end-ipliteral
	?c <- (http-char ?name 93) ; ]
	?i <- (http-ip-literal (name ?name) (value ?i6&:(instancep ?i6)))
	?h <- (http-host (value ?i))
	=>
	(retract ?c ?i)
	(modify ?h (value (make-instance of HTTP-IP-LITERAL (id ?name) (value ?i6))))
	(assert (http-char ?name (http-read ?name))))

;(defrule ip-literal-detect-ipvfuture
;	?c <- (char ?name 118) ; v

(defrule http-host-detect-ipv4address
	(http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?h <- (http-host (name ?name) (value nil))
	=>
	(modify ?h (value (assert (http-ipv4address (name ?name) (octets (assert (http-dec-octet (name ?name)))))))))

(defrule http-dec-octet-set-first-digit
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?o <- (http-dec-octet (name ?name) (first-digit ""))
	=>
	(retract ?c)
	(modify ?o (first-digit (format nil "%c" ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-dec-octet-set-second-digit
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?o <- (http-dec-octet (name ?name) (first-digit ~""&~"0") (second-digit ""))
	=>
	(retract ?c)
	(modify ?o (second-digit (format nil "%c" ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-dec-octet-set-third-digit-when-first-digit-is-one
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?o <- (http-dec-octet (name ?name) (first-digit "1") (second-digit ~"") (third-digit ""))
	=>
	(retract ?c)
	(modify ?o (third-digit (format nil "%c" ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-dec-octet-set-third-digit-when-first-digit-is-two-and-second-digit-is-5
	?c <- (http-char ?name ?char&48|49|50|51|52|53) ; 0 1 2 3 4 5
	?o <- (http-dec-octet (name ?name) (first-digit "2") (second-digit "5") (third-digit ""))
	=>
	(retract ?c)
	(modify ?o (third-digit (format nil "%c" ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-dec-octet-set-third-digit-when-first-digit-is-two-and-second-digit-is-less-than-5
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?o <- (http-dec-octet (name ?name) (first-digit "2") (second-digit "0"|"1"|"2"|"3"|"4") (third-digit ""))
	=>
	(retract ?c)
	(modify ?o (third-digit (format nil "%c" ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-dec-octet
	(http-char ?name 9|13|32|46|47|64) ; HTAB CR SP . / @
	?o <- (http-dec-octet (name ?name) (first-digit ?first) (second-digit ?second) (third-digit ?third))
	?i <- (http-ipv4address (octets $?octets ?o))
	=>
	(retract ?o)
	(modify ?i (octets ?octets (make-instance of HTTP-DEC-OCTET (id ?name) (value (format nil "%s%s%s" ?first ?second ?third))))))

;;; ":" ends an octet only before a port; inside an IPv6 address it makes the octet an h16 instead
(defrule http-end-dec-octet-before-port
	(http-char ?name 58) ; :
	?o <- (http-dec-octet (name ?name) (first-digit ?first) (second-digit ?second) (third-digit ?third))
	?i <- (http-ipv4address (octets $?octets ?o))
	(http-host (value ?i))
	=>
	(retract ?o)
	(modify ?i (octets ?octets (make-instance of HTTP-DEC-OCTET (id ?name) (value (format nil "%s%s%s" ?first ?second ?third))))))

(defrule http-ipv4address-create-octet
	?c <- (http-char ?name 46) ; .
	?i <- (http-ipv4address (name ?name) (octets $?octets&:(> 4 (length$ ?octets))&:(instancep (nth$ (length$ ?octets) ?octets))))
	=>
	(retract ?c)
	(modify ?i (octets ?octets (assert (http-dec-octet (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-host-end-ipv4address
	(http-char ?name 9|13|32|47|58) ; HTAB CR SP / :
	?i <- (http-ipv4address (name ?name) (octets ?first ?second ?third ?fourth&:(instancep ?fourth)))
	?h <- (http-host (value ?i))
	=>
	(retract ?i)
	(modify ?h (value (make-instance of HTTP-IPV4ADDRESS (id ?name) (first-octet ?first) (second-octet ?second) (third-octet ?third) (fourth-octet ?fourth)))))

(defrule http-host-ipv4address-change-to-reg-name
	?i <- (http-ipv4address (name ?name) (octets $?octets))
	?h <- (http-host (value ?i))
	(or
		(http-char ?name ?char&:(member$ ?char (create$ ?*http-reg-name-no-digits* 37))) ; %
		(and
			(http-char ?name ?char&:(member$ ?char ?*http-digit*))
			(http-dec-octet (name ?name) (first-digit ?first&~"") (second-digit ?second) (third-digit ?third))
			(test (not (http-dec-octet-accepts-digit ?first ?second ?third ?char))))
		(and
			(http-char ?name 9|13|32|47|58|64) ; HTAB CR SP / : @
			(test (> 4 (length$ ?octets)))
			(test (instancep (nth$ (length$ ?octets) ?octets))))
		(and
			(http-char ?name ~9&~13&~32&~47&~58) ; an "@" after four octets makes them a userinfo, so it stays
			(test (= 4 (length$ ?octets)))
			(test (instancep (nth$ 4 ?octets)))))
	=>
	(retract ?i)
	(bind ?value "")
	(bind ?separator "")
	(do-for-all-instances ((?octet HTTP-DEC-OCTET)) (member$ ?octet ?octets)
		(bind ?value (str-cat ?value ?separator (send ?octet get-value)))
		(bind ?separator ".")
		(unmake-instance ?octet))
	(do-for-fact ((?octet http-dec-octet)) (member$ ?octet ?octets)
		(bind ?value (str-cat ?value ?separator (fact-slot-value ?octet first-digit) (fact-slot-value ?octet second-digit) (fact-slot-value ?octet third-digit)))
		(retract ?octet))
	(modify ?h (value (assert (http-reg-name (name ?name) (value (assert (http-escapable-sequence (name ?name) (allowed-chars ?*http-reg-name*) (sequence ?value)))))))))

(defrule http-host-detect-reg-name
	(http-char ?name ?char&:(member$ ?char (create$ ?*http-reg-name-no-digits* 37))) ; %
	?h <- (http-host (name ?name) (value nil))
	=>
	(modify ?h (value (assert (http-reg-name (name ?name) (value (assert (http-escapable-sequence (name ?name) (allowed-chars ?*http-reg-name*)))))))))

(defrule http-end-reg-name
	(http-char ?name 9|13|32|47|58|64) ; HTAB CR SP / : @
	?e <- (http-escapable-sequence (sequence ?sequence) (pct-encoded nil))
	?r <- (http-reg-name (value ?e))
	?h <- (http-host (name ?name) (value ?r))
	=>
	(retract ?e ?r)
	(modify ?h (value (make-instance of HTTP-REG-NAME (id ?name) (value ?sequence)))))

(defrule http-authority-form-start-port
	?c <- (http-char ?name 58) ; :
	?a <- (http-authority-form (name ?name) (uri-host ?host&:(instancep ?host)) (port nil))
	=>
	(retract ?c)
	(modify ?a (port (assert (http-port (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-authority-start-port
	?c <- (http-char ?name 58) ; :
	?a <- (http-authority (name ?name) (host ?host&:(instancep ?host)) (port nil))
	=>
	(retract ?c)
	(modify ?a (port (assert (http-port (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-continue-port
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?p <- (http-port (name ?name) (value ?start&:(> 5 (str-length ?start))))
	=>
	(retract ?c)
	(modify ?p (value (format nil "%s%c" ?start ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-authority-form
	?c <- (http-char ?name 32) ; SP
	?a <- (http-authority-form (name ?name) (uri-host ?host) (port ?p&:(instancep ?p)))
	?r <- (http-request-line (request-target ?a))
	=>
	(retract ?c ?a)
	(modify ?r (request-target (make-instance of HTTP-AUTHORITY-FORM (id ?name) (uri-host ?host) (port ?p))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-authority-end-port
	(http-char ?name 9|13|32|35|47|63) ; HTAB CR SP # / ?
	?p <- (http-port (name ?name) (value ?port))
	?a <- (http-authority (host ?host&:(instancep ?host)) (port ?p))
	=>
	(retract ?p)
	(modify ?a (port (make-instance of HTTP-PORT (id ?name) (value ?port)))))

(defrule http-end-authority
	(http-char ?name 9|13|32|35|47|63) ; HTAB CR SP # / ?
	?a <- (http-authority (name ?name) (userinfo ?userinfo&nil|:(instancep ?userinfo)) (host ?host&:(instancep ?host)) (port ?port&nil|:(instancep ?port)))
	?h <- (http-hier-part (authority ?a))
	=>
	(retract ?a)
	(modify ?h (authority (make-instance of HTTP-AUTHORITY (id ?name) (userinfo ?userinfo) (host ?host) (port ?port)))))

(defrule http-start-path-abempty
	(http-char ?name 9|13|32|35|47|63) ; HTAB CR SP # / ?
	?h <- (http-hier-part (name ?name) (authority ?a&:(instancep ?a)) (path nil))
	=>
	(modify ?h (path (assert (http-path-abempty (name ?name))))))

(defrule http-end-path-abempty
	(http-char ?name 9|13|32|35|63) ; HTAB CR SP # ?
	?p <- (http-path-abempty (name ?name) (segments $?segments&:(= 0 (length$ ?segments))|:(instancep (nth$ (length$ ?segments) ?segments))))
	?h <- (http-hier-part (path ?p))
	=>
	(retract ?p)
	(modify ?h (path (make-instance of HTTP-PATH-ABEMPTY (id ?name) (segments ?segments)))))

(defrule http-end-hier-part
	(http-char ?name 9|13|32|35|63) ; HTAB CR SP # ?
	?h <- (http-hier-part (name ?name) (authority ?authority&nil|:(instancep ?authority)) (path ?path&:(instancep ?path)))
	?a <- (http-absolute-uri (hier-part ?h))
	=>
	(retract ?h)
	(modify ?a (hier-part (make-instance of HTTP-HIER-PART (id ?name) (authority ?authority) (path ?path)))))

(defrule http-absolute-uri-start-query
	?c <- (http-char ?name 63) ; ?
	?a <- (http-absolute-uri (name ?name) (hier-part ?h&:(instancep ?h)))
	=>
	(retract ?c)
	(modify ?a (query (assert (http-escapable-sequence (name ?name) (allowed-chars ?*http-query*)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-absolute-uri-end-query
	(http-char ?name 9|13|32|35) ; HTAB CR SP #
	?e <- (http-escapable-sequence (name ?name) (sequence ?sequence) (pct-encoded nil))
	?a <- (http-absolute-uri (query ?e))
	=>
	(retract ?e)
	(modify ?a (query (make-instance of HTTP-QUERY (id ?name) (value ?sequence)))))

(defrule http-start-request-target-asterisk-form
	?c <- (http-char ?name 42) ; *
	?m <- (object (is-a HTTP-METHOD) (value "OPTIONS"))
	?r <- (http-request-line (name ?name) (method =(instance-name ?m)) (request-target nil))
	=>
	(retract ?c)
	(modify ?r (request-target "*"))
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-request-target-asterisk-form
	?c <- (http-char ?name 32) ; SP
	?r <- (http-request-line (name ?name) (request-target "*"))
	=>
	(retract ?c)
	(modify ?r (request-target (make-instance of HTTP-ASTERISK-FORM (id ?name))))
	(assert (http-char ?name (http-read ?name))))

	; the type of path this segment is for (origin-form, path-abempty, path-absolute, path-rootless)
(defrule http-origin-form-end-of-segment
	(http-char ?name 32|47|63) ; SP / ?
	?es <- (http-escapable-sequence (sequence ?value) (pct-encoded nil))
	?s <- (http-segment (value ?es))
	?o <- (http-origin-form (name ?name) (segments $?segments ?s))
	=>
	(retract ?es ?s)
	(modify ?o (segments ?segments (make-instance of HTTP-SEGMENT (id ?name) (value ?value)))))

(defrule http-path-abempty-end-of-segment
	(http-char ?name 9|13|32|35|47|63) ; HTAB CR SP # / ?
	?es <- (http-escapable-sequence (sequence ?value) (pct-encoded nil))
	?s <- (http-segment (value ?es))
	?p <- (http-path-abempty (name ?name) (segments $?segments ?s))
	=>
	(retract ?es ?s)
	(modify ?p (segments ?segments (make-instance of HTTP-SEGMENT (id ?name) (value ?value)))))

(defrule http-path-absolute-end-of-segment
	(http-char ?name 9|13|32|35|47|63) ; HTAB CR SP # / ?
	?es <- (http-escapable-sequence (sequence ?value) (pct-encoded nil))
	?s <- (http-segment (value ?es))
	?p <- (http-path-absolute (name ?name) (segments $?segments ?s))
	=>
	(retract ?es ?s)
	(modify ?p (segments ?segments (make-instance of HTTP-SEGMENT (id ?name) (value ?value)))))

(defrule http-path-rootless-end-of-segment
	(http-char ?name 32|47|63) ; SP / ?
	?es <- (http-escapable-sequence (sequence ?value) (pct-encoded nil))
	?s <- (http-segment (value ?es))
	?p <- (http-path-rootless (name ?name) (segments $?segments ?s))
	=>
	(retract ?es ?s)
	(modify ?p (segments ?segments (make-instance of HTTP-SEGMENT (id ?name) (value ?value)))))

(defrule http-origin-form-find-next-segment
	?c <- (http-char ?name 47) ; /
	?o <- (http-origin-form (name ?name) (segments $?segments ?segment&:(instancep ?segment)))
	=>
	(retract ?c)
	(modify ?o (segments ?segments ?segment (assert (http-segment (name ?name) (value (assert (http-escapable-sequence (name ?name) (allowed-chars ?*http-pchar*))))))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-path-abempty-find-next-segment
	?c <- (http-char ?name 47) ; /
	?p <- (http-path-abempty (name ?name) (segments $?segments&:(= 0 (length$ ?segments))|:(instancep (nth$ (length$ ?segments) ?segments))))
	=>
	(retract ?c)
	(modify ?p (segments ?segments (assert (http-segment (name ?name) (value (assert (http-escapable-sequence (name ?name) (allowed-chars ?*http-pchar*))))))))
	(assert (http-char ?name (http-read ?name))))
	
(defrule http-path-absolute-find-next-segment
	?c <- (http-char ?name 47) ; /
	?p <- (http-path-absolute (name ?name) (segment-nz ?segment-nz&:(instancep ?segment-nz)) (segments $?segments&:(= 0 (length$ ?segments))|:(instancep (nth$ (length$ ?segments) ?segments))))
	=>
	(retract ?c)
	(modify ?p (segments ?segments (assert (http-segment (name ?name) (value (assert (http-escapable-sequence (name ?name) (allowed-chars ?*http-pchar*))))))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-path-absolute-end-segment-nz
	(http-char ?name 9|13|32|35|47|63) ; HTAB CR SP # / ?
	?es <- (http-escapable-sequence (sequence ?value&~"") (pct-encoded nil))
	?p <- (http-path-absolute (name ?name) (segment-nz ?es))
	=>
	(retract ?es)
	(modify ?p (segment-nz (make-instance of HTTP-SEGMENT (id ?name) (value ?value)))))

; path-absolute = "/" [ segment-nz *( "/" segment ) ] : a lone "/" has no segment-nz
(defrule http-path-absolute-end-without-segment-nz
	(http-char ?name 9|13|32|35|63) ; HTAB CR SP # ?
	?es <- (http-escapable-sequence (sequence "") (pct-encoded nil))
	?p <- (http-path-absolute (name ?name) (segment-nz ?es))
	=>
	(retract ?es)
	(modify ?p (segment-nz nil)))

(defrule http-end-path-absolute
	(http-char ?name 9|13|32|35|63) ; HTAB CR SP # ?
	?p <- (http-path-absolute (name ?name) (segment-nz ?segment-nz&nil|:(instancep ?segment-nz)) (segments $?segments&:(= 0 (length$ ?segments))|:(instancep (nth$ (length$ ?segments) ?segments))))
	?h <- (http-hier-part (path ?p))
	=>
	(retract ?p)
	(modify ?h (path (make-instance of HTTP-PATH-ABSOLUTE (id ?name) (segment-nz ?segment-nz) (segments ?segments)))))
	
(defrule http-path-rootless-find-next-segment
	?c <- (http-char ?name 47) ; /
	?p <- (http-path-rootless (name ?name) (segments $?segments ?segment&:(instancep ?segment)))
	=>
	(retract ?c)
	(modify ?p (segments ?segments ?segment (assert (http-segment (name ?name) (value (assert (http-escapable-sequence (name ?name) (allowed-chars ?*http-pchar*))))))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-origin-form-start-query
	?c <- (http-char ?name 63) ; ?
	?a <- (http-origin-form (name ?name) (segments $?segments ?segment&:(instancep ?segment)) (query nil))
	=>
	(retract ?c)
	(modify ?a (query (assert (http-escapable-sequence (name ?name) (allowed-chars ?*http-query*)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-origin-form-end-query
	(http-char ?name 32) ; SP
	?e <- (http-escapable-sequence (name ?name) (sequence ?sequence) (pct-encoded nil))
	?a <- (http-origin-form (query ?e))
	=>
	(retract ?e)
	(modify ?a (query (make-instance of HTTP-QUERY (id ?name) (value ?sequence)))))

(defrule http-end-of-origin-form
	?c <- (http-char ?name 32) ; SP
	?o <- (http-origin-form (name ?name) (segments $?segments ?segment&:(instancep ?segment)) (query ?query&nil|:(instancep ?query)))
	?r <- (http-request-line (request-target ?o))
	=>
	(retract ?c ?o)
	(modify ?r (request-target (make-instance of HTTP-ORIGIN-FORM (id ?name) (segments ?segments ?segment) (query ?query))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-of-absolute-uri
	?c <- (http-char ?name 32) ; SP
	?a <- (http-absolute-uri (name ?name) (scheme ?scheme) (hier-part ?hier-part&:(instancep ?hier-part)) (query ?query&nil|:(instancep ?query)))
	?r <- (http-request-line (request-target ?a))
	=>
	(retract ?c ?a)
	(modify ?r (request-target (make-instance of HTTP-ABSOLUTE-URI (id ?name) (scheme ?scheme) (hier-part ?hier-part) (query ?query))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-relative-part
	(http-char ?name 9|13|32|35|63) ; HTAB CR SP # ?
	?h <- (http-hier-part (name ?name) (authority ?authority&nil|:(instancep ?authority)) (path ?path&:(instancep ?path)))
	?p <- (http-partial-uri (relative-part ?h))
	=>
	(retract ?h)
	(modify ?p (relative-part (make-instance of HTTP-RELATIVE-PART (id ?name) (authority ?authority) (path ?path)))))

(defrule http-partial-uri-start-query
	?c <- (http-char ?name 63) ; ?
	?p <- (http-partial-uri (name ?name) (relative-part ?r&:(instancep ?r)) (query nil))
	=>
	(retract ?c)
	(modify ?p (query (assert (http-escapable-sequence (name ?name) (allowed-chars ?*http-query*)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-partial-uri-end-query
	(http-char ?name 9|13|32|35) ; HTAB CR SP #
	?e <- (http-escapable-sequence (name ?name) (sequence ?sequence) (pct-encoded nil))
	?p <- (http-partial-uri (query ?e))
	=>
	(retract ?e)
	(modify ?p (query (make-instance of HTTP-QUERY (id ?name) (value ?sequence)))))

;   Referer  = absolute-URI / partial-URI
;   Location = URI-reference
;   URI-reference = URI / relative-ref
;   fragment      = *( pchar / "/" / "?" )
; Referer (RFC 9110 10.1.3) and Location (10.2.2) share the URI grammar, so the
; same uri-reference-header fact and rules build both; only Location allows a
; fragment, and only the end rule differs.
(defrule http-detect-uri-reference-header-absolute-uri
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-alpha*))
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Referer"|"Location"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(retract ?c)
	(modify ?fv (value (assert (http-uri-reference-header (name ?name) (uri-reference (assert (http-absolute-uri (name ?name) (scheme (assert (http-scheme (name ?name) (value (format nil "%c" ?char))))))))))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-detect-uri-reference-header-partial-uri
	(http-char ?name 47) ; /
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Referer"|"Location"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-uri-reference-header (name ?name) (uri-reference (assert (http-partial-uri (name ?name) (relative-part (assert (http-hier-part (name ?name))))))))))))

; relative-part = ... / path-noscheme : a value that starts like a scheme but is
; never followed by ":" is a path-noscheme; its first segment is what was read
(defrule http-uri-reference-header-change-scheme-to-path-noscheme
	(http-char ?name ?char&~58&~:(member$ ?char ?*http-scheme*)) ; :
	?s <- (http-scheme (name ?name) (value ?value&~nil))
	?a <- (http-absolute-uri (scheme ?s) (hier-part nil))
	?h <- (http-uri-reference-header (uri-reference ?a))
	=>
	(retract ?s ?a)
	(modify ?h (uri-reference (assert (http-partial-uri (name ?name) (relative-part (assert (http-hier-part (name ?name) (path (assert (http-path-noscheme (name ?name) (segment-nz-nc (assert (http-escapable-sequence (name ?name) (sequence ?value) (allowed-chars ?*http-segment-nz-nc*)))))))))))))))

; a path-noscheme that does not start with ALPHA cannot be a scheme at all
(defrule http-detect-uri-reference-header-path-noscheme
	(http-char ?name ?char&:(member$ ?char (create$ ?*http-segment-nz-nc-no-alpha* 37))) ; %
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Referer"|"Location"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-uri-reference-header (name ?name) (uri-reference (assert (http-partial-uri (name ?name) (relative-part (assert (http-hier-part (name ?name) (path (assert (http-path-noscheme (name ?name) (segment-nz-nc (assert (http-escapable-sequence (name ?name) (allowed-chars ?*http-segment-nz-nc*))))))))))))))))))

(defrule http-path-noscheme-end-segment-nz-nc
	(http-char ?name 9|13|32|35|47|63) ; HTAB CR SP # / ?
	?es <- (http-escapable-sequence (sequence ?value&~"") (pct-encoded nil))
	?p <- (http-path-noscheme (name ?name) (segment-nz-nc ?es))
	=>
	(retract ?es)
	(modify ?p (segment-nz-nc (make-instance of HTTP-SEGMENT (id ?name) (value ?value)))))

(defrule http-path-noscheme-find-next-segment
	?c <- (http-char ?name 47) ; /
	?p <- (http-path-noscheme (name ?name) (segment-nz-nc ?segment-nz-nc&:(instancep ?segment-nz-nc)) (segments $?segments&:(= 0 (length$ ?segments))|:(instancep (nth$ (length$ ?segments) ?segments))))
	=>
	(retract ?c)
	(modify ?p (segments ?segments (assert (http-segment (name ?name) (value (assert (http-escapable-sequence (name ?name) (allowed-chars ?*http-pchar*))))))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-path-noscheme-end-of-segment
	(http-char ?name 9|13|32|35|47|63) ; HTAB CR SP # / ?
	?es <- (http-escapable-sequence (sequence ?value) (pct-encoded nil))
	?s <- (http-segment (value ?es))
	?p <- (http-path-noscheme (name ?name) (segments $?segments ?s))
	=>
	(retract ?es ?s)
	(modify ?p (segments ?segments (make-instance of HTTP-SEGMENT (id ?name) (value ?value)))))

(defrule http-end-path-noscheme
	(http-char ?name 9|13|32|35|63) ; HTAB CR SP # ?
	?p <- (http-path-noscheme (name ?name) (segment-nz-nc ?segment-nz-nc&:(instancep ?segment-nz-nc)) (segments $?segments&:(= 0 (length$ ?segments))|:(instancep (nth$ (length$ ?segments) ?segments))))
	?h <- (http-hier-part (path ?p))
	=>
	(retract ?p)
	(modify ?h (path (make-instance of HTTP-PATH-NOSCHEME (id ?name) (segment-nz-nc ?segment-nz-nc) (segments ?segments)))))

(defrule http-uri-reference-header-end-absolute-uri
	(http-char ?name 9|13|32) ; HTAB CR SP
	?a <- (http-absolute-uri (name ?name) (scheme ?scheme) (hier-part ?hier-part&:(instancep ?hier-part)) (query ?query&nil|:(instancep ?query)) (fragment nil))
	?h <- (http-uri-reference-header (uri-reference ?a))
	=>
	(retract ?a)
	(modify ?h (uri-reference (make-instance of HTTP-ABSOLUTE-URI (id ?name) (scheme ?scheme) (hier-part ?hier-part) (query ?query)))))

(defrule http-uri-reference-header-end-uri
	(http-char ?name 9|13|32) ; HTAB CR SP
	?a <- (http-absolute-uri (name ?name) (scheme ?scheme) (hier-part ?hier-part&:(instancep ?hier-part)) (query ?query&nil|:(instancep ?query)) (fragment ?fragment&:(instancep ?fragment)))
	?h <- (http-uri-reference-header (uri-reference ?a))
	=>
	(retract ?a)
	(modify ?h (uri-reference (make-instance of HTTP-URI (id ?name) (scheme ?scheme) (hier-part ?hier-part) (query ?query) (fragment ?fragment)))))

(defrule http-uri-reference-header-end-partial-uri
	(http-char ?name 9|13|32) ; HTAB CR SP
	?p <- (http-partial-uri (name ?name) (relative-part ?relative-part&:(instancep ?relative-part)) (query ?query&nil|:(instancep ?query)) (fragment nil))
	?h <- (http-uri-reference-header (uri-reference ?p))
	=>
	(retract ?p)
	(modify ?h (uri-reference (make-instance of HTTP-PARTIAL-URI (id ?name) (relative-part ?relative-part) (query ?query)))))

(defrule http-uri-reference-header-end-relative-ref
	(http-char ?name 9|13|32) ; HTAB CR SP
	?p <- (http-partial-uri (name ?name) (relative-part ?relative-part&:(instancep ?relative-part)) (query ?query&nil|:(instancep ?query)) (fragment ?fragment&:(instancep ?fragment)))
	?h <- (http-uri-reference-header (uri-reference ?p))
	=>
	(retract ?p)
	(modify ?h (uri-reference (make-instance of HTTP-RELATIVE-REF (id ?name) (relative-part ?relative-part) (query ?query) (fragment ?fragment)))))

(defrule http-location-header-uri-start-fragment
	?c <- (http-char ?name 35) ; #
	?a <- (http-absolute-uri (name ?name) (hier-part ?hier-part&:(instancep ?hier-part)) (query ?query&nil|:(instancep ?query)) (fragment nil))
	?h <- (http-uri-reference-header (uri-reference ?a))
	?fv <- (http-field-value (value ?h))
	(http-field-line (field-name ?fn) (field-value ?fv))
	(object (is-a HTTP-FIELD-NAME) (name ?fn) (value "Location"))
	=>
	(retract ?c)
	(modify ?a (fragment (assert (http-escapable-sequence (name ?name) (allowed-chars ?*http-query*)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-location-header-relative-ref-start-fragment
	?c <- (http-char ?name 35) ; #
	?p <- (http-partial-uri (name ?name) (relative-part ?relative-part&:(instancep ?relative-part)) (query ?query&nil|:(instancep ?query)) (fragment nil))
	?h <- (http-uri-reference-header (uri-reference ?p))
	?fv <- (http-field-value (value ?h))
	(http-field-line (field-name ?fn) (field-value ?fv))
	(object (is-a HTTP-FIELD-NAME) (name ?fn) (value "Location"))
	=>
	(retract ?c)
	(modify ?p (fragment (assert (http-escapable-sequence (name ?name) (allowed-chars ?*http-query*)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-uri-end-fragment
	(http-char ?name 9|13|32) ; HTAB CR SP
	?e <- (http-escapable-sequence (name ?name) (sequence ?sequence) (pct-encoded nil))
	?a <- (http-absolute-uri (fragment ?e))
	=>
	(retract ?e)
	(modify ?a (fragment (make-instance of HTTP-FRAGMENT (id ?name) (value ?sequence)))))

(defrule http-relative-ref-end-fragment
	(http-char ?name 9|13|32) ; HTAB CR SP
	?e <- (http-escapable-sequence (name ?name) (sequence ?sequence) (pct-encoded nil))
	?p <- (http-partial-uri (fragment ?e))
	=>
	(retract ?e)
	(modify ?p (fragment (make-instance of HTTP-FRAGMENT (id ?name) (value ?sequence)))))

(defrule http-uri-reference-header-skip-ows-after-uri-reference
	?c <- (http-char ?name 9|32) ; HTAB SP
	(http-uri-reference-header (name ?name) (uri-reference ?u&:(instancep ?u)))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-referer-header
	(http-char ?name 13) ; CR
	?h <- (http-uri-reference-header (name ?name) (uri-reference ?u&:(instancep ?u)))
	?fv <- (http-field-value (value ?h))
	(http-field-line (field-name ?fn) (field-value ?fv))
	(object (is-a HTTP-FIELD-NAME) (name ?fn) (value "Referer"))
	=>
	(retract ?h)
	(modify ?fv (value (make-instance of HTTP-REFERER-HEADER (id ?name) (uri-reference ?u)))))

(defrule http-end-location-header
	(http-char ?name 13) ; CR
	?h <- (http-uri-reference-header (name ?name) (uri-reference ?u&:(instancep ?u)))
	?fv <- (http-field-value (value ?h))
	(http-field-line (field-name ?fn) (field-value ?fv))
	(object (is-a HTTP-FIELD-NAME) (name ?fn) (value "Location"))
	=>
	(retract ?h)
	(modify ?fv (value (make-instance of HTTP-LOCATION-HEADER (id ?name) (uri-reference ?u)))))

(defrule http-char-is-allowed-char-in-escapable-sequence
	?e <- (http-escapable-sequence (name ?name) (sequence ?sequence) (allowed-chars $?allowed-chars) (pct-encoded nil))
	?c <- (http-char ?name ?char&:(member$ ?char ?allowed-chars))
	=>
	(retract ?c)
	(modify ?e (sequence (format nil "%s%c" ?sequence ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-pct-encoded-sequence
	?c <- (http-char ?name 37) ; %
	?e <- (http-escapable-sequence (name ?name) (sequence ?sequence) (pct-encoded nil))
	=>
	(retract ?c)
	(modify ?e (pct-encoded (assert (http-pct-encoded (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-pct-encoded-find-first
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-hexdig*))
	?p <- (http-pct-encoded (name ?name) (first nil))
	=>
	(retract ?c)
	(modify ?p (first ?char))
	(assert (http-char ?name (http-read ?name))))

(defrule http-pct-encoded-find-second
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-hexdig*))
	?p <- (http-pct-encoded (name ?name) (first ?first&~nil))
	?es <- (http-escapable-sequence (pct-encoded ?p) (sequence ?sequence))
	=>
	(retract ?p ?c)
	(modify ?es (sequence (format nil "%s%c%c%c" ?sequence 37 ?first ?char)) (pct-encoded nil))
	(assert (http-char ?name (http-read ?name))))

(defrule http-find-http-version
	?c <- (http-char ?name 72) ; H
	?r <- (http-request-line (name ?name) (request-target ?request-target&:(instancep ?request-target)) (http-version nil))
	=>
	(retract ?c)
	(modify ?r (http-version (assert (http-version (name ?name) (H TRUE)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-find-http-version-first-T
	?c <- (http-char ?name 84) ; T
	?h <- (http-version (name ?name) (H TRUE) (T nil))
	=>
	(retract ?c)
	(modify ?h (T TRUE))
	(assert (http-char ?name (http-read ?name))))

(defrule http-find-http-version-second-T
	?c <- (http-char ?name 84) ; T
	?h <- (http-version (name ?name) (T TRUE) (TT nil))
	=>
	(retract ?c)
	(modify ?h (TT TRUE))
	(assert (http-char ?name (http-read ?name))))

(defrule http-find-http-version-P
	?c <- (http-char ?name 80) ; P
	?h <- (http-version (name ?name) (TT TRUE) (P nil))
	=>
	(retract ?c)
	(modify ?h (P TRUE))
	(assert (http-char ?name (http-read ?name))))

(defrule http-find-http-version-slash
	?c <- (http-char ?name 47) ; /
	?h <- (http-version (name ?name) (P TRUE) (major nil))
	=>
	(retract ?c)
	(modify ?h (major ""))
	(assert (http-char ?name (http-read ?name))))

(defrule http-find-http-version-continue-major
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?h <- (http-version (name ?name) (major ?major&~nil) (minor nil))
	=>
	(retract ?c)
	(modify ?h (major (format nil "%s%c" ?major ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-find-http-version-period
	?c <- (http-char ?name 46) ; .
	?h <- (http-version (name ?name) (major ~nil) (minor nil))
	=>
	(retract ?c)
	(modify ?h (minor ""))
	(assert (http-char ?name (http-read ?name))))

(defrule http-find-http-version-continue-minor
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?h <- (http-version (name ?name) (minor ?minor&~nil))
	=>
	(retract ?c)
	(modify ?h (minor (format nil "%s%c" ?minor ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-request-line-http-version-end
	?c <- (http-char ?name 13) ; CR
	?h <- (http-version (name ?name) (major ?major) (minor ?minor&~nil))
	?r <- (http-request-line (http-version ?h))
	=>
	(retract ?c ?h)
	(modify ?r (http-version (make-instance of HTTP-VERSION (id ?name) (major ?major) (minor ?minor))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-request-line-end
	?c <- (http-char ?name 10) ; LF
	?r <- (http-request-line (method ?method) (request-target ?request-target) (http-version ?http-version&:(instancep ?http-version)))
	?h <- (http-message (name ?name) (start-line ?r))
	=>
	(retract ?c ?r)
	(modify ?h (start-line (make-instance of HTTP-REQUEST-LINE (id ?name) (method ?method) (request-target ?request-target) (http-version ?http-version))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-detect-field-line
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?h <- (http-message (name ?name) (start-line ?s&:(instancep ?s)) (field-lines $?field-lines&:(= 0 (length$ ?field-lines))|:(instancep (nth$ (length$ ?field-lines) ?field-lines))) (message-body nil))
	=>
	(modify ?h (field-lines ?field-lines (assert (http-field-line (name ?name) (field-name (assert (http-field-name (name ?name)))))))))

(defrule http-continue-field-name
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?f <- (http-field-name (name ?name) (value ?value))
	=>
	(retract ?c)
	(modify ?f (value (format nil "%s%c" ?value ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-field-name
	?c <- (http-char ?name 58)
	?fn <- (http-field-name (name ?name) (value ?value))
	?fl <- (http-field-line (field-name ?fn))
	=>
	(retract ?c ?fn)
	(modify ?fl (field-name (make-instance of HTTP-FIELD-NAME (id ?name) (value ?value))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-ignore-ows-after-field-name
	?c <- (http-char ?name 9|32) ; HTAB SP
	(http-field-line (name ?name) (field-name ?f&:(instancep ?f)) (field-value nil))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-detect-field-value
	(http-char ?name ~9&~32) ; HTAB SP
	?o <- (object (is-a HTTP-FIELD-NAME))
	?fl <- (http-field-line (name ?name) (field-name =(instance-name ?o)) (field-value nil))
	=>
	(modify ?fl (field-value (assert (http-field-value (name ?name))))))

(defrule http-detect-unknown-header
	(http-char ?name ?char)
	?o <- (object (is-a HTTP-FIELD-NAME) (value ?field-name&~"Accept"&~"Accept-Charset"&~"Allow"&~"Authorization"&~"Accept-Encoding"&~"Accept-Language"&~"Accept-Ranges"&~"Cache-Control"&~"Connection"&~"Content-Disposition"&~"Content-Encoding"&~"Content-Language"&~"Content-Length"&~"Content-Range"&~"Content-Type"&~"Cookie"&~"Date"&~"ETag"&~"Expect"&~"From"&~"Host"&~"If-Match"&~"If-Modified-Since"&~"If-None-Match"&~"If-Range"&~"If-Unmodified-Since"&~"Last-Modified"&~"Location"&~"Max-Forwards"&~"Pragma"&~"Proxy-Authorization"&~"Range"&~"Referer"&~"Server"&~"Set-Cookie"&~"TE"&~"Trailer"&~"Upgrade"&~"User-Agent"&~"Vary"&~"Via"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	(test (or
		(and (>= ?char 33) (<= ?char 126)) ; VCHAR
		(and (>= ?char 128) (<= ?char 255)))) ; obs-text
	=>
	(modify ?fv (value (assert (http-unknown-header (name ?name))))))

(defrule http-build-unknown-header
	?c <- (http-char ?name ?char)
	?u <- (http-unknown-header (name ?name) (value ?value) (possible-ows ?possible-ows))
	(test (or
		(and (>= ?char 33) (<= ?char 126)) ; VCHAR
		(and (>= ?char 128) (<= ?char 255)))) ; obs-text
	=>
	(retract ?c)
	(modify ?u (value (format nil "%s%s%c" ?value ?possible-ows ?char)) (possible-ows ""))
	(assert (http-char ?name (http-read ?name))))

;  set-cookie-header = "Set-Cookie:" SP set-cookie-string
;  set-cookie-string = cookie-pair *( ";" SP cookie-av )
(defrule http-detect-set-cookie-header
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Set-Cookie"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-set-cookie-header (name ?name) (cookie-pair (assert (http-cookie-pair (name ?name) (cookie-name (assert (http-token (name ?name))))))))))))

(defrule http-end-set-cookie-header
	(http-char ?name 13) ; CR
	?clh <- (http-set-cookie-header (name ?name) (cookie-pair ?cookie-pair&:(instancep ?cookie-pair)) (cookie-avs $?cookie-avs&:(= 0 (length$ ?cookie-avs))|:(instancep (nth$ (length$ ?cookie-avs) ?cookie-avs))))
	?fv <- (http-field-value (value ?clh))
	=>
	(retract ?clh)
	(modify ?fv (value (make-instance of HTTP-SET-COOKIE-HEADER (id ?name) (cookie-pair ?cookie-pair) (cookie-avs ?cookie-avs)))))

(defrule http-set-cookie-header-end-quoted-cookie-pair
	?c <- (http-char ?name 34) ; "
	?cookie-pair <- (http-cookie-pair (name ?name) (cookie-name ?cookie-name&:(stringp ?cookie-name)) (cookie-value ?cookie-value) (cookie-value-quoted TRUE))
	?set-cookie-header <- (http-set-cookie-header (cookie-pair ?cookie-pair))
	=>
	(retract ?c ?cookie-pair)
	(modify ?set-cookie-header (cookie-pair (make-instance of HTTP-COOKIE-PAIR (id ?name) (cookie-name ?cookie-name) (cookie-value ?cookie-value) (cookie-value-quoted TRUE))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-set-cookie-header-end-cookie-pair
	(http-char ?name 13|32|59) ; CR SP ;
	?cookie-pair <- (http-cookie-pair (name ?name) (cookie-name ?cookie-name&:(stringp ?cookie-name)) (cookie-value ?cookie-value) (cookie-value-quoted FALSE|nil))
	?set-cookie-header <- (http-set-cookie-header (cookie-pair ?cookie-pair))
	=>
	(retract ?cookie-pair)
	(modify ?set-cookie-header (cookie-pair (make-instance of HTTP-COOKIE-PAIR (id ?name) (cookie-name ?cookie-name) (cookie-value ?cookie-value) (cookie-value-quoted FALSE)))))

(defrule http-set-cookie-header-detect-next-cookie-pair
	?c <- (http-char ?name 59) ; ;
	?set-cookie-header <- (http-set-cookie-header (name ?name) (cookie-pair ?cookie-pair&:(instancep ?cookie-pair)) (cookie-avs $?cookie-avs&:(= 0 (length$ ?cookie-avs))|:(instancep (nth$ (length$ ?cookie-avs) ?cookie-avs))))
	=>
	(retract ?c)
	(modify ?set-cookie-header (cookie-pair ?cookie-pair) (cookie-avs ?cookie-avs (assert (http-cookie-av (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-set-cookie-header-end-cookie-av
	(http-char ?name 13|59) ; CR ;
	?c <- (http-cookie-av (value ?value&:(instancep ?value)))
	?set-cookie-header <- (http-set-cookie-header (name ?name) (cookie-avs $?cookie-avs ?c))
	=>
	(retract ?c)
	(modify ?set-cookie-header (cookie-avs ?cookie-avs (make-instance of HTTP-COOKIE-AV (id ?name) (value ?value)))))

(defrule http-cookie-av-detect-required-sp
	?c <- (http-char ?name 32) ; SP
	?ca <- (http-cookie-av (name ?name) (required-sp nil))
	=>
	(retract ?c)
	(modify ?ca (required-sp TRUE))
	(assert (http-char ?name (http-read ?name))))

(defrule http-build-cookie-av
	?c <- (http-char ?name ?char&:(<= 32 ?char)&:(>= 58 ?char)|:(<= 60 ?char)&:(>= 126 ?char)&~61) ; SP : < ~ =
	?ca <- (http-cookie-av (name ?name) (string ?string) (value nil) (required-sp TRUE))
	=>
	(retract ?c)
	(modify ?ca (string (format nil "%s%c" ?string ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-cookie-av-continue-on-equals-if-unknown-attribute
	?c <- (http-char ?name 61) ; =
	?ca <- (http-cookie-av (name ?name) (string ?string&~"Expires"&~"Max-Age"&~"Domain"&~"Path"&~"SameSite") (value nil) (required-sp TRUE))
	=>
	(retract ?c)
	(modify ?ca (string (format nil "%s%c" ?string 61)))
	(assert (http-char ?name (http-read ?name))))

;cookie-av         = expires-av / max-age-av / domain-av /
;                    path-av / secure-av / httponly-av /
;                    samesite-av / extension-av
;  expires-av        = "Expires=" sane-cookie-date
;  sane-cookie-date  = <rfc1123-date, defined in [RFC2616], Section 3.3.1>

(defrule http-cookie-av-detect-expires-av
	?c <- (http-char ?name 61) ; =
	?ca <- (http-cookie-av (name ?name) (string "Expires") (value nil) (required-sp TRUE))
	=>
	(retract ?c)
	(modify ?ca (value (assert (http-expires-av (name ?name)))))
	(assert (http-char ?name (http-read ?name))))
	
;  max-age-av        = "Max-Age=" non-zero-digit *DIGIT
;                        ; In practice, both expires-av and max-age-av
;                        ; are limited to dates representable by the
;                        ; user agent.
;  non-zero-digit    = %x31-39
;                        ; digits 1 through 9
(defrule http-cookie-av-detect-max-age-av
	?c <- (http-char ?name 61) ; =
	?ca <- (http-cookie-av (name ?name) (string "Max-Age") (value nil) (required-sp TRUE))
	=>
	(retract ?c)
	(modify ?ca (value (assert (http-max-age-av (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-max-age-av-detect-first-digit
	?c <- (http-char ?name ?char&49|50|51|52|53|54|55|56|57) ; 1-9
	?m <- (http-max-age-av (name ?name) (first-digit nil))
	=>
	(retract ?c)
	(modify ?m (first-digit (format nil "%c" ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-max-age-av-build-rest
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?m <- (http-max-age-av (name ?name) (first-digit ~nil) (rest ?rest))
	=>
	(retract ?c)
	(modify ?m (rest (format nil "%s%c" ?rest ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-cookie-av-end-max-age-av
	(http-char ?name 13|59) ; CR ;
	?m <- (http-max-age-av (name ?name) (first-digit ?first&~nil) (rest ?rest))
	?ca <- (http-cookie-av (value ?m))
	=>
	(retract ?m)
	(modify ?ca (value (make-instance of HTTP-MAX-AGE-AV (id ?name) (value (format nil "%s%s" ?first ?rest))))))
	
;  domain-av         = "Domain=" domain-value
;  domain-value      = <subdomain>
;                        ; defined in [RFC1034], Section 3.5, as
;                        ; enhanced by [RFC1123], Section 2.1
(defrule http-cookie-av-detect-domain-av
	?c <- (http-char ?name 61) ; =
	?ca <- (http-cookie-av (name ?name) (string "Domain") (value nil) (required-sp TRUE))
	=>
	(retract ?c)
	(modify ?ca (value (assert (http-domain-av (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

; derived, not actually defined formally in ABNF in an RFC
; subdomain  = *( ldh-label "." ) top-label
; ldh-label  = alphanum [ *( alphanum / "-" ) alphanum ]
; top-label  = ALPHA [ *( alphanum / "-" ) alphanum ]

(defrule http-domain-av-detect-subdomain
	(http-char ?name ?char&:(member$ ?char ?*http-alphanum*))
	?d <- (http-domain-av (name ?name) (subdomain nil))
	=>
	(modify ?d (subdomain (assert (http-subdomain (name ?name))))))

(defrule http-subdomain-detect-ldh-label
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?s <- (http-subdomain (name ?name) (ldh-labels $?ldh-labels&:(= 0 (length$ ?ldh-labels))|:(instancep (nth$ (length$ ?ldh-labels) ?ldh-labels))) (top-label nil))
	=>
	(retract ?c)
	(modify ?s (ldh-labels (assert (http-ldh-label (name ?name) (value (format nil "%c" ?char))))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-subdomain-detect-top-label
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-alpha*))
	?s <- (http-subdomain (name ?name) (ldh-labels $?ldh-labels&:(= 0 (length$ ?ldh-labels))|:(instancep (nth$ (length$ ?ldh-labels) ?ldh-labels))) (top-label nil))
	=>
	(retract ?c)
	(modify ?s (top-label (assert (http-top-label (name ?name) (value (format nil "%c" ?char))))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-subdomain-change-top-label-to-ldh-label
	(http-char ?name 46) ; .
	?t <- (http-top-label (name ?name) (value ?value))
	?s <- (http-subdomain (name ?name) (ldh-labels $?ldh-labels) (top-label ?t))
	=>
	(retract ?t)
	(modify ?s (ldh-labels ?ldh-labels (assert (http-ldh-label (name ?name) (value ?value)))) (top-label nil)))

(defrule http-build-top-label
	?c <- (http-char ?name ?char&:(member$ ?char (create$ ?*http-alphanum* 45))) ; -
	?t <- (http-top-label (name ?name) (value ?value))
	=>
	(retract ?c)
	(modify ?t (value (format nil "%s%c" ?value ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-build-ldh-label
	?c <- (http-char ?name ?char&:(member$ ?char (create$ ?*http-alphanum* 45))) ; -
	?l <- (http-ldh-label (name ?name) (value ?value))
	=>
	(retract ?c)
	(modify ?l (value (format nil "%s%c" ?value ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-subdomain-end-ldh-label
	?c <- (http-char ?name 46) ; .
	?l <- (http-ldh-label (name ?name) (value ?value&:(neq (sub-string (- (str-length ?value) 1) (str-length ?value) ?value) "-")))
	?s <- (http-subdomain (ldh-labels $?ldh-labels ?l))
	=>
	(retract ?c ?l)
	(modify ?s (ldh-labels ?ldh-labels (make-instance of HTTP-LDH-LABEL (id ?name) (value (format nil "%s." ?value)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-subdomain-end-top-label
	(http-char ?name 13|59) ; CR ;
	?t <- (http-top-label (name ?name) (value ?value&:(neq (sub-string (- (str-length ?value) 1) (str-length ?value) ?value) "-")))
	?s <- (http-subdomain (top-label ?t))
	=>
	(retract ?t)
	(modify ?s (top-label (make-instance of HTTP-TOP-LABEL (id ?name) (value ?value)))))

(defrule http-domain-av-end-subdomain
	(http-char ?name 13|59) ; CR ;
	?s <- (http-subdomain (name ?name) (top-label ?t&:(instancep ?t)) (ldh-labels $?ldh-labels&:(= 0 (length$ ?ldh-labels))|:(instancep (nth$ (length$ ?ldh-labels) ?ldh-labels))))
	?d <- (http-domain-av (name ?name) (subdomain ?s))
	=>
	(retract ?s)
	(modify ?d (subdomain (make-instance of HTTP-SUBDOMAIN (id ?name) (top-label ?t) (ldh-labels ?ldh-labels)))))

(defrule http-cookie-av-end-domain-av
	(http-char ?name 13|59) ; CR ;
	?d <- (http-domain-av (name ?name) (subdomain ?s&:(instancep ?s)))
	?ca <- (http-cookie-av (name ?name) (value ?d))
	=>
	(retract ?d)
	(modify ?ca (value (make-instance of HTTP-DOMAIN-AV (id ?name) (subdomain ?s)))))

;  path-av           = "Path=" path-value
;  path-value        = <any CHAR except CTLs or ";">
(defrule http-cookie-av-detect-path-av
	?c <- (http-char ?name 61) ; =
	?ca <- (http-cookie-av (name ?name) (string "Path") (value nil) (required-sp TRUE))
	=>
	(retract ?c)
	(modify ?ca (value (assert (http-path-av (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-build-path-av
	?c <- (http-char ?name ?char&:(<= 32 ?char)&:(>= 58 ?char)|:(<= 60 ?char)&:(>= 126 ?char)) ; = SP : < ~
	?ca <- (http-path-av (name ?name) (value ?value))
	=>
	(retract ?c)
	(modify ?ca (value (format nil "%s%c" ?value ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-cookie-av-end-path-av
	(http-char ?name 13|59) ; CR ;
	?p <- (http-path-av (name ?name) (value ?value))
	?ca <- (http-cookie-av (name ?name) (value ?p))
	=>
	(retract ?p)
	(modify ?ca (value (make-instance of HTTP-PATH-AV (id ?name) (value ?value)))))

;  secure-av         = "Secure"
(defrule http-cookie-av-detect-secure-av
	(http-char ?name 13|59) ; CR ;
	?ca <- (http-cookie-av (name ?name) (string "Secure") (value nil) (required-sp TRUE))
	=>
	(modify ?ca (value (make-instance of HTTP-SECURE-AV (id ?name)))))

;  httponly-av       = "HttpOnly"
(defrule http-cookie-av-detect-httponly-av
	(http-char ?name 13|59) ; CR ;
	?ca <- (http-cookie-av (name ?name) (string "HttpOnly") (value nil) (required-sp TRUE))
	=>
	(modify ?ca (value (make-instance of HTTP-HTTPONLY-AV (id ?name)))))

;samesite-av       = "SameSite" BWS "=" BWS samesite-value
;samesite-value    = "Strict" / "Lax" / "None"
(defrule http-cookie-av-detect-samesite-av
	?c <- (http-char ?name 61) ; =
	?ca <- (http-cookie-av (name ?name) (string "SameSite") (value nil) (required-sp TRUE))
	=>
	(retract ?c)
	(modify ?ca (value (assert (http-samesite-av (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-samesite-av-detect-strict
	?c <- (http-char ?name 83) ; S
	?s <- (http-samesite-av (name ?name) (value nil))
	=>
	(retract ?c)
	(modify ?s (value (assert (http-strict (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-strict-detect-t
	?c <- (http-char ?name 116) ; t
	?l <- (http-strict (name ?name) (t nil))
	=>
	(retract ?c)
	(modify ?l (t TRUE))
	(assert (http-char ?name (http-read ?name))))

(defrule http-strict-detect-r
	?c <- (http-char ?name 114) ; r
	?l <- (http-strict (name ?name) (t TRUE) (r nil))
	=>
	(retract ?c)
	(modify ?l (r TRUE))
	(assert (http-char ?name (http-read ?name))))

(defrule http-strict-detect-i
	?c <- (http-char ?name 105) ; i
	?l <- (http-strict (name ?name) (t TRUE) (r TRUE) (i nil))
	=>
	(retract ?c)
	(modify ?l (i TRUE))
	(assert (http-char ?name (http-read ?name))))

(defrule http-strict-detect-c
	?c <- (http-char ?name 99) ; c
	?l <- (http-strict (name ?name) (t TRUE) (r TRUE) (i TRUE) (c nil))
	=>
	(retract ?c)
	(modify ?l (c TRUE))
	(assert (http-char ?name (http-read ?name))))

(defrule http-strict-detect-last-t
	?c <- (http-char ?name 116) ; t
	?l <- (http-strict (name ?name) (t TRUE) (r TRUE) (i TRUE) (c TRUE) (last-t nil))
	=>
	(retract ?c)
	(modify ?l (last-t TRUE))
	(assert (http-char ?name (http-read ?name))))

(defrule http-samesite-av-end-strict
	(http-char ?name 13|59) ; CR ;
	?st <- (http-strict (name ?name) (t TRUE) (r TRUE) (i TRUE) (c TRUE) (last-t TRUE))
	?s <- (http-samesite-av (name ?name) (value ?st))
	=>
	(retract ?st)
	(modify ?s (value (make-instance of HTTP-STRICT (id ?name)))))

(defrule http-samesite-av-detect-lax
	?c <- (http-char ?name 76) ; L
	?s <- (http-samesite-av (name ?name) (value nil))
	=>
	(retract ?c)
	(modify ?s (value (assert (http-lax (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-lax-detect-a
	?c <- (http-char ?name 97) ; a
	?l <- (http-lax (name ?name) (a nil))
	=>
	(retract ?c)
	(modify ?l (a TRUE))
	(assert (http-char ?name (http-read ?name))))

(defrule http-lax-detect-x
	?c <- (http-char ?name 120) ; x
	?l <- (http-lax (name ?name) (a TRUE) (x nil))
	=>
	(retract ?c)
	(modify ?l (x TRUE))
	(assert (http-char ?name (http-read ?name))))

(defrule http-samesite-av-end-lax
	(http-char ?name 13|59) ; CR ;
	?l <- (http-lax (name ?name) (a TRUE) (x TRUE))
	?s <- (http-samesite-av (name ?name) (value ?l))
	=>
	(retract ?l)
	(modify ?s (value (make-instance of HTTP-LAX (id ?name)))))

(defrule http-samesite-av-detect-none
	?c <- (http-char ?name 78) ; N
	?s <- (http-samesite-av (name ?name) (value nil))
	=>
	(retract ?c)
	(modify ?s (value (assert (http-none (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-none-detect-o
	?c <- (http-char ?name 111) ; o
	?l <- (http-none (name ?name) (o nil))
	=>
	(retract ?c)
	(modify ?l (o TRUE))
	(assert (http-char ?name (http-read ?name))))

(defrule http-none-detect-n
	?c <- (http-char ?name 110) ; n
	?l <- (http-none (name ?name) (o TRUE) (n nil))
	=>
	(retract ?c)
	(modify ?l (n TRUE))
	(assert (http-char ?name (http-read ?name))))

(defrule http-none-detect-e
	?c <- (http-char ?name 101) ; e
	?l <- (http-none (name ?name) (o TRUE) (n TRUE) (e nil))
	=>
	(retract ?c)
	(modify ?l (e TRUE))
	(assert (http-char ?name (http-read ?name))))

(defrule http-samesite-av-end-none
	(http-char ?name 13|59) ; CR ;
	?n <- (http-none (name ?name) (o TRUE) (n TRUE) (e TRUE))
	?s <- (http-samesite-av (name ?name) (value ?n))
	=>
	(retract ?n)
	(modify ?s (value (make-instance of HTTP-NONE (id ?name)))))

(defrule http-cookie-av-end-samesite-av
	(http-char ?name 13|59) ; CR ;
	?s <- (http-samesite-av (name ?name) (value ?v&:(instancep ?v)))
	?ca <- (http-cookie-av (name ?name) (value ?s) (required-sp TRUE))
	=>
	(retract ?s)
	(modify ?ca (value (make-instance of HTTP-SAMESITE-AV (id ?name) (value ?v)))))

;extension-av      = *av-octet
;av-octet          = %x20-3A / %x3C-7E
                      ; any CHAR except CTLs or ";"
(defrule http-cookie-av-end-extension-av
	(http-char ?name 13|59) ; CR ;
	?ca <- (http-cookie-av (name ?name) (string ?string&~"Expires"&~"Max-Age"&~"Domain"&~"Path"&~"SameSite"&~"Secure"&~"HttpOnly") (value nil) (required-sp TRUE))
	=>
	(retract ?ca)
	(modify ?ca (value (make-instance of HTTP-EXTENSION-AV (id ?name) (value ?string)))))

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
(defrule http-expires-av-build-value
	(http-char ?name 70|77|83|84|87) ; F M S T W
	?e <- (http-expires-av (name ?name) (rfc1123-date nil))
	=>
	(modify ?e (rfc1123-date (assert (http-rfc1123-date (name ?name))))))

(defrule http-rfc1123-date-detect-wkday
	(http-char ?name 70|77|83|84|87) ; F M S T W
	?r <- (http-rfc1123-date (name ?name) (wkday nil))
	=>
	(modify ?r (wkday (assert (http-wkday (name ?name))))))

(defrule http-build-wkday
	?c <- (http-char ?name ?char&70|77|83|84|87|114|105|111|110|97|116|117|101|104|100) ; F M S T W r i o n a t u e h d
	?w <- (http-wkday (name ?name) (value ?value&:(> 3 (str-length ?value))))
	=>
	(retract ?c)
	(modify ?w (value (format nil "%s%c" ?value ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-wkday
	?c <- (http-char ?name 44) ; ,
	?w <- (http-wkday (value ?value&"Fri"|"Mon"|"Sat"|"Sun"|"Tue"|"Thu"|"Wed"))
	?r <- (http-rfc1123-date (name ?name) (wkday ?w))
	=>
	(retract ?c ?w)
	(modify ?r (wkday (make-instance of HTTP-WKDAY (id ?name) (value ?value))))
	(assert (http-char ?name (http-read ?name))))

;  date1        = 2DIGIT SP month SP 4DIGIT
;       month        = "Jan" | "Feb" | "Mar" | "Apr"
;                    | "May" | "Jun" | "Jul" | "Aug"
;                    | "Sep" | "Oct" | "Nov" | "Dec"
(defrule http-rfc1123-date-start-date1
	?c <- (http-char ?name 32) ; SP
	?r <- (http-rfc1123-date (name ?name) (wkday ?w&:(instancep ?w)) (date1 nil))
	=>
	(retract ?c)
	(modify ?r (date1 (assert (http-date1 (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-date1-build-first-2digit
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?d <- (http-date1 (name ?name) (first-2digit ?first&:(> 2 (str-length ?first))))
	=>
	(retract ?c)
	(modify ?d (first-2digit (format nil "%s%c" ?first ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-date1-detect-end-first-2digit-start-month
	?c <- (http-char ?name 32) ; SP
	?d <- (http-date1 (name ?name) (first-2digit ?first&:(= 2 (str-length ?first))) (month nil))
	=>
	(retract ?c)
	(modify ?d (month (assert (http-month (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-build-month
	?c <- (http-char ?name ?char&74|97|110|70|101|98|77|114|65|112|121|117|108|103|83|79|99|116|78|111|118|68) ; J a n F e b M r A p y u l g S O c t N o v D
	?m <- (http-month (name ?name) (value ?value&:(> 3 (str-length ?value))))
	=>
	(retract ?c)
	(modify ?m (value (format nil "%s%c" ?value ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-date1-end-month
	?c <- (http-char ?name 32) ; SP
	?m <- (http-month (value ?value&"Jan"|"Feb"|"Mar"|"Apr"|"May"|"Jun"|"Jul"|"Aug"|"Sep"|"Oct"|"Nov"|"Dec"))
	?d <- (http-date1 (name ?name) (month ?m))
	=>
	(retract ?c ?m)
	(modify ?d (month (make-instance of HTTP-MONTH (id ?name) (value ?value))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-date1-build-last-4digit
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?d <- (http-date1 (name ?name) (month ?m&:(instancep ?m)) (last-4digit ?last&:(> 4 (str-length ?last))))
	=>
	(retract ?c)
	(modify ?d (last-4digit (format nil "%s%c" ?last ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-rfc1123-end-date1
	(http-char ?name 32) ; SP
	?d <- (http-date1 (first-2digit ?first) (month ?month) (last-4digit ?last&:(= 4 (str-length ?last))))
	?r <- (http-rfc1123-date (name ?name) (wkday ?w&:(instancep ?w)) (date1 ?d))
	=>
	(retract ?d)
	(modify ?r (date1 (make-instance of HTTP-DATE1 (id ?name) (first-2digit ?first) (month ?month) (last-4digit ?last)))))

;       time         = 2DIGIT ":" 2DIGIT ":" 2DIGIT
;                      ; 00:00:00 - 23:59:59
(defrule http-rfc1123-date-start-time
	?c <- (http-char ?name 32) ; SP
	?r <- (http-rfc1123-date (name ?name) (date1 ?d&:(instancep ?d)) (time nil))
	=>
	(retract ?c)
	(modify ?r (time (assert (http-time (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-time-build-first-2digit
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?t <- (http-time (name ?name) (first-2digit ?first&:(> 2 (str-length ?first))))
	=>
	(retract ?c)
	(modify ?t (first-2digit (format nil "%s%c" ?first ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-time-detect-first-colon
	?c <- (http-char ?name 58) ; :
	?t <- (http-time (name ?name) (first-2digit ?first&:(= 2 (str-length ?first))) (first-colon nil))
	=>
	(retract ?c)
	(modify ?t (first-colon TRUE))
	(assert (http-char ?name (http-read ?name))))

(defrule http-time-build-second-2digit
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?t <- (http-time (name ?name) (first-colon TRUE) (second-2digit ?second&:(> 2 (str-length ?second))))
	=>
	(retract ?c)
	(modify ?t (second-2digit (format nil "%s%c" ?second ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-time-detect-second-colon
	?c <- (http-char ?name 58) ; :
	?t <- (http-time (name ?name) (second-2digit ?second&:(= 2 (str-length ?second))) (second-colon nil))
	=>
	(retract ?c)
	(modify ?t (second-colon TRUE))
	(assert (http-char ?name (http-read ?name))))

(defrule http-time-build-third-2digit
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?t <- (http-time (name ?name) (second-colon TRUE) (third-2digit ?third&:(> 2 (str-length ?third))))
	=>
	(retract ?c)
	(modify ?t (third-2digit (format nil "%s%c" ?third ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-rfc1123-date-end-time
	?c <- (http-char ?name 32) ; SP
	?t <- (http-time (name ?name) (first-2digit ?first) (second-2digit ?second) (third-2digit ?third&:(= 2 (str-length ?third))))
	?r <- (http-rfc1123-date (name ?name) (time ?t))
	=>
	(retract ?c ?t)
	(modify ?r (time (make-instance of HTTP-TIME (id ?name) (first-2digit ?first) (second-2digit ?second) (third-2digit ?third))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-rfc1123-expect-GMT
	?c <- (http-char ?name ?char&71|77|84) ; G M T
	?r <- (http-rfc1123-date (name ?name) (time ?t&:(instancep ?t)) (GMT ?GMT&:(> 3 (str-length ?GMT))))
	=>
	(retract ?c)
	(modify ?r (GMT (format nil "%s%c" ?GMT ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-expires-av-end-rfc1123
	(http-char ?name 13|59) ; CR ;
	?r <- (http-rfc1123-date (name ?name) (wkday ?wkday) (date1 ?date1) (time ?time) (GMT "GMT"))
	?e <- (http-expires-av (name ?name) (rfc1123-date ?r))
	=>
	(retract ?r)
	(modify ?e (rfc1123-date (make-instance of HTTP-RFC1123-DATE (id ?name) (wkday ?wkday) (date1 ?date1) (time ?time)))))

(defrule http-cookie-av-end-expires-av
	(http-char ?name 13|59) ; CR ;
	?e <- (http-expires-av (name ?name) (rfc1123-date ?r&:(instancep ?r)))
	?ca <- (http-cookie-av (name ?name) (value ?e) (required-sp TRUE))
	=>
	(retract ?e)
	(modify ?ca (value (make-instance of HTTP-EXPIRES-AV (id ?name) (rfc1123-date ?r)))))

;   cookie-header     = "Cookie:" OWS cookie-string OWS
;   cookie-string     = cookie-pair *( ";" SP cookie-pair )
;   cookie-pair       = cookie-name "=" cookie-value
;   cookie-name       = token
;   cookie-value      = *cookie-octet / ( DQUOTE *cookie-octet DQUOTE )
;   cookie-octet      = %x21 / %x23-2B / %x2D-3A / %x3C-5B / %x5D-7E
;                         ; US-ASCII characters excluding CTLs,
;                         ; whitespace DQUOTE, comma, semicolon,
;                         ; and backslash
(defrule http-detect-cookie-header
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Cookie"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-cookie-header (name ?name) (cookie-pairs (assert (http-cookie-pair (name ?name)))))))))

(defrule http-cookie-pair-detect-cookie-name
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?c <- (http-cookie-pair (name ?name) (cookie-name nil))
	=>
	(modify ?c (cookie-name (assert (http-token (name ?name))))))

(defrule http-cookie-pair-end-cookie-name
	?c <- (http-char ?name 61) ; =
	?t <- (http-token (value ?value))
	?cookie-pair <- (http-cookie-pair (name ?name) (cookie-name ?t))
	=>
	(retract ?c ?t)
	(modify ?cookie-pair (cookie-name ?value))
	(assert (http-char ?name (http-read ?name))))

(defrule http-cookie-pair-detect-cookie-value
	(http-char ?name ?char&:(member$ ?char ?*http-cookie-octet*))
	?cookie-pair <- (http-cookie-pair (name ?name) (cookie-name ?cookie-name&:(stringp ?cookie-name)) (cookie-value "") (cookie-value-quoted nil))
	=>
	(modify ?cookie-pair (cookie-value-quoted FALSE)))

(defrule http-cookie-pair-detect-quoted-cookie-value
	?c <- (http-char ?name 34) ; "
	?cookie-pair <- (http-cookie-pair (name ?name) (cookie-name ?cookie-name&:(stringp ?cookie-name)) (cookie-value "") (cookie-value-quoted nil))
	=>
	(retract ?c)
	(modify ?cookie-pair (cookie-value-quoted TRUE))
	(assert (http-char ?name (http-read ?name))))

(defrule http-cookie-pair-build-cookie-value
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-cookie-octet*))
	?cookie-pair <- (http-cookie-pair (name ?name) (cookie-name ?cookie-name&:(stringp ?cookie-name)) (cookie-value ?value) (cookie-value-quoted TRUE|FALSE))
	=>
	(retract ?c)
	(modify ?cookie-pair (cookie-value (format nil "%s%c" ?value ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-cookie-header-end-quoted-cookie-pair
	?c <- (http-char ?name 34) ; "
	?cookie-pair <- (http-cookie-pair (name ?name) (cookie-name ?cookie-name&:(stringp ?cookie-name)) (cookie-value ?cookie-value) (cookie-value-quoted TRUE))
	?cookie-header <- (http-cookie-header (cookie-pairs $?cookie-pairs ?cookie-pair))
	=>
	(retract ?c ?cookie-pair)
	(modify ?cookie-header (cookie-pairs ?cookie-pairs (make-instance of HTTP-COOKIE-PAIR (id ?name) (cookie-name ?cookie-name) (cookie-value ?cookie-value) (cookie-value-quoted TRUE))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-cookie-header-end-cookie-pair
	(http-char ?name 13|32|59) ; CR SP ;
	?cookie-pair <- (http-cookie-pair (name ?name) (cookie-name ?cookie-name&:(stringp ?cookie-name)) (cookie-value ?cookie-value) (cookie-value-quoted FALSE|nil))
	?cookie-header <- (http-cookie-header (cookie-pairs $?cookie-pairs ?cookie-pair))
	=>
	(retract ?cookie-pair)
	(modify ?cookie-header (cookie-pairs ?cookie-pairs (make-instance of HTTP-COOKIE-PAIR (id ?name) (cookie-name ?cookie-name) (cookie-value ?cookie-value) (cookie-value-quoted FALSE)))))

(defrule http-cookie-header-skip-ows-after-end-cookie-pair
	?c <- (http-char ?name 32) ; SP
	?cookie-header <- (http-cookie-header (name ?name) (cookie-pairs $?cookie-pairs ?cookie-pair&:(instancep ?cookie-pair)))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-cookie-header-detect-next-cookie-pair
	?c <- (http-char ?name 59) ; ;
	?cookie-header <- (http-cookie-header (name ?name) (cookie-pairs $?cookie-pairs ?cookie-pair&:(instancep ?cookie-pair)))
	=>
	(retract ?c)
	(modify ?cookie-header (cookie-pairs ?cookie-pairs ?cookie-pair (assert (http-cookie-pair (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-cookie-header-skip-ows-before-next-cookie-pair
	?c <- (http-char ?name 32) ; SP
	?cookie-pair <- (http-cookie-pair (name ?name) (cookie-name nil))
	?cookie-header <- (http-cookie-header (cookie-pairs $?cookie-pairs ?cookie-pair))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-cookie-header
	(http-char ?name 13) ; CR
	?clh <- (http-cookie-header (name ?name) (cookie-pairs $?cookie-pairs ?cookie-pair&:(instancep ?cookie-pair)))
	?fv <- (http-field-value (value ?clh))
	=>
	(retract ?clh)
	(modify ?fv (value (make-instance of HTTP-COOKIE-HEADER (id ?name) (cookie-pairs ?cookie-pairs ?cookie-pair)))))

; Allow = #method
(defrule http-detect-allow-header
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Allow"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-allow-header (name ?name) (methods (assert (http-method (name ?name)))))))))

(defrule http-allow-header-detect-next-method
	?c <- (http-char ?name 44) ; ,
	?a <- (http-allow-header (name ?name) (methods $?methods ?method&:(instancep ?method)))
	=>
	(retract ?c)
	(modify ?a (methods ?methods ?method (assert (http-method (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-allow-header-skip-ows-before-method
	?c <- (http-char ?name 9|13|32) ; HTAB CR SP
	?method <- (http-method (name ?name) (value ""))
	(http-allow-header (name ?name) (methods $?methods ?method))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-allow-header-end-method
	(http-char ?name 9|13|32|44) ; HTAB CR SP ,
	?method <- (http-method (name ?name) (value ?value&~""))
	?a <- (http-allow-header (name ?name) (methods $?methods ?method))
	=>
	(retract ?method)
	(modify ?a (methods ?methods (make-instance of HTTP-METHOD (id ?name) (value ?value)))))

(defrule http-allow-header-skip-ows-after-method
	?c <- (http-char ?name 9|32) ; HTAB CR SP
	(http-allow-header (name ?name) (methods $?methods ?method&:(instancep ?method)))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-allow-header
	(http-char ?name 13) ; CR
	?clh <- (http-allow-header (name ?name) (methods $?methods&:(instancep (nth$ (length$ ?methods) ?methods))))
	?fv <- (http-field-value (value ?clh))
	=>
	(retract ?clh)
	(modify ?fv (value (make-instance of HTTP-ALLOW-HEADER (id ?name) (methods ?methods)))))

; Connection = #connection-option ; connection-option = token
; Accept-Ranges = 1#range-unit ; range-unit = token
; Vary = #( "*" / field-name ) ; field-name = token
; Trailer = #field-name
; Content-Encoding = #content-coding ; content-coding = token
(defrule http-detect-token-list-header
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Connection"|"Accept-Ranges"|"Vary"|"Trailer"|"Content-Encoding"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-token-list-header (name ?name) (tokens (assert (http-token (name ?name)))))))))

(defrule http-token-list-header-end-token
	(http-char ?name 9|13|32|44) ; HTAB CR SP ,
	?t <- (http-token (name ?name) (value ?value&~""))
	?h <- (http-token-list-header (name ?name) (tokens $?tokens ?t))
	=>
	(retract ?t)
	(modify ?h (tokens ?tokens ?value)))

(defrule http-token-list-header-detect-next-token
	?c <- (http-char ?name 44) ; ,
	?h <- (http-token-list-header (name ?name) (tokens $?tokens ?token&:(stringp ?token)))
	=>
	(retract ?c)
	(modify ?h (tokens ?tokens ?token (assert (http-token (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-token-list-header-skip-ows-before-token
	?c <- (http-char ?name 9|32) ; HTAB SP
	?t <- (http-token (name ?name) (value ""))
	(http-token-list-header (name ?name) (tokens $?tokens ?t))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-token-list-header-skip-ows-after-token
	?c <- (http-char ?name 9|32) ; HTAB SP
	(http-token-list-header (name ?name) (tokens $?tokens ?token&:(stringp ?token)))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-connection-header
	(http-char ?name 13) ; CR
	?h <- (http-token-list-header (name ?name) (tokens $?tokens&:(stringp (nth$ (length$ ?tokens) ?tokens))))
	?fv <- (http-field-value (value ?h))
	(http-field-line (field-name ?fn) (field-value ?fv))
	(object (is-a HTTP-FIELD-NAME) (name ?fn) (value "Connection"))
	=>
	(retract ?h)
	(modify ?fv (value (make-instance of HTTP-CONNECTION-HEADER (id ?name) (tokens ?tokens)))))

(defrule http-end-accept-ranges-header
	(http-char ?name 13) ; CR
	?h <- (http-token-list-header (name ?name) (tokens $?tokens&:(stringp (nth$ (length$ ?tokens) ?tokens))))
	?fv <- (http-field-value (value ?h))
	(http-field-line (field-name ?fn) (field-value ?fv))
	(object (is-a HTTP-FIELD-NAME) (name ?fn) (value "Accept-Ranges"))
	=>
	(retract ?h)
	(modify ?fv (value (make-instance of HTTP-ACCEPT-RANGES-HEADER (id ?name) (tokens ?tokens)))))

(defrule http-end-vary-header
	(http-char ?name 13) ; CR
	?h <- (http-token-list-header (name ?name) (tokens $?tokens&:(stringp (nth$ (length$ ?tokens) ?tokens))))
	?fv <- (http-field-value (value ?h))
	(http-field-line (field-name ?fn) (field-value ?fv))
	(object (is-a HTTP-FIELD-NAME) (name ?fn) (value "Vary"))
	=>
	(retract ?h)
	(modify ?fv (value (make-instance of HTTP-VARY-HEADER (id ?name) (tokens ?tokens)))))

(defrule http-end-trailer-header
	(http-char ?name 13) ; CR
	?h <- (http-token-list-header (name ?name) (tokens $?tokens&:(stringp (nth$ (length$ ?tokens) ?tokens))))
	?fv <- (http-field-value (value ?h))
	(http-field-line (field-name ?fn) (field-value ?fv))
	(object (is-a HTTP-FIELD-NAME) (name ?fn) (value "Trailer"))
	=>
	(retract ?h)
	(modify ?fv (value (make-instance of HTTP-TRAILER-HEADER (id ?name) (tokens ?tokens)))))

(defrule http-end-content-encoding-header
	(http-char ?name 13) ; CR
	?h <- (http-token-list-header (name ?name) (tokens $?tokens&:(stringp (nth$ (length$ ?tokens) ?tokens))))
	?fv <- (http-field-value (value ?h))
	(http-field-line (field-name ?fn) (field-value ?fv))
	(object (is-a HTTP-FIELD-NAME) (name ?fn) (value "Content-Encoding"))
	=>
	(retract ?h)
	(modify ?fv (value (make-instance of HTTP-CONTENT-ENCODING-HEADER (id ?name) (tokens ?tokens)))))

;   Accept = #( media-range [ weight ] )
;   media-range    = ( "*/*"
;                     / ( type "/" "*" )
;                     / ( type "/" subtype )
;                   ) parameters
(defrule http-detect-accept-header
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Accept"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-accept-header (name ?name) (media-ranges (assert (http-media-range (name ?name)))))))))

(defrule http-media-range-detect-type
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?m <- (http-media-range (name ?name) (type nil))
	=>
	(modify ?m (type (assert (http-type (name ?name))))))

(defrule http-media-range-end-type
	?c <- (http-char ?name 47) ; /
	?t <- (http-type (name ?name) (value ?value))
	?m <- (http-media-range (type ?t))
	=>
	(retract ?c ?t)
	(modify ?m (type (make-instance of HTTP-TYPE (id ?name) (value ?value))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-media-range-detect-subtype
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?m <- (http-media-range (name ?name) (type ?t&:(instancep ?t)) (subtype nil))
	=>
	(modify ?m (subtype (assert (http-subtype (name ?name))))))

(defrule http-media-range-end-subtype
	(http-char ?name 13|32|44|59) ; CR SP , ;
	?s <- (http-subtype (name ?name) (value ?value))
	?m <- (http-media-range (subtype ?s))
	=>
	(retract ?s)
	(modify ?m (subtype (make-instance of HTTP-SUBTYPE (id ?name) (value ?value)))))

(defrule http-media-range-detect-parameter
	?c <- (http-char ?name 59) ; ;
	?cth <- (http-media-range (name ?name) (subtype ?s&:(instancep ?s)) (parameters $?parameters&:(= 0 (length$ ?parameters))|:(instancep (nth$ (length$ ?parameters) ?parameters))) (weight nil))
	=>
	(retract ?c)
	(modify ?cth (parameters ?parameters (assert (http-parameter (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-media-range-detect-ows
	?c <- (http-char ?name 32) ; SP
	(http-media-range (name ?name) (type ?t) (subtype ?s) (parameters $?parameters&:(= 0 (length$ ?parameters))|:(instancep (nth$ (length$ ?parameters) ?parameters))) (weight ?w&nil|:(instancep ?w)))
	(test (or
		(and (eq ?t nil) (eq ?s nil))
		(and (instancep ?t) (instancep ?s))))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-media-range-end-parameter
	(http-char ?name 9|13|32|44|59) ; HTAB CR SP , ;
	?p <- (http-parameter (parameter-name ?t&:(stringp ?t)) (ext-token ?ext-token) (parameter-value ?parameter-value&:(instancep ?parameter-value)|:(stringp ?parameter-value)))
	?m <- (http-media-range (name ?name) (subtype ?s&:(instancep ?s)) (parameters $?parameters ?p))
	=>
	(retract ?p)
	(modify ?m (parameters ?parameters (make-instance of HTTP-PARAMETER (id ?name) (parameter-name ?t) (ext-token ?ext-token) (parameter-value ?parameter-value)))))

(defrule http-media-range-end-weight
	(http-char ?name 9|13|32|44) ; HTAB CR SP ,
	?w <- (http-weight (name ?name) (qvalue ?q&:(instancep ?q)))
	?m <- (http-media-range (name ?name) (weight ?w))
	=>
	(retract ?w)
	(modify ?m (weight (make-instance of HTTP-WEIGHT (id ?name) (qvalue ?q)))))

(defrule http-accept-header-end-media-range
	(http-char ?name 13|44) ; CR ,
	?m <- (http-media-range (name ?name) (type ?type) (subtype ?subtype&:(instancep ?subtype)) (parameters $?parameters&:(= 0 (length$ ?parameters))|:(instancep (nth$ (length$ ?parameters) ?parameters))) (weight ?weight&nil|:(instancep ?weight)))
	?a <- (http-accept-header (name ?name) (media-ranges $?media-ranges ?m))
	=>
	(retract ?m)
	(modify ?a (media-ranges ?media-ranges (make-instance of HTTP-MEDIA-RANGE (id ?name) (type ?type) (subtype ?subtype) (parameters ?parameters) (weight ?weight)))))

(defrule http-accept-header-start-next-media-range
	?c <- (http-char ?name 44) ; ,
	?a <- (http-accept-header (name ?name) (media-ranges $?media-ranges&:(instancep (nth$ (length$ ?media-ranges) ?media-ranges))))
	=>
	(retract ?c)
	(modify ?a (media-ranges ?media-ranges (assert (http-media-range (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-accept-header
	(http-char ?name 13) ; CR
	?clh <- (http-accept-header (name ?name) (media-ranges $?media-ranges&:(instancep (nth$ (length$ ?media-ranges) ?media-ranges))))
	?fv <- (http-field-value (value ?clh))
	=>
	(retract ?clh)
	(modify ?fv (value (make-instance of HTTP-ACCEPT-HEADER (id ?name) (media-ranges ?media-ranges)))))

;   Accept-Encoding  = #( codings [ weight ] )
;   codings          = content-coding / "identity" / "*"
;   content-coding = token
;   weight = OWS ";" OWS "q=" qvalue
(defrule http-detect-accept-encoding-header
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Accept-Encoding"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-accept-encoding-header (name ?name) (codings (assert (http-coding (name ?name) (codings (assert (http-token (name ?name))))))))))))

(defrule http-accept-encoding-header-start-next-coding
	?c <- (http-char ?name 44) ; ,
	?a <- (http-accept-encoding-header (name ?name) (codings $?codings&:(instancep (nth$ (length$ ?codings) ?codings))))
	=>
	(retract ?c)
	(modify ?a (codings ?codings (assert (http-coding (name ?name) (codings (assert (http-token (name ?name))))))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-coding-end-codings
	(http-char ?name 9|13|32|44|59) ; HTAB CR SP , ;
	?t <- (http-token (value ?value&~""))
	?c <- (http-coding (name ?name) (codings ?t))
	=>
	(retract ?t)
	(modify ?c (codings ?value)))

(defrule http-coding-skip-ows-before-codings
	?c <- (http-char ?name 9|32) ; HTAB SP
	?t <- (http-token (value ""))
	(http-coding (name ?name) (codings ?t))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-coding-skip-ows-before-weight
	?c <- (http-char ?name 9|32) ; HTAB SP
	(http-coding (name ?name) (codings ?content-coding&:(stringp ?content-coding)) (weight nil))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-coding-detect-weight
	?ch <- (http-char ?name 59) ; ;
	?co <- (http-coding (name ?name) (codings ?content-coding&:(stringp ?content-coding)) (weight nil))
	=>
	(retract ?ch)
	(modify ?co (weight (assert (http-weight (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-weight-ignore-ows-before-q
	?c <- (http-char ?name 9|32) ; HTAB SP
	(http-weight (name ?name) (q nil))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-weight-detect-q
	?c <- (http-char ?name 113) ; q
	?w <- (http-weight (name ?name) (q nil))
	=>
	(retract ?c)
	(modify ?w (q TRUE))
	(assert (http-char ?name (http-read ?name))))
	
(defrule http-weight-detect-equals
	?c <- (http-char ?name 61) ; =
	?w <- (http-weight (name ?name) (q TRUE) (equals nil))
	=>
	(retract ?c)
	(modify ?w (equals TRUE))
	(assert (http-char ?name (http-read ?name))))

(defrule http-weight-detect-qvalue
	(http-char ?name ?char&48|49) ; 0 1
	?w <- (http-weight (name ?name) (equals TRUE) (qvalue nil))
	=>
	(modify ?w (qvalue (assert (http-qvalue (name ?name))))))

(defrule http-qvalue-detect-first-digit
	?c <- (http-char ?name ?char&48|49) ; 0 1
	?q <- (http-qvalue (name ?name) (first nil))
	=>
	(retract ?c)
	(modify ?q (first (format nil "%c" ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-qvalue-detect-decimal
	?c <- (http-char ?name 46) ; .
	?q <- (http-qvalue (name ?name) (first "0"|"1") (decimal nil))
	=>
	(retract ?c)
	(modify ?q (decimal TRUE))
	(assert (http-char ?name (http-read ?name))))

(defrule http-qvalue-detect-digit-after-0
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?q <- (http-qvalue (name ?name) (first "0") (decimal TRUE) (fraction ?fraction&:(> 3 (str-length ?fraction))))
	=>
	(retract ?c)
	(modify ?q (fraction (format nil "%s%c" ?fraction ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-qvalue-detect-0-after-1
	?c <- (http-char ?name 48) ; 0
	?q <- (http-qvalue (name ?name) (first "0"|"1") (decimal TRUE) (fraction ?fraction&:(> 3 (str-length ?fraction))))
	=>
	(retract ?c)
	(modify ?q (fraction (format nil "%s%c" ?fraction 48)))
	(assert (http-char ?name (http-read ?name))))

; qvalue = ( "0" [ "." *3DIGIT ] ) / ( "1" [ "." *3"0" ] )

(defrule http-weight-end-qvalue
	(http-char ?name 9|13|32|44) ; HTAB CR SP ,
	?q <- (http-qvalue (first ?first) (decimal ?decimal) (fraction ?fraction))
	?w <- (http-weight (name ?name) (qvalue ?q))
	=>
	(retract ?q)
	(modify ?w (qvalue (make-instance of HTTP-QVALUE (id ?name) (first ?first) (decimal ?decimal) (fraction ?fraction)))))

(defrule http-coding-end-weight
	(http-char ?name 9|13|32|44) ; HTAB CR SP ,
	?w <- (http-weight (name ?name) (qvalue ?q&:(instancep ?q)))
	?c <- (http-coding (name ?name) (weight ?w))
	=>
	(retract ?w)
	(modify ?c (weight (make-instance of HTTP-WEIGHT (id ?name) (qvalue ?q)))))

(defrule http-accept-encoding-header-end-coding
	(http-char ?name ?char&9|13|32|44) ; HTAB CR SP ,
	?c <- (http-coding (codings ?value&:(stringp ?value)) (weight ?w&nil|:(instancep ?w)))
	?a <- (http-accept-encoding-header (name ?name) (codings $?codings ?c))
	;; OWS before a weight is skipped, since ";" might follow it; it ends the coding only after the weight
	(test (or (eq ?char 13) (eq ?char 44) (instancep ?w)))
	=>
	(retract ?c)
	(modify ?a (codings ?codings (make-instance of HTTP-CODING (id ?name) (codings ?value) (weight ?w)))))

(defrule http-end-accept-encoding-header
	(http-char ?name 9|13|32) ; HTAB CR SP
	?clh <- (http-accept-encoding-header (name ?name) (codings $?codings&:(instancep (nth$ (length$ ?codings) ?codings))))
	?fv <- (http-field-value (value ?clh))
	=>
	(retract ?clh)
	(modify ?fv (value (make-instance of HTTP-ACCEPT-ENCODING-HEADER (id ?name) (codings ?codings)))))

;   Accept-Charset = #( ( token / "*" ) [ weight ] )
;   weight = OWS ";" OWS "q=" qvalue
(defrule http-detect-accept-charset-header
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Accept-Charset"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-accept-charset-header (name ?name) (charsets (assert (http-charset (name ?name) (charset (assert (http-token (name ?name))))))))))))

(defrule http-accept-charset-header-start-next-charset
	?c <- (http-char ?name 44) ; ,
	?a <- (http-accept-charset-header (name ?name) (charsets $?charsets&:(instancep (nth$ (length$ ?charsets) ?charsets))))
	=>
	(retract ?c)
	(modify ?a (charsets ?charsets (assert (http-charset (name ?name) (charset (assert (http-token (name ?name))))))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-charset-skip-ows-before-charset
	?c <- (http-char ?name 9|32) ; HTAB SP
	?t <- (http-token (value ""))
	(http-charset (name ?name) (charset ?t))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-charset-end-charset
	(http-char ?name 9|13|32|44|59) ; HTAB CR SP , ;
	?t <- (http-token (value ?value&~""))
	?c <- (http-charset (name ?name) (charset ?t))
	=>
	(retract ?t)
	(modify ?c (charset ?value)))

(defrule http-charset-skip-ows-before-weight
	?c <- (http-char ?name 9|32) ; HTAB SP
	(http-charset (name ?name) (charset ?charset&:(stringp ?charset)) (weight nil))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-charset-detect-weight
	?ch <- (http-char ?name 59) ; ;
	?c <- (http-charset (name ?name) (charset ?charset&:(stringp ?charset)) (weight nil))
	=>
	(retract ?ch)
	(modify ?c (weight (assert (http-weight (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-charset-end-weight
	(http-char ?name 9|13|32|44) ; HTAB CR SP ,
	?w <- (http-weight (name ?name) (qvalue ?q&:(instancep ?q)))
	?c <- (http-charset (name ?name) (weight ?w))
	=>
	(retract ?w)
	(modify ?c (weight (make-instance of HTTP-WEIGHT (id ?name) (qvalue ?q)))))

(defrule http-charset-skip-ows-after-weight
	?ch <- (http-char ?name 9|32) ; HTAB SP
	(http-charset (name ?name) (weight ?w&:(instancep ?w)))
	=>
	(retract ?ch)
	(assert (http-char ?name (http-read ?name))))

(defrule http-accept-charset-header-end-charset
	(http-char ?name 13|44) ; CR ,
	?c <- (http-charset (charset ?value&:(stringp ?value)) (weight ?w&nil|:(instancep ?w)))
	?a <- (http-accept-charset-header (name ?name) (charsets $?charsets ?c))
	=>
	(retract ?c)
	(modify ?a (charsets ?charsets (make-instance of HTTP-CHARSET (id ?name) (charset ?value) (weight ?w)))))

(defrule http-end-accept-charset-header
	(http-char ?name 13) ; CR
	?clh <- (http-accept-charset-header (name ?name) (charsets $?charsets&:(instancep (nth$ (length$ ?charsets) ?charsets))))
	?fv <- (http-field-value (value ?clh))
	=>
	(retract ?clh)
	(modify ?fv (value (make-instance of HTTP-ACCEPT-CHARSET-HEADER (id ?name) (charsets ?charsets)))))

;   Upgrade          = #protocol
;  protocol         = protocol-name ["/" protocol-version]
;  protocol-name    = token
;  protocol-version = token
(defrule http-detect-upgrade-header
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Upgrade"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-upgrade-header (name ?name))))))

(defrule http-upgrade-header-detect-protocol
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?u <- (http-upgrade-header (name ?name) (protocols))
	=>
	(modify ?u (protocols (assert (http-protocol (name ?name))))))

(defrule http-protocol-detect-protocol-name
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?p <- (http-protocol (name ?name) (protocol-name nil))
	=>
	(modify ?p (protocol-name (assert (http-token (name ?name))))))

(defrule http-protocol-end-protocol-name
	(http-char ?name 9|13|32|44|47) ; HTAB CR SP , /
	?t <- (http-token (value ?value&~""))
	?p <- (http-protocol (name ?name) (protocol-name ?t))
	=>
	(retract ?t)
	(modify ?p (protocol-name ?value)))

(defrule http-protocol-start-protocol-version
	?c <- (http-char ?name 47) ; /
	?p <- (http-protocol (name ?name) (protocol-name ?protocol-name&:(stringp ?protocol-name)) (protocol-version nil))
	=>
	(retract ?c)
	(modify ?p (protocol-version (assert (http-token (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-protocol-end-protocol-version
	(http-char ?name 9|13|32|44) ; HTAB CR SP ,
	?t <- (http-token (value ?value&~""))
	?p <- (http-protocol (name ?name) (protocol-version ?t))
	=>
	(retract ?t)
	(modify ?p (protocol-version ?value)))

(defrule http-upgrade-header-end-protocol
	(http-char ?name 9|13|32|44) ; HTAB CR SP ,
	?p <- (http-protocol (name ?name) (protocol-name ?protocol-name&:(stringp ?protocol-name)) (protocol-version ?protocol-version&nil|:(stringp ?protocol-version)))
	?u <- (http-upgrade-header (name ?name) (protocols $?protocols ?p))
	=>
	(retract ?p)
	(modify ?u (protocols ?protocols (make-instance of HTTP-PROTOCOL (id ?name) (protocol-name ?protocol-name) (protocol-version ?protocol-version)))))

(defrule http-upgrade-header-detect-next-protocol
	?c <- (http-char ?name 44) ; ,
	?u <- (http-upgrade-header (name ?name) (protocols $?protocols ?protocol&:(instancep ?protocol)))
	=>
	(retract ?c)
	(modify ?u (protocols ?protocols ?protocol (assert (http-protocol (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-upgrade-header-skip-ows-after-protocol
	?c <- (http-char ?name 9|32) ; HTAB SP
	(http-upgrade-header (name ?name) (protocols $?protocols&:(= 0 (length$ ?protocols))|:(instancep (nth$ (length$ ?protocols) ?protocols))))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-upgrade-header-skip-ows-before-protocol
	?c <- (http-char ?name 9|32) ; HTAB SP
	?p <- (http-protocol (protocol-name nil))
	(http-upgrade-header (name ?name) (protocols $?protocols ?p))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-upgrade-header
	(http-char ?name 13) ; CR
	?u <- (http-upgrade-header (protocols $?protocols&:(instancep (nth$ (length$ ?protocols) ?protocols))))
	?f <- (http-field-value (name ?name) (value ?u))
	=>
	(retract ?u)
	(modify ?f (value (make-instance of HTTP-UPGRADE-HEADER (id ?name) (protocols ?protocols)))))

;  Via = #( received-protocol RWS received-by [ RWS comment ] )
(defrule http-detect-via-header
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Via"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-via-header (name ?name))))))

(defrule http-via-header-value-skip-ows-before-received-protocol
	?c <- (http-char ?name 9|32) ; HTAB SP
	(http-via-header-value (name ?name) (received-protocol nil))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-via-header-detect-value
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?v <- (http-via-header (name ?name) (values $?values&:(= 0 (length$ ?values))|:(instancep (nth$ (length$ ?values) ?values))))
	=>
	(modify ?v (values ?values (assert (http-via-header-value (name ?name))))))

(defrule http-via-header-value-detect-received-protocol
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?v <- (http-via-header-value (name ?name) (received-protocol nil))
	=>
	(modify ?v (received-protocol (assert (http-received-protocol (name ?name))))))

;  received-protocol = [ protocol-name "/" ] protocol-version
(defrule http-received-protocol-detect-protocol-name
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?r <- (http-received-protocol (name ?name) (protocol-name nil) (protocol-version nil))
	=>
	(modify ?r (protocol-name (assert (http-token (name ?name))))))

(defrule http-received-protocol-end-protocol-name-start-protocol-version
	?c <- (http-char ?name 47) ; /
	?t <- (http-token (value ?value&~""))
	?r <- (http-received-protocol (name ?name) (protocol-name ?t))
	=>
	(retract ?c ?t)
	(modify ?r (protocol-name ?value) (protocol-version (assert (http-token (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-received-protocol-change-protocol-name-to-protocol-version
	(http-char ?name 9|32) ; HTAB SP
	?t <- (http-token)
	?r <- (http-received-protocol (name ?name) (protocol-name ?t))
	=>
	(modify ?r (protocol-name nil) (protocol-version ?t)))

(defrule http-via-header-value-end-received-protocol
	?c <- (http-char ?name 9|32) ; HTAB SP
	?t <- (http-token (value ?value))
	?r <- (http-received-protocol (protocol-name ?protocol-name) (protocol-version ?t))
	?v <- (http-via-header-value (name ?name) (received-protocol ?r))
	=>
	(retract ?c ?t ?r)
	(modify ?v (received-protocol (make-instance of HTTP-RECEIVED-PROTOCOL (id ?name) (protocol-name ?protocol-name) (protocol-version ?value))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-via-header-skip-extra-RWS-after-received-protocol
	?c <- (http-char ?name 9|32) ; HTAB SP
	?v <- (http-via-header-value (name ?name) (received-protocol ?received-protocol&:(instancep ?received-protocol)) (received-by nil))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-via-header-value-detect-received-by
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?v <- (http-via-header-value (name ?name) (received-protocol ?r&:(instancep ?r)) (received-by nil))
	=>
	(modify ?v (received-by (assert (http-received-by (name ?name) (pseudonym (assert (http-token (name ?name)))))))))

(defrule http-received-by-end-pseudonym
	(http-char ?name 9|13|32|44|58) ; HTAB CR SP , :
	?t <- (http-token (name ?name) (value ?value))
	?r <- (http-received-by (name ?name) (pseudonym ?t))
	=>
	(retract ?t)
	(modify ?r (pseudonym ?value)))

(defrule http-received-by-detect-port
	?c <- (http-char ?name 58) ; :
	?r <- (http-received-by (name ?name) (pseudonym ?p&:(stringp ?p)) (port nil))
	=>
	(modify ?r (port (assert (http-port (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-received-by-end-port
	(http-char ?name 9|13|32|44) ; HTAB CR SP
	?p <- (http-port (value ?value))
	?r <- (http-received-by (name ?name) (pseudonym ?pseudonym) (port ?p))
	=>
	(retract ?p)
	(modify ?r (port (make-instance of HTTP-PORT (id ?name) (value ?value)))))

(defrule http-via-header-value-end-received-by
	(http-char ?name 9|13|32|44) ; HTAB CR SP ,
	?r <- (http-received-by (name ?name) (pseudonym ?pseudonym&:(stringp ?pseudonym)) (port ?port&nil|:(instancep ?port)))
	?v <- (http-via-header-value (received-by ?r))
	=>
	(retract ?r)
	(modify ?v (received-by (make-instance of HTTP-RECEIVED-BY (id ?name) (pseudonym ?pseudonym) (port ?port)))))

(defrule http-via-header-value-detect-RWS-before-comment
	?c <- (http-char ?name 9|32) ; HTAB SP
	?v <- (http-via-header-value (name ?name) (received-by ?r&:(instancep ?r)) (comment nil))
	=>
	(retract ?c)
	(modify ?v (rws TRUE))
	(assert (http-char ?name (http-read ?name))))

;   comment        = "(" *( ctext / quoted-pair / comment ) ")"
(defrule http-via-header-value-detect-comment
	?c <- (http-char ?name 40) ; (
	?v <- (http-via-header-value (name ?name) (received-by ?r&:(instancep ?r)) (comment nil) (rws TRUE))
	=>
	(retract ?c)
	(modify ?v (comment (assert (http-comment (name ?name) (values "")))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-add-ctext-to-comment
	?ch <- (http-char ?name ?char&:(member$ ?char ?*http-ctext*))
	?co <- (http-comment (name ?name) (values $?values ?value&:(stringp ?value)))
	(not (http-quoted-pair ?name))
	=>
	(retract ?ch)
	(modify ?co (values ?values (format nil "%s%c" ?value ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-comment-end-comment
	?c <- (http-char ?name 41) ; )
	?c-inner <- (http-comment (name ?name) (values $?values-inner ?value&:(instancep ?value)|:(stringp ?value)))
	?c-outer <- (http-comment (name ?name) (values $?values ?c-inner))
	(not (http-quoted-pair ?name))
	=>
	(retract ?c ?c-inner)
	(modify ?c-outer (values ?values (make-instance of HTTP-COMMENT (id ?name) (values ?values-inner ?value)) ""))
	(assert (http-char ?name (http-read ?name))))

(defrule http-comment-detect-quoted-pair
	?ch <- (http-char ?name 92) ; \
	?co <- (http-comment (name ?name) (values $?values ?value&:(stringp ?value)))
	(not (http-quoted-pair ?name))
	=>
	(retract ?ch)
	(assert (http-quoted-pair ?name)
		(http-char ?name (http-read ?name))))

(defrule http-comment-add-quoted-pair
	?ch <- (http-char ?name ?char)
	?co <- (http-comment (name ?name) (values $?values ?value&:(stringp ?value)))
	?q <- (http-quoted-pair ?name)
	(test (or
		(= 9 ?char)
		(= 32 ?char)
		(and (>= ?char 33) (<= ?char 126)) ; VCHAR
		(and (>= ?char 128) (<= ?char 255)))) ; obs-text
	=>
	(retract ?ch ?q)
	(modify ?co (values ?values (format nil "%s%c%c" ?value "\\" ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-add-comment-to-comment
	?ch <- (http-char ?name 40) ; (
	?co <- (http-comment (name ?name) (values $?values ?value&:(instancep ?value)|:(stringp ?value)))
	(not (http-quoted-pair ?name))
	=>
	(retract ?ch)
	(modify ?co (values ?values ?value (assert (http-comment (name ?name) (values "")))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-via-header-value-end-comment
	?ch <- (http-char ?name 41) ; )
	?co <- (http-comment (name ?name) (values $?values ?value&:(instancep ?value)|:(stringp ?value)))
	?v <- (http-via-header-value (comment ?co))
	=>
	(retract ?ch ?co)
	(modify ?v (comment (make-instance of HTTP-COMMENT (id ?name) (values ?values ?value))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-via-header-end-via-header-value
	(http-char ?name 13|44) ; CR ,
	?vhv <- (http-via-header-value (received-protocol ?received-protocol&:(instancep ?received-protocol)) (received-by ?received-by&:(instancep ?received-by)) (comment ?comment&nil|:(instancep ?comment)))
	?vh <- (http-via-header (name ?name) (values $?values ?vhv))
	=>
	(retract ?vhv)
	(modify ?vh (values ?values (make-instance of HTTP-VIA-HEADER-VALUE (id ?name) (received-protocol ?received-protocol) (received-by ?received-by) (comment ?comment)))))

(defrule http-via-header-start-next-via-header-value
	?c <- (http-char ?name 44) ; ,
	?v <- (http-via-header (name ?name) (values $?values&:(instancep (nth$ (length$ ?values) ?values))))
	=>
	(retract ?c)
	(modify ?v (values ?values (assert (http-via-header-value (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-via-header
	(http-char ?name 13) ; CR
	?v <- (http-via-header (values $?values&:(instancep (nth$ (length$ ?values) ?values))))
	?f <- (http-field-value (name ?name) (value ?v))
	=>
	(retract ?v)
	(modify ?f (value (make-instance of HTTP-VIA-HEADER (id ?name) (values ?values)))))

;   Accept-Language = #( language-range [ weight ] )
;   language-range   = (1*8ALPHA *("-" 1*8alphanum)) / "*"

;   User-Agent = product *( RWS ( product / comment ) )
;   Server     = product *( RWS ( product / comment ) )
;   product         = token [ "/" product-version ]
;   product-version = token
;   comment         = "(" *( ctext / quoted-pair / comment ) ")"
(defrule http-detect-user-agent-header
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?o <- (object (is-a HTTP-FIELD-NAME) (value "User-Agent"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-product-header (name ?name) (values (assert (http-product (name ?name) (token (assert (http-token (name ?name))))))))))))

(defrule http-detect-server-header
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Server"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-product-header (name ?name) (values (assert (http-product (name ?name) (token (assert (http-token (name ?name))))))))))))

(defrule http-product-end-token-start-product-version
	?c <- (http-char ?name 47) ; /
	?t <- (http-token (name ?name) (value ?value&~""))
	?p <- (http-product (name ?name) (token ?t))
	=>
	(retract ?c ?t)
	(modify ?p (token ?value) (product-version (assert (http-token (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-product-end-token
	(http-char ?name 9|13|32) ; HTAB CR SP
	?t <- (http-token (name ?name) (value ?value&~""))
	?p <- (http-product (name ?name) (token ?t))
	=>
	(retract ?t)
	(modify ?p (token ?value)))

(defrule http-product-end-product-version
	(http-char ?name 9|13|32) ; HTAB CR SP
	?t <- (http-token (name ?name) (value ?value&~""))
	?p <- (http-product (name ?name) (product-version ?t))
	=>
	(retract ?t)
	(modify ?p (product-version ?value)))

(defrule http-product-header-end-product
	(http-char ?name 9|13|32) ; HTAB CR SP
	?p <- (http-product (name ?name) (token ?token&:(stringp ?token)) (product-version ?product-version&nil|:(stringp ?product-version)))
	?ph <- (http-product-header (name ?name) (values $?values ?p))
	=>
	(retract ?p)
	(modify ?ph (values ?values (make-instance of HTTP-PRODUCT (id ?name) (token ?token) (product-version ?product-version)))))

; RWS is required between products and comments. It also absorbs any
; trailing OWS before the CR that ends the field line.
(defrule http-product-header-detect-RWS
	?c <- (http-char ?name 9|32) ; HTAB SP
	?ph <- (http-product-header (name ?name) (values $?values ?v&:(instancep ?v)))
	=>
	(retract ?c)
	(modify ?ph (rws TRUE))
	(assert (http-char ?name (http-read ?name))))

(defrule http-product-header-detect-next-product
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?ph <- (http-product-header (name ?name) (rws TRUE) (values $?values ?v&:(instancep ?v)))
	=>
	(modify ?ph (rws FALSE) (values ?values ?v (assert (http-product (name ?name) (token (assert (http-token (name ?name)))))))))

(defrule http-product-header-detect-comment
	?c <- (http-char ?name 40) ; (
	?ph <- (http-product-header (name ?name) (rws TRUE) (values $?values ?v&:(instancep ?v)))
	=>
	(retract ?c)
	(modify ?ph (rws FALSE) (values ?values ?v (assert (http-comment (name ?name) (values "")))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-product-header-end-comment
	?ch <- (http-char ?name 41) ; )
	?co <- (http-comment (name ?name) (values $?values ?value&:(instancep ?value)|:(stringp ?value)))
	?ph <- (http-product-header (name ?name) (values $?vs ?co))
	(not (http-quoted-pair ?name))
	=>
	(retract ?ch ?co)
	(modify ?ph (values ?vs (make-instance of HTTP-COMMENT (id ?name) (values ?values ?value))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-user-agent-header
	(http-char ?name 13) ; CR
	?ph <- (http-product-header (name ?name) (values $?values&:(instancep (nth$ (length$ ?values) ?values))))
	?fv <- (http-field-value (value ?ph))
	(http-field-line (field-name ?fn) (field-value ?fv))
	(object (is-a HTTP-FIELD-NAME) (name ?fn) (value "User-Agent"))
	=>
	(retract ?ph)
	(modify ?fv (value (make-instance of HTTP-USER-AGENT-HEADER (id ?name) (values ?values)))))

(defrule http-end-server-header
	(http-char ?name 13) ; CR
	?ph <- (http-product-header (name ?name) (values $?values&:(instancep (nth$ (length$ ?values) ?values))))
	?fv <- (http-field-value (value ?ph))
	(http-field-line (field-name ?fn) (field-value ?fv))
	(object (is-a HTTP-FIELD-NAME) (name ?fn) (value "Server"))
	=>
	(retract ?ph)
	(modify ?fv (value (make-instance of HTTP-SERVER-HEADER (id ?name) (values ?values)))))

(defrule http-detect-accept-language-header
	(http-char ?name ?char&:(member$ ?char (create$ ?*http-alpha* 42))) ; *
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Accept-Language"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-accept-language-header (name ?name) (language-ranges (assert (http-language-range (name ?name) (first-language (assert (http-language (name ?name))))))))))))

(defrule http-language-range-detect-first-language
	(http-char ?name ?char&:(member$ ?char (create$ ?*http-alpha* 42))) ; *
	?lr <- (http-language-range (name ?name) (first-language nil))
	=>
	(modify ?lr (first-language (assert (http-language (name ?name))))))

(defrule http-language-range-detect-asterisk
	?c <- (http-char ?name 42) ; *
	?l <- (http-language (value ""))
	?lr <- (http-language-range (name ?name) (first-language ?l))
	=>
	(retract ?c)
	(modify ?l (value "*"))
	(assert (http-char ?name (http-read ?name))))

(defrule http-language-range-build-first-language
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-alpha*))
	?l <- (http-language (value ?value&~"*"))
	?lr <- (http-language-range (name ?name) (first-language ?l))
	=>
	(retract ?c)
	(modify ?l (value (format nil "%s%c" ?value ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-language-range-end-first-language
	(http-char ?name 9|13|32|44|59) ; HTAB CR SP , ;
	?l <- (http-language (value ?value&:(< 0 (str-length ?value))))
	?lr <- (http-language-range (name ?name) (first-language ?l))
	=>
	(retract ?l)
	(modify ?lr (first-language (make-instance of HTTP-LANGUAGE (id ?name) (value ?value)))))

(defrule http-language-range-end-first-language-and-detect-next-language
	?c <- (http-char ?name 45) ; -
	?l <- (http-language (value ?value&:(< 0 (str-length ?value))))
	?lr <- (http-language-range (name ?name) (first-language ?l))
	=>
	(retract ?c ?l)
	(modify ?lr (first-language (make-instance of HTTP-LANGUAGE (id ?name) (value ?value))) (languages (assert (http-language (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-language-range-end-weight
	(http-char ?name 9|13|32|44) ; HTAB CR SP ,
	?w <- (http-weight (name ?name) (qvalue ?q&:(instancep ?q)))
	?l <- (http-language-range (name ?name) (weight ?w))
	=>
	(retract ?w)
	(modify ?l (weight (make-instance of HTTP-WEIGHT (id ?name) (qvalue ?q)))))

(defrule http-language-range-end-language
	(http-char ?name 9|13|32|44|59) ; HTAB CR SP , ;
	?l <- (http-language (value ?value&:(< 0 (str-length ?value))))
	?lr <- (http-language-range (name ?name) (languages $?languages ?l))
	=>
	(retract ?l)
	(modify ?lr (languages ?languages (make-instance of HTTP-LANGUAGE (id ?name) (value ?value)))))

(defrule http-language-range-end-language-and-detect-next-language
	?c <- (http-char ?name 45) ; -
	?l <- (http-language (value ?value&:(< 0 (str-length ?value))))
	?lr <- (http-language-range (name ?name) (languages $?languages ?l))
	=>
	(retract ?c)
	(modify ?lr (languages ?languages (make-instance of HTTP-LANGUAGE (id ?name) (value ?value)) (assert (http-language (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-language-range-build-language
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-alphanum*))
	?l <- (http-language (name ?name) (value ?value))
	?lr <- (http-language-range (languages $? ?l))
	=>
	(retract ?c)
	(modify ?l (value (format nil "%s%c" ?value ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-language-range-ignore-ows-before-weight
	?c <- (http-char ?name 9|32) ; HTAB SP
	?l <- (http-language-range (name ?name) (first-language ?first-language&:(instancep ?first-language)) (languages $?languages&:(= 0 (length$ ?languages))|:(instancep (nth$ (length$ ?languages) ?languages))) (weight nil))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-language-range-ignore-ows-after-weight
	?c <- (http-char ?name 9|32) ; HTAB SP
	?l <- (http-language-range (name ?name) (first-language ?first-language&:(instancep ?first-language)) (languages $?languages&:(= 0 (length$ ?languages))|:(instancep (nth$ (length$ ?languages) ?languages))) (weight ?weight&:(instancep ?weight)))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-language-range-detect-weight
	?c <- (http-char ?name 59) ; ;
	?l <- (http-language-range (name ?name) (first-language ?first-language&:(instancep ?first-language)) (languages $?languages&:(= 0 (length$ ?languages))|:(instancep (nth$ (length$ ?languages) ?languages))) (weight nil))
	=>
	(retract ?c)
	(modify ?l (weight (assert (http-weight (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-accept-language-header-end-language-range
	(http-char ?name 13|44) ; CR ,
	?l <- (http-language-range (name ?name) (first-language ?first-language&:(instancep ?first-language)) (languages $?languages&:(= 0 (length$ ?languages))|:(instancep (nth$ (length$ ?languages) ?languages))) (weight ?weight&nil|:(instancep ?weight)))
	?a <- (http-accept-language-header (language-ranges $?language-ranges ?l))
	=>
	(retract ?l)
	(modify ?a (language-ranges ?language-ranges (make-instance of HTTP-LANGUAGE-RANGE (id ?name) (first-language ?first-language) (languages ?languages) (weight ?weight)))))

(defrule http-accept-language-header-ignore-ows-between-language-ranges
	?c <- (http-char ?name 9|32) ; HTAB SP
	?l <- (http-language-range (first-language nil))
	?a <- (http-accept-language-header (name ?name) (language-ranges $?language-ranges ?l))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-accept-language-header-start-next-language-range
	?c <- (http-char ?name 44) ; ,
	?a <- (http-accept-language-header (name ?name) (language-ranges $?language-ranges&:(instancep (nth$ (length$ ?language-ranges) ?language-ranges))))
	=>
	(retract ?c)
	(modify ?a (language-ranges ?language-ranges (assert (http-language-range (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-accept-language-header
	(http-char ?name 13) ; CR
	?clh <- (http-accept-language-header (name ?name) (language-ranges $?language-ranges&:(instancep (nth$ (length$ ?language-ranges) ?language-ranges))))
	?fv <- (http-field-value (value ?clh))
	=>
	(retract ?clh)
	(modify ?fv (value (make-instance of HTTP-ACCEPT-LANGUAGE-HEADER (id ?name) (language-ranges ?language-ranges)))))

;   Content-Language = #language-tag
;   language-tag     = <Language-Tag, see [RFC5646], Section 2.1>
; A language-tag is built by the language-range rules above (the subtags are
; the same 1*8alphanum pieces); only the header's own rules differ, and a
; language-tag carries no weight.
(defrule http-detect-content-language-header
	(http-char ?name ?char&:(member$ ?char ?*http-alpha*))
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Content-Language"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-content-language-header (name ?name) (language-tags (assert (http-language-range (name ?name) (first-language (assert (http-language (name ?name))))))))))))

(defrule http-content-language-header-end-language-tag
	(http-char ?name 13|44) ; CR ,
	?l <- (http-language-range (name ?name) (first-language ?first-language&:(instancep ?first-language)) (languages $?languages&:(= 0 (length$ ?languages))|:(instancep (nth$ (length$ ?languages) ?languages))) (weight nil))
	?h <- (http-content-language-header (language-tags $?language-tags ?l))
	=>
	(retract ?l)
	(modify ?h (language-tags ?language-tags (make-instance of HTTP-LANGUAGE-TAG (id ?name) (first-language ?first-language) (languages ?languages)))))

(defrule http-content-language-header-ignore-ows-between-language-tags
	?c <- (http-char ?name 9|32) ; HTAB SP
	?l <- (http-language-range (first-language nil))
	?h <- (http-content-language-header (name ?name) (language-tags $?language-tags ?l))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-content-language-header-start-next-language-tag
	?c <- (http-char ?name 44) ; ,
	?h <- (http-content-language-header (name ?name) (language-tags $?language-tags&:(instancep (nth$ (length$ ?language-tags) ?language-tags))))
	=>
	(retract ?c)
	(modify ?h (language-tags ?language-tags (assert (http-language-range (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-content-language-header
	(http-char ?name 13) ; CR
	?clh <- (http-content-language-header (name ?name) (language-tags $?language-tags&:(instancep (nth$ (length$ ?language-tags) ?language-tags))))
	?fv <- (http-field-value (value ?clh))
	=>
	(retract ?clh)
	(modify ?fv (value (make-instance of HTTP-CONTENT-LANGUAGE-HEADER (id ?name) (language-tags ?language-tags)))))

;   From = mailbox (RFC 9110 10.1.2; the mailbox grammar is RFC 5322 3.4)
; The first atext run or quoted-string may be the local-part of an addr-spec or
; the first word of a display-name: "@" after it makes it the local-part, SP,
; HTAB or "<" make it a word.  CFWS comments are not handled.
(defrule http-detect-from-header-dot-atom
	(http-char ?name ?char&:(member$ ?char ?*http-atext*))
	?o <- (object (is-a HTTP-FIELD-NAME) (value "From"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-from-header (name ?name) (mailbox (assert (http-mailbox (name ?name) (local-part (assert (http-dot-atom (name ?name))))))))))))

(defrule http-detect-from-header-quoted-string
	?c <- (http-char ?name 34) ; "
	?o <- (object (is-a HTTP-FIELD-NAME) (value "From"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(retract ?c)
	(modify ?fv (value (assert (http-from-header (name ?name) (mailbox (assert (http-mailbox (name ?name) (local-part (assert (http-quoted-string (name ?name)))))))))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-detect-from-header-angle-addr
	?c <- (http-char ?name 60) ; <
	?o <- (object (is-a HTTP-FIELD-NAME) (value "From"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(retract ?c)
	(modify ?fv (value (assert (http-from-header (name ?name) (mailbox (assert (http-mailbox (name ?name) (angle-addr open))))))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-build-dot-atom
	?c <- (http-char ?name ?char&46|:(member$ ?char ?*http-atext*)) ; .
	?d <- (http-dot-atom (name ?name) (value ?value))
	=>
	(retract ?c)
	(modify ?d (value (format nil "%s%c" ?value ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-mailbox-start-local-part-dot-atom
	(http-char ?name ?char&:(member$ ?char ?*http-atext*))
	?m <- (http-mailbox (name ?name) (local-part nil) (domain nil))
	=>
	(modify ?m (local-part (assert (http-dot-atom (name ?name))))))

(defrule http-mailbox-start-local-part-quoted-string
	?c <- (http-char ?name 34) ; "
	?m <- (http-mailbox (name ?name) (local-part nil) (domain nil))
	=>
	(retract ?c)
	(modify ?m (local-part (assert (http-quoted-string (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-mailbox-start-angle-addr
	?c <- (http-char ?name 60) ; <
	?m <- (http-mailbox (name ?name) (local-part nil) (domain nil) (angle-addr nil))
	=>
	(retract ?c)
	(modify ?m (angle-addr open))
	(assert (http-char ?name (http-read ?name))))

(defrule http-mailbox-end-local-part-dot-atom
	(http-char ?name 64) ; @
	?d <- (http-dot-atom (value ?value&~""))
	?m <- (http-mailbox (name ?name) (local-part ?d))
	=>
	(retract ?d)
	(modify ?m (local-part ?value)))

(defrule http-mailbox-end-local-part-quoted-string
	?c <- (http-char ?name 34) ; "
	?q <- (http-quoted-string (name ?name) (value ?value))
	?m <- (http-mailbox (name ?name) (local-part ?q))
	(not (http-quoted-pair ?name))
	=>
	(retract ?c ?q)
	(modify ?m (local-part (make-instance of HTTP-QUOTED-STRING (id ?name) (value ?value))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-mailbox-dot-atom-is-display-name-word
	(http-char ?name 9|32|60) ; HTAB SP <
	?d <- (http-dot-atom (value ?value&~""))
	?m <- (http-mailbox (name ?name) (display-name $?words) (local-part ?d) (domain nil) (angle-addr nil))
	=>
	(retract ?d)
	(modify ?m (display-name ?words ?value) (local-part nil)))

(defrule http-mailbox-quoted-string-is-display-name-word
	(http-char ?name 9|32|60) ; HTAB SP <
	?m <- (http-mailbox (name ?name) (display-name $?words) (local-part ?q&:(instancep ?q)) (domain nil) (angle-addr nil))
	=>
	(modify ?m (display-name ?words ?q) (local-part nil)))

(defrule http-mailbox-skip-ows-between-words
	?c <- (http-char ?name 9|32) ; HTAB SP
	(http-mailbox (name ?name) (display-name $?words&:(> (length$ ?words) 0)) (local-part nil) (domain nil) (angle-addr nil))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-mailbox-start-domain
	?c <- (http-char ?name 64) ; @
	?m <- (http-mailbox (name ?name) (local-part ?l&:(stringp ?l)|:(instancep ?l)) (domain nil))
	=>
	(retract ?c)
	(modify ?m (domain (assert (http-dot-atom (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-mailbox-change-domain-to-domain-literal
	?c <- (http-char ?name 91) ; [
	?d <- (http-dot-atom (value ""))
	?m <- (http-mailbox (name ?name) (domain ?d))
	=>
	(retract ?c ?d)
	(modify ?m (domain (assert (http-domain-literal (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-build-domain-literal
	?c <- (http-char ?name ?char&:(or (and (>= ?char 33) (<= ?char 90)) (and (>= ?char 94) (<= ?char 126)))) ; dtext
	?d <- (http-domain-literal (name ?name) (value ?value))
	=>
	(retract ?c)
	(modify ?d (value (format nil "%s%c" ?value ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-mailbox-end-domain-literal
	?c <- (http-char ?name 93) ; ]
	?d <- (http-domain-literal (name ?name) (value ?value))
	?m <- (http-mailbox (name ?name) (domain ?d))
	=>
	(retract ?c ?d)
	(modify ?m (domain (make-instance of HTTP-DOMAIN-LITERAL (id ?name) (value ?value))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-mailbox-end-domain-dot-atom
	(http-char ?name 9|13|32|62) ; HTAB CR SP >
	?d <- (http-dot-atom (value ?value&~""))
	?m <- (http-mailbox (name ?name) (domain ?d))
	=>
	(retract ?d)
	(modify ?m (domain ?value)))

(defrule http-mailbox-end-angle-addr
	?c <- (http-char ?name 62) ; >
	?m <- (http-mailbox (name ?name) (domain ?d&:(stringp ?d)|:(instancep ?d)) (angle-addr open))
	=>
	(retract ?c)
	(modify ?m (angle-addr closed))
	(assert (http-char ?name (http-read ?name))))

(defrule http-mailbox-skip-ows-after-mailbox
	?c <- (http-char ?name 9|32) ; HTAB SP
	(http-mailbox (name ?name) (domain ?d&:(stringp ?d)|:(instancep ?d)) (angle-addr nil|closed))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-from-header-addr-spec
	(http-char ?name 13) ; CR
	?m <- (http-mailbox (name ?name) (display-name) (local-part ?l&:(stringp ?l)|:(instancep ?l)) (domain ?d&:(stringp ?d)|:(instancep ?d)) (angle-addr nil))
	?h <- (http-from-header (name ?name) (mailbox ?m))
	?fv <- (http-field-value (value ?h))
	=>
	(retract ?m ?h)
	(modify ?fv (value (make-instance of HTTP-FROM-HEADER (id ?name) (mailbox (make-instance of HTTP-ADDR-SPEC (id ?name) (local-part ?l) (domain ?d)))))))

(defrule http-end-from-header-name-addr
	(http-char ?name 13) ; CR
	?m <- (http-mailbox (name ?name) (display-name $?words) (local-part ?l&:(stringp ?l)|:(instancep ?l)) (domain ?d&:(stringp ?d)|:(instancep ?d)) (angle-addr closed))
	?h <- (http-from-header (name ?name) (mailbox ?m))
	?fv <- (http-field-value (value ?h))
	=>
	(retract ?m ?h)
	(modify ?fv (value (make-instance of HTTP-FROM-HEADER (id ?name) (mailbox (make-instance of HTTP-NAME-ADDR (id ?name) (display-name ?words) (addr-spec (make-instance of HTTP-ADDR-SPEC (id ?name) (local-part ?l) (domain ?d)))))))))

;RWS = 1*( SP / HTAB )
;  Via = #( received-protocol RWS received-by [ RWS comment ] )
;
;  received-protocol = [ protocol-name "/" ] protocol-version
;                    ; see Section 7.8
;  received-by       = pseudonym [ ":" port ]
;  pseudonym         = token

(defrule http-detect-content-length-header
	(http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Content-Length"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-content-length-header (name ?name))))))

;   Max-Forwards = 1*DIGIT
(defrule http-detect-max-forwards-header
	(http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Max-Forwards"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-max-forwards-header (name ?name))))))

;   Content-Type = media-type
;     media-type = type "/" subtype parameters
;     type       = token
;     subtype    = token
;          token = 1*tchar
(defrule http-detect-content-type-header-type
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Content-Type"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-content-type-header (name ?name) (type (assert (http-type (name ?name)))))))))

(defrule http-detect-host-header
	(http-char ?name ?char&:(member$ ?char (create$ 91 ?*http-reg-name*))) ; [
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Host"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-host-header (name ?name) (uri-host (assert (http-host (name ?name)))))))))

(defrule http-build-type
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?t <- (http-type (name ?name) (value ?type))
	=>
	(retract ?c)
	(modify ?t (value (format nil "%s%c" ?type ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-content-type-end-type
	?c <- (http-char ?name 47) ; /
	?t <- (http-type (name ?name) (value ?value))
	?ct <- (http-content-type-header (type ?t))
	=>
	(retract ?c ?t)
	(modify ?ct (type (make-instance of HTTP-TYPE (id ?name) (value ?value))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-content-type-detect-subtype
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?c <- (http-content-type-header (name ?name) (type ?t&:(instancep ?t)) (subtype nil))
	=>
	(modify ?c (subtype (assert (http-subtype (name ?name))))))

(defrule http-build-subtype
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?s <- (http-subtype (name ?name) (value ?subtype))
	=>
	(retract ?c)
	(modify ?s (value (format nil "%s%c" ?subtype ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-content-type-end-subtype
	(http-char ?name 13|32|59) ; CR SP ;
	?s <- (http-subtype (name ?name) (value ?value))
	?c <- (http-content-type-header (subtype ?s))
	=>
	(retract ?s)
	(modify ?c (subtype (make-instance of HTTP-SUBTYPE (id ?name) (value ?value)))))

(defrule http-content-type-detect-parameter
	?c <- (http-char ?name 59) ; ;
	?cth <- (http-content-type-header (name ?name) (subtype ?s&:(instancep ?s)) (parameters $?parameters&:(= 0 (length$ ?parameters))|:(instancep (nth$ (length$ ?parameters) ?parameters))))
	=>
	(retract ?c)
	(modify ?cth (parameters ?parameters (assert (http-parameter (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-content-type-detect-ows
	?c <- (http-char ?name 32) ; SP
	(http-content-type-header (name ?name) (subtype ?s&:(instancep ?s)) (parameters $?parameters&:(= 0 (length$ ?parameters))|:(instancep (nth$ (length$ ?parameters) ?parameters))))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-parameter-detect-ows
	?c <- (http-char ?name 32) ; SP
	(http-parameter (name ?name) (parameter-name nil))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-parameter-detect-parameter-name
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?p <- (http-parameter (name ?name) (parameter-name nil))
	=>
	(modify ?p (parameter-name (assert (http-token (name ?name))))))

(defrule http-build-token
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?t <- (http-token (name ?name) (value ?value))
	(not (and (http-parameter (parameter-name ?t)) (test (= ?char 42)))) ; * ends an ext-token parameter name
	=>
	(retract ?c)
	(modify ?t (value (format nil "%s%c" ?value ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-parameter-name-detect-ext-token
	?c <- (http-char ?name 42) ; *
	?t <- (http-token (name ?name) (value ?value&~""))
	?p <- (http-parameter (parameter-name ?t) (ext-token FALSE))
	=>
	(retract ?c)
	(modify ?p (ext-token TRUE))
	(assert (http-char ?name (http-read ?name))))

(defrule http-parameter-end-parameter-name
	?c <- (http-char ?name 61) ; =
	?t <- (http-token (name ?name) (value ?value&~""&~"q"))
	?p <- (http-parameter (parameter-name ?t))
	=>
	(retract ?c ?t)
	(modify ?p (parameter-name ?value))
	(assert (http-char ?name (http-read ?name))))

(defrule http-media-range-parameter-change-to-weight
	?c <- (http-char ?name 61) ; =
	?t <- (http-token (name ?name) (value "q"))
	?p <- (http-parameter (parameter-name ?t))
	?m <- (http-media-range (parameters $?parameters ?p))
	=>
	(retract ?c ?t ?p)
	(modify ?m (parameters ?parameters) (weight (assert (http-weight (name ?name) (q TRUE) (equals TRUE)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-parameter-detect-parameter-value-token
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?p <- (http-parameter (name ?name) (parameter-name ?parameter-name&:(stringp ?parameter-name)) (ext-token FALSE) (parameter-value nil))
	=>
	(modify ?p (parameter-value (assert (http-token (name ?name))))))

(defrule http-parameter-end-parameter-value-token
	(http-char ?name 9|13|32|44|59) ; HTAB CR SP , ;
	?t <- (http-token (name ?name) (value ?value&~""))
	?p <- (http-parameter (parameter-value ?t))
	=>
	(retract ?t)
	(modify ?p (parameter-value ?value)))

(defrule http-parameter-detect-parameter-value-quoted-string
	?c <- (http-char ?name 34) ; "
	?p <- (http-parameter (name ?name) (parameter-name ?t&:(stringp ?t)) (parameter-value nil))
	=>
	(retract ?c)
	(modify ?p (parameter-value (assert (http-quoted-string (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-quoted-string-detect-quoted-pair
	?c <- (http-char ?name 92) ; \
	?q <- (http-quoted-string (name ?name) (value ?value))
	(not (http-quoted-pair ?name))
	=>
	(retract ?c)
	(assert (http-quoted-pair ?name)
		(http-char ?name (http-read ?name))))

;   quoted-string = DQUOTE *( qdtext / quoted-pair ) DQUOTE
;        qdtext   = HTAB / SP / "!" / %x23-5B / %x5D-7E / obs-text
(defrule http-build-quoted-string
	?c <- (http-char ?name ?char)
	?q <- (http-quoted-string (name ?name) (value ?value))
	(not (http-quoted-pair ?name))
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
	(assert (http-char ?name (http-read ?name))))

;   quoted-pair = "\" ( HTAB / SP / VCHAR / obs-text )
(defrule http-build-quoted-string-quoted-pair
	?c <- (http-char ?name ?char)
	?qp <- (http-quoted-pair ?name)
	?q <- (http-quoted-string (name ?name) (value ?value))
	(test (or
		(= ?char 9) ; HTAB
		(= ?char 32) ; SP
		(and (>= ?char 33) (<= ?char 126)) ; VCHAR
		(and (>= ?char 128) (<= ?char 255)))) ; obs-text
	=>
	(retract ?c ?qp)
	(modify ?q (value (format nil "%s%c" ?value ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-parameter-end-parameter-value-quoted-string
	?c <- (http-char ?name 34) ; "
	?q <- (http-quoted-string (name ?name) (value ?value&:(stringp ?value)))
	?p <- (http-parameter (parameter-name ?t&:(stringp ?t)) (parameter-value ?q))
	(not (http-quoted-pair ?name))
	=>
	(retract ?c ?q)
	(modify ?p (parameter-value (make-instance of HTTP-QUOTED-STRING (id ?name) (value ?value))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-content-type-header-end-parameter
	(http-char ?name 9|13|32|59) ; HTAB CR SP ;
	?p <- (http-parameter (parameter-name ?t&:(stringp ?t)) (ext-token ?ext-token) (parameter-value ?parameter-value&:(instancep ?parameter-value)|:(stringp ?parameter-value)))
	?c <- (http-content-type-header (name ?name) (subtype ?s&:(instancep ?s)) (parameters $?parameters ?p))
	=>
	(retract ?p)
	(modify ?c (parameters ?parameters (make-instance of HTTP-PARAMETER (id ?name) (parameter-name ?t) (ext-token ?ext-token) (parameter-value ?parameter-value)))))

(defrule http-host-header-end-host
	(http-char ?name 13|32|58) ; CR SP :
	?h <- (http-host (value ?value&:(instancep ?value)))
	?hh <- (http-host-header (name ?name) (uri-host ?h))
	=>
	(retract ?h)
	(modify ?hh (uri-host (make-instance of HTTP-HOST (id ?name) (value ?value)))))

(defrule http-host-header-detect-port
	?c <- (http-char ?name 58)
	?hh <- (http-host-header (name ?name) (uri-host ?h&:(instancep ?h)) (port nil))
	=>
	(retract ?c)
	(modify ?hh (port (assert (http-port (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-host-header-end-port
	(http-char ?name 13|32) ; CR SP
	?p <- (http-port (value ?value))
	?hh <- (http-host-header (name ?name) (port ?p))
	=>
	(retract ?p)
	(modify ?hh (port (make-instance of HTTP-PORT (id ?name) (value ?value)))))

(defrule http-build-content-length-header
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?clh <- (http-content-length-header (name ?name) (value ?content-length-header))
	=>
	(retract ?c)
	(modify ?clh (value (format nil "%s%c" ?content-length-header ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-build-max-forwards-header
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?mfh <- (http-max-forwards-header (name ?name) (value ?max-forwards-header))
	=>
	(retract ?c)
	(modify ?mfh (value (format nil "%s%c" ?max-forwards-header ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-unknown-header-allow-ows
	?c <- (http-char ?name ?char&9|32) ; HTAB SP
	?u <- (http-unknown-header (name ?name) (value ?unknown-header&~"") (possible-ows ?possible-ows))
	?f <- (http-field-value (value ?u))
	=>
	(retract ?c)
	(modify ?u (possible-ows (format nil "%s%c" ?possible-ows ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-unknown-header
	(http-char ?name 13)
	?u <- (http-unknown-header (name ?name) (value ?value))
	?fv <- (http-field-value (value ?u))
	=>
	(retract ?u)
	(modify ?fv (value (make-instance of HTTP-UNKNOWN-HEADER (id ?name) (value ?value)))))

(defrule http-end-content-length-header
	(http-char ?name 13|32) ; CR SP
	?clh <- (http-content-length-header (name ?name) (value ?content-length-header))
	?fv <- (http-field-value (value ?clh))
	=>
	(retract ?clh)
	(modify ?fv (value (make-instance of HTTP-CONTENT-LENGTH-HEADER (id ?name) (value ?content-length-header)))))

(defrule http-end-max-forwards-header
	(http-char ?name 9|13|32) ; HTAB CR SP
	?mfh <- (http-max-forwards-header (name ?name) (value ?max-forwards-header))
	?fv <- (http-field-value (value ?mfh))
	=>
	(retract ?mfh)
	(modify ?fv (value (make-instance of HTTP-MAX-FORWARDS-HEADER (id ?name) (value ?max-forwards-header)))))

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
(defrule http-detect-http-date-header
	(http-char ?name 70|77|83|84|87) ; F M S T W
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Date"|"Last-Modified"|"If-Modified-Since"|"If-Unmodified-Since"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-date-header (name ?name) (http-date (assert (http-day-name (name ?name)))))))))

(defrule http-build-day-name
	?c <- (http-char ?name ?char&77|111|110|100|97|121|84|117|101|115|87|104|114|70|105|83|116) ; M o n d a y T u e s W h r F i S t
	?d <- (http-day-name (name ?name) (value ?value&:(> 9 (str-length ?value))))
	=>
	(retract ?c)
	(modify ?d (value (format nil "%s%c" ?value ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-day-name-end-imf-fixdate
	?c <- (http-char ?name 44) ; ,
	?d <- (http-day-name (name ?name) (value ?value&"Mon"|"Tue"|"Wed"|"Thu"|"Fri"|"Sat"|"Sun"))
	?h <- (http-date-header (name ?name) (http-date ?d))
	=>
	(retract ?c ?d)
	(modify ?h (http-date (assert (http-rfc1123-date (name ?name) (wkday (make-instance of HTTP-WKDAY (id ?name) (value ?value)))))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-day-name-end-rfc850-date
	?c <- (http-char ?name 44) ; ,
	?d <- (http-day-name (name ?name) (value ?value&"Monday"|"Tuesday"|"Wednesday"|"Thursday"|"Friday"|"Saturday"|"Sunday"))
	?h <- (http-date-header (name ?name) (http-date ?d))
	=>
	(retract ?c ?d)
	(modify ?h (http-date (assert (http-rfc850-date (name ?name) (day-name-l (make-instance of HTTP-DAY-NAME-L (id ?name) (value ?value)))))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-day-name-end-asctime-date
	?c <- (http-char ?name 32) ; SP
	?d <- (http-day-name (name ?name) (value ?value&"Mon"|"Tue"|"Wed"|"Thu"|"Fri"|"Sat"|"Sun"))
	?h <- (http-date-header (name ?name) (http-date ?d))
	=>
	(retract ?c ?d)
	(modify ?h (http-date (assert (http-asctime-date (name ?name) (day-name (make-instance of HTTP-WKDAY (id ?name) (value ?value))) (date3 (assert (http-date3 (name ?name) (month (assert (http-month (name ?name)))))))))))
	(assert (http-char ?name (http-read ?name))))

; IMF-fixdate: the rfc1123-date rules above carry the fact through "GMT"
(defrule http-date-header-end-rfc1123-date
	(http-char ?name 9|13|32) ; HTAB CR SP
	?r <- (http-rfc1123-date (name ?name) (wkday ?wkday) (date1 ?date1) (time ?time) (GMT "GMT"))
	?h <- (http-date-header (name ?name) (http-date ?r))
	=>
	(retract ?r)
	(modify ?h (http-date (make-instance of HTTP-RFC1123-DATE (id ?name) (wkday ?wkday) (date1 ?date1) (time ?time)))))

;   rfc850-date  = day-name-l "," SP date2 SP time-of-day SP GMT
;   date2        = day "-" month "-" 2DIGIT
;                ; e.g., 02-Jun-82
(defrule http-rfc850-date-start-date2
	?c <- (http-char ?name 32) ; SP
	?r <- (http-rfc850-date (name ?name) (day-name-l ?d&:(instancep ?d)) (date2 nil))
	=>
	(retract ?c)
	(modify ?r (date2 (assert (http-date2 (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-date2-build-day
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?d <- (http-date2 (name ?name) (day ?day&:(> 2 (str-length ?day))))
	=>
	(retract ?c)
	(modify ?d (day (format nil "%s%c" ?day ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-date2-end-day-start-month
	?c <- (http-char ?name 45) ; -
	?d <- (http-date2 (name ?name) (day ?day&:(= 2 (str-length ?day))) (month nil))
	=>
	(retract ?c)
	(modify ?d (month (assert (http-month (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-date2-end-month
	?c <- (http-char ?name 45) ; -
	?m <- (http-month (value ?value&"Jan"|"Feb"|"Mar"|"Apr"|"May"|"Jun"|"Jul"|"Aug"|"Sep"|"Oct"|"Nov"|"Dec"))
	?d <- (http-date2 (name ?name) (month ?m))
	=>
	(retract ?c ?m)
	(modify ?d (month (make-instance of HTTP-MONTH (id ?name) (value ?value))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-date2-build-year
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?d <- (http-date2 (name ?name) (month ?m&:(instancep ?m)) (year ?year&:(> 2 (str-length ?year))))
	=>
	(retract ?c)
	(modify ?d (year (format nil "%s%c" ?year ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-rfc850-date-end-date2
	(http-char ?name 32) ; SP
	?d <- (http-date2 (day ?day) (month ?month) (year ?year&:(= 2 (str-length ?year))))
	?r <- (http-rfc850-date (name ?name) (date2 ?d))
	=>
	(retract ?d)
	(modify ?r (date2 (make-instance of HTTP-DATE2 (id ?name) (day ?day) (month ?month) (year ?year)))))

(defrule http-rfc850-date-start-time
	?c <- (http-char ?name 32) ; SP
	?r <- (http-rfc850-date (name ?name) (date2 ?d&:(instancep ?d)) (time nil))
	=>
	(retract ?c)
	(modify ?r (time (assert (http-time (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-rfc850-date-end-time
	?c <- (http-char ?name 32) ; SP
	?t <- (http-time (name ?name) (first-2digit ?first) (second-2digit ?second) (third-2digit ?third&:(= 2 (str-length ?third))))
	?r <- (http-rfc850-date (name ?name) (time ?t))
	=>
	(retract ?c ?t)
	(modify ?r (time (make-instance of HTTP-TIME (id ?name) (first-2digit ?first) (second-2digit ?second) (third-2digit ?third))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-rfc850-date-expect-GMT
	?c <- (http-char ?name ?char&71|77|84) ; G M T
	?r <- (http-rfc850-date (name ?name) (time ?t&:(instancep ?t)) (GMT ?GMT&:(> 3 (str-length ?GMT))))
	=>
	(retract ?c)
	(modify ?r (GMT (format nil "%s%c" ?GMT ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-date-header-end-rfc850-date
	(http-char ?name 9|13|32) ; HTAB CR SP
	?r <- (http-rfc850-date (name ?name) (day-name-l ?day-name-l) (date2 ?date2) (time ?time) (GMT "GMT"))
	?h <- (http-date-header (name ?name) (http-date ?r))
	=>
	(retract ?r)
	(modify ?h (http-date (make-instance of HTTP-RFC850-DATE (id ?name) (day-name-l ?day-name-l) (date2 ?date2) (time ?time)))))

;   asctime-date = day-name SP date3 SP time-of-day SP year
;   date3        = month SP ( 2DIGIT / ( SP 1DIGIT ))
;                ; e.g., Jun  2
(defrule http-date3-end-month
	?c <- (http-char ?name 32) ; SP
	?m <- (http-month (value ?value&"Jan"|"Feb"|"Mar"|"Apr"|"May"|"Jun"|"Jul"|"Aug"|"Sep"|"Oct"|"Nov"|"Dec"))
	?d <- (http-date3 (name ?name) (month ?m))
	=>
	(retract ?c ?m)
	(modify ?d (month (make-instance of HTTP-MONTH (id ?name) (value ?value))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-date3-detect-padding
	?c <- (http-char ?name 32) ; SP
	?d <- (http-date3 (name ?name) (month ?m&:(instancep ?m)) (day "") (padded FALSE))
	=>
	(retract ?c)
	(modify ?d (padded TRUE))
	(assert (http-char ?name (http-read ?name))))

(defrule http-date3-build-2digit-day
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?d <- (http-date3 (name ?name) (month ?m&:(instancep ?m)) (day ?day&:(> 2 (str-length ?day))) (padded FALSE))
	=>
	(retract ?c)
	(modify ?d (day (format nil "%s%c" ?day ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-date3-build-1digit-day
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?d <- (http-date3 (name ?name) (day "") (padded TRUE))
	=>
	(retract ?c)
	(modify ?d (day (format nil "%c" ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-asctime-date-end-date3-2digit
	(http-char ?name 32) ; SP
	?d <- (http-date3 (month ?month) (day ?day&:(= 2 (str-length ?day))) (padded FALSE))
	?a <- (http-asctime-date (name ?name) (date3 ?d))
	=>
	(retract ?d)
	(modify ?a (date3 (make-instance of HTTP-DATE3 (id ?name) (month ?month) (day ?day) (padded FALSE)))))

(defrule http-asctime-date-end-date3-1digit
	(http-char ?name 32) ; SP
	?d <- (http-date3 (month ?month) (day ?day&:(= 1 (str-length ?day))) (padded TRUE))
	?a <- (http-asctime-date (name ?name) (date3 ?d))
	=>
	(retract ?d)
	(modify ?a (date3 (make-instance of HTTP-DATE3 (id ?name) (month ?month) (day ?day) (padded TRUE)))))

(defrule http-asctime-date-start-time
	?c <- (http-char ?name 32) ; SP
	?a <- (http-asctime-date (name ?name) (date3 ?d&:(instancep ?d)) (time nil))
	=>
	(retract ?c)
	(modify ?a (time (assert (http-time (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-asctime-date-end-time
	?c <- (http-char ?name 32) ; SP
	?t <- (http-time (name ?name) (first-2digit ?first) (second-2digit ?second) (third-2digit ?third&:(= 2 (str-length ?third))))
	?a <- (http-asctime-date (name ?name) (time ?t))
	=>
	(retract ?c ?t)
	(modify ?a (time (make-instance of HTTP-TIME (id ?name) (first-2digit ?first) (second-2digit ?second) (third-2digit ?third))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-asctime-date-build-year
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?a <- (http-asctime-date (name ?name) (time ?t&:(instancep ?t)) (year ?year&:(> 4 (str-length ?year))))
	=>
	(retract ?c)
	(modify ?a (year (format nil "%s%c" ?year ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-date-header-end-asctime-date
	(http-char ?name 9|13|32) ; HTAB CR SP
	?a <- (http-asctime-date (name ?name) (day-name ?day-name) (date3 ?date3) (time ?time) (year ?year&:(= 4 (str-length ?year))))
	?h <- (http-date-header (name ?name) (http-date ?a))
	=>
	(retract ?a)
	(modify ?h (http-date (make-instance of HTTP-ASCTIME-DATE (id ?name) (day-name ?day-name) (date3 ?date3) (time ?time) (year ?year)))))

(defrule http-end-date-header
	(http-char ?name 9|13|32) ; HTAB CR SP
	?h <- (http-date-header (name ?name) (http-date ?d&:(instancep ?d)))
	?fv <- (http-field-value (value ?h))
	(http-field-line (field-name ?fn) (field-value ?fv))
	(object (is-a HTTP-FIELD-NAME) (name ?fn) (value "Date"))
	=>
	(retract ?h)
	(modify ?fv (value (make-instance of HTTP-DATE (id ?name) (http-date ?d)))))

(defrule http-end-last-modified-header
	(http-char ?name 9|13|32) ; HTAB CR SP
	?h <- (http-date-header (name ?name) (http-date ?d&:(instancep ?d)))
	?fv <- (http-field-value (value ?h))
	(http-field-line (field-name ?fn) (field-value ?fv))
	(object (is-a HTTP-FIELD-NAME) (name ?fn) (value "Last-Modified"))
	=>
	(retract ?h)
	(modify ?fv (value (make-instance of HTTP-LAST-MODIFIED-HEADER (id ?name) (http-date ?d)))))

(defrule http-end-if-modified-since-header
	(http-char ?name 9|13|32) ; HTAB CR SP
	?h <- (http-date-header (name ?name) (http-date ?d&:(instancep ?d)))
	?fv <- (http-field-value (value ?h))
	(http-field-line (field-name ?fn) (field-value ?fv))
	(object (is-a HTTP-FIELD-NAME) (name ?fn) (value "If-Modified-Since"))
	=>
	(retract ?h)
	(modify ?fv (value (make-instance of HTTP-IF-MODIFIED-SINCE-HEADER (id ?name) (http-date ?d)))))

(defrule http-end-if-unmodified-since-header
	(http-char ?name 9|13|32) ; HTAB CR SP
	?h <- (http-date-header (name ?name) (http-date ?d&:(instancep ?d)))
	?fv <- (http-field-value (value ?h))
	(http-field-line (field-name ?fn) (field-value ?fv))
	(object (is-a HTTP-FIELD-NAME) (name ?fn) (value "If-Unmodified-Since"))
	=>
	(retract ?h)
	(modify ?fv (value (make-instance of HTTP-IF-UNMODIFIED-SINCE-HEADER (id ?name) (http-date ?d)))))

;   ETag          = entity-tag
;   entity-tag    = [ weak ] opaque-tag
;   weak          = %s"W/"
;   opaque-tag    = DQUOTE *etagc DQUOTE
;   etagc         = %x21 / %x23-7E / obs-text
; The entity-tag fact is built by rules keyed only on the fact itself, so the
; same builder serves ETag, If-Match, If-None-Match and If-Range. Only the
; rule that closes the tag differs per owning header.
(defrule http-entity-tag-detect-weak
	?c <- (http-char ?name 87) ; W
	?e <- (http-entity-tag (name ?name) (weak FALSE) (opaque-tag nil))
	=>
	(retract ?c)
	(modify ?e (weak "W"))
	(assert (http-char ?name (http-read ?name))))

(defrule http-entity-tag-end-weak
	?c <- (http-char ?name 47) ; /
	?e <- (http-entity-tag (name ?name) (weak "W") (opaque-tag nil))
	=>
	(retract ?c)
	(modify ?e (weak TRUE))
	(assert (http-char ?name (http-read ?name))))

(defrule http-entity-tag-start-opaque-tag
	?c <- (http-char ?name 34) ; "
	?e <- (http-entity-tag (name ?name) (weak FALSE|TRUE) (opaque-tag nil))
	=>
	(retract ?c)
	(modify ?e (opaque-tag ""))
	(assert (http-char ?name (http-read ?name))))

(defrule http-build-opaque-tag
	?c <- (http-char ?name ?char)
	?e <- (http-entity-tag (name ?name) (opaque-tag ?value&:(stringp ?value)))
	(test (or
		(= ?char 33) ; !
		(and (>= ?char 35) (<= ?char 126)) ; %x23-7E
		(and (>= ?char 128) (<= ?char 255)))) ; obs-text
	=>
	(retract ?c)
	(modify ?e (opaque-tag (format nil "%s%c" ?value ?char)))
	(assert (http-char ?name (http-read ?name))))

; ETag = entity-tag
(defrule http-detect-etag-header
	(http-char ?name 34|87) ; " W
	?o <- (object (is-a HTTP-FIELD-NAME) (value "ETag"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-etag-header (name ?name) (entity-tag (assert (http-entity-tag (name ?name)))))))))

(defrule http-etag-header-end-entity-tag
	?c <- (http-char ?name 34) ; "
	?e <- (http-entity-tag (name ?name) (weak ?weak) (opaque-tag ?value&:(stringp ?value)))
	?h <- (http-etag-header (name ?name) (entity-tag ?e))
	=>
	(retract ?c ?e)
	(modify ?h (entity-tag (make-instance of HTTP-ENTITY-TAG (id ?name) (weak ?weak) (opaque-tag ?value))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-etag-header-skip-ows-after-entity-tag
	?c <- (http-char ?name 9|32) ; HTAB SP
	(http-etag-header (name ?name) (entity-tag ?e&:(instancep ?e)))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-etag-header
	(http-char ?name 13) ; CR
	?h <- (http-etag-header (name ?name) (entity-tag ?e&:(instancep ?e)))
	?fv <- (http-field-value (value ?h))
	=>
	(retract ?h)
	(modify ?fv (value (make-instance of HTTP-ETAG-HEADER (id ?name) (entity-tag ?e)))))

;   If-Match      = "*" / #entity-tag
;   If-None-Match = "*" / #entity-tag
(defrule http-detect-entity-tag-list-header
	(http-char ?name 34|87) ; " W
	?o <- (object (is-a HTTP-FIELD-NAME) (value "If-Match"|"If-None-Match"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-entity-tag-list-header (name ?name) (entity-tags (assert (http-entity-tag (name ?name)))))))))

(defrule http-detect-entity-tag-list-header-star
	?c <- (http-char ?name 42) ; *
	?o <- (object (is-a HTTP-FIELD-NAME) (value "If-Match"|"If-None-Match"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(retract ?c)
	(modify ?fv (value (assert (http-entity-tag-list-header (name ?name) (entity-tags "*")))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-entity-tag-list-header-end-entity-tag
	?c <- (http-char ?name 34) ; "
	?e <- (http-entity-tag (name ?name) (weak ?weak) (opaque-tag ?value&:(stringp ?value)))
	?h <- (http-entity-tag-list-header (name ?name) (entity-tags $?entity-tags ?e))
	=>
	(retract ?c ?e)
	(modify ?h (entity-tags ?entity-tags (make-instance of HTTP-ENTITY-TAG (id ?name) (weak ?weak) (opaque-tag ?value))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-entity-tag-list-header-detect-next-entity-tag
	?c <- (http-char ?name 44) ; ,
	?h <- (http-entity-tag-list-header (name ?name) (entity-tags $?entity-tags ?e&:(instancep ?e)))
	=>
	(retract ?c)
	(modify ?h (entity-tags ?entity-tags ?e (assert (http-entity-tag (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-entity-tag-list-header-skip-ows-before-entity-tag
	?c <- (http-char ?name 9|32) ; HTAB SP
	?e <- (http-entity-tag (name ?name) (weak FALSE) (opaque-tag nil))
	(http-entity-tag-list-header (name ?name) (entity-tags $?entity-tags ?e))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-entity-tag-list-header-skip-ows-after-entity-tag
	?c <- (http-char ?name 9|32) ; HTAB SP
	(http-entity-tag-list-header (name ?name) (entity-tags $?entity-tags ?e&"*"|:(instancep ?e)))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-if-match-header
	(http-char ?name 13) ; CR
	?h <- (http-entity-tag-list-header (name ?name) (entity-tags $?entity-tags ?e&"*"|:(instancep ?e)))
	?fv <- (http-field-value (value ?h))
	(http-field-line (field-name ?fn) (field-value ?fv))
	(object (is-a HTTP-FIELD-NAME) (name ?fn) (value "If-Match"))
	=>
	(retract ?h)
	(modify ?fv (value (make-instance of HTTP-IF-MATCH-HEADER (id ?name) (entity-tags ?entity-tags ?e)))))

(defrule http-end-if-none-match-header
	(http-char ?name 13) ; CR
	?h <- (http-entity-tag-list-header (name ?name) (entity-tags $?entity-tags ?e&"*"|:(instancep ?e)))
	?fv <- (http-field-value (value ?h))
	(http-field-line (field-name ?fn) (field-value ?fv))
	(object (is-a HTTP-FIELD-NAME) (name ?fn) (value "If-None-Match"))
	=>
	(retract ?h)
	(modify ?fv (value (make-instance of HTTP-IF-NONE-MATCH-HEADER (id ?name) (entity-tags ?entity-tags ?e)))))

;   If-Range = entity-tag / HTTP-date
; The first character picks the branch: DQUOTE is an entity-tag, F M S T start
; a day name. W is ambiguous (W/"..." or Wed,...), so it is consumed and the
; next character decides.
(defrule http-detect-if-range-header-entity-tag
	(http-char ?name 34) ; "
	?o <- (object (is-a HTTP-FIELD-NAME) (value "If-Range"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-if-range-header (name ?name) (value (assert (http-entity-tag (name ?name)))))))))

(defrule http-detect-if-range-header-http-date
	(http-char ?name 70|77|83|84) ; F M S T
	?o <- (object (is-a HTTP-FIELD-NAME) (value "If-Range"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-if-range-header (name ?name) (value (assert (http-date-header (name ?name) (http-date (assert (http-day-name (name ?name))))))))))))

(defrule http-detect-if-range-header-W
	?c <- (http-char ?name 87) ; W
	?o <- (object (is-a HTTP-FIELD-NAME) (value "If-Range"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(retract ?c)
	(modify ?fv (value (assert (http-if-range-header (name ?name) (value W)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-if-range-header-W-is-weak-entity-tag
	?c <- (http-char ?name 47) ; /
	?h <- (http-if-range-header (name ?name) (value W))
	=>
	(retract ?c)
	(modify ?h (value (assert (http-entity-tag (name ?name) (weak TRUE)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-if-range-header-W-is-day-name
	(http-char ?name 101) ; e
	?h <- (http-if-range-header (name ?name) (value W))
	=>
	(modify ?h (value (assert (http-date-header (name ?name) (http-date (assert (http-day-name (name ?name) (value "W")))))))))

(defrule http-if-range-header-end-entity-tag
	?c <- (http-char ?name 34) ; "
	?e <- (http-entity-tag (name ?name) (weak ?weak) (opaque-tag ?value&:(stringp ?value)))
	?h <- (http-if-range-header (name ?name) (value ?e))
	=>
	(retract ?c ?e)
	(modify ?h (value (make-instance of HTTP-ENTITY-TAG (id ?name) (weak ?weak) (opaque-tag ?value))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-if-range-header-end-http-date
	(http-char ?name 9|13|32) ; HTAB CR SP
	?d <- (http-date-header (name ?name) (http-date ?date&:(instancep ?date)))
	?h <- (http-if-range-header (name ?name) (value ?d))
	=>
	(retract ?d)
	(modify ?h (value ?date)))

(defrule http-if-range-header-skip-ows-after-value
	?c <- (http-char ?name 9|32) ; HTAB SP
	(http-if-range-header (name ?name) (value ?v&:(instancep ?v)))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-if-range-header
	(http-char ?name 13) ; CR
	?h <- (http-if-range-header (name ?name) (value ?v&:(instancep ?v)))
	?fv <- (http-field-value (value ?h))
	=>
	(retract ?h)
	(modify ?fv (value (make-instance of HTTP-IF-RANGE-HEADER (id ?name) (value ?v)))))

(defrule http-end-content-type-header
	(http-char ?name 13)
	?cth <- (http-content-type-header (name ?name) (type ?type&:(instancep ?type)) (subtype ?subtype&:(instancep ?subtype)) (parameters $?parameters&:(= 0 (length$ ?parameters))|:(instancep (nth$ (length$ ?parameters) ?parameters))))
	?f <- (http-field-value (value ?cth))
	=>
	(retract ?cth)
	(modify ?f (value (make-instance of HTTP-CONTENT-TYPE-HEADER (id ?name) (type ?type) (subtype ?subtype) (parameters ?parameters)))))

;   ext-value = charset "'" [ language ] "'" value-chars (RFC 8187 3.2.1)
; the value of a parameter whose name is an ext-token
(defrule http-parameter-detect-parameter-value-ext-value
	(http-char ?name ?char&:(member$ ?char ?*http-mime-charsetc*))
	?p <- (http-parameter (name ?name) (parameter-name ?parameter-name&:(stringp ?parameter-name)) (ext-token TRUE) (parameter-value nil))
	=>
	(modify ?p (parameter-value (assert (http-ext-value (name ?name))))))

(defrule http-build-ext-value-charset
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-mime-charsetc*))
	?e <- (http-ext-value (name ?name) (charset ?charset) (language nil))
	=>
	(retract ?c)
	(modify ?e (charset (format nil "%s%c" ?charset ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-ext-value-end-charset
	?c <- (http-char ?name 39) ; '
	?e <- (http-ext-value (name ?name) (charset ~"") (language nil))
	=>
	(retract ?c)
	(modify ?e (language ""))
	(assert (http-char ?name (http-read ?name))))

(defrule http-build-ext-value-language
	?c <- (http-char ?name ?char&45|:(member$ ?char ?*http-alphanum*)) ; -
	?e <- (http-ext-value (name ?name) (language ?language&:(stringp ?language)) (value-chars nil))
	=>
	(retract ?c)
	(modify ?e (language (format nil "%s%c" ?language ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-ext-value-end-language
	?c <- (http-char ?name 39) ; '
	?e <- (http-ext-value (name ?name) (language ?language&:(stringp ?language)) (value-chars nil))
	=>
	(retract ?c)
	(modify ?e (value-chars ""))
	(assert (http-char ?name (http-read ?name))))

(defrule http-build-ext-value-value-chars
	?c <- (http-char ?name ?char&37|:(member$ ?char ?*http-attr-char*)) ; %
	?e <- (http-ext-value (name ?name) (value-chars ?value-chars&:(stringp ?value-chars)))
	=>
	(retract ?c)
	(modify ?e (value-chars (format nil "%s%c" ?value-chars ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-parameter-end-parameter-value-ext-value
	(http-char ?name 9|13|32|44|59) ; HTAB CR SP , ;
	?e <- (http-ext-value (name ?name) (charset ?charset) (language ?language) (value-chars ?value-chars&:(stringp ?value-chars)))
	?p <- (http-parameter (parameter-value ?e))
	=>
	(retract ?e)
	(modify ?p (parameter-value (make-instance of HTTP-EXT-VALUE (id ?name) (charset ?charset) (language ?language) (value-chars ?value-chars)))))

;   Content-Disposition = disposition-type *( ";" disposition-parm ) (RFC 6266 4.1)
; the parameters are built by the shared parameter rules above
(defrule http-detect-content-disposition-header
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Content-Disposition"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-content-disposition-header (name ?name) (disposition-type (assert (http-token (name ?name)))))))))

(defrule http-content-disposition-header-end-disposition-type
	(http-char ?name 9|13|32|59) ; HTAB CR SP ;
	?t <- (http-token (name ?name) (value ?value&~""))
	?h <- (http-content-disposition-header (name ?name) (disposition-type ?t))
	=>
	(retract ?t)
	(modify ?h (disposition-type ?value)))

(defrule http-content-disposition-header-detect-parameter
	?c <- (http-char ?name 59) ; ;
	?h <- (http-content-disposition-header (name ?name) (disposition-type ?d&:(stringp ?d)) (parameters $?parameters&:(= 0 (length$ ?parameters))|:(instancep (nth$ (length$ ?parameters) ?parameters))))
	=>
	(retract ?c)
	(modify ?h (parameters ?parameters (assert (http-parameter (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-content-disposition-header-skip-ows
	?c <- (http-char ?name 9|32) ; HTAB SP
	(http-content-disposition-header (name ?name) (disposition-type ?d&:(stringp ?d)) (parameters $?parameters&:(= 0 (length$ ?parameters))|:(instancep (nth$ (length$ ?parameters) ?parameters))))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-content-disposition-header-end-parameter
	(http-char ?name 9|13|32|59) ; HTAB CR SP ;
	?p <- (http-parameter (parameter-name ?t&:(stringp ?t)) (ext-token ?ext-token) (parameter-value ?parameter-value&:(instancep ?parameter-value)|:(stringp ?parameter-value)))
	?h <- (http-content-disposition-header (name ?name) (parameters $?parameters ?p))
	=>
	(retract ?p)
	(modify ?h (parameters ?parameters (make-instance of HTTP-PARAMETER (id ?name) (parameter-name ?t) (ext-token ?ext-token) (parameter-value ?parameter-value)))))

(defrule http-end-content-disposition-header
	(http-char ?name 13) ; CR
	?h <- (http-content-disposition-header (name ?name) (disposition-type ?d&:(stringp ?d)) (parameters $?parameters&:(= 0 (length$ ?parameters))|:(instancep (nth$ (length$ ?parameters) ?parameters))))
	?f <- (http-field-value (value ?h))
	=>
	(retract ?h)
	(modify ?f (value (make-instance of HTTP-CONTENT-DISPOSITION-HEADER (id ?name) (disposition-type ?d) (parameters ?parameters)))))

(defrule http-end-host-header
	(http-char ?name 13|32) ; CR SP
	?hh <- (http-host-header (name ?name) (uri-host ?h&:(instancep ?h)) (port ?p&nil|:(instancep ?p)))
	?f <- (http-field-value (value ?hh))
	=>
	(retract ?hh)
	(modify ?f (value (make-instance of HTTP-HOST-HEADER (id ?name) (uri-host ?h) (port ?p)))))

;
;  Authorization = credentials
;  Proxy-Authorization = credentials
;  credentials = auth-scheme [ 1*SP ( token68 / [ auth-param *( OWS "," OWS auth-param ) ] ) ]
;  auth-scheme = token
;  token68 = 1*( ALPHA / DIGIT / "-" / "." / "_" / "~" / "+" / "/" ) *"="
;  auth-param = token BWS "=" BWS ( token / quoted-string )
; Authorization (RFC 9110 11.6.2) and Proxy-Authorization (11.7.2) share the
; credentials grammar, so the same proxy-authorization-header fact and rules
; build both; only the end rule differs.
(defrule http-detect-proxy-authorization-header
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Authorization"|"Proxy-Authorization"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-proxy-authorization-header (name ?name) (auth-scheme (assert (http-token (name ?name)))))))))

(defrule http-proxy-authorization-header-end-auth-scheme
	(http-char ?name 9|13|32) ; HTAB CR SP
	?t <- (http-token (value ?value))
	?p <- (http-proxy-authorization-header (name ?name) (auth-scheme ?t))
	=>
	(retract ?t)
	(modify ?p (auth-scheme ?value)))

(defrule http-proxy-authorization-detect-second-part-after-auth-scheme
	?c <- (http-char ?name 32) ; SP
	?p <- (http-proxy-authorization-header (name ?name) (auth-scheme ?auth-scheme&:(stringp ?auth-scheme)) (second-part))
	=>
	(retract ?c)
	(modify ?p (second-part (assert (http-token68 (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-proxy-authorization-skip-sp-after-auth-scheme
	?c <- (http-char ?name 32) ; SP
	?t <- (http-token68 (name ?name) (value ""))
	(http-proxy-authorization-header (name ?name) (second-part ?t))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-build-token68
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-token68*))
	?t <- (http-token68 (name ?name) (value ?value) (equals 0))
	=>
	(retract ?c)
	(modify ?t (value (format nil "%s%c" ?value ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-token68-detect-equals
	?c <- (http-char ?name 61) ; =
	?t <- (http-token68 (name ?name) (value ?value) (equals ?equals))
	=>
	(retract ?c)
	(modify ?t (equals (+ 1 ?equals)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-proxy-authorization-end-token68
	(http-char ?name 9|13|32) ; HTAB CR SP
	?t <- (http-token68 (name ?name) (value ?value&~"") (equals ?equals))
	?p <- (http-proxy-authorization-header (name ?name) (second-part ?t))
	=>
	(retract ?t)
	(modify ?p (second-part (make-instance of HTTP-TOKEN68 (id ?name) (value ?value) (equals ?equals)))))

(defrule http-proxy-authorization-change-token68-to-auth-param
	(http-char ?name ?char&~:(member$ ?char ?*http-token68*)&:(member$ ?char ?*http-tchar*))
	?t <- (http-token68 (name ?name) (value ?value) (equals 0))
	?p <- (http-proxy-authorization-header (name ?name) (second-part ?t))
	=>
	(retract ?t)
	(modify ?p (second-part (assert (http-auth-param (name ?name) (left-side (assert (http-token (name ?name) (value ?value)))))))))

(defrule http-proxy-authorization-change-token68-to-auth-param-after-equals
	(http-char ?name ?char&~:(member$ ?char ?*http-token68*)&:(member$ ?char ?*http-tchar*))
	?t <- (http-token68 (name ?name) (value ?value&~:(str-index "/" ?value)) (equals 1))
	?p <- (http-proxy-authorization-header (name ?name) (second-part ?t))
	=>
	(retract ?t)
	(modify ?p (second-part (assert (http-auth-param (name ?name) (left-side ?value) (right-side (assert (http-token (name ?name)))))))))

(defrule http-auth-param-end-left-side
	?c <- (http-char ?name 61) ; =
	?t <- (http-token (value ?value))
	?a <- (http-auth-param (name ?name) (left-side ?t))
	=>
	(retract ?c ?t)
	(modify ?a (left-side ?value) (right-side (assert (http-token (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-auth-param-end-left-side
	(http-char ?name 9|13|32|44) ; HTAB CR SP ,
	?t <- (http-token (value ?value))
	?a <- (http-auth-param (name ?name) (right-side ?t))
	=>
	(retract ?t)
	(modify ?a (right-side ?value)))

(defrule http-proxy-authorization-header-end-auth-param
	(http-char ?name 9|13|32|44) ; HTAB CR SP ,
	?a <- (http-auth-param (name ?name) (left-side ?left-side) (right-side ?right-side&:(stringp ?right-side)))
	?p <- (http-proxy-authorization-header (name ?name) (second-part $?auth-params ?a))
	=>
	(retract ?a)
	(modify ?p (second-part ?auth-params (make-instance of HTTP-AUTH-PARAM (id ?name) (left-side ?left-side) (right-side ?right-side)))))

(defrule http-proxy-authorization-header-detext-next-auth-param
	?c <- (http-char ?name 44) ; ,
	?auth-param <- (object (is-a HTTP-AUTH-PARAM))
	?p <- (http-proxy-authorization-header (name ?name) (second-part $?auth-params ?auth-param))
	=>
	(retract ?c)
	(modify ?p (second-part ?auth-params ?auth-param (assert (http-auth-param (name ?name) (left-side (assert (http-token (name ?name)))))))))

(defrule http-proxy-authorization-header-skip-ows-after-auth-param
	?c <- (http-char ?name 9|32) ; HTAB SP
	?clh <- (http-proxy-authorization-header (name ?name) (auth-scheme ?auth-scheme) (second-part $?auth-params&:(instancep (nth$ (length$ ?auth-params) ?auth-params))))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-authorization-header
	(http-char ?name 13) ; CR
	?clh <- (http-proxy-authorization-header (name ?name) (auth-scheme ?auth-scheme) (second-part $?auth-params&:(instancep (nth$ (length$ ?auth-params) ?auth-params))))
	?fv <- (http-field-value (value ?clh))
	(http-field-line (field-name ?fn) (field-value ?fv))
	(object (is-a HTTP-FIELD-NAME) (name ?fn) (value "Authorization"))
	=>
	(retract ?clh)
	(modify ?fv (value (make-instance of HTTP-AUTHORIZATION-HEADER (id ?name) (auth-scheme ?auth-scheme) (second-part ?auth-params)))))

(defrule http-end-proxy-authorization-header
	(http-char ?name 13) ; CR
	?clh <- (http-proxy-authorization-header (name ?name) (auth-scheme ?auth-scheme) (second-part $?auth-params&:(instancep (nth$ (length$ ?auth-params) ?auth-params))))
	?fv <- (http-field-value (value ?clh))
	(http-field-line (field-name ?fn) (field-value ?fv))
	(object (is-a HTTP-FIELD-NAME) (name ?fn) (value "Proxy-Authorization"))
	=>
	(retract ?clh)
	(modify ?fv (value (make-instance of HTTP-PROXY-AUTHORIZATION-HEADER (id ?name) (auth-scheme ?auth-scheme) (second-part ?auth-params)))))

;   TE                 = #t-codings
;  t-codings          = "trailers" / ( transfer-coding [ weight ] )
;  transfer-coding    = token *( OWS ";" OWS transfer-parameter )
;  transfer-parameter = token BWS "=" BWS ( token / quoted-string )

(defrule http-detect-te-header
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?o <- (object (is-a HTTP-FIELD-NAME) (value "TE"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-te-header (name ?name) (t-codings (assert (http-t-coding (name ?name) (value (assert (http-token (name ?name))))))))))))

(defrule http-t-coding-end-value
	(http-char ?name 9|13|32|44|59) ; HTAB CR SP , ;
	?t <- (http-token (name ?name) (value ?value))
	?t-coding <- (http-t-coding (name ?name) (value ?t))
	=>
	(retract ?t)
	(modify ?t-coding (value ?value)))

(defrule http-t-coding-ignore-ows-before-weight
	?c <- (http-char ?name 9|32) ; HTAB SP
	?l <- (http-t-coding (name ?name) (value ?value&:(stringp ?value)) (weight nil))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-t-coding-detect-weight
	?c <- (http-char ?name 59) ; ;
	?t <- (http-t-coding (name ?name) (value ?value&:(stringp ?value)&~"trailers") (weight nil))
	=>
	(retract ?c)
	(modify ?t (weight (assert (http-weight (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-t-coding-end-weight
	(http-char ?name 9|13|32|44) ; HTAB CR SP ,
	?w <- (http-weight (name ?name) (qvalue ?q&:(instancep ?q)))
	?t <- (http-t-coding (name ?name) (weight ?w))
	=>
	(retract ?w)
	(modify ?t (weight (make-instance of HTTP-WEIGHT (id ?name) (qvalue ?q)))))

(defrule http-te-header-end-t-coding
	(http-char ?name ?char&9|13|32|44) ; HTAB CR SP ,
	?t <- (http-t-coding (name ?name) (value ?value&:(stringp ?value)) (weight ?w&nil|:(instancep ?w)))
	?te <- (http-te-header (t-codings $?t-codings ?t))
	;; OWS before a weight is skipped, since ";" might follow it; it ends the t-coding only after the weight
	(test (or (eq ?char 13) (eq ?char 44) (instancep ?w)))
	=>
	(retract ?t)
	(modify ?te (t-codings ?t-codings (make-instance of HTTP-T-CODING (id ?name) (value ?value) (weight ?w)))))

(defrule http-te-header-detect-next-t-coding
	?c <- (http-char ?name 44) ; ,
	?t <- (http-te-header (name ?name) (t-codings $?t-codings ?t-coding&:(instancep ?t-coding)))
	=>
	(retract ?c)
	(modify ?t (t-codings ?t-codings ?t-coding (assert (http-t-coding (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-te-header-ignore-ows-before-next-t-coding
	?c <- (http-char ?name 9|32) ; HTAB SP
	?t <- (http-t-coding (name ?name) (value nil))
	?te <- (http-te-header (t-codings $?t-codings ?t))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-te-header-ignore-ows-after-last-t-coding
	?c <- (http-char ?name 9|32) ; HTAB SP
	?clh <- (http-te-header (name ?name) (t-codings $?t-codings&:(instancep (nth$ (length$ ?t-codings) ?t-codings))))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-te-header-detect-next-t-coding-value
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?t <- (http-t-coding (name ?name) (value nil))
	=>
	(modify ?t (value (assert (http-token (name ?name))))))

(defrule http-end-te-header
	(http-char ?name 13) ; CR
	?clh <- (http-te-header (name ?name) (t-codings $?t-codings&:(instancep (nth$ (length$ ?t-codings) ?t-codings))))
	?fv <- (http-field-value (value ?clh))
	=>
	(retract ?clh)
	(modify ?fv (value (make-instance of HTTP-TE-HEADER (id ?name) (t-codings ?t-codings)))))

; range-set = range-spec *( OWS "," OWS range-spec )
; range-spec = int-range / suffix-range / other-range
; range-unit = token
; ranges-specifier = range-unit "=" range-set
;  Range = ranges-specifier
(defrule http-detect-range-header
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Range"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-range-header (name ?name) (ranges-specifier (assert (http-ranges-specifier (name ?name) (range-unit (assert (http-token (name ?name))))))))))))

(defrule http-ranges-specifier-end-range-unit
	?c <- (http-char ?name 61) ; =
	?t <- (http-token (name ?name) (value ?value))
	?r <- (http-ranges-specifier (name ?name) (range-unit ?t))
	=>
	(retract ?c ?t)
	(modify ?r (range-unit ?value) (range-set (assert (http-range-set (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

; int-range = first-pos "-" [ last-pos ]
; other-range = 1*( %x21-2B ; '!'-'+'
;                 / %x2D-7E ; '-'-'~'
;                 )
;suffix-range = "-" suffix-length
; 
; first-pos = 1*DIGIT
; last-pos = 1*DIGIT
; suffix-length = 1*DIGIT
(defrule http-range-set-detect-first-range-spec
	(http-char ?name ?char&:(member$ ?char ?*http-other-range*))
	?r <- (http-range-set (name ?name) (range-specs))
	=>
	(modify ?r (range-specs (assert (http-range-spec (name ?name))))))

(defrule http-range-spec-detect-int-range
	(http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?r <- (http-range-spec (name ?name) (value nil))
	=>
	(modify ?r (value (assert (http-int-range (name ?name))))))

(defrule http-range-spec-int-range-change-to-other-range-during-first-pos
	(http-char ?name ?char&~45&~:(member$ ?char ?*http-digit*)&:(member$ ?char ?*http-other-range*))
	?i <- (http-int-range (first-pos ?first-pos&~"") (last-pos nil))
	?r <- (http-range-spec (name ?name) (value ?i))
	=>
	(retract ?i)
	(modify ?r (value (assert (http-other-range (name ?name) (value ?first-pos))))))

(defrule http-range-spec-int-range-change-to-other-range-during-last-pos
	(http-char ?name ?char&~:(member$ ?char ?*http-digit*)&:(member$ ?char ?*http-other-range*))
	?i <- (http-int-range (first-pos ?first-pos) (last-pos ?last-pos&~nil))
	?r <- (http-range-spec (name ?name) (value ?i))
	=>
	(retract ?i)
	(modify ?r (value (assert (http-other-range (name ?name) (value (format nil "%s-%s" ?first-pos ?last-pos)))))))

(defrule http-range-spec-suffix-range-change-to-other-range
	(http-char ?name ?char&~:(member$ ?char ?*http-digit*)&:(member$ ?char ?*http-other-range*))
	?s <- (http-suffix-range (name ?name) (suffix-length ?suffix-length))
	?r <- (http-range-spec (value ?o))
	=>
	(retract ?s)
	(modify ?r (value (assert (http-other-range (name ?name) (value (format nil "-%s" ?suffix-length)))))))

(defrule http-range-spec-detect-suffix-range
	?c <- (http-char ?name 45) ; -
	?r <- (http-range-spec (name ?name) (value nil))
	=>
	(retract ?c)
	(modify ?r (value (assert (http-suffix-range (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-range-spec-detect-other-range
	?c <- (http-char ?name ?char&~45&~:(member$ ?char ?*http-digit*)&:(member$ ?char ?*http-other-range*)) ; -
	?r <- (http-range-spec (name ?name) (value nil))
	=>
	(retract ?c)
	(modify ?r (value (assert (http-other-range (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-build-other-range
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-other-range*))
	?o <- (http-other-range (name ?name) (value ?value))
	=>
	(retract ?c)
	(modify ?o (value (format nil "%s%c" ?value ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-other-range
	(http-char ?name 9|13|32|44) ; HTAB CR SP ,
	?o <- (http-other-range (name ?name) (value ?value))
	?r <- (http-range-spec (value ?o))
	=>
	(retract ?o)
	(modify ?r (value (make-instance of HTTP-OTHER-RANGE (id ?name) (value ?value)))))

(defrule http-build-suffix-range
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?s <- (http-suffix-range (name ?name) (suffix-length ?suffix-length))
	=>
	(retract ?c)
	(modify ?s (suffix-length (format nil "%s%c" ?suffix-length ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-suffix-range
	(http-char ?name 9|13|32|44) ; HTAB CR SP ,
	?s <- (http-suffix-range (name ?name) (suffix-length ?suffix-length))
	?r <- (http-range-spec (value ?s))
	=>
	(retract ?s)
	(modify ?r (value (make-instance of HTTP-SUFFIX-RANGE (id ?name) (suffix-length ?suffix-length)))))

(defrule http-int-range-build-first-pos
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?i <- (http-int-range (name ?name) (first-pos ?value) (last-pos nil))
	=>
	(retract ?c)
	(modify ?i (first-pos (format nil "%s%c" ?value ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-int-range-detect-last-pos
	?c <- (http-char ?name 45) ; -
	?i <- (http-int-range (name ?name) (first-pos ?value) (last-pos nil))
	=>
	(retract ?c)
	(modify ?i (last-pos ""))
	(assert (http-char ?name (http-read ?name))))

(defrule http-int-range-build-last-pos
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?i <- (http-int-range (name ?name) (last-pos ?value&~nil))
	=>
	(retract ?c)
	(modify ?i (last-pos (format nil "%s%c" ?value ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-int-range
	(http-char ?name 9|13|32|44) ; HTAB CR SP ,
	?i <- (http-int-range (name ?name) (first-pos ?first-pos) (last-pos ?last-pos&~nil))
	?r <- (http-range-spec (value ?i))
	=>
	(retract ?i)
	(modify ?r (value (make-instance of HTTP-INT-RANGE (id ?name) (first-pos ?first-pos) (last-pos ?last-pos)))))

(defrule http-end-range-spec
	(http-char ?name 9|13|32|44) ; HTAB CR SP ,
	?r <- (http-range-spec (value ?value&:(instancep ?value)))
	?range-set <- (http-range-set (range-specs $?range-specs ?r))
	=>
	(retract ?r)
	(modify ?range-set (range-specs ?range-specs (make-instance of HTTP-RANGE-SPEC (id ?name) (value ?value)))))

(defrule http-range-set-skip-ows-after-range-spec
	?c <- (http-char ?name 9|32) ; HTAB SP
	(http-range-set (range-specs $?range-specs ?range-spec&:(instancep ?range-spec)))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-range-set-detect-next-range-spec
	?c <- (http-char ?name 44)
	?r <- (http-range-set (name ?name) (range-specs $?range-specs ?range-spec&:(instancep ?range-spec)))
	=>
	(retract ?c)
	(modify ?r (range-specs ?range-specs ?range-spec (assert (http-range-spec (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-range-set-skip-ows-before-next-range-spec
	?c <- (http-char ?name 9|32) ; HTAB SP
	?r <- (http-range-spec (value nil))
	(http-range-set (range-specs $?range-specs ?r))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-range-set
	(http-char ?name 13) ; CR
	?r <- (http-range-set (name ?name) (range-specs $?range-specs ?range-spec&:(instancep ?range-spec)))
	?ranges-specifier <- (http-ranges-specifier (range-set ?r))
	=>
	(retract ?r)
	(modify ?ranges-specifier (range-set (make-instance of HTTP-RANGE-SET (id ?name) (range-specs ?range-specs ?range-spec)))))

(defrule http-end-ranges-specifier
	(http-char ?name 13) ; CR
	?ranges-specifier <- (http-ranges-specifier (range-unit ?u&:(stringp ?u)) (range-set ?r&:(instancep ?r)))
	?range-header <- (http-range-header (name ?name) (ranges-specifier ?ranges-specifier))
	=>
	(retract ?ranges-specifier)
	(modify ?range-header (ranges-specifier (make-instance of HTTP-RANGES-SPECIFIER (id ?name) (range-unit ?u) (range-set ?r)))))

(defrule http-end-range-header
	(http-char ?name 13) ; CR
	?r <- (http-range-header (name ?name) (ranges-specifier ?ranges-specifier&:(instancep ?ranges-specifier)))
	?fv <- (http-field-value (value ?r))
	=>
	(retract ?r)
	(modify ?fv (value (make-instance of HTTP-RANGE-HEADER (id ?name) (ranges-specifier ?ranges-specifier)))))

; Content-Range = range-unit SP ( range-resp / unsatisfied-range )
(defrule http-detect-content-range-header
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Content-Range"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-content-range-header (name ?name) (range-unit (assert (http-token (name ?name)))))))))

(defrule http-content-range-header-end-range-unit
	?c <- (http-char ?name 32) ; SP
	?t <- (http-token (name ?name) (value ?value))
	?h <- (http-content-range-header (name ?name) (range-unit ?t))
	=>
	(retract ?c ?t)
	(modify ?h (range-unit ?value))
	(assert (http-char ?name (http-read ?name))))

; range-resp = incl-range "/" ( complete-length / "*" )
; incl-range = first-pos "-" last-pos
; the incl-range is built by the http-int-range first-pos and last-pos rules
(defrule http-content-range-header-detect-range-resp
	(http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?h <- (http-content-range-header (name ?name) (range-unit ?u&:(stringp ?u)) (range nil))
	=>
	(modify ?h (range (assert (http-range-resp (name ?name) (incl-range (assert (http-int-range (name ?name)))))))))

(defrule http-range-resp-end-incl-range
	?c <- (http-char ?name 47) ; /
	?i <- (http-int-range (name ?name) (first-pos ?first-pos) (last-pos ?last-pos&~nil))
	?r <- (http-range-resp (name ?name) (incl-range ?i))
	=>
	(retract ?c ?i)
	(modify ?r (incl-range (make-instance of HTTP-INCL-RANGE (id ?name) (first-pos ?first-pos) (last-pos ?last-pos))) (complete-length ""))
	(assert (http-char ?name (http-read ?name))))

; complete-length = 1*DIGIT
(defrule http-range-resp-build-complete-length
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?r <- (http-range-resp (name ?name) (complete-length ?complete-length&~nil&~"*"))
	=>
	(retract ?c)
	(modify ?r (complete-length (format nil "%s%c" ?complete-length ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-range-resp-unknown-complete-length
	?c <- (http-char ?name 42) ; *
	?r <- (http-range-resp (name ?name) (complete-length ""))
	=>
	(retract ?c)
	(modify ?r (complete-length "*"))
	(assert (http-char ?name (http-read ?name))))

(defrule http-content-range-header-end-range-resp
	(http-char ?name 9|13|32) ; HTAB CR SP
	?r <- (http-range-resp (name ?name) (incl-range ?i&:(instancep ?i)) (complete-length ?complete-length&~nil&~""))
	?h <- (http-content-range-header (name ?name) (range ?r))
	=>
	(retract ?r)
	(modify ?h (range (make-instance of HTTP-RANGE-RESP (id ?name) (incl-range ?i) (complete-length ?complete-length)))))

; unsatisfied-range = "*/" complete-length
(defrule http-content-range-header-detect-unsatisfied-range
	?c <- (http-char ?name 42) ; *
	?h <- (http-content-range-header (name ?name) (range-unit ?u&:(stringp ?u)) (range nil))
	=>
	(retract ?c)
	(modify ?h (range (assert (http-unsatisfied-range (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-unsatisfied-range-detect-complete-length
	?c <- (http-char ?name 47) ; /
	?u <- (http-unsatisfied-range (name ?name) (complete-length nil))
	=>
	(retract ?c)
	(modify ?u (complete-length ""))
	(assert (http-char ?name (http-read ?name))))

(defrule http-unsatisfied-range-build-complete-length
	?c <- (http-char ?name ?char&:(member$ ?char ?*http-digit*))
	?u <- (http-unsatisfied-range (name ?name) (complete-length ?complete-length&~nil))
	=>
	(retract ?c)
	(modify ?u (complete-length (format nil "%s%c" ?complete-length ?char)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-content-range-header-end-unsatisfied-range
	(http-char ?name 9|13|32) ; HTAB CR SP
	?u <- (http-unsatisfied-range (name ?name) (complete-length ?complete-length&~nil&~""))
	?h <- (http-content-range-header (name ?name) (range ?u))
	=>
	(retract ?u)
	(modify ?h (range (make-instance of HTTP-UNSATISFIED-RANGE (id ?name) (complete-length ?complete-length)))))

(defrule http-end-content-range-header
	(http-char ?name 9|13|32) ; HTAB CR SP
	?h <- (http-content-range-header (name ?name) (range-unit ?u&:(stringp ?u)) (range ?r&:(instancep ?r)))
	?fv <- (http-field-value (value ?h))
	=>
	(retract ?h)
	(modify ?fv (value (make-instance of HTTP-CONTENT-RANGE-HEADER (id ?name) (range-unit ?u) (range ?r)))))

(defrule http-ignore-ows-at-end-of-field-value
	?c <- (http-char ?name 9|32) ; HTAB SP
	(http-field-value (name ?name) (value ?v&:(instancep ?v)))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-field-value
	?c <- (http-char ?name 13) ; CR
	?fv <- (http-field-value (name ?name) (value ?v&:(instancep ?v)))
	?fl <- (http-field-line (field-value ?fv))
	=>
	(retract ?c ?fv)
	(modify ?fl (field-value (make-instance of HTTP-FIELD-VALUE (id ?name) (value ?v))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-field-line
	?c <- (http-char ?name 10) ; LF
	?f <- (http-field-line (field-name ?field-name) (field-value ?field-value&:(instancep ?field-value)))
	?h <- (http-message (name ?name) (field-lines $?field-lines ?f))
	=>
	(retract ?c ?f)
	(modify ?h (field-lines ?field-lines (make-instance of HTTP-FIELD-LINE (id ?name) (field-name ?field-name) (field-value ?field-value))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-message-detect-message-body
	?c <- (http-char ?name 13) ; CR
	?h <- (http-message (name ?name) (start-line ?start-line&:(instancep ?start-line)) (field-lines $?field-lines&:(= 0 (length$ ?field-lines))|:(instancep (nth$ (length$ ?field-lines) ?field-lines))) (message-body nil))
	=>
	(retract ?c)
	(modify ?h (message-body (assert (http-message-body (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

;   Expect      = #expectation
;    expectation = token [ "=" ( token / quoted-string ) parameters ]
;     parameters = *( OWS ";" OWS [ parameter ] )
(defrule http-detect-expect-header
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Expect"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-expect-header (name ?name) (expectations (assert (http-expectation (name ?name) (token (assert (http-token (name ?name))))))))))))

(defrule http-expect-header-skip-ows-before-expectation
	?c <- (http-char ?name 9|32) ; HTAB SP
	?t <- (http-token (name ?name) (value ""))
	?e <- (http-expectation (name ?name) (token ?t))
	(http-expect-header (name ?name) (expectations $?expectations ?e))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-expectation-end-token
	(http-char ?name 9|13|32|44|59|61) ; HTAB CR SP , ; =
	?t <- (http-token (name ?name) (value ?value&~""))
	?e <- (http-expectation (name ?name) (token ?t))
	=>
	(retract ?t)
	(modify ?e (token ?value)))

(defrule http-expectation-detect-equals
	?c <- (http-char ?name 61) ; =
	?e <- (http-expectation (name ?name) (token ?token&:(stringp ?token)) (equals FALSE))
	=>
	(retract ?c)
	(modify ?e (equals TRUE))
	(assert (http-char ?name (http-read ?name))))

(defrule http-expectation-detect-value-token
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?e <- (http-expectation (name ?name) (equals TRUE) (value nil))
	=>
	(modify ?e (value (assert (http-token (name ?name))))))

(defrule http-expectation-end-value-token
	(http-char ?name 9|13|32|44|59) ; HTAB CR SP , ;
	?t <- (http-token (name ?name) (value ?value&~""))
	?e <- (http-expectation (name ?name) (value ?t))
	=>
	(retract ?t)
	(modify ?e (value ?value)))

(defrule http-expectation-detect-value-quoted-string
	?c <- (http-char ?name 34) ; "
	?e <- (http-expectation (name ?name) (equals TRUE) (value nil))
	=>
	(retract ?c)
	(modify ?e (value (assert (http-quoted-string (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-expectation-end-value-quoted-string
	?c <- (http-char ?name 34) ; "
	?q <- (http-quoted-string (name ?name) (value ?value&:(stringp ?value)))
	?e <- (http-expectation (name ?name) (value ?q))
	(not (http-quoted-pair ?name))
	=>
	(retract ?c ?q)
	(modify ?e (value (make-instance of HTTP-QUOTED-STRING (id ?name) (value ?value))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-expectation-detect-parameter
	?c <- (http-char ?name 59) ; ;
	?e <- (http-expectation (name ?name) (token ?token&:(stringp ?token)) (value ?value&nil|:(stringp ?value)|:(instancep ?value)) (parameters $?parameters&:(= 0 (length$ ?parameters))|:(instancep (nth$ (length$ ?parameters) ?parameters))))
	=>
	(retract ?c)
	(modify ?e (parameters ?parameters (assert (http-parameter (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-expectation-end-parameter
	(http-char ?name 9|13|32|44|59) ; HTAB CR SP , ;
	?p <- (http-parameter (parameter-name ?pn&:(stringp ?pn)) (ext-token ?ext-token) (parameter-value ?pv&:(stringp ?pv)|:(instancep ?pv)))
	?e <- (http-expectation (name ?name) (parameters $?parameters ?p))
	=>
	(retract ?p)
	(modify ?e (parameters ?parameters (make-instance of HTTP-PARAMETER (id ?name) (parameter-name ?pn) (ext-token ?ext-token) (parameter-value ?pv)))))

(defrule http-expect-header-end-expectation
	(http-char ?name 13|44) ; CR ,
	?e <- (http-expectation (name ?name) (token ?token&:(stringp ?token)) (value ?value&nil|:(stringp ?value)|:(instancep ?value)) (parameters $?parameters&:(= 0 (length$ ?parameters))|:(instancep (nth$ (length$ ?parameters) ?parameters))))
	?eh <- (http-expect-header (name ?name) (expectations $?expectations ?e))
	=>
	(retract ?e)
	(modify ?eh (expectations ?expectations (make-instance of HTTP-EXPECTATION (id ?name) (token ?token) (value ?value) (parameters ?parameters)))))

; OWS is allowed after a completed expectation, both before the "," that
; starts the next one and before the ";" that starts a parameter, so the
; expectation is not ended here -- only the whitespace is consumed.
(defrule http-expectation-skip-ows-after-token
	?c <- (http-char ?name 9|32) ; HTAB SP
	?e <- (http-expectation (name ?name) (token ?token&:(stringp ?token)) (value ?value&nil|:(stringp ?value)|:(instancep ?value)) (equals ?equals&:(or (eq ?equals FALSE) (neq ?value nil))) (parameters $?parameters&:(= 0 (length$ ?parameters))|:(instancep (nth$ (length$ ?parameters) ?parameters))))
	(http-expect-header (name ?name) (expectations $?expectations ?e))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-expect-header-detect-next-expectation
	?c <- (http-char ?name 44) ; ,
	?eh <- (http-expect-header (name ?name) (expectations $?expectations ?e&:(instancep ?e)))
	=>
	(retract ?c)
	(modify ?eh (expectations ?expectations ?e (assert (http-expectation (name ?name) (token (assert (http-token (name ?name))))))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-expect-header
	(http-char ?name 13) ; CR
	?eh <- (http-expect-header (name ?name) (expectations $?expectations&:(instancep (nth$ (length$ ?expectations) ?expectations))))
	?fv <- (http-field-value (value ?eh))
	=>
	(retract ?eh)
	(modify ?fv (value (make-instance of HTTP-EXPECT-HEADER (id ?name) (expectations ?expectations)))))

;   Cache-Control   = #cache-directive
;    cache-directive = token [ "=" ( token / quoted-string ) ]
;   Pragma           = #pragma-directive
;    pragma-directive = "no-cache" / extension-pragma
;    extension-pragma = token [ "=" ( token / quoted-string ) ]
; Pragma (RFC 9111 5.4, deprecated) shares the cache-directive grammar, so the
; same cache-control-header fact and rules build both; only the end rule differs.
(defrule http-detect-cache-control-header
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?o <- (object (is-a HTTP-FIELD-NAME) (value "Cache-Control"|"Pragma"))
	?fv <- (http-field-value (name ?name) (value nil))
	?fl <- (http-field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (http-cache-control-header (name ?name) (cache-directives (assert (http-cache-directive (name ?name) (token (assert (http-token (name ?name))))))))))))

(defrule http-cache-control-header-skip-ows-before-cache-directive
	?c <- (http-char ?name 9|32) ; HTAB SP
	?t <- (http-token (name ?name) (value ""))
	?cd <- (http-cache-directive (name ?name) (token ?t))
	(http-cache-control-header (name ?name) (cache-directives $?cache-directives ?cd))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-cache-directive-end-token
	(http-char ?name 9|13|32|44|61) ; HTAB CR SP , =
	?t <- (http-token (name ?name) (value ?value&~""))
	?cd <- (http-cache-directive (name ?name) (token ?t))
	=>
	(retract ?t)
	(modify ?cd (token ?value)))

(defrule http-cache-directive-detect-equals
	?c <- (http-char ?name 61) ; =
	?cd <- (http-cache-directive (name ?name) (token ?token&:(stringp ?token)) (equals FALSE))
	=>
	(retract ?c)
	(modify ?cd (equals TRUE))
	(assert (http-char ?name (http-read ?name))))

(defrule http-cache-directive-detect-value-token
	(http-char ?name ?char&:(member$ ?char ?*http-tchar*))
	?cd <- (http-cache-directive (name ?name) (equals TRUE) (value nil))
	=>
	(modify ?cd (value (assert (http-token (name ?name))))))

(defrule http-cache-directive-end-value-token
	(http-char ?name 9|13|32|44) ; HTAB CR SP ,
	?t <- (http-token (name ?name) (value ?value&~""))
	?cd <- (http-cache-directive (name ?name) (value ?t))
	=>
	(retract ?t)
	(modify ?cd (value ?value)))

(defrule http-cache-directive-detect-value-quoted-string
	?c <- (http-char ?name 34) ; "
	?cd <- (http-cache-directive (name ?name) (equals TRUE) (value nil))
	=>
	(retract ?c)
	(modify ?cd (value (assert (http-quoted-string (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-cache-directive-end-value-quoted-string
	?c <- (http-char ?name 34) ; "
	?q <- (http-quoted-string (name ?name) (value ?value&:(stringp ?value)))
	?cd <- (http-cache-directive (name ?name) (value ?q))
	(not (http-quoted-pair ?name))
	=>
	(retract ?c ?q)
	(modify ?cd (value (make-instance of HTTP-QUOTED-STRING (id ?name) (value ?value))))
	(assert (http-char ?name (http-read ?name))))

; OWS is allowed after a completed cache-directive, before the "," that starts
; the next one, so the directive is not ended here -- only the whitespace is
; consumed.
(defrule http-cache-directive-skip-ows-after-token
	?c <- (http-char ?name 9|32) ; HTAB SP
	?cd <- (http-cache-directive (name ?name) (token ?token&:(stringp ?token)) (value ?value&nil|:(stringp ?value)|:(instancep ?value)) (equals ?equals&:(or (eq ?equals FALSE) (neq ?value nil))))
	(http-cache-control-header (name ?name) (cache-directives $?cache-directives ?cd))
	=>
	(retract ?c)
	(assert (http-char ?name (http-read ?name))))

(defrule http-cache-control-header-end-cache-directive
	(http-char ?name 13|44) ; CR ,
	?cd <- (http-cache-directive (name ?name) (token ?token&:(stringp ?token)) (value ?value&nil|:(stringp ?value)|:(instancep ?value)) (equals ?equals&:(or (eq ?equals FALSE) (neq ?value nil))))
	?cch <- (http-cache-control-header (name ?name) (cache-directives $?cache-directives ?cd))
	=>
	(retract ?cd)
	(modify ?cch (cache-directives ?cache-directives (make-instance of HTTP-CACHE-DIRECTIVE (id ?name) (token ?token) (value ?value)))))

(defrule http-cache-control-header-detect-next-cache-directive
	?c <- (http-char ?name 44) ; ,
	?cch <- (http-cache-control-header (name ?name) (cache-directives $?cache-directives ?cd&:(instancep ?cd)))
	=>
	(retract ?c)
	(modify ?cch (cache-directives ?cache-directives ?cd (assert (http-cache-directive (name ?name) (token (assert (http-token (name ?name))))))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-end-cache-control-header
	(http-char ?name 13) ; CR
	?cch <- (http-cache-control-header (name ?name) (cache-directives $?cache-directives&:(instancep (nth$ (length$ ?cache-directives) ?cache-directives))))
	?fv <- (http-field-value (value ?cch))
	(http-field-line (field-name ?fn) (field-value ?fv))
	(object (is-a HTTP-FIELD-NAME) (name ?fn) (value "Cache-Control"))
	=>
	(retract ?cch)
	(modify ?fv (value (make-instance of HTTP-CACHE-CONTROL-HEADER (id ?name) (cache-directives ?cache-directives)))))

(defrule http-end-pragma-header
	(http-char ?name 13) ; CR
	?cch <- (http-cache-control-header (name ?name) (cache-directives $?cache-directives&:(instancep (nth$ (length$ ?cache-directives) ?cache-directives))))
	?fv <- (http-field-value (value ?cch))
	(http-field-line (field-name ?fn) (field-value ?fv))
	(object (is-a HTTP-FIELD-NAME) (name ?fn) (value "Pragma"))
	=>
	(retract ?cch)
	(modify ?fv (value (make-instance of HTTP-PRAGMA-HEADER (id ?name) (cache-directives ?cache-directives)))))

(defrule http-message-body-set-length-remaining
	(http-char ?name 10) ; LF
	?m <- (http-message-body (name ?name) (length-remaining nil))
	(object (is-a HTTP-CONTENT-LENGTH-HEADER) (id ?name) (value ?value&~"0"))
	=>
	(modify ?m (length-remaining (string-to-field ?value))))

(defrule http-message-body-determine-empty
	?c <- (http-char ?name 10) ; LF
	?m <- (http-message-body (name ?name) (length-remaining nil))
	(or
		(not (object (is-a HTTP-CONTENT-LENGTH-HEADER) (id ?name)))
		(object (is-a HTTP-CONTENT-LENGTH-HEADER) (id ?name) (value "0")))
	=>
	(retract ?c)
	(modify ?m (length-remaining 0))
	;; the message is complete: a -1 char ends it here, and the stream stays where it is (a socket has no EOF)
	(assert (http-char ?name -1)))

(defrule http-message-body-leave-application-json
	"a JSON body stays on the stream for COOLJSON, which reads it after http-done"
	?c <- (http-char ?name 10) ; LF
	?m <- (http-message-body (name ?name) (length-remaining ?length-remaining&~nil&:(> ?length-remaining 0)) (value nil))
	(object (is-a HTTP-CONTENT-TYPE-HEADER) (id ?name) (type ?type) (subtype ?subtype))
	(object (is-a HTTP-TYPE) (name ?type) (value "application"))
	(object (is-a HTTP-SUBTYPE) (name ?subtype) (value "json"))
	=>
	(retract ?c)
	(modify ?m (length-remaining 0))
	(assert (http-char ?name -1)))

(defrule http-message-body-detect-application-octet-stream
	?c <- (http-char ?name 10) ; LF
	?m <- (http-message-body (name ?name) (length-remaining ?length-remaining&~nil&:(> ?length-remaining 0)) (value nil))
	(or
		(not (object (is-a HTTP-CONTENT-TYPE-HEADER) (id ?name)))
		(and
			(object (is-a HTTP-CONTENT-TYPE-HEADER) (id ?name) (type ?t) (subtype ?s))
			(object (is-a HTTP-TYPE) (name ?t) (value "application"))
			(object (is-a HTTP-SUBTYPE) (name ?s) (value "octet-stream")))
		(and
			(object (is-a HTTP-CONTENT-TYPE-HEADER) (id ?name) (type ?t) (subtype ?s))
			(object (is-a HTTP-TYPE) (name ?t) (value ?type))
			(object (is-a HTTP-SUBTYPE) (name ?s) (value ?subtype))
			(not (http-supported-content-type ?type ?subtype))))
	=>
	(retract ?c)
	(modify ?m (value (assert (http-octet-stream (name ?name)))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-message-body-detect-application-x-www-form-urlencoded
	?c <- (http-char ?name 10) ; LF
	?m <- (http-message-body (name ?name) (length-remaining ?length-remaining&~nil&:(> ?length-remaining 0)) (value nil))
	(object (is-a HTTP-CONTENT-TYPE-HEADER) (id ?name) (type ?type) (subtype ?subtype))
	(object (is-a HTTP-TYPE) (name ?type) (value "application"))
	(object (is-a HTTP-SUBTYPE) (name ?subtype) (value "x-www-form-urlencoded"))
	=>
	(retract ?c)
	(modify ?m (value (assert (http-x-www-form-urlencoded (name ?name) (sequences (assert (http-sequence (name ?name))))))))
	(assert (http-char ?name (http-read ?name))))

(defrule http-build-octet-stream
	?c <- (http-char ?name ?char)
	?o <- (http-octet-stream (name ?name) (value ?value))
	?m <- (http-message-body (length-remaining ?length-remaining&~nil&:(> ?length-remaining 1)) (value ?o))
	=>
	(retract ?c)
	(modify ?o (value (format nil "%s%c" ?value ?char)))
	(modify ?m (length-remaining (- ?length-remaining 1)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-build-octet-stream-with-last-octet
	"the last octet of the body: a -1 char ends the message here, so nothing past Content-Length is read"
	?c <- (http-char ?name ?char)
	?o <- (http-octet-stream (name ?name) (value ?value))
	?m <- (http-message-body (length-remaining 1) (value ?o))
	=>
	(retract ?c)
	(modify ?o (value (format nil "%s%c" ?value ?char)))
	(modify ?m (length-remaining 0))
	(assert (http-char ?name -1)))

(defrule http-x-www-form-urlencoded-build-name-string
	?c <- (http-char ?name ?char&~61) ; =
	?sequence <- (http-sequence (name ?name) (name-string ?name-string) (value-string nil))
	?x <- (http-x-www-form-urlencoded (sequences $?sequences ?sequence))
	?m <- (http-message-body (length-remaining ?length-remaining&~nil&:(> ?length-remaining 1)) (value ?x))
	=>
	(retract ?c)
	(modify ?sequence (name-string (format nil "%s%c" ?name-string ?char)))
	(modify ?m (length-remaining (- ?length-remaining 1)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-x-www-form-urlencoded-build-name-string-with-last-octet
	"the last octet of the body: a -1 char ends the message here, so nothing past Content-Length is read"
	?c <- (http-char ?name ?char&~61) ; =
	?sequence <- (http-sequence (name ?name) (name-string ?name-string) (value-string nil))
	?x <- (http-x-www-form-urlencoded (sequences $?sequences ?sequence))
	?m <- (http-message-body (length-remaining 1) (value ?x))
	=>
	(retract ?c)
	(modify ?sequence (name-string (format nil "%s%c" ?name-string ?char)))
	(modify ?m (length-remaining 0))
	(assert (http-char ?name -1)))

(defrule http-x-www-form-urlencoded-end-name-string
	?c <- (http-char ?name 61) ; =
	?sequence <- (http-sequence (name ?name) (name-string ?name-string) (value-string nil))
	?x <- (http-x-www-form-urlencoded (sequences $?sequences ?sequence))
	?m <- (http-message-body (length-remaining ?length-remaining&~nil&:(> ?length-remaining 1)) (value ?x))
	=>
	(retract ?c)
	(modify ?sequence (value-string ""))
	(modify ?m (length-remaining (- ?length-remaining 1)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-x-www-form-urlencoded-end-name-string-with-last-octet
	"the last octet of the body: a -1 char ends the message here, so nothing past Content-Length is read"
	?c <- (http-char ?name 61) ; =
	?sequence <- (http-sequence (name ?name) (name-string ?name-string) (value-string nil))
	?x <- (http-x-www-form-urlencoded (sequences $?sequences ?sequence))
	?m <- (http-message-body (length-remaining 1) (value ?x))
	=>
	(retract ?c)
	(modify ?sequence (value-string ""))
	(modify ?m (length-remaining 0))
	(assert (http-char ?name -1)))

(defrule http-x-www-form-urlencoded-build-value-string
	?c <- (http-char ?name ?char&~38) ; &
	?sequence <- (http-sequence (name ?name) (value-string ?value-string&~nil))
	?x <- (http-x-www-form-urlencoded (sequences $?sequences ?sequence))
	?m <- (http-message-body (length-remaining ?length-remaining&~nil&:(> ?length-remaining 1)) (value ?x))
	=>
	(retract ?c)
	(modify ?sequence (value-string (format nil "%s%c" ?value-string ?char)))
	(modify ?m (length-remaining (- ?length-remaining 1)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-x-www-form-urlencoded-build-value-string-with-last-octet
	"the last octet of the body: a -1 char ends the message here, so nothing past Content-Length is read"
	?c <- (http-char ?name ?char&~38) ; &
	?sequence <- (http-sequence (name ?name) (value-string ?value-string&~nil))
	?x <- (http-x-www-form-urlencoded (sequences $?sequences ?sequence))
	?m <- (http-message-body (length-remaining 1) (value ?x))
	=>
	(retract ?c)
	(modify ?sequence (value-string (format nil "%s%c" ?value-string ?char)))
	(modify ?m (length-remaining 0))
	(assert (http-char ?name -1)))

(defrule http-x-www-form-urlencoded-end-sequence-and-start-next-sequence
	?c <- (http-char ?name 38) ; &
	?sequence <- (http-sequence (name ?name) (name-string ?name-string) (value-string ?value-string))
	?x <- (http-x-www-form-urlencoded (sequences $?sequences ?sequence))
	?m <- (http-message-body (length-remaining ?length-remaining&~nil&:(> ?length-remaining 1)) (value ?x))
	=>
	(retract ?c ?sequence)
	(modify ?x (sequences ?sequences (make-instance of HTTP-SEQUENCE (id ?name) (name-string ?name-string) (value-string ?value-string)) (assert (http-sequence (name ?name)))))
	(modify ?m (length-remaining (- ?length-remaining 1)))
	(assert (http-char ?name (http-read ?name))))

(defrule http-x-www-form-urlencoded-end-sequence-and-start-next-sequence-with-last-octet
	"the last octet of the body: a -1 char ends the message here, so nothing past Content-Length is read"
	?c <- (http-char ?name 38) ; &
	?sequence <- (http-sequence (name ?name) (name-string ?name-string) (value-string ?value-string))
	?x <- (http-x-www-form-urlencoded (sequences $?sequences ?sequence))
	?m <- (http-message-body (length-remaining 1) (value ?x))
	=>
	(retract ?c ?sequence)
	(modify ?x (sequences ?sequences (make-instance of HTTP-SEQUENCE (id ?name) (name-string ?name-string) (value-string ?value-string)) (assert (http-sequence (name ?name)))))
	(modify ?m (length-remaining 0))
	(assert (http-char ?name -1)))

(defrule http-end-octet-stream
	(http-char ?name -1)
	?o <- (http-octet-stream (name ?name) (value ?value))
	?m <- (http-message-body (length-remaining 0) (value ?o))
	=>
	(retract ?o)
	(modify ?m (value (make-instance of HTTP-OCTET-STREAM (id ?name) (value ?value)))))

(defrule http-x-www-form-urlencoded-end-sequence
	(http-char ?name -1)
	?sequence <- (http-sequence (name ?name) (name-string ?name-string) (value-string ?value-string))
	?x <- (http-x-www-form-urlencoded (sequences $?sequences ?sequence))
	?m <- (http-message-body (length-remaining 0) (value ?x))
	=>
	(retract ?sequence)
	(modify ?x (sequences ?sequences (make-instance of HTTP-SEQUENCE (id ?name) (name-string ?name-string) (value-string ?value-string)))))

(defrule http-end-x-www-form-urlencoded
	(http-char ?name -1)
	?x <- (http-x-www-form-urlencoded (name ?name) (sequences $?sequences&:(= 0 (length$ ?sequences))|:(instancep (nth$ (length$ ?sequences) ?sequences))))
	?m <- (http-message-body (length-remaining 0) (value ?x))
	=>
	(retract ?x)
	(modify ?m (value (make-instance of HTTP-X-WWW-FORM-URLENCODED (id ?name) (sequences ?sequences)))))

(defrule http-message-end-message-body
	(http-char ?name -1)
	?m <- (http-message-body (value ?value&nil|:(instancep ?value)) (length-remaining 0))
	?h <- (http-message (name ?name) (message-body ?m))
	=>
	(retract ?m)
	(modify ?h (message-body (make-instance of HTTP-MESSAGE-BODY (id ?name) (value ?value)))))

(defrule http-end-http-message
	?c <- (http-char ?name -1)
	;(start ?name ?start)
	?h <- (http-message (name ?name) (start-line ?s) (field-lines $?f) (message-body ?m&:(instancep ?m)))
	?st <- (http-stream (id ?name) (stream ?stream))
=>
;(println ?name ": " (- (time) ?start))
(retract ?h ?c ?st)
(assert (http-done (id ?name) (stream ?stream) (message (make-instance of HTTP-MESSAGE (id ?name) (start-line ?s) (field-lines $?f) (message-body ?m))))))

; Serializes a quoted-string value, re-escaping the DQUOTE and "\" that
; quoted-pair strips out when the value is parsed.
(deffunction http-print-quoted-string (?t ?value)
	(printout ?t "\"")
	(bind ?i 1)
	(while (<= ?i (str-length ?value))
		(bind ?c (sub-string ?i ?i ?value))
		(if (or (eq ?c "\"") (eq ?c "\\")) then (printout ?t "\\"))
		(printout ?t ?c)
		(bind ?i (+ ?i 1)))
	(printout ?t "\""))

(defmessage-handler HTTP-METHOD pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler HTTP-QUOTED-STRING pprint primary (?t)
(http-print-quoted-string ?t ?self:value))

(defmessage-handler HTTP-EXT-VALUE pprint primary (?t)
(printout ?t ?self:charset "'" ?self:language "'" ?self:value-chars))

(defmessage-handler HTTP-PARAMETER pprint primary (?t)
(if ?self:ext-token
then (printout ?t ?self:parameter-name "*=")
     (send ?self:parameter-value pprint ?t)
else (if (instancep ?self:parameter-value)
then (printout ?t ?self:parameter-name "=")
     (send ?self:parameter-value pprint ?t)
else (if (eq "charset" (lowcase ?self:parameter-name))
     then (printout ?t (lowcase ?self:parameter-name) "=" (lowcase ?self:parameter-value))
     else (printout ?t ?self:parameter-name "=" ?self:parameter-value)))))

(defmessage-handler HTTP-SEGMENT pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler HTTP-SCHEME pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler HTTP-USERINFO pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler HTTP-DEC-OCTET pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler HTTP-IPV4ADDRESS pprint primary (?t)
(send ?self:first-octet pprint ?t)
(printout ?t ".")
(send ?self:second-octet pprint ?t)
(printout ?t ".")
(send ?self:third-octet pprint ?t)
(printout ?t ".")
(send ?self:fourth-octet pprint ?t))

(defmessage-handler HTTP-HOST pprint primary (?t)
(send ?self:value pprint ?t))

(defmessage-handler HTTP-IP-LITERAL pprint primary (?t)
(printout ?t "[")
(send ?self:value pprint ?t)
(printout ?t "]"))

(defmessage-handler HTTP-IPV6ADDRESS pprint primary (?t)
(bind ?parts ?self:parts)
(bind ?len (length$ ?parts))
(bind ?i 0)
(foreach ?part ?parts
(bind ?i (+ ?i 1))
(if (instancep ?part)
then (send ?part pprint ?t)
(if (and (< ?i ?len) (instancep (nth$ (+ ?i 1) ?parts))) then (printout ?t ":"))
else (printout ?t ?part))))

(defmessage-handler HTTP-H16 pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler HTTP-REG-NAME pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler HTTP-PORT pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler HTTP-QUERY pprint primary (?t)
(printout ?t "?" ?self:value))

(defmessage-handler HTTP-PATH-ABSOLUTE pprint primary (?t)
(printout ?t "/")
(if (neq ?self:segment-nz nil) then (send ?self:segment-nz pprint ?t))
(foreach ?seg ?self:segments
(printout ?t "/")
(send ?seg pprint ?t)))

(defmessage-handler HTTP-PATH-NOSCHEME pprint primary (?t)
(send ?self:segment-nz-nc pprint ?t)
(foreach ?seg ?self:segments
(printout ?t "/")
(send ?seg pprint ?t)))

(defmessage-handler HTTP-PATH-ABEMPTY pprint primary (?t)
(printout ?t "/")
(if (neq ?self:segments nil) then
(bind ?segs ?self:segments)
(bind ?len (length$ ?segs))
(bind ?i 0)
(foreach ?seg ?segs
(bind ?i (+ ?i 1))
(send ?seg pprint ?t)
(if (< ?i ?len) then (printout ?t "/") else (printout ?t)))))

(defmessage-handler HTTP-ORIGIN-FORM pprint primary (?t)
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

(defmessage-handler HTTP-AUTHORITY pprint primary (?t)
(if (neq ?self:userinfo nil)
then (send ?self:userinfo pprint ?t) (printout ?t "@"))
(if (neq ?self:host nil)
then (send ?self:host pprint ?t))
(if (neq ?self:port nil)
then (printout ?t ":") (send ?self:port pprint ?t)))

(defmessage-handler HTTP-AUTHORITY-FORM pprint primary (?t)
(if (neq ?self:uri-host nil)
then (send ?self:uri-host pprint ?t))
(if (neq ?self:port nil)
then (printout ?t ":") (send ?self:port pprint ?t)))

(defmessage-handler HTTP-HIER-PART pprint primary (?t)
(if (neq ?self:authority nil)
then (printout ?t "//") (send ?self:authority pprint ?t))
(if (neq ?self:path nil)
then (send ?self:path pprint ?t)))

(defmessage-handler HTTP-ABSOLUTE-URI pprint primary (?t)
(send ?self:scheme pprint ?t)
(printout ?t ":")
(send ?self:hier-part pprint ?t)
(if (neq ?self:query nil)
then (send ?self:query pprint ?t)))

(defmessage-handler HTTP-URI pprint after (?t)
(send ?self:fragment pprint ?t))

(defmessage-handler HTTP-PARTIAL-URI pprint primary (?t)
(send ?self:relative-part pprint ?t)
(if (neq ?self:query nil)
then (send ?self:query pprint ?t)))

(defmessage-handler HTTP-RELATIVE-REF pprint after (?t)
(send ?self:fragment pprint ?t))

(defmessage-handler HTTP-FRAGMENT pprint primary (?t)
(printout ?t "#" ?self:value))

(defmessage-handler HTTP-URI-REFERENCE-HEADER pprint primary (?t)
(send ?self:uri-reference pprint ?t))

(defmessage-handler HTTP-ASTERISK-FORM pprint primary (?t)
(printout ?t "*"))

(defmessage-handler HTTP-VERSION pprint primary (?t)
(printout ?t "HTTP/" ?self:major "." ?self:minor))

(defmessage-handler HTTP-REQUEST-LINE pprint primary (?t)
(send ?self:method pprint ?t)
(printout ?t " ")
(send ?self:request-target pprint ?t)
(printout ?t " ")
(send ?self:http-version pprint ?t)
(printout ?t crlf))

(defmessage-handler HTTP-STATUS-LINE pprint primary (?t)
(send ?self:http-version pprint ?t)
(printout ?t " " ?self:status-code " ")
(send ?self:reason-phrase pprint ?t)
(printout ?t crlf))

(defmessage-handler HTTP-REASON-PHRASE pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler HTTP-FIELD-LINE pprint primary (?t)
(send ?self:field-name pprint ?t)
(printout ?t ": ")
(send ?self:field-value pprint ?t)
(printout ?t crlf))

(defmessage-handler HTTP-FIELD-NAME pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler HTTP-FIELD-VALUE pprint primary (?t)
(send ?self:value pprint ?t))

(defmessage-handler HTTP-MESSAGE-BODY pprint primary (?t)
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

(defmessage-handler HTTP-UNKNOWN-HEADER pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler HTTP-ACCEPT-ENCODING-HEADER pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:codings
     (bind ?i (+ ?i 1))
     (send ?f pprint ?t)
     (if (< ?i (length$ ?self:codings)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler HTTP-ACCEPT-CHARSET-HEADER pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:charsets
     (bind ?i (+ ?i 1))
     (send ?f pprint ?t)
     (if (< ?i (length$ ?self:charsets)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler HTTP-CONTENT-LENGTH-HEADER pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler HTTP-MAX-FORWARDS-HEADER pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler HTTP-CONTENT-TYPE-HEADER pprint primary (?t)
(send ?self:type pprint ?t)
(printout ?t "/")
(send ?self:subtype pprint ?t)
(if (neq ?self:parameters nil)
then (foreach ?f ?self:parameters
     (printout ?t ";")
     (send ?f pprint ?t))))

(defmessage-handler HTTP-CONTENT-DISPOSITION-HEADER pprint primary (?t)
(printout ?t ?self:disposition-type)
(foreach ?f ?self:parameters
     (printout ?t ";")
     (send ?f pprint ?t)))

(defmessage-handler HTTP-HOST-HEADER pprint primary (?t)
(send ?self:uri-host pprint ?t)
(if (neq ?self:port nil)
then (printout ?t ":") (send ?self:port pprint ?t)))

(defmessage-handler HTTP-VIA-HEADER pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:values
     (bind ?i (+ ?i 1))
	(send ?f pprint ?t)
        (if (< ?i (length$ ?self:values)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler HTTP-VIA-HEADER-VALUE pprint primary (?t)
	(send ?self:received-protocol pprint ?t)
	(printout ?t " ")
	(send ?self:received-by pprint ?t)
	(if (neq ?self:comment nil) then
		(printout ?t " ")
		(send ?self:comment pprint ?t)))

(defmessage-handler HTTP-RECEIVED-PROTOCOL pprint primary (?t)
	(if (neq ?self:protocol-name nil)
		then (printout ?t ?self:protocol-name "/"))
	(printout ?t ?self:protocol-version))

(defmessage-handler HTTP-RECEIVED-BY pprint primary (?t)
	(printout ?t ?self:pseudonym)
	(if (neq ?self:port nil)
		then (printout ?t ":" ?self:port)))

(defmessage-handler HTTP-COMMENT pprint primary (?t)
	(printout ?t "(")
	(foreach ?f ?self:values
		(if (stringp ?f)
			then (printout ?t ?f)
			else (send ?f pprint ?t)))
	(printout ?t ")"))

(defmessage-handler HTTP-PRODUCT-HEADER pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:values
     (bind ?i (+ ?i 1))
     (send ?f pprint ?t)
     (if (< ?i (length$ ?self:values)) then (printout ?t " ") else (printout ?t))))

(defmessage-handler HTTP-PRODUCT pprint primary (?t)
	(printout ?t ?self:token)
	(if (neq ?self:product-version nil)
		then (printout ?t "/" ?self:product-version)))

(defmessage-handler HTTP-TYPE pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler HTTP-SUBTYPE pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler HTTP-OCTET-STREAM pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler HTTP-X-WWW-FORM-URLENCODED pprint primary (?t)
(if (neq ?self:sequences nil)
then (bind ?len (length$ ?self:sequences))
   (bind ?i 0)
   (foreach ?f ?self:sequences
     (bind ?i (+ ?i 1))
     (send ?f pprint ?t)
     (if (< ?i ?len) then (printout ?t "&") else (printout ?t)))))

(defmessage-handler HTTP-SEQUENCE pprint primary (?t)
(printout ?t ?self:name-string "=" ?self:value-string))

(defmessage-handler HTTP-CODING pprint primary (?t)
(printout ?t ?self:codings)
(if (neq ?self:weight nil)
then (printout ?t ";") (send ?self:weight pprint ?t)))

(defmessage-handler HTTP-CHARSET pprint primary (?t)
(printout ?t ?self:charset)
(if (neq ?self:weight nil)
then (printout ?t ";") (send ?self:weight pprint ?t)))

(defmessage-handler HTTP-WEIGHT pprint primary (?t)
(printout ?t "q=")
(send ?self:qvalue pprint ?t))

(defmessage-handler HTTP-QVALUE pprint primary (?t)
(printout ?t ?self:first)
(if (neq ?self:decimal nil)
then (printout ?t "." ?self:fraction)))

(defmessage-handler HTTP-ACCEPT-HEADER pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:media-ranges
     (bind ?i (+ ?i 1))
     (send ?f pprint ?t)
     (if (< ?i (length$ ?self:media-ranges)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler HTTP-MEDIA-RANGE pprint primary (?t)
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

(defmessage-handler HTTP-ACCEPT-LANGUAGE-HEADER pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:language-ranges
     (bind ?i (+ ?i 1))
     (send ?f pprint ?t)
     (if (< ?i (length$ ?self:language-ranges)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler HTTP-CONTENT-LANGUAGE-HEADER pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:language-tags
     (bind ?i (+ ?i 1))
     (send ?f pprint ?t)
     (if (< ?i (length$ ?self:language-tags)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler HTTP-FROM-HEADER pprint primary (?t)
	(send ?self:mailbox pprint ?t))

; a word of a display-name or a local-part is an atom (a string) or a quoted-string
(deffunction http-print-word (?t ?word)
	(if (instancep ?word)
	then (http-print-quoted-string ?t (send ?word get-value))
	else (printout ?t ?word)))

(defmessage-handler HTTP-ADDR-SPEC pprint primary (?t)
	(http-print-word ?t ?self:local-part)
	(printout ?t "@")
	(if (instancep ?self:domain)
	then (send ?self:domain pprint ?t)
	else (printout ?t ?self:domain)))

(defmessage-handler HTTP-NAME-ADDR pprint primary (?t)
	(foreach ?word ?self:display-name
		(http-print-word ?t ?word)
		(printout ?t " "))
	(printout ?t "<")
	(send ?self:addr-spec pprint ?t)
	(printout ?t ">"))

(defmessage-handler HTTP-DOMAIN-LITERAL pprint primary (?t)
	(printout ?t "[" ?self:value "]"))

(defmessage-handler HTTP-LANGUAGE-TAG pprint primary (?t)
	(send ?self:first-language pprint ?t)
	(bind ?i 0)
	(if (<> 0 (length$ ?self:languages))
	then
	     (printout ?t "-")
	     (foreach ?f ?self:languages
	     (bind ?i (+ ?i 1))
	     (send ?f pprint ?t)
	     (if (< ?i (length$ ?self:languages)) then (printout ?t "-") else (printout ?t)))))

(defmessage-handler HTTP-LANGUAGE-RANGE pprint after (?t)
	(if (neq ?self:weight nil)
	then
	     (printout ?t ";")
	     (send ?self:weight pprint ?t)))

(defmessage-handler HTTP-LANGUAGE pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler HTTP-ALLOW-HEADER pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:methods
     (bind ?i (+ ?i 1))
     (send ?f pprint ?t)
     (if (< ?i (length$ ?self:methods)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler HTTP-TOKEN-LIST-HEADER pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:tokens
     (bind ?i (+ ?i 1))
     (printout ?t ?f)
     (if (< ?i (length$ ?self:tokens)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler HTTP-EXPECT-HEADER pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:expectations
     (bind ?i (+ ?i 1))
     (send ?f pprint ?t)
     (if (< ?i (length$ ?self:expectations)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler HTTP-EXPECTATION pprint primary (?t)
	(printout ?t ?self:token)
	(if (neq ?self:value nil)
	then
	     (printout ?t "=")
	     (if (instancep ?self:value)
	     then (http-print-quoted-string ?t (send ?self:value get-value))
	     else (printout ?t ?self:value)))
	(foreach ?f ?self:parameters
	     (printout ?t ";")
	     (send ?f pprint ?t)))

(defmessage-handler HTTP-CACHE-DIRECTIVE-HEADER pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:cache-directives
     (bind ?i (+ ?i 1))
     (send ?f pprint ?t)
     (if (< ?i (length$ ?self:cache-directives)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler HTTP-CACHE-DIRECTIVE pprint primary (?t)
	(printout ?t ?self:token)
	(if (neq ?self:value nil)
	then
	     (printout ?t "=")
	     (if (instancep ?self:value)
	     then (http-print-quoted-string ?t (send ?self:value get-value))
	     else (printout ?t ?self:value))))

(defmessage-handler HTTP-TE-HEADER pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:t-codings
     (bind ?i (+ ?i 1))
     (send ?f pprint ?t)
     (if (< ?i (length$ ?self:t-codings)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler HTTP-T-CODING pprint primary (?t)
(printout ?t ?self:value)
(if (neq ?self:weight nil)
then (printout ?t ";") (send ?self:weight pprint ?t)))

(defmessage-handler HTTP-RANGE-HEADER pprint primary (?t)
(send ?self:ranges-specifier pprint ?t))

(defmessage-handler HTTP-RANGES-SPECIFIER pprint primary (?t)
(printout ?t ?self:range-unit "=")
(send ?self:range-set pprint ?t))

(defmessage-handler HTTP-RANGE-UNIT pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler HTTP-RANGE-SET pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:range-specs
     (bind ?i (+ ?i 1))
     (send ?f pprint ?t)
     (if (< ?i (length$ ?self:range-specs)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler HTTP-RANGE-SPEC pprint primary (?t)
(send ?self:value pprint ?t))

(defmessage-handler HTTP-INT-RANGE pprint primary (?t)
(printout ?t ?self:first-pos "-" ?self:last-pos))

(defmessage-handler HTTP-SUFFIX-RANGE pprint primary (?t)
(printout ?t "-" ?self:suffix-length))

(defmessage-handler HTTP-OTHER-RANGE pprint primary (?t)
(printout ?t ?self:value))

(defmessage-handler HTTP-CONTENT-RANGE-HEADER pprint primary (?t)
(printout ?t ?self:range-unit " ")
(send ?self:range pprint ?t))

(defmessage-handler HTTP-RANGE-RESP pprint primary (?t)
(send ?self:incl-range pprint ?t)
(printout ?t "/" ?self:complete-length))

(defmessage-handler HTTP-UNSATISFIED-RANGE pprint primary (?t)
(printout ?t "*/" ?self:complete-length))

(defmessage-handler HTTP-UPGRADE-HEADER pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:protocols
     (bind ?i (+ ?i 1))
     (send ?f pprint ?t)
     (if (< ?i (length$ ?self:protocols)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler HTTP-PROTOCOL pprint primary (?t)
	(printout ?t ?self:protocol-name)
	(if (neq ?self:protocol-version nil)
		then (printout ?t "/" ?self:protocol-version)))

(defmessage-handler HTTP-CREDENTIALS-HEADER pprint primary (?t)
	(printout ?t ?self:auth-scheme " ")
	(bind ?i 0)
	(foreach ?f ?self:second-part
		(bind ?i (+ ?i 1))
		(send ?f pprint ?t)
		(if (< ?i (length$ ?self:second-part)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler HTTP-TOKEN68 pprint primary (?t)
	(printout ?t ?self:value)
	(bind ?i 0)
	(while (< ?i ?self:equals)
		(bind ?i (+ 1 ?i))
		(printout ?t "=")))

(defmessage-handler HTTP-AUTH-PARAM pprint primary (?t)
	(printout ?t ?self:left-side "=" ?self:right-side))

(defmessage-handler HTTP-COOKIE-HEADER pprint primary (?t)
	(bind ?i 0)
	(foreach ?f ?self:cookie-pairs
		(bind ?i (+ ?i 1))
		(send ?f pprint ?t)
		(if (< ?i (length$ ?self:cookie-pairs)) then (printout ?t "; ") else (printout ?t))))

(defmessage-handler HTTP-COOKIE-PAIR pprint primary (?t)
(printout ?t ?self:cookie-name "=")
(if ?self:cookie-value-quoted then (printout ?t "\""))
(printout ?t ?self:cookie-value)
(if ?self:cookie-value-quoted then (printout ?t "\"")))

(defmessage-handler HTTP-SET-COOKIE-HEADER pprint primary (?t)
	(send ?self:cookie-pair pprint ?t)
	(bind ?i 0)
	(foreach ?f ?self:cookie-avs
		(printout ?t "; ")
		(send ?f pprint ?t)))

(defmessage-handler HTTP-COOKIE-AV pprint primary (?t)
	(send ?self:value pprint ?t))

(defmessage-handler HTTP-SECURE-AV pprint primary (?t)
(printout ?t "Secure"))

(defmessage-handler HTTP-MAX-AGE-AV pprint (?t)
(printout ?t "Max-Age=" ?self:value))

(defmessage-handler HTTP-PATH-AV pprint (?t)
(printout ?t "Path=" ?self:value))

(defmessage-handler HTTP-HTTPONLY-AV pprint (?t)
(printout ?t "HttpOnly"))

(defmessage-handler HTTP-EXTENSION-AV pprint (?t)
(printout ?t ?self:value))

(defmessage-handler HTTP-EXPIRES-AV pprint (?t)
(printout ?t "Expires=")
(send ?self:rfc1123-date pprint ?t))

(defmessage-handler HTTP-RFC1123-DATE pprint (?t)
(send ?self:wkday pprint ?t)
(printout ?t ", ")
(send ?self:date1 pprint ?t)
(printout ?t " ")
(send ?self:time pprint ?t)
(printout ?t " GMT"))

(defmessage-handler HTTP-DATE-HEADER pprint primary (?t)
(send ?self:http-date pprint ?t))

(defmessage-handler HTTP-ENTITY-TAG pprint primary (?t)
(if ?self:weak then (printout ?t "W/"))
(printout ?t "\"" ?self:opaque-tag "\""))

(defmessage-handler HTTP-ETAG-HEADER pprint primary (?t)
(send ?self:entity-tag pprint ?t))

(defmessage-handler HTTP-ENTITY-TAG-LIST-HEADER pprint primary (?t)
(bind ?i 0)
(foreach ?f ?self:entity-tags
     (bind ?i (+ ?i 1))
     (if (stringp ?f) then (printout ?t ?f) else (send ?f pprint ?t))
     (if (< ?i (length$ ?self:entity-tags)) then (printout ?t ",") else (printout ?t))))

(defmessage-handler HTTP-IF-RANGE-HEADER pprint primary (?t)
(send ?self:value pprint ?t))

(defmessage-handler HTTP-DAY-NAME-L pprint (?t)
(printout ?t ?self:value))

(defmessage-handler HTTP-RFC850-DATE pprint (?t)
(send ?self:day-name-l pprint ?t)
(printout ?t ", ")
(send ?self:date2 pprint ?t)
(printout ?t " ")
(send ?self:time pprint ?t)
(printout ?t " GMT"))

(defmessage-handler HTTP-DATE2 pprint (?t)
(printout ?t ?self:day "-")
(send ?self:month pprint ?t)
(printout ?t "-" ?self:year))

(defmessage-handler HTTP-ASCTIME-DATE pprint (?t)
(send ?self:day-name pprint ?t)
(printout ?t " ")
(send ?self:date3 pprint ?t)
(printout ?t " ")
(send ?self:time pprint ?t)
(printout ?t " " ?self:year))

(defmessage-handler HTTP-DATE3 pprint (?t)
(send ?self:month pprint ?t)
(printout ?t " ")
(if ?self:padded then (printout ?t " "))
(printout ?t ?self:day))

(defmessage-handler HTTP-WKDAY pprint (?t)
(printout ?t ?self:value))

(defmessage-handler HTTP-DATE1 pprint (?t)
(printout ?t ?self:first-2digit " ")
(send ?self:month pprint ?t)
(printout ?t " " ?self:last-4digit))

(defmessage-handler HTTP-MONTH pprint (?t)
(printout ?t ?self:value))

(defmessage-handler HTTP-TIME pprint (?t)
(printout ?t ?self:first-2digit ":" ?self:second-2digit ":" ?self:third-2digit))

(defmessage-handler HTTP-DOMAIN-AV pprint (?t)
(printout ?t "Domain=")
(send ?self:subdomain pprint ?t))

(defmessage-handler HTTP-SUBDOMAIN pprint (?t)
	(foreach ?f ?self:ldh-labels
		(send ?f pprint ?t))
	(send ?self:top-label pprint ?t))

(defmessage-handler HTTP-TOP-LABEL pprint (?t)
(printout ?t ?self:value))

(defmessage-handler HTTP-LDH-LABEL pprint (?t)
(printout ?t ?self:value))

(defmessage-handler HTTP-SAMESITE-AV pprint (?t)
(printout ?t "SameSite=")
(send ?self:value pprint ?t))

(defmessage-handler HTTP-LAX pprint (?t)
(printout ?t "Lax"))

(defmessage-handler HTTP-STRICT pprint (?t)
(printout ?t "Strict"))

(defmessage-handler HTTP-NONE pprint (?t)
(printout ?t "None"))
