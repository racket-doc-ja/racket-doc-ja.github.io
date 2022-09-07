#lang plait

;; The first line above is important. It tells DrRacket which
;;  variant of Racket you want to use.

;; This is a comment that continues to the end of the line.
; One semi-colon is enough.

;; A common convention is to use two semi-colons for
;; multiple lines of comments, and a single semi-colon
;; when adding a comment on the same
;; line as code.

#| This is a block comment,
   which starts with "#|"
   and ends with a "|#". Block comments
   can be nested, which is why I can
   name the start and end tokens in this
   comment. |#

;; #; comments out a single form. We use #; below
;; to comment out error examples.
#;(/ (+ 1 1)
     0)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Built-in atomic data

;; Booleans

#t    ; true
#f    ; false

;; Numbers

1
0.5
1/2  ; this is a literal fraction, not a division operation
1+2i ; complex number

;; Strings

"apple"
"banana cream pie"

;; Symbols

'apple
'banana-cream-pie
'a->b
'#%$^@*&?!

;; Characters (unlikely to be useful)

#\a
#\b
#\A
#\space  ; same as #\  (with a space after \)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Built-in functions on atomic data

(not #t) ; => #f
(not #f) ; => #t

(+ 1 2) ; => 3
(- 1 2) ; => -1
(* 1 2) ; => 2
;; etc.

(< 1 2)  ; => #t
(> 1 2)  ; => #f
(= 1 2)  ; => #f
(<= 1 2) ; => #t
(>= 1 2) ; => #f

(string-append "a" "b") ; => "ab"
(string=? "a" "b")      ; => #f
(string-ref "a" 0)      ; => #\a

(char=? #\a #\b) ; => #f

(equal? "apple" "apple")   ; => #t
(string=? "apple" "apple") ; => #t
(equal? "apple" (string-append "a" "pple")) ; => #t

(eq? 'apple 'apple)       ; => #t
(eq? 'apple 'orange)      ; => #f
(eq? "apple" "apple")     ; => #t
(eq? "apple" (string-append "a" "pple")) ; => #f

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Types

1         ; => 1, but says "Number" first
(+ 1 1/2) ; => 3/2, but says "Number" first

"a"       ; => "a", but says "String"

not       ; => #<procedure:not>, but says "(Boolean -> Boolean)"

#;(+ 1 "1/2") ; error: Number vs String

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; S-expressions

`(+ 1 2) ; => `(+ 1 2), but says "S-Expression" first

`1       ; => `1
`"a"     ; => `"a"

`a       ; => 'a, and says "S-expression" first
'a       ; => 'a, and says "Symbol" first
(symbol->s-exp 'a) ; => `a

(s-exp->number `1) ; => 1
(number->s-exp 1) ; => `1

#;(s-exp->string `1) ; says "String", but then reports an error

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Basic expression forms

;; Procedure application
;;  (<expr> <expr> ...)

(not #f)                  ; => #f
(+ 1 2)                   ; => 3
(string-append "a" "b")   ; => "ab"

;; Conditionals
;;  (cond
;;    [<expr> <expr>] ...)
;;  (cond
;;    [<expr> <expr>] ...
;;    [else <expr>])

(cond                     ;
  [(< 2 1) 17]            ;
  [(> 2 1) 18])           ; => 18

(cond                     ; second expression not evaluated
  [#t 8]                  ;
  [#f (/ 1 0)])           ; => 8

(cond                     ; in fact, second test not evaluated
  [#t 9]                  ;
  [(zero? (/ 1 0)) 0])    ; => 9

(cond                     ; any number of cond-lines allowed
  [(< 3 1) 0]             ;
  [(< 3 2) 1]             ;
  [(< 3 3) 2]             ;
  [(< 3 4) 3])            ; => 3

(cond                     ; else allowed as last case
  [(eq? 'a 'b) 0]         ;
  [(eq? 'a 'c) 1]         ;
  [else 2])               ; => 2

;; If
;;   (if <expr> <expr> <expr>)
  
(if (< 3 1)               ; simpler form for single test
    "apple"               ;
    "banana")             ; => "banana"

;; And and Or
;;  (and <expr> ...)
;;  (or <expr> ...)

(and #t #t)                   ; => #t
(and #t #f)                   ; => #f
(and (< 2 1) #t)              ; => #f
(and (< 2 1) (zero? (/ 1 0))) ; => #f (second expression is not evaluated)

(or #f #t)                    ; #t
(or #f #f)                    ; #f
(or (< 1 2) (zero? (/ 1 0))) ; => #t (second expression is not evaluated)

(and #t #t #t #t)             ; => #t
(or #f #f #f)                 ; => #f

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Built-in compound data

;; Lists

empty                     ; => '()

(list 1 2 3)              ; => '(1 2 3), but shows "(Listof Number)" first
'(1 2 3)                  ; => '(1 2 3)
(cons 0 (list 1 2 3))     ; => '(0 1 2 3)

(list 'a 'b)              ; => '(a b), because ' also distributes to elements

#;(list 1 'a)  ; error: Number vs Symbol

(list "a" "b")             ; => '("a" "b")
(list (list 1 2) (list 3)) ; '((1 2) (3))

(cons 1 empty)            ; => '(1)

(cons 'a (cons 'b empty))  ; => '(a b)

(list (list 1) empty)      ; => '((1) ())
(cons (list 1) empty)      ; => '((1))

(append (list 1 2) empty) ; => '(1 2)
(append (list 1 2)
        (list 3 4))       ; => '(1 2 3 4)

(first (list 1 2 3))      ; => 1
(rest (list 1 2 3))       ; => '(2 3)
(first (rest (list 1 2))) ; => 2

(list-ref (list 1 2 3) 2) ; => 3

`(1 2 3) ; => `(1 2 3), but says "S-Expression" first
(first (s-exp->list `(1 2 3))) ; => `1, but says "S-Expression" first

;; Vectors

(vector 1 2 3 4)            ; => '#(1 2 3 4), but shows "(Vectorof Number)"
(vector-ref (vector 1 2) 0) ; => 1

;; Boxes

(box 1)                   ; => '#&1
(unbox (box 1))           ; => 1

;; Tuples

(values 1 2)   ; => (values 1 2), but says "(Number * Number)" first
(values 1 "a") ; => (values 1 "a"), but says "(Number * String)" first

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Definitions

;; Defining constants
;;  (define <id> <expr>)

(define PI 3.14159)
(* PI 10)                 ; => 31.4159

;; Defining functions
;;  (define (<id> <id> ...) <expr>)

(define (circle-area r)
  (* PI (* r r)))
(circle-area 10)          ; => 314.159

(define (is-odd? x)
  (if (zero? x)
      #f
      (is-even? (- x 1))))
(define (is-even? x)
  (if (zero? x)
      #t
      (is-odd? (- x 1))))
(is-odd? 12)              ; => #f

;; Definition matching a tuple

(define-values (size color) (values 10 'red))
size ; => 10
color ; => 'red

;; Declaring types

(define e : Number 2.71828)

;; Declaring argument and result types
;;  (define (<id> [<id> : <type>] ...) : <type> <expr>)

(define (circle-perimeter [r : Number]) : Number
  (* 2 (* PI r)))

(circle-perimeter 10) ; => 62.8318

;; Defining datatypes
;;  (define-type <id>
;;    [<id> (<id> : <type>) ...] ...)

(define-type Animal
  [snake (name : Symbol)
         (weight : Number)
         (food : Symbol)]
  [tiger (name : Symbol)
         (stripe-count : Number)])

(snake 'Slimey 10 'rats)  ; => (snake 'Slimey 10 'rats)
(tiger 'Tony 12)          ; => (tiger 'Tony 12)

(list (tiger 'Tony 12))   ; => (list (tiger 'Tony 12))
                          ;    since use of `tiger' cannot be quoted

#;(snake 10 'Slimey 5)    ; error: Symbol vs Number

(snake-name (snake 'Slimey 10 'rats)) ; => 'Slimey
(tiger-name (tiger 'Tony 12)) ; => 'Tony

(snake? (snake 'Slimey 10 'rats)) ; => #t
(tiger? (snake 'Slimey 10 'rats)) ; => #f

#; (snake? 5) ; error: Number vs Animal

;; A type can have any number of variants:
(define-type Shape
  [square (side : Number)]
  [circle (radius : Number)]
  [triangle (height : Number)
            (width : Number)])

(define (curvy? [s : Shape]) : Boolean
  (circle? s))

(curvy? (square 5)) ; => #f
(curvy? (circle 5)) ; => #t
(curvy? (triangle 3 5)) ; => #f

;; Parameterized datatypes (like "generics" in Java)
;;  (define-type (<id> '<id> ...)
;;    [<id> (<id> : <type>) ...] ...)

(define-type (Tree 'a)
  [leaf (val : 'a)]
  [node (left : (Tree 'a))
        (right : (Tree 'a))])

(leaf 10) ; => (leaf 10), but says "(Tree Number)" first
(leaf (circle 8)) ; => (leaf 10), but says "(Tree Shape)" first

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Local binding forms

;; Local
;;  (local [<definition> ...] <expr>)

(local [(define x 10)]
  (+ x x))                ; => 20

#;x                       ; error: unbound identifier

(define (to-the-fourth x)
  (local [(define (squared n)
            (* n n))]
    (* (squared x) (squared x))))
(to-the-fourth 10)        ; => 10000

(local [(define (odd? x)
          (if (zero? x)
              #f
              (even? (- x 1))))
        (define (even? x)
          (if (zero? x)
              #t
              (odd? (- x 1))))]
  (odd? 12))              ; => #f

;; Let (more traditional but less regular)
;;  (let ([<id> <expr>] ...) <expr>)

(let ([x 10]
      [y 11])
  (+ x y))                ; => 21

(let ([x 0])
  (let ([x 10]
        [y (+ x 1)])
    (+ x y)))             ; => 11

(let ([x 0])
  (let* ([x 10]
         [y (+ x 1)])
    (+ x y)))             ; => 21

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Datatype case dispatch

;; Type case
;;  (type-case <id> <expr>
;;    [(<id> <id> ...) <expr>] ...)
;;  (type-case <id> <expr>
;;    [(<id> <id> ...) <expr>] ...
;;    [else <expr>])

(type-case Animal (snake 'Slimey 10 'rats)
  [(snake n w f) n]
  [(tiger n sc) n])      ; => 'Slimey

(define (animal-name a)
  (type-case Animal a
    [(snake n w f) n]
    [(tiger n sc) n]))

(animal-name (snake 'Slimey 10 'rats)) ; => 'Slimey
(animal-name (tiger 'Tony 12)) ; => 'Tony

#;(animal-name 10)        ; error: Number vs Animal

#;(type-case Food ...)    ; error: Food is not a defined type
  
#;(define (animal-weight a)
    (type-case Animal a
      [snake (n w f) w])) ; error: missing tiger case
  
(define (animal-weight a)
  (type-case Animal a
    [(snake n w f) w]
    [else 0]))

;; Type case also works on lists with special `empty` and `cons`
;; patterns to match empty and non-empty lists, respectively

(define (list-length l)
  (type-case (Listof Symbol) l
    [empty 0]
    [(cons fst rst) (+ 1 (list-length rst))]))

(list-length '(apple banana coconut)) ; => 3

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; First-class functions

;; Anonymous function:
;;  (lambda (<id> ...) <expr>)

(lambda (x) (+ x 1))      ; => #<procedure>, but shows "(Number -> Number)" first

((lambda (x) (+ x 1)) 10) ; => 11

(define add-one
  (lambda (x)
    (+ x 1)))
(add-one 10)              ; => 11

(define add-two : (Number -> Number)
  (lambda (x)
    (+ x 2)))
(add-two 10)              ; => 12

(define (make-adder n)
  (lambda (m)
    (+ m n)))
(make-adder 8)            ; => #<procedure>
(define add-five (make-adder 5))
(add-five 12)             ; => 17
((make-adder 5) 12)       ; => 17

(map (lambda (x) (* x x))
     (list 1 2 3))        ; => (list 1 4 9)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Side-effects
;;  IMPORTANT: in this class using a side-effect is
;;             usually wrong; avoid all side-effects

;; set! and begin
;;  (set! <id> <expr>)
;;  (begin <expr>*)

(define count 0)

(set! count (+ count 1))  ; =>
count                     ; => 1

(begin
  (set! count (+ count 1))
  count)                  ; => 2

(local [(define x '())]   ; note: demonstrates set! in local,
  (begin                  ;       but it's terrible style
    (set! x (cons 1 x))   ;
    (set! x (cons 2 x))   ;
    x))                   ; => '(2 1)

;; set-box! is a function:

(define B (box 10))
(set-box! B 12)           ; =>
B                         ; => (box 12)
(unbox B)                 ; => 12

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Polymorphic functions

(define identity (lambda (x) x))

identity       ; => #<procedure>, but shows "('a -> 'a)" first
(identity "a") ; => "a"
(identity 1)   ; => 1

empty  ; => '(), but shows "(list 'a)" first
cons   ; => #<procedure>, but shows "('a (Listof 'a) -> 'a)" first

(define b (box empty))
b      ; => '#&(), but shows "(Boxof (Listof '_a))" first
(set-box! b (list 1)) ; =>
#;(set-box! b (list "a")) ; error: Number vs String

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Testing

;; test, test/pred, and test/exn functions:

(test (+ 5 5) 10)         ; => displays (good 10 10 "...")
(test (+ 5 4) 10)         ; => error-displays (bad 9 10 "...")

(test/exn (cond) "no matching")            ; => displays (good ...)
(test/exn (cond) "bad dog")                ; => error-displays (exception ...)
(test/exn (cond [#t 10]) "no matching")    ; => error-displays (exception ...)

(print-only-errors #t)
(test (+ 5 5) 10)         ; => no display
(test (+ 5 4) 10)         ; => error-displays (bad 9 10 "...")

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; More information

;; Use the "Help Desk" item in DrRacket's "Help" menu
;; and see "Plait Language"
