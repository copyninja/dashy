(import [dash.core [mapcat flatten partition accumulate take-last last]])
(import [operator [mul]])
(require dash.core)
(require tests.testy)

(tests test-partition
       (examples
	(partition (range 6) 2) ⇔ [[0 1] [2 3] [4 5]]
	(partition (range 6) 4) ⇔ [[0 1 2 3]]
	(partition (range 6) 2 1) ⇔ [[0 1] [1 2] [2 3] [3 4] [4 5]]))

(tests test-accumulate
       (examples (list (accumulate (range 1 6))) ⇔ [1 3 6 10 15]
		 (list (accumulate (range 1 6) mul)) ⇔ [1 2 6 24 120]))

(tests test-take-last
       (examples (list (take-last 3 (range 6))) ⇔ [5 4 3]
		 (list (take-last 1 (range 6))) ⇔ [5]))

(tests test-last
       (examples (last (range 6)) ⇔ 5
		 (last [1 2 3]) ⇔ 3))

(tests test-mapcat []
  "test mapcat"
  (env (defn simple-gen [l] (foreach [it l] (yield it))))
  (examples [1 2 3 4 5 6] ⇔ (mapcat reversed [[3 2 1] [6 5 4]])
	    [0 1 2 1 2 3 2 3 4] ⇔ (mapcat (fn [n] [(dec n) n (inc n)]) [1 2 3])
	    [0 1 2 1 2 3 2 3 4] ⇔
	    (mapcat (fn [n] [(dec n) n (inc n)]) (simple-gen [1 2 3]))))

(tests test-dotimes []
  "test dotimes; since this has side effects and doesn't return
   Kinda gross; need a better example"
  (env (defn fibgen [a b]
	 "the canonical ∞ fibonacci generator"
	 (while true
	   (yield a)
	   (setv (, a b) (, b (+ a b)))))

       (def fibs (fibgen 0 1)))

  (examples (let [] (-dotimes 10 (.next fibs)) (.next fibs)) ⇔ 55))

(tests test-flatten []
  "flattening a list/tuple"
  (examples [1 2 3 4] ⇔ (flatten [1 2 [3 4]])
	    [1 2 3 4] ⇔ (flatten [1 2 3 4])
	    [1 2 3 4] ⇔ (flatten (, 1 (, 2 3) 4))))
