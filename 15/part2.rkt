#lang racket

(require "part1.rkt")

(module+ main 
    (let ([g (new-game-data)])
        (game-data-spoken-last (start-game 30000000 g))))
