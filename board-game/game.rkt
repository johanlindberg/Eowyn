#lang racket/gui

;; Some global data
(define number-of-players-list (list "2" "3" "4" "5"))
(define player-colors (list "yellow" "orange" "green" "blue" "violet"))

;; Game state
(define started? #f)
(define current-player 1)

(define state 0)
(define states
  (list "roll"
        "move"
        "result"))

;; A list of nodes where each node is := (index stone? goal? (x y) (next))
(define path 
  (list (list 0 #f #f (list 53 103) (list 1))
        (list 1 #f #f (list 90 120) (list 0 2))
        (list 2 #t #f (list 131 125) (list 1 3))
        (list 3 #f #f (list 170 140) (list 2 4))
        (list 4 #f #f (list 190 174) (list 3 5 13))
        (list 5 #f #f (list 223 154) (list 4 6))
        (list 6 #f #f (list 256 135) (list 5 7))
        (list 7 #t #f (list 284 108) (list 6 8))
        (list 8 #f #f (list 310 80) (list 7 9))
        (list 9 #f #f (list 340 55) (list 8 10))
        (list 10 #f #f (list 378 53) (list 9 11))
        (list 11 #t #f (list 396 88) (list 10 12))
        (list 12 #f #f (list 374 120) (list 11 26))
              
        (list 13 #f #f (list 163 203) (list 4 14))
        (list 14 #t #f (list 127 220) (list 13 15))
        (list 15 #f #f (list 131 125) (list 14 16))
        (list 16 #f #f (list 88 225) (list 15 17))
        (list 17 #f #f (list 85 264) (list 16 18))
        (list 18 #f #f (list 120 280) (list 17 19))
        (list 19 #t #f (list 157 290) (list 18 20))
        (list 20 #f #f (list 195 294) (list 19 21))
        (list 21 #f #f (list 233 305) (list 10 22))
        (list 22 #t #f (list 271 305) (list 21 23))
        (list 23 #f #f (list 309 300) (list 22 24))
        (list 24 #f #f (list 334 270) (list 23 25))
        (list 25 #t #f (list 345 232) (list 24 26))
        (list 26 #f #f (list 309 300) (list 25 27))
        (list 27 #f #f (list 355 195) (list 12 26 28))
        (list 28 #f #f (list 364 157) (list 27 29))
        
        (list 29 #f #t (list 402 161) (list 28))))

;; Current status
(define (get-current-status-label)
  (if (= state 2)
      (begin ; Results
        (string-append "Player " (number->string current-player) " wins!"))
      (if started?
          (string-append "Player " (number->string current-player) "'s turn")
          "Press start to begin")))

;; Draw functions
(define (draw-players canvas dc)
  (send dc set-pen "black" 1 'solid)

  (do ([y 118 (+ y 20)]
       [count 0 (+ count 1)])
    ((>= count (string->number
                (list-ref number-of-players-list
                          (send number-of-players get-selection)))))
    (send dc set-brush (list-ref player-colors count) 'solid)
    (send dc draw-ellipse 18 y 10 10)))

(define (hexagon-path size x y)
  (let ([path (new dc-path%)])
    (send path move-to (+ x (* 0.87 size)) (+ y (* 0.5 size)))
    (send path line-to x (+ y size))
    (send path line-to (+ x (* -0.87 size)) (+ y (* 0.5 size)))
    (send path line-to (+ x (* -0.87 size)) (+ y (* -0.5 size)))
    (send path line-to x (- y size))
    (send path line-to (+ x (* 0.87 size)) (+ y (* -0.5 size)))
    (send path close)
    
    path))

(define (draw-board canvas dc)
  (send dc set-pen "black" 1 'solid)
  (send dc set-brush "white" 'transparent)

  (let ([size 25])
    (do ([x 0 (+ x (* 2 size 0.87))])
	((> x (send canvas get-width)))

      (do ([y (* 1.75 size 0.87) (+ y (* 3 size))])
	  ((> y (send canvas get-height)))
	(send dc draw-path (hexagon-path size x y)))

      (do ([y 0 (+ y (* 3 size))])
	  ((> y (send canvas get-height)))        
        (send dc draw-path (hexagon-path size (+ x (* size 0.87)) y)))))
  
  (send dc set-pen "black" 3 'solid)
  (send dc set-brush "white" 'transparent)
  
  ;; Start arrow
  (send dc draw-line 33 123 53 123)
  (send dc draw-line 43 118 53 123)
  (send dc draw-line 43 128 53 123)
          
  ;; Goal arrow
  (send dc draw-line 442 181 462 181)
  (send dc draw-line 452 176 462 181)
  (send dc draw-line 452 186 462 181)

  (for ([node path])
    ; node := (index stone? goal? (x y) (next))
    (if (second node) ; stone?
        (send dc set-brush "red" 'solid)
        (send dc set-brush "white" 'transparent))
    
    (send dc draw-ellipse
          (first (fourth node))  ; x
          (second (fourth node)) ; y
          40 40)))

;;; GUI definition
;;; --------------
(define main-frame (new frame%
                        [label "Eowyn's board-game"]
                        [width 500]
                        [height 420]))
;; Game board
(define main-frame-canvas
  (new canvas%
       [parent main-frame]
       [min-width 500]
       [min-height 420]
       [paint-callback
        (lambda (canvas dc)
          (draw-board canvas dc)
          (draw-players canvas dc))]))

;; Bottom panel
(define bottom-panel (new horizontal-panel%
                          [parent main-frame]))
(define start-button (new button%
                          [label "Start"]
                          [parent bottom-panel]
                          [callback
                           (lambda (button event)
                             (if started?
                                 (begin ; Quit
                                   (set! started? #f)
                                   (set! state 2) ; Result
                                   (send number-of-players enable #t)
                                   (send die enable #f)
                                   (send current-status-label set-label (get-current-status-label))
                                   (send start-button set-label "Start"))
                                 (begin ; Start
                                   (set! started? #t)
                                   (set! state 0)
                                   (send number-of-players enable #f)
                                   (send die enable #t)
                                   (send current-status-label set-label (get-current-status-label))
                                   (send start-button set-label "Quit"))))]))
(define number-of-players (new choice%
                              [label "Players:"]
                              [parent bottom-panel]
                              [callback 
                               (lambda (choice event)
                                 (send main-frame refresh))]
                              [choices number-of-players-list]))
(define current-status-label (new message%
                                  [label (get-current-status-label)]
                                  [parent bottom-panel]))
(define die (new button%
                 [label (number->string (+ (random 6) 1))]
                 [parent bottom-panel]
                 [enabled #f]
                 [callback
                  (lambda (button event)
                    (send die set-label (number->string (+ (random 6) 1))))]))

(send main-frame show #t)
