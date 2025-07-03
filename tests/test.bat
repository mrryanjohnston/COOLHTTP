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
))

(foreach ?file ?*files*
	(assert (filename ?file))
	(open (sym-cat cases/ ?file) ?file)
)

(run)

(foreach ?file ?*files*
	(open actual actual "w")
	(bind ?found FALSE)
	(do-for-instance ((?i HTTP-MESSAGE)) (eq ?file ?i:filename)
		(bind ?found TRUE)
		(send ?i pprint actual))
	(if ?found
	    then
	         (close actual)
	         (compare-files (sym-cat expected/ ?file) actual t)
	         (close ?file)
	    else (close actual)
	         (println crlf "Failure: did not find HTTP-MESSAGE for " ?file))
)
(println)
(exit)
