#lang racket

(require racket/gui/easy
         racket/class
         racket/draw)

(define (run prog . args)
  (apply system* (find-program prog) args))
 
(define (find-program str)
  (or (find-executable-path str)
      (error 'pfsh "could not find program: ~a" str)))

(define main
  (window
    #:title "alles"
    #:size '(400 #f)
    #:position 'center
    #:style '(no-resize-border)
    (vpanel
      (input "lala"
          #:enabled? #t
          #:min-size '(#f 75)
          #:font (make-object font%
                    48
                    'modern))
      (button "exec-things"
        (λ () (system "ydotool mousemove 100 100"))))))

(render main)
(send main dependencies)