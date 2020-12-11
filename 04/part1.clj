;; lein repl
;; (load-file "part1.clj")
;; (user/main)

(require ['clojure.string :as 'str])

(defn load-passport-data []
  (filter #(not= (first %) "")
    (partition-by (partial = "") 
      (str/split-lines (slurp "input")))))

(defn parse-passport [lines]
  (let [all-pairs (str/split (str/join #" " lines) #" ")]
    (into {} (map #(str/split % #":") all-pairs))))

(defn valid-passport? [p]
  (every? (partial = true)
    (map (partial contains? p) ["ecl", "pid", "eyr", "hcl", "byr", "iyr", "hgt"])))

(defn count-valid-passports [valid?]
  (count (filter valid?
    (map parse-passport (load-passport-data)))))

(defn main []
  (println "Answer:" 
    (count-valid-passports valid-passport?)))
