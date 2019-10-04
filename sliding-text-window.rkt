;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname sliding-text-window) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
#|

Write a universe program that will, piece by piece, display
a message, such as the string `A-MESSAGE` defined below. At
any given moment, we should see exactly 3 characters of the
message and, as time ticks, the three characters that are
visible should move forward through the message below. For
example, at the first time tick, we should see

  Wel

and the in the second time tick we should see:

  elc

and then

  lco

until time ticks to the end of the string. At that point, we
should see:

  IPD

and then

  PD!

and then the beginning of the string should appear, right
next to the content at the end, namely:

  D!W

and then

  !We

and then

  Wel

as before. And the entire process should repeat, for all
time.

Try to make it be the case that if someone calls your
function with `ANOTHER-MESSAGE` instead of `A-MESSAGE`, then
your program should still work (displaying the different
message). If there are any situations where your program
would fail to work for some possible message string, note
them in comments in your solution.

Think carefully about what the World state should be. It
needs to be some kind of a number, but not just any old
number is allowed.

|#

(require 2htdp/image)
(require 2htdp/universe)

;; defines some example messages:
(define A-MESSAGE       "Welcome to IPD!")
(define ANOTHER-MESSAGE "This message should work, too. ")


#|
Note: when making the image, consider using a fixed-width
font. The font named “Courier New” or “Monospace” might
work. (Usually most computers have one of those installed.)
Below is a helper function that should do the trick on all
platforms (but will look best on a Mac)
|#

;Background
(define BACKGROUND (empty-scene 350 50))

;DefaultWorldState at 2
(define WORLD0 2)

;; A SlidingTextWorld is a Natural in [2, (+ 1 (string-length A-MESSAGE))]
 ; interp. 2 plus the index of the first shown character



; monospaced-text : String -> Image
; the body of this function uses something called a "symbol"
; it is a lot like a string, except it begins with a ' mark
; and ends with whitespace. Don't worry about this too much;
; they are needed to call “text/font”
(define (monospaced-text str)
  (text/font str
             36
             "black"
             "Monospace" 'modern
             'normal 'normal #f))

;; cut-message : string number -> string
;; Breaks the string into a list of strings of 1 character
;; Then it appends three letters together
;; And it iterates through the string as the clock ticks

(check-expect (cut-message A-MESSAGE 2) "Wel")
(check-expect (cut-message A-MESSAGE (string-length A-MESSAGE)) "D!W")
(check-expect (cut-message A-MESSAGE (+ 1 (string-length A-MESSAGE))) "!We")
(define (cut-message str num)
  (cond
    [(= num (string-length str))
     (string-append 
      (list-ref (explode str) (- num 2))
      (list-ref (explode str) (- num 1))
      (list-ref (explode str) (- num (string-length str))))]
    [(= num (+ 1 (string-length str)))
     (string-append 
      (list-ref (explode str) (- num 2))
      (list-ref (explode str) (- num (+ 1 (string-length str))))
      (list-ref (explode str) (- num (string-length str))))]
    [else
     (string-append 
      (list-ref (explode str) (- num 2))
      (list-ref (explode str) (- num 1))
      (list-ref (explode str) num))]
    ))

;; calc-scene : string number -> image
;; Dynamic scene that changes using cut-message
(define (calc-scene str num)
  (overlay (monospaced-text (cut-message str num)) BACKGROUND))

;; render : SlidingTextWorld -> SlidingTextWorld
;; Renders the current world by calling calc-scene
(define (render world)
  (calc-scene A-MESSAGE world))

;; update-world: SlidingTextWorld -> SlidingTextWorld
;; Adds a value of 1 to the SlidingTextWorld
;; whenever the SlidingTextWorld is not equal to 1 + the length of string being put in,
;; otherwise it will substract one less than the length of the string to
;; bring the SlidingTextWorld back to it's initial value of 2
(check-expect (update-world 3) 4)
(check-expect (update-world 10) 11)
(check-expect (update-world (+ (string-length A-MESSAGE) 1)) 2)
(define (update-world uw)
  (cond
    [(= uw (+ (string-length A-MESSAGE) 1)) (- uw (- (string-length A-MESSAGE) 1))]
    [else (+ uw 1)]))

;; start: SlidingTextWorld -> SlidingTextWorld
;; a big-bang function which uses to-draw to render the current world
;; on-tick to update-world to change the string dynamically
(define (start initial-world)
  (big-bang initial-world
    [to-draw render]
    [on-tick update-world .5]))

; Starts the World
; (start WORLD0)
