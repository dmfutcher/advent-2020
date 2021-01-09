#lang racket

(provide 
    start-game
    new-game-data
    game-data-spoken-last)

(define raw-input "19,20,14,0,9,1")
(define input (map string->number (string-split raw-input ",")))

(struct game-data (turn starters spoken spoken-last))
(define (new-game-data) (game-data 1 input (make-hash) -1))

(define (speak-number n g) 
    (let ([turn (game-data-turn g)]
          [turns-n-spoken (match (hash-ref (game-data-spoken g) n (list))
              [(list a b) (list a)]
              [l l])])
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

(define (start-game target-turn g) 
    (letrec ([play-game-turn
        (lambda (target-turn g) 
            (let ([new-g (take-turn g)]
                [turn (game-data-turn g)])
                (if (= turn (+ 1 target-turn)) 
                    g
                    (play-game-turn target-turn new-g))))])
        (play-game-turn target-turn g)))

(module+ main
    (let ([g (new-game-data)])
        (game-data-spoken-last (start-game 2020 g))))

