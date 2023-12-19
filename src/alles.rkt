#lang racket/base

(require racket/gui/base
         racket/class
         racket/system
         racket/match
         "threading.rkt")

(define frame
  (new frame% [label "alles"]
              [x 300] [y 300]
              [style '()]
              [width 300] [height 100]))

(define (keycode->string keycode)
  (cond
    [(symbol? keycode) (symbol->string keycode)]
    [(char? keycode) (string keycode)]
    [else "how?"]))

(define (wrap-key-descriptor key-descriptor condition modifier-name)
  (if condition
      (string-append "(" modifier-name " " key-descriptor ")")
      key-descriptor))

(define (cons-single-key-descriptor key C? M?)
  (~> key
      (wrap-key-descriptor M? "Meta")
      (wrap-key-descriptor C? "Ctrl")
      ))

(define (get-single-key-descriptor key-event)
  (define keycode (send key-event get-key-code))
  (define ctrl-down? (send key-event get-control-down))
  (define meta-down? (send key-event get-meta-down))
  (define keystring (cons-single-key-descriptor (keycode->string keycode) ctrl-down? meta-down?))
  keystring)

(define my-canvas%
  (class canvas% ; The base class is canvas%
    ; Define overriding method to handle keyboard events
    (define/override (on-char key-event)
      (handle-key-event key-event))
    ; Call the superclass init, passing on all init args
    (super-new)))
 
; Make a canvas that handles events in the frame
(define my-canvas (new my-canvas% [parent frame]))

(define msg (new message% [parent frame]
                          [font (make-object font% 48 'modern)]
                          [label "Nothing happened so far."]))

(define (handle-key-event key-event)
  (define single-key-descriptor (get-single-key-descriptor key-event))
  (match single-key-descriptor
    ["q"            (send frame show #f)]
    ["n"            (begin (system "firefox --new-tab 'search.nixos.org';
                                    sleep 0.5;
                                    ydotool key 125:1 15:1 15:0 125:0")
                            )]
    ["(Ctrl n)"    (begin (system "firefox --new-tab 'search.nixos.org/options';
                                    sleep 0.5;
                                    ydotool key 125:1 15:1 15:0 125:0")
                            )]
    [_ (send msg set-label single-key-descriptor)]))

(send my-canvas focus)
(send frame show #t)
