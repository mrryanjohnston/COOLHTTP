;;; Runs every case under every conflict resolution strategy CLIPS offers.  A
;;; COOL codec keeps only one rule on the agenda at a time, so it decodes the
;;; same way under each strategy; a case that fails under one strategy and not
;;; another points at a rule that relies on firing order.  All the cases
;;; decode in one run, so a strategy like breadth advances every message a
;;; character at a time in lockstep: a rule whose patterns are not all tied to
;;; one message then matches facts from two messages at once, which decoding
;;; one case at a time cannot show.
;(watch rules)
;(watch facts)
;(watch activations)
;(watch statistics)
(load* compline.clp)
(load* ../program.clp)

(defglobal ?*strategies* = (create$ depth breadth lex mea complexity simplicity random))

;;; Compares what the codec decoded for one case with the file of the same
;;; name in expected.  Prints the failure, if any, and returns TRUE when the
;;; case passed.
(deffunction check-case (?strategy ?file)
	(open actual actual "w")
	(bind ?found FALSE)
	(do-for-instance ((?m HTTP-MESSAGE)) (eq ?m:id ?file)
		(bind ?found TRUE)
		(send ?m pprint actual))
	(close actual)
	(if (not ?found) then
		(println "FAIL " ?file " (" ?strategy "): did not find the HTTP-MESSAGE instance")
		(return FALSE))
	(bind ?differences (compare-files (sym-cat expected/ ?file) actual))
	(if (> (length$ ?differences) 0) then
		(println "FAIL " ?file " (" ?strategy ")")
		(foreach ?line ?differences (println ?line))
		(return FALSE))
	TRUE)

;;; Decodes every case at once under one strategy, then checks each.  Returns
;;; the number of checks that failed.
(deffunction run-strategy (?strategy ?files)
	(set-strategy ?strategy)
	(reset)
	(foreach ?file ?files
		(open (sym-cat cases/ ?file) ?file)
		(assert (http-parse (stream ?file) (id ?file)) (http-ready (id ?file))))
	(run)
	(bind ?failed 0)
	(foreach ?file ?files
		(if (not (check-case ?strategy ?file)) then
			(bind ?failed (+ ?failed 1)))
		(close ?file))
	?failed)

;;; Runs every strategy, reporting only the failures plus a one line summary.
(deffunction run-tests (?files)
	(bind ?failed 0)
	(foreach ?strategy ?*strategies*
		(bind ?failed (+ ?failed (run-strategy ?strategy ?files))))
	(bind ?total (* (length$ ?files) (length$ ?*strategies*)))
	(println (length$ ?files) " cases x " (length$ ?*strategies*) " strategies = "
	         ?total " tests, " (- ?total ?failed) " passed, " ?failed " failed")
	(if (> ?failed 0) then (exit 1) else (exit 0)))

(run-tests (create$
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
test62.http
test63.http
test64.http
test65.http
test66.http
test67.http
test68.http
test69.http
test70.http
test71.http
test72.http
test73.http
test74.http
test75.http
test76.http
test77.http
test78.http
test79.http
test80.http
test81.http
test82.http
test83.http
test84.http
test85.http
test86.http
test87.http
test88.http
test89.http
test90.http
test91.http
test92.http
test93.http
test94.http
test95.http
test96.http
test97.http
test98.http
test99.http
test100.http
test101.http
test102.http
test103.http
test104.http
test105.http
test106.http
test107.http
test108.http
test109.http
test110.http
test111.http
test112.http
test113.http
test114.http
test115.http
test116.http
test117.http
test118.http
test119.http
test120.http
test121.http
test122.http
test123.http
test124.http
test125.http
test126.http
test127.http
test128.http
test129.http
test130.http
test131.http
test132.http
))
