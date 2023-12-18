#lang racket/base

(require racket/gui)

; (define frame (new frame% [style '(float)] [label "Example"]))


; ; Make a button in the frame
; (new button% [parent frame]
;              [label "Click Me"]
;              ; Callback procedure for a button click:
;              [callback (lambda (button event)
;                          (send msg set-label "Button click"))])

; (send frame show #t)

; (new canvas% [parent frame]
;              [paint-callback
;               (lambda (canvas dc)
;                 (send dc set-scale 3 3)
;                 (send dc set-text-foreground "blue")
;                 (send dc draw-text "Don't Panic!" 0 0))])


(define frame (new frame%
                   [label "Example"]
                   [x 300]
                   [y 300]
                   [width 300]
                   [height 300]
                   ))

(define msg (new message% [parent frame]
                          [label "Nothing happened so far."]))

(define (get-key keycode)
  (cond
    [(symbol? keycode) (symbol->string keycode)]
    [(char? keycode) (string keycode)]
    [else "how?"]))

(define (handle-key-event key-event)
  (define keypress (get-key (send key-event get-key-code)))
  (send msg set-label keypress))

(define my-canvas%
  (class canvas% ; The base class is canvas%
    ; Define overriding method to handle keyboard events
    (define/override (on-char key-event)
      (handle-key-event key-event))
    ; Call the superclass init, passing on all init args
    (super-new)))
 
; Make a canvas that handles events in the frame
(define my-canvas (new my-canvas% [parent frame]))

(send my-canvas focus)
(send frame show #t)
(send frame has-focus?)
(send frame is-enabled?)
(send frame is-shown?)
