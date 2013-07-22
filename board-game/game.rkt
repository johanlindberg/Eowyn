#lang racket/gui

(define main-frame (new frame% [label "--"] [width 800] [height 600]))
(send main-frame show #t)