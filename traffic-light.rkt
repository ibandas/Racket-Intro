;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname traffic-light) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
#|

In Chicago, some traffic lights have, in addition to the
red/orange/green phases, a special pedestrian crossing
indication that changes to walk slightly before the light
turns green and an orange hand that appears slightly before
the main traffic light turns orange.

Design a data definition to capture all of the different
states that the light can take on. (Our solution has five
states; yours should probably too, but if you think a
different number makes more sense, go for it.) When changing
from one state to the next, either the light color should
change or the walk/don’t-walk status should change, never
both. Note that each state should show both the traffic
light and the walk sign.

Write functions to support a big-bang program that draws a
traffic light that cycles appropriately.

|#

(require 2htdp/image)
(require 2htdp/universe)

(define RADIUS 20)   ;; the radius of the circle

(define BACKGROUND (empty-scene 300 300))

(define Walk-Sign (text "Walk" 11 "black"))
(define No-Walk-Sign (text "Don't Walk" 11 "black"))

(define Red-Circle (circle RADIUS "solid" "red"))
(define Green-Circle (circle RADIUS "solid" "green"))
(define Orange-Circle (circle RADIUS "solid" "orange"))


;Starts world on Red and Don't Walk
(define FS-WORLD0  "Red-Sit-Circle")
; start : World -> World

;;Enumerations
;1st State
(define Red-Sit-Scene
  (overlay No-Walk-Sign Red-Circle BACKGROUND))

;2nd State (Change blue to red later)
;Blue represents a Red and Walk combination
(define Red-Walk-Scene
  (overlay Walk-Sign Red-Circle BACKGROUND))

;3rd State
(define Green-Walk-Scene
  (overlay Walk-Sign Green-Circle BACKGROUND))

;4th State (Change purple to green later)
;;Purple represents a Green & Don't Walk combination
(define Green-Sit-Scene
  (overlay No-Walk-Sign Green-Circle BACKGROUND))

;5th State
(define Orange-Sit-Scene
  (overlay No-Walk-Sign Orange-Circle BACKGROUND))

; String -> WorldState
; yields the next state given current state world
;(check-expect (traffic-light-next "red") "green")
(define (render-circle/2 world)
  (cond
    [(string=? world "Red-Sit-Circle")  Red-Sit-Scene]
    [(string=? world "Red-Walk-Circle")  Red-Walk-Scene]
    [(string=? world "Green-Walk-Circle")  Green-Walk-Scene]
    [(string=? world "Green-Sit-Circle")  Green-Sit-Scene]
    [(string=? world "Orange-Sit-Circle") Orange-Sit-Scene]))

;on-tick function
;changes state every 3 seconds
; String -> String
(define (update-world uw)
  (cond
    [(string=? uw "Red-Sit-Circle") "Red-Walk-Circle"]
    [(string=? uw "Red-Walk-Circle") "Green-Walk-Circle"]
    [(string=? uw "Green-Walk-Circle") "Green-Sit-Circle"]
    [(string=? uw "Green-Sit-Circle") "Orange-Sit-Circle"]
    [(string=? uw "Orange-Sit-Circle") "Red-Sit-Circle"]))

; World -> World
(define (start initial-world)
  (big-bang initial-world
    [to-draw render-circle/2]
    [on-tick update-world 3]))

(start FS-WORLD0)

