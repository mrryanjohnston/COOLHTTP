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
	(slot status-code)
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

(deftemplate content-length-header
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
	(slot value))

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
(defclass CONTENT-LENGTH-HEADER (is-a HTTP) (slot value))
(defclass CONTENT-TYPE-HEADER (is-a HTTP) (slot type) (slot subtype) (multislot parameters))
(defclass HOST-HEADER (is-a HTTP) (slot uri-host) (slot port))
(defclass QUOTED-STRING (is-a HTTP) (slot value))
(defclass MESSAGE-BODY (is-a HTTP) (slot value))
(defclass OCTET-STREAM (is-a HTTP) (slot value))
(defclass X-WWW-FORM-URLENCODED (is-a HTTP) (multislot sequences))
(defclass SEQUENCE (is-a HTTP) (slot name-string) (slot value-string))

(defrule initialize-request
	(filename ?name)
	=>
	(assert
		(char ?name (get-char ?name))
		(http-message (name ?name) (start-line (assert (request-line (name ?name) (method (assert (method (name ?name))))))))))

(defrule build-method
	?c <- (char ?name ?char&65|67|68|69|71|72|73|76|78|79|80|82|83|84|85) ; A|C|D|E|G|H|I|L|N|O|P|R|S|T|U
	?m <- (method (name ?name) (value ?value&~"H"&:(> 7 (str-length ?value))))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?m (value (format nil "%s%c" ?value ?char))))

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
	(assert (char ?name (get-char ?name)))
	(modify ?h (start-line (assert (status-line (name ?name) (http-version (assert (http-version (name ?name) (H TRUE) (T TRUE)))))))))

(defrule end-method
	?c <- (char ?name 32)
	?m <- (method (name ?name) (value ?value&:(member$ ?value ?*methods*)))
	?r <- (request-line (method ?m))
	=>
	(retract ?c ?m)
	(assert (char ?name (get-char ?name)))
	(modify ?r (method (make-instance of METHOD (filename ?name) (value ?value)))))
 
;   request-target = origin-form
;                  / absolute-form
;                  / authority-form
;                  / asterisk-form
(defrule start-request-target-origin-form
	?c <- (char ?name 47) ; /
	?r <- (request-line (name ?name) (method ?method&:(instancep ?method)) (request-target nil))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?r (request-target (assert (origin-form (name ?name) (segments (assert (segment (name ?name) (value (assert (escapable-sequence (name ?name) (allowed-chars ?*pchar*))))))))))))

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
	(assert (char ?name (get-char ?name)))
	(modify ?r (request-target (assert (absolute-uri (name ?name) (scheme (assert (scheme (name ?name) (value (format nil "%c" ?char))))))))))

(defrule continue-scheme
	?c <- (char ?name ?char&:(member$ ?char ?*scheme*))
	?s <- (scheme (name ?name) (value ?value&~nil))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?s (value (format nil "%s%c" ?value ?char))))

(defrule absolute-uri-end-scheme
	?c <- (char ?name 58) ; :
	?s <- (scheme (name ?name) (value ?value&~nil))
	?a <- (absolute-uri (scheme ?s))
	=>
	(retract ?c ?s)
	(assert (char ?name (get-char ?name)))
	(modify ?a (scheme (make-instance of SCHEME (filename ?name) (value ?value))) (hier-part (assert (hier-part (name ?name))))))

(defrule hier-part-find-path-absolute-first-slash
	?c <- (char ?name 47) ; /
	?h <- (hier-part (name ?name) (authority nil) (path nil))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?h (path (assert (path-absolute (name ?name) (segment-nz (assert (escapable-sequence (name ?name) (allowed-chars ?*pchar*)))))))))

(defrule hier-part-find-second-slash-change-path-absolute-to-authority
	?c <- (char ?name 47) ; /
	?e <- (escapable-sequence (sequence ""))
	?path <- (path-absolute (name ?name) (segment-nz ?e))
	?h <- (hier-part (path ?path))
	=>
	(retract ?c ?e ?path)
	(assert (char ?name (get-char ?name)))
	(modify ?h (path nil) (authority (assert (authority (name ?name) (host (assert (host (name ?name)))))))))

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
	(assert (char ?name (get-char ?name)))
	(modify ?a (userinfo (make-instance of USERINFO (filename ?name) (value ?sequence))) (host (assert (host (name ?name))))))

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
	(assert (char ?name (get-char ?name)))
	(modify ?h (value (assert (ip-literal (name ?name))))))

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
	(assert (char ?name (get-char ?name)))
	(modify ?i (value (assert (ipv6address (name ?name) (parts ":"))))))

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
	(assert (char ?name (get-char ?name)))
	(modify ?h (value (format nil "%s%c" ?value ?char))))

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
	(assert (char ?name (get-char ?name)))
	(modify ?i (parts ?parts "::" ":")))

(defrule ipv6address-detect-next-part
	?c <- (char ?name 58) ; :
	?i6 <- (ipv6address (name ?name) (parts $?parts&:(= 0 (length$ ?parts))|:(eq "::" (nth$ (length$ ?parts) ?parts))|:(instancep (nth$ (length$ ?parts) ?parts))))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?i6 (parts ?parts ":")))

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
	(assert (char ?name (get-char ?name)))
	(modify ?h (value (make-instance of IP-LITERAL (filename ?name) (value ?i6)))))

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
	(assert (char ?name (get-char ?name)))
	(modify ?o (first-digit (format nil "%c" ?char))))

(defrule dec-octet-set-second-digit-when-first-digit-is-one
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?o <- (dec-octet (name ?name) (first-digit "1") (second-digit ""))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?o (second-digit (format nil "%c" ?char))))

(defrule dec-octet-set-second-digit-when-first-digit-is-two
	?c <- (char ?name ?char&48|49|50|51|52) ; 1 2 3 4 5
	?o <- (dec-octet (name ?name) (first-digit "2") (second-digit ""))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?o (second-digit (format nil "%c" ?char))))

(defrule dec-octet-set-third-digit-when-first-digit-is-one
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?o <- (dec-octet (name ?name) (first-digit "1") (second-digit ~"") (third-digit ""))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?o (third-digit (format nil "%c" ?char))))

(defrule dec-octet-set-third-digit-when-first-digit-is-two-and-second-digit-is-5
	?c <- (char ?name ?char&48|49|50|51|52) ; 1 2 3 4 5
	?o <- (dec-octet (name ?name) (first-digit "2") (second-digit "5") (third-digit ""))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?o (third-digit (format nil "%c" ?char))))

(defrule dec-octet-set-third-digit-when-first-digit-is-two-and-second-digit-is-not-5
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?o <- (dec-octet (name ?name) (first-digit "2") (second-digit ~"5") (third-digit ""))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?o (third-digit (format nil "%c" ?char))))

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
	(assert (char ?name (get-char ?name)))
	(modify ?i (octets ?octets (assert (dec-octet (name ?name))))))

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
	(assert (char ?name (get-char ?name)))
	(modify ?a (port (assert (port (name ?name))))))

(defrule authority-start-port
	?c <- (char ?name 58) ; :
	?a <- (authority (name ?name) (host ?host&:(instancep ?host)) (port nil))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?a (port (assert (port (name ?name))))))

(defrule continue-port
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?p <- (port (name ?name) (value ?start&:(> 5 (str-length ?start))))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?p (value (format nil "%s%c" ?start ?char))))

(defrule end-authority-form
	?c <- (char ?name 32) ; SP
	?a <- (authority-form (name ?name) (uri-host ?host) (port ?p&:(instancep ?p)))
	?r <- (request-line (request-target ?a))
	=>
	(retract ?c ?a)
	(assert (char ?name (get-char ?name)))
	(modify ?r (request-target (make-instance of AUTHORITY-FORM (filename ?name) (uri-host ?host) (port ?p)))))

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
	(assert (char ?name (get-char ?name)))
	(modify ?a (query (assert (escapable-sequence (name ?name) (allowed-chars ?*query*))))))

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
	(assert (char ?name (get-char ?name)))
	(modify ?r (request-target "*")))

(defrule end-request-target-asterisk-form
	?c <- (char ?name 32) ; SP
	?r <- (request-line (name ?name) (request-target "*"))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?r (request-target (make-instance of ASTERISK-FORM (filename ?name)))))

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
	(assert (char ?name (get-char ?name)))
	(modify ?o (segments ?segments ?segment (assert (segment (name ?name) (value (assert (escapable-sequence (name ?name) (allowed-chars ?*pchar*))))))))) 

(defrule path-abempty-find-next-segment
	?c <- (char ?name 47) ; /
	?p <- (path-abempty (name ?name) (segments $?segments&:(= 0 (length$ ?segments))|:(instancep (nth$ (length$ ?segments) ?segments))))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?p (segments ?segments (assert (segment (name ?name) (value (assert (escapable-sequence (name ?name) (allowed-chars ?*pchar*)))))))))
	
(defrule path-absolute-find-next-segment
	?c <- (char ?name 47) ; /
	?p <- (path-absolute (name ?name) (segments $?segments ?segment&:(instancep ?segment)))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?p (segments ?segments ?segment (assert (segment (name ?name) (value (assert (escapable-sequence (name ?name) (allowed-chars ?*pchar*)))))))))
	
(defrule path-rootless-find-next-segment
	?c <- (char ?name 47) ; /
	?p <- (path-rootless (name ?name) (segments $?segments ?segment&:(instancep ?segment)))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?p (segments ?segments ?segment (assert (segment (name ?name) (value (assert (escapable-sequence (name ?name) (allowed-chars ?*pchar*)))))))))

(defrule origin-form-start-query
	?c <- (char ?name 63) ; ?
	?a <- (origin-form (name ?name) (segments $?segments ?segment&:(instancep ?segment)) (query nil))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?a (query (assert (escapable-sequence (name ?name) (allowed-chars ?*query*))))))

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
	(assert (char ?name (get-char ?name)))
	(modify ?r (request-target (make-instance of ORIGIN-FORM (filename ?name) (segments ?segments ?segment) (query ?query)))))

(defrule end-of-absolute-uri
	?c <- (char ?name 32) ; SP
	?a <- (absolute-uri (name ?name) (scheme ?scheme) (hier-part ?hier-part&:(instancep ?hier-part)) (query ?query&nil|:(instancep ?query)))
	?r <- (request-line (request-target ?a))
	=>
	(retract ?c ?a)
	(assert (char ?name (get-char ?name)))
	(modify ?r (request-target (make-instance of ABSOLUTE-URI (filename ?name) (scheme ?scheme) (hier-part ?hier-part) (query ?query)))))

(defrule char-is-allowed-char-in-escapable-sequence
	?e <- (escapable-sequence (name ?name) (sequence ?sequence) (allowed-chars $?allowed-chars) (pct-encoded nil))
	?c <- (char ?name ?char&:(member$ ?char ?allowed-chars))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?e (sequence (format nil "%s%c" ?sequence ?char))))

(defrule pct-encoded-sequence
	?c <- (char ?name 37) ; %
	?e <- (escapable-sequence (name ?name) (sequence ?sequence) (pct-encoded nil))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?e (pct-encoded (assert (pct-encoded (name ?name))))))

(defrule pct-encoded-find-first
	?c <- (char ?name ?char&:(member$ ?char ?*hexdig*))
	?p <- (pct-encoded (name ?name) (first nil))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?p (first ?char)))

(defrule pct-encoded-find-second
	?c <- (char ?name ?char&:(member$ ?char ?*hexdig*))
	?p <- (pct-encoded (name ?name) (first ?first&~nil))
	?es <- (escapable-sequence (pct-encoded ?p) (sequence ?sequence))
	=>
	(retract ?p ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?es (sequence (format nil "%s%c%c%c" ?sequence 37 ?first ?char)) (pct-encoded nil)))

(defrule find-http-version
	?c <- (char ?name 72) ; H
	?r <- (request-line (name ?name) (request-target ?request-target&:(instancep ?request-target)) (http-version nil))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?r (http-version (assert (http-version (name ?name) (H TRUE))))))

(defrule find-http-version-first-T
	?c <- (char ?name 84) ; T
	?h <- (http-version (name ?name) (H TRUE) (T nil))
	(request-line (http-version ?h))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?h (T TRUE)))

(defrule find-http-version-second-T
	?c <- (char ?name 84) ; T
	?h <- (http-version (name ?name) (T TRUE) (TT nil))
	(request-line (http-version ?h))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?h (TT TRUE)))

(defrule find-http-version-P
	?c <- (char ?name 80) ; P
	?h <- (http-version (name ?name) (TT TRUE) (P nil))
	(request-line (http-version ?h))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?h (P TRUE)))

(defrule find-http-version-slash
	?c <- (char ?name 47) ; /
	?h <- (http-version (name ?name) (P TRUE) (major nil))
	(request-line (http-version ?h))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?h (major "")))

(defrule find-http-version-continue-major
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?h <- (http-version (name ?name) (major ?major&~nil) (minor nil))
	(request-line (http-version ?h))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?h (major (format nil "%s%c" ?major ?char))))

(defrule find-http-version-period
	?c <- (char ?name 46) ; .
	?h <- (http-version (name ?name) (major ~nil) (minor nil))
	(request-line (http-version ?h))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?h (minor "")))

(defrule find-http-version-continue-minor
	?c <- (char ?name ?char&:(member$ ?char ?*digit*))
	?h <- (http-version (name ?name) (minor ?minor&~nil))
	(request-line (http-version ?h))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?h (minor (format nil "%s%c" ?minor ?char))))

(defrule http-version-end
	?c <- (char ?name 13) ; CR
	?h <- (http-version (name ?name) (major ?major) (minor ?minor&~nil))
	?r <- (request-line (http-version ?h))
	=>
	(retract ?c ?h)
	(assert (char ?name (get-char ?name)))
	(modify ?r (http-version (make-instance of HTTP-VERSION (filename ?name) (major ?major) (minor ?minor)))))

(defrule request-line-end
	?c <- (char ?name 10) ; LF
	?r <- (request-line (method ?method) (request-target ?request-target) (http-version ?http-version&:(instancep ?http-version)))
	?h <- (http-message (name ?name) (start-line ?r))
	=>
	(retract ?c ?r)
	(assert (char ?name (get-char ?name)))
	(modify ?h (start-line (make-instance of REQUEST-LINE (filename ?name) (method ?method) (request-target ?request-target) (http-version ?http-version)))))

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
	(assert (char ?name (get-char ?name)))
	(modify ?f (value (format nil "%s%c" ?value ?char))))

(defrule end-field-name
	?c <- (char ?name 58)
	?fn <- (field-name (name ?name) (value ?value))
	?fl <- (field-line (field-name ?fn))
	=>
	(retract ?c ?fn)
	(assert (char ?name (get-char ?name)))
	(modify ?fl (field-name (make-instance of FIELD-NAME (filename ?name) (value ?value)))))

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
	(char ?name ?char&:(> ?char 32)&:(< ?char 127))
	?o <- (object (is-a FIELD-NAME) (value ?field-name&~"Content-Length"&~"Content-Type"&~"Host"))
	?fv <- (field-value (name ?name) (value nil))
	?fl <- (field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (unknown-header (name ?name))))))

(defrule build-unknown-header
	?c <- (char ?name ?char&~92&:(> ?char 32)&:(< ?char 127)) ; \
	?u <- (unknown-header (name ?name) (value ?value) (possible-ows ?possible-ows))
	(not (obs-text ?name $?))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?u (value (format nil "%s%s%c" ?value ?possible-ows ?char)) (possible-ows "")))

(defrule detect-content-length-header
	(char ?name ?char&:(member$ ?char ?*digit*))
	?o <- (object (is-a FIELD-NAME) (value "Content-Length"))
	?fv <- (field-value (name ?name) (value nil))
	?fl <- (field-line (field-name =(instance-name ?o)) (field-value ?fv))
	=>
	(modify ?fv (value (assert (content-length-header (name ?name))))))

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
	(assert (char ?name (get-char ?name)))
	(modify ?t (value (format nil "%s%c" ?type ?char))))

(defrule content-type-end-type
	?c <- (char ?name 47) ; /
	?t <- (type (name ?name) (value ?value))
	?ct <- (content-type-header (type ?t))
	=>
	(retract ?c ?t)
	(assert (char ?name (get-char ?name)))
	(modify ?ct (type (make-instance of TYPE (filename ?name) (value ?value)))))

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
	(assert (char ?name (get-char ?name)))
	(modify ?s (value (format nil "%s%c" ?subtype ?char))))

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
	(assert (char ?name (get-char ?name)))
	(modify ?cth (parameters ?parameters (assert (parameter (name ?name))))))

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
	(assert (char ?name (get-char ?name)))
	(modify ?t (value (format nil "%s%c" ?value ?char))))

(defrule parameter-end-parameter-name
	?c <- (char ?name 61) ; =
	?t <- (token (name ?name) (value ?value&~""))
	?p <- (parameter (parameter-name ?t))
	=>
	(retract ?c ?t)
	(assert (char ?name (get-char ?name)))
	(modify ?p (parameter-name ?value)))

(defrule parameter-detect-parameter-value-token
	(char ?name ?char&:(member$ ?char ?*tchar*))
	?p <- (parameter (name ?name) (parameter-name ?parameter-name&:(stringp ?parameter-name)) (parameter-value nil))
	=>
	(modify ?p (parameter-value (assert (token (name ?name))))))

(defrule parameter-end-parameter-value-token
	(char ?name 9|13|32|59) ; HTAB CR SP ;
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
	(assert (char ?name (get-char ?name)))
	(modify ?p (parameter-value (assert (quoted-string (name ?name))))))

(defrule quoted-string-detect-quoted-pair
	?c <- (char ?name 92) ; \
	?q <- (quoted-string (name ?name) (value ?value))
	(not (quoted-pair ?name))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(assert (quoted-pair ?name)))

(defrule parameter-end-parameter-value-quoted-string
	?c <- (char ?name 34) ; "
	?q <- (quoted-string (name ?name) (value ?value&:(stringp ?value)))
	?p <- (parameter (parameter-name ?t&:(stringp ?t)) (parameter-value ?q))
	=>
	(retract ?c ?q)
	(assert (char ?name (get-char ?name)))
	(modify ?p (parameter-value (make-instance of QUOTED-STRING (filename ?name) (value ?value)))))

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
	(assert (char ?name (get-char ?name)))
	(modify ?hh (port (assert (port (name ?name))))))

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
	(assert (char ?name (get-char ?name)))
	(modify ?clh (value (format nil "%s%c" ?content-length-header ?char))))

(defrule allow-ows-in-unknown-header
	?c <- (char ?name ?char&9|32) ; HTAB SP
	?u <- (unknown-header (name ?name) (value ?unknown-header&~"") (possible-ows ?possible-ows))
	?f <- (field-value (value ?u))
	(not (obs-text ?name $?))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?f (possible-ows (format nil "%s%c" ?possible-ows ?char))))

(defrule unknown-header-detect-obs-text
	?c <- (char ?name 92) ; \
	?u <- (unknown-header (name ?name))
	?f <- (field-value (value ?u))
	(not (obs-text ?name $?))
	=>
	(retract ?c)
	(assert (obs-text ?name)
		(char ?name (get-char ?name))))

(defrule detect-obs-text-x
	?c <- (char ?name 120) ; x
	?o <- (obs-text ?name)
	=>
	(retract ?c ?o)
	(assert (obs-text ?name x)
		(char ?name (get-char ?name))))

(defrule detect-obs-text-x-first
	?c <- (char ?name ?char&56|57|97|98|99|100|101|102|65|66|67|68|69|70) ; 8 9 a b c d e f A B C D E F
	?o <- (obs-text ?name x)
	=>
	(retract ?c ?o)
	(assert (obs-text ?name x ?char)
		(char ?name (get-char ?name))))

(defrule unknown-header-detect-obs-text-x-second
	?c <- (char ?name ?char&:(member$ ?char ?*hexdig*))
	?u <- (unknown-header (name ?name) (value ?value) (possible-ows ?possible-ows))
	?o <- (obs-text ?name x ?first)
	=>
	(retract ?c ?o)
	(assert (char ?name (get-char ?name)))
	(modify ?u (value (format nil "%s\\x%c%c%s" ?value ?possible-ows ?first ?char)) (possible-ows "")))

(defrule end-unknown-header
	(char ?name 13)
	?u <- (unknown-header (name ?name) (value ?value))
	?fv <- (field-value (value ?u))
	(not (obs-text ?name $?))
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
	(assert (char ?name (get-char ?name)))
	(modify ?fl (field-value (make-instance of FIELD-VALUE (filename ?name) (value ?v)))))

(defrule end-field-line
	?c <- (char ?name 10) ; LF
	?f <- (field-line (field-name ?field-name) (field-value ?field-value&:(instancep ?field-value)))
	?h <- (http-message (name ?name) (field-lines $?field-lines ?f))
	=>
	(retract ?c ?f)
	(assert (char ?name (get-char ?name)))
	(modify ?h (field-lines ?field-lines (make-instance of FIELD-LINE (filename ?name) (field-name ?field-name) (field-value ?field-value)))))

(defrule http-message-detect-message-body
	?c <- (char ?name 13) ; CR
	?h <- (http-message (name ?name) (start-line ?start-line&:(instancep ?start-line)) (field-lines $?field-lines&:(= 0 (length$ ?field-lines))|:(instancep (nth$ (length$ ?field-lines) ?field-lines))) (message-body nil))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?h (message-body (assert (message-body (name ?name))))))

(defrule message-body-set-length-remaining
	(char ?name 10) ; LF
	?m <- (message-body (name ?name) (length-remaining nil))
	(object (is-a CONTENT-LENGTH-HEADER) (filename ?name) (value ?value))
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
	(assert (char ?name (get-char ?name)))
	(modify ?m (length-remaining 0)))

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
	(assert (char ?name (get-char ?name)))
	(modify ?m (value (assert (octet-stream (name ?name))))))

(defrule message-body-detect-application-x-www-form-urlencoded
	?c <- (char ?name 10) ; LF
	?m <- (message-body (name ?name) (length-remaining ?length-remaining&~nil&:(> ?length-remaining 0)) (value nil))
	(object (is-a TYPE) (filename ?name) (value "application"))
	(object (is-a SUBTYPE) (filename ?name) (value "x-www-form-urlencoded"))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?m (value (assert (x-www-form-urlencoded (name ?name) (sequences (assert (sequence (name ?name)))))))))

(defrule build-octet-stream
	?c <- (char ?name ?char)
	?o <- (octet-stream (name ?name) (value ?value))
	?m <- (message-body (length-remaining ?length-remaining&~nil&:(> ?length-remaining 0)) (value ?o))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?o (value (format nil "%s%c" ?value ?char)))
	(modify ?m (length-remaining (- ?length-remaining 1))))

(defrule x-www-form-urlencoded-build-name-string
	?c <- (char ?name ?char&~61) ; =
	?sequence <- (sequence (name ?name) (name-string ?name-string) (value-string nil))
	?x <- (x-www-form-urlencoded (sequences $?sequences ?sequence))
	?m <- (message-body (length-remaining ?length-remaining&~nil&:(> ?length-remaining 0)) (value ?x))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?sequence (name-string (format nil "%s%c" ?name-string ?char)))
	(modify ?m (length-remaining (- ?length-remaining 1))))

(defrule x-www-form-urlencoded-end-name-string
	?c <- (char ?name 61) ; =
	?sequence <- (sequence (name ?name) (name-string ?name-string) (value-string nil))
	?x <- (x-www-form-urlencoded (sequences $?sequences ?sequence))
	?m <- (message-body (length-remaining ?length-remaining&~nil&:(> ?length-remaining 0)) (value ?x))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?sequence (value-string ""))
	(modify ?m (length-remaining (- ?length-remaining 1))))

(defrule x-www-form-urlencoded-build-value-string
	?c <- (char ?name ?char&~38) ; &
	?sequence <- (sequence (name ?name) (value-string ?value-string&~nil))
	?x <- (x-www-form-urlencoded (sequences $?sequences ?sequence))
	?m <- (message-body (length-remaining ?length-remaining&~nil&:(> ?length-remaining 0)) (value ?x))
	=>
	(retract ?c)
	(assert (char ?name (get-char ?name)))
	(modify ?sequence (value-string (format nil "%s%c" ?value-string ?char)))
	(modify ?m (length-remaining (- ?length-remaining 1))))

(defrule x-www-form-urlencoded-end-sequence-and-start-next-sequence
	?c <- (char ?name 38) ; &
	?sequence <- (sequence (name ?name) (name-string ?name-string) (value-string ?value-string))
	?x <- (x-www-form-urlencoded (sequences $?sequences ?sequence))
	?m <- (message-body (length-remaining ?length-remaining&~nil&:(> ?length-remaining 0)) (value ?x))
	=>
	(retract ?c ?sequence)
	(assert (char ?name (get-char ?name)))
	(modify ?x (sequences ?sequences (make-instance of SEQUENCE (filename ?name) (name-string ?name-string) (value-string ?value-string)) (assert (sequence (name ?name)))))
	(modify ?m (length-remaining (- ?length-remaining 1))))

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
	?h <- (http-message (name ?name) (start-line ?s) (field-lines $?f) (message-body ?m&:(instancep ?m)))
	=>
	(retract ?h)
	(make-instance of HTTP-MESSAGE (filename ?name) (start-line ?s) (field-lines $?f) (message-body ?m)))

(defmessage-handler METHOD pprint primary (?t)
  (printout ?t ?self:value))

(defmessage-handler PARAMETER pprint primary (?t)
  (if (eq "charset" (lowcase ?self:parameter-name))
    then (printout ?t (lowcase ?self:parameter-name) "=" (lowcase ?self:parameter-value))
    else (printout ?t ?self:parameter-name "=" ?self:parameter-value)))

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

(defmessage-handler CONTENT-LENGTH-HEADER pprint primary (?t)
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
