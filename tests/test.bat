;(set-strategy depth) ; default
;(set-strategy breadth)
;(set-strategy simplicity)
;(set-strategy complexity)
;(set-strategy lex)
;(set-strategy mea) ; fastest!!
;(set-strategy random)
;(watch rules)
;(watch facts)
;(watch activations)
(watch statistics)
;(watch all)
(load compline.clp)
(load ../program.clp)
(reset)

(defglobal ?*files* = (create$ 
test.http
test2.http
test3.http
test4.http
test5.http
test6.http
test7.http
test8.http
test9.http
test10.http
test11.http
test12.http
test13.http
test14.http
test15.http
test16.http
test17.http
test18.http
test19.http
test20.http
test21.http
test22.http
test23.http
test24.http
test25.http
test26.http
test27.http
test28.http
test29.http
test30.http
test31.http
test32.http
test33.http
test34.http
test35.http
test36.http
test37.http
test38.http
test39.http
test40.http
test41.http
test42.http
test43.http
test44.http
test45.http
test46.http
test47.http
test48.http
test49.http
test50.http
test51.http
test52.http
test53.http
test54.http
test55.http
test56.http
test57.http
test58.http
test59.http
test60.http
test61.http
))

(foreach ?file ?*files*
	(assert (filename ?file))
	(open (sym-cat cases/ ?file) ?file)
)

(run)

(defglobal ?*successes* = 0)
(defglobal ?*did-not-complete* = 0)
(foreach ?file ?*files*
	(open actual actual "w")
	(bind ?found FALSE)
	(do-for-instance ((?i HTTP-MESSAGE)) (eq ?file ?i:filename)
		(bind ?found TRUE)
		(send ?i pprint actual))
	(if ?found
	    then
	         (close actual)
	         (bind ?*successes* (+ ?*successes* (compare-files (sym-cat expected/ ?file) actual t)))
	         (close ?file)
	    else (close actual)
	         (println crlf "Failure: did not find HTTP-MESSAGE for " ?file)
                 (bind ?*did-not-complete* (+ ?*did-not-complete* 1)))
)
(println)
(println)
(println "Successful tests: " ?*successes* "/" (length$ ?*files*))
(println "Did not complete: " ?*did-not-complete* "/" (length$ ?*files*))
(println)
;(exit)
