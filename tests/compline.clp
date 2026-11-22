;;; Compares two files octet by octet and returns a multifield of report lines
;;; describing the differences.  An empty multifield means the two files hold
;;; the same octets.
;;;
;;; A line ends at LF and at no other octet, so a CR is part of its line: a
;;; line that ends with CR LF is not equal to a line that ends with LF.  The
;;; report shows an octet that does not print as an escape: \r for CR, \t for
;;; TAB, \\ for a backslash, and \xNN for each other one.

;;; Reads one line of an open file, without its LF.  Returns EOF when the file
;;; has no more octets.
(deffunction compare-files-line (?logical-name)
   (bind ?octet (get-char ?logical-name))
   (if (= ?octet -1) then (return EOF))
   (bind ?line "")
   (while (and (<> ?octet -1) (<> ?octet 10)) do
      (bind ?line (str-cat ?line
         (if (= ?octet 13) then "\\r"
          else (if (= ?octet 9) then "\\t"
          else (if (= ?octet 92) then "\\\\"
          else (if (and (>= ?octet 32) (<= ?octet 126)) then (format nil "%c" ?octet)
          else (format nil "\\x%02X" ?octet)))))))
      (bind ?octet (get-char ?logical-name)))
   ;; a last line that has no LF is not equal to the same line with one
   (if (= ?octet -1) then (bind ?line (str-cat ?line "<no LF>")))
   ?line)

(deffunction compare-files (?base-file ?test-file)
   (if (not (open ?base-file base "rb")) then
      (return (create$ (str-cat "   the file " ?base-file " does not open"))))
   (if (not (open ?test-file test "rb")) then
      (close base)
      (return (create$ (str-cat "   the file " ?test-file " does not open"))))
   (bind ?i 0)
   (bind ?differences (create$))
   (bind ?base-line (compare-files-line base))
   (bind ?test-line (compare-files-line test))
   (while (and (neq ?base-line EOF) (neq ?test-line EOF)) do
      (bind ?i (+ ?i 1))
      (if (neq ?base-line ?test-line) then
          (bind ?differences (create$ ?differences
             (format nil "   %3d expected: %s" ?i ?base-line)
             (format nil "   %3d actual:   %s" ?i ?test-line))))
      (bind ?base-line (compare-files-line base))
      (bind ?test-line (compare-files-line test)))
   (if (or (neq ?base-line EOF) (neq ?test-line EOF)) then
      (bind ?differences (create$ ?differences
         "   files do not have the same # of lines:"
         (format nil "   expected last line %s" ?base-line)
         (format nil "   actual last line %s" ?test-line))))
   (close base)
   (close test)
   ?differences)
