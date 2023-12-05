#lang racket/base 

(require racket/gui/easy
         racket/class
         racket/draw)



(render
 (window
  #:title "alles"
  #:size '(400 #f)
  #:position 'center
  #:style '(float)
  (input "lala"
         
         #:enabled? #t
         #:min-size '(#f 75)
         #:font (make-object font%
                  48
                  'modern)
         )))