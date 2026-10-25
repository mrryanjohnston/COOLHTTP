(watch rules)
(load program.clp)

(foreach ?file (create$
;tests/cases/test.http
;tests/cases/test2.http
;test3.http
;test4.http
;test5.http
;test6.http
;test7.http
;test8.http
tests/cases/test9.http
;test10.http
;test11.http
;test12.http
;test13.http
;test14.http
;test15.http
;test16.http
)
	(reset)
	(open ?file ?file)
	(assert (filename ?file))
	(run)
	(println tab ?file)
	(do-for-instance ((?i HTTP-MESSAGE)) TRUE
		(send ?i pprint t))
	(rewind ?file)
	(bind ?line (readline ?file))
	(while (neq ?line EOF) (println ?line) (bind ?line (readline ?file)))
	(close ?file)
)
