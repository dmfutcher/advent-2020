#lang racket ; defines the language we are using

(define raw-input "19,20,14,0,9,1")
(define input (map string->number (string-split raw-input ",")))

(struct game-data (turn starters spoken spoken-last))

(define (speak-number n g) 
    (let ([turn (game-data-turn g)]
          [turns-n-spoken (hash-ref (game-data-spoken g) n (list))])
        (hash-set! (game-data-spoken g) n (cons turn turns-n-spoken))
        (struct-copy game-data g
            [turn (+ 1 turn)]
            [spoken-last n])))

(define (speak-starting-number g)
    (let* ([starters (game-data-starters g)]
           [n (first starters)])
        (struct-copy game-data (speak-number n g) [starters (rest starters)])))

(define (speak-subsequent-number g)
    (let* ([n (game-data-spoken-last g)]
           [n-spoken (hash-ref (game-data-spoken g) n (list))])
        (match (length n-spoken)
            [n #:when (>= n 2) (speak-number (- (first n-spoken) (second n-spoken)) g)]
            [n #:when (< n 2) (speak-number 0 g)])))

(define (take-turn g)
    (if (> (length (game-data-starters g)) 0)
        (speak-starting-number g)
        (speak-subsequent-number g)))

(define (play-game g)
    (let ([new-g (take-turn g)]
          [turn (game-data-turn g)])
        (if (= turn 2021) 
            g
            (play-game new-g))))

(let ([g (game-data 1 input (make-hash) -1)])
    (game-data-spoken-last (play-game g)))
