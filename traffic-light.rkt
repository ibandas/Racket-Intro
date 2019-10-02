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

;; the radius of the circle
(define RADIUS 20)   

;; the dimensions of the background
(define BACKGROUND (empty-scene 300 300))

;; defines the walk sign and the no-walk sign
(define Walk-Sign (text "Walk" 11 "black"))
(define No-Walk-Sign (text "Don't Walk" 11 "black"))

;; the different colors of the traffic light
(define Red-Circle (circle RADIUS "solid" "red"))
(define Green-Circle (circle RADIUS "solid" "green"))
(define Orange-Circle (circle RADIUS "solid" "orange"))


;; Starts world on Red and Don't Walk
;; start : World -> World
(define FS-WORLD0  "Red-Sit-Circle")

;; Red-Sit-Scene : World -> World
;;Enumerations
;1st State
(define Red-Sit-Scene
  (overlay No-Walk-Sign Red-Circle BACKGROUND))

;; Red-Walk-Scene : World -> World
;; 2nd State 
;; Represents a Red and Walk combination
(define Red-Walk-Scene
  (overlay Walk-Sign Red-Circle BACKGROUND))

;; Green-Walk-Scene : World -> World
;; 3rd State
;; Represents a Green and Walk combo
(define Green-Walk-Scene
  (overlay Walk-Sign Green-Circle BACKGROUND))

;; Green-Sit-Scene : World -> World
;; 4th State 
;; Represents a Green & Don't Walk combination
(define Green-Sit-Scene
  (overlay No-Walk-Sign Green-Circle BACKGROUND))

;; Orange-Sit-Scene : World -> World
;; 5th State
;; represents an Orange and Don't Walk combination
(define Orange-Sit-Scene
  (overlay No-Walk-Sign Orange-Circle BACKGROUND))

;; render-circle: CurrentWorldState -> World
;; renders the current world state given the definition name
;; EXAMPLE
 (check-expect (render-circle "Red-Sit-Circle") (overlay No-Walk-Sign Red-Circle BACKGROUND))
 (check-expect (render-circle "Red-Walk-Circle") (overlay Walk-Sign Red-Circle BACKGROUND))
 (check-expect (render-circle "Green-Walk-Circle") (overlay Walk-Sign Green-Circle BACKGROUND))
 (check-expect (render-circle "Green-Sit-Circle") (overlay No-Walk-Sign Green-Circle BACKGROUND))
 (check-expect (render-circle "Orange-Sit-Circle") (overlay No-Walk-Sign Orange-Circle BACKGROUND))
 

(define (render-circle world)
  (cond
    [(string=? world "Red-Sit-Circle")  Red-Sit-Scene]
    [(string=? world "Red-Walk-Circle")  Red-Walk-Scene]
    [(string=? world "Green-Walk-Circle")  Green-Walk-Scene]
    [(string=? world "Green-Sit-Circle")  Green-Sit-Scene]
    [(string=? world "Orange-Sit-Circle") Orange-Sit-Scene]))

;; update-world: CurrentWorldState -> NextWorldState
;; on-tick function
;; changes WorldState every 3 seconds
;; EXAMPLE
 (check-expect (update-world "Green-Walk-Circle") "Green-Sit-Circle")
 (check-expect (update-world "Orange-Sit-Circle") "Red-Sit-Circle")
 (check-expect (update-world "Red-Sit-Circle") "Red-Walk-Circle")
 (check-expect (update-world "Red-Walk-Circle") "Green-Walk-Circle")
 (check-expect (update-world "Green-Sit-Circle") "Orange-Sit-Circle")

(define (update-world uw)
  (cond
    [(string=? uw "Red-Sit-Circle") "Red-Walk-Circle"]
    [(string=? uw "Red-Walk-Circle") "Green-Walk-Circle"]
    [(string=? uw "Green-Walk-Circle") "Green-Sit-Circle"]
    [(string=? uw "Green-Sit-Circle") "Orange-Sit-Circle"]
    [(string=? uw "Orange-Sit-Circle") "Red-Sit-Circle"]))

;; start: World -> World
;; big-bang is used where to-draw renders the current world state
;; on-tick calls the update-world function which changes the world state
(define (start initial-world)
  (big-bang initial-world
    [to-draw render-circle]
    [on-tick update-world 3]))

;; starts the test with the initial world state
; (start FS-WORLD0)

