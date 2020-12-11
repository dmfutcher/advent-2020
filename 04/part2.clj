(load-file "part1.clj")

(defn in-range? [n min max] 
  (and
    (>= n min)
    (<= n max)))

(defn valid-year? [n-str min max]
  (let [n (Integer/parseInt n-str)]
    (and
      (in-range? n min max)
      (= 4 (count n-str)))))

(defn valid-byr? [byr] 
  (and 
    (not= nil byr)
    (valid-year? byr 1920 2002)))

(defn valid-iyr? [iyr]
  (and
    (not= nil iyr)
    (valid-year? iyr 2010 2020)))

(defn valid-eyr? [eyr]
  (and
    (not= nil eyr)
    (valid-year? eyr 2020 2030)))

(defn valid-ecl? [ecl]
  (not= nil
    (some (partial = ecl) ["amb" "blu" "brn" "gry" "grn" "hzl" "oth"])))

(defn valid-pid? [pid]
  (= 9 (count pid)))

(defn valid-hcl? [hcl]
  (and
    (not= nil hcl)
    (not= nil (re-matches #"#[a-f0-9]{6}" hcl))))

(defn valid-hgt? [hgt] true
  (let [[fst, snd] (partition-by #(Character/isDigit %) hgt)
        n-str (apply str fst) 
        unit (apply str snd)]
    (if (= "" n-str)
      false
      (let [n (Integer/parseInt n-str)]
        (if (= "cm" unit)
          (in-range? n 150 193)
          (in-range? n 59 76))))))

(defn valid-passport? [p] 
  (and 
    (valid-byr? (get p "byr"))
    (valid-iyr? (get p "iyr"))
    (valid-eyr? (get p "eyr"))
    (valid-ecl? (get p "ecl"))
    (valid-pid? (get p "pid"))
    (valid-hcl? (get p "hcl"))
    (valid-hgt? (get p "hgt"))))

(defn main [] 
  (println "Answer:" 
    (count-valid-passports valid-passport?)))
