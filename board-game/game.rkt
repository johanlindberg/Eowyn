#lang racket/gui

;; Draw functions
(define (draw-players canvas dc)
  #t)

(define (draw-board canvas dc)
          ;;; Draw the game board
          ;;; This is more or less a direct translation of a drawing.
          
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
                    
          ;; Regular board positions
          (send dc draw-ellipse 53 103 40 40)
          (send dc draw-ellipse 90 120 40 40)
          (send dc draw-ellipse 170 140 40 40)
          
          (send dc draw-ellipse 190 174 40 40)

          (send dc draw-ellipse 223 154 40 40)
          (send dc draw-ellipse 256 135 40 40)
          (send dc draw-ellipse 310 80 40 40)
          (send dc draw-ellipse 340 55 40 40)
          (send dc draw-ellipse 378 53 40 40)
          
          (send dc draw-ellipse 374 120 40 40)
          
          (send dc draw-ellipse 163 203 40 40)
          (send dc draw-ellipse 88 225 40 40)
          (send dc draw-ellipse 85 264 40 40)          
          (send dc draw-ellipse 120 280 40 40)
          (send dc draw-ellipse 195 294 40 40)
          (send dc draw-ellipse 233 305 40 40)
          (send dc draw-ellipse 309 300 40 40)
          (send dc draw-ellipse 334 270 40 40)
          (send dc draw-ellipse 355 195 40 40)
          (send dc draw-ellipse 364 157 40 40)
          
          (send dc draw-ellipse 402 161 40 40)

          ;;; Stone positions
          (send dc set-brush "red" 'solid)

          (send dc draw-ellipse 131 125 40 40)
          (send dc draw-ellipse 127 220 40 40)
          (send dc draw-ellipse 157 290 40 40)
          (send dc draw-ellipse 271 305 40 40)
          (send dc draw-ellipse 345 232 40 40)

          (send dc draw-ellipse 284 108 40 40)
          (send dc draw-ellipse 396 88 40 40))

(define main-frame (new frame%
                        [label "Eowyn's board-game"]
                        [width 500]
                        [height 420]))
(define main-frame-canvas
  (new canvas%
       [parent main-frame]
       [min-width 500]
       [min-height 420]
       [paint-callback
        (lambda (canvas dc)
          (draw-board canvas dc)
          (draw-players canvas dc))]))

(define button-panel (new horizontal-panel%
                          [parent main-frame]))
(define start-button (new button%
                          [label "Start"]
                          [parent button-panel]))
(define number-of-players (new choice%
                              [label "Players:"]
                              [parent button-panel]
                              [choices (list "2"
                                             "3"
                                             "4"
                                             "5")]))

(send main-frame show #t)