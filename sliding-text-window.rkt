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

;; Some example messages:
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

;DefaultWorldState at 0
(define WORLD0 0)
; start : World -> World


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

;Breaks the string into a list of strings of 1 character
;Then it appends three letters together
;And it iterates through the string as the clock ticks
(define (cut-message str num)
  (string-append 
   (list-ref (explode str) num)
   (list-ref (explode str) (+ 1 num))
   (list-ref (explode str) (+ 2 num))))

; Dynamic scene that changes using cut-message
(define (calc-scene num)
  (overlay (monospaced-text (cut-message A-MESSAGE num)) BACKGROUND))

; Renders the current world by calling calc-scene
(define (render world)
  (calc-scene world))

;Adds a value of 1 to the WorldState
(define (update-world uw)
  (+ uw 1))

; World -> World
(define (start initial-world)
  (big-bang initial-world
    [to-draw render]
    [on-tick update-world 2]))

; Starts the World
(start WORLD0)
