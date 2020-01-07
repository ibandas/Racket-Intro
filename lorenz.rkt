;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname lorenz) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
#|
The Lorenz attractor is a beautiful (IMO) non-repeating motion in three
dimensional space that is governed by the following differential
equations (for appropriate definitions of the constants σ, ρ, and β):
dx/dt = σ * (y-x)
dy/dt = x*(ρ - z) - y
dz/dt = x*y - β*z
We can simulate the motion that these equations describe by translating
them into BSL. (If you are not familiar with differential equations,
don’t worry; the assignment explains how to use them.)
|#
(require 2htdp/image)
(require 2htdp/universe)

; LorenzWorldState is one which has four dots/points
; interp. dots/points are Images at of small red circles
; at specific coordinates


(define SIGMA 10)  ; σ
(define BETA 8/3)  ; β
(define RHO 28)    ; ρ

(define TIME-STEP #i0.01)
(define EPSILON #i1e-5)

; Number Number Number -> Number
; Computes the next x coordinate given the x, y, and z coordinates.

(check-within (next-x 1 1 1) 1 EPSILON)

; Strategy: domain knowledge
(define (next-x x y z)
  (+ x (* TIME-STEP (* SIGMA (- y x)))))


; Number Number Number -> Number
; Computes the next y coordinate given the x, y, and z coordinates.

(check-within (next-y 1 1 1) 1.26 EPSILON)

; Strategy: domain knowledge
(define (next-y x y z)
  (+ y (* TIME-STEP (- (* x (- RHO z)) y))))


; Number Number Number -> Number
; Computes the next z coordinate given the x, y, and z coordinates.

(check-within (next-z 1 1 1) 0.98333 EPSILON)

; Strategy: domain knowledge
(define (next-z x y z)
  (+ z (* TIME-STEP (- (* x y) (* BETA z)))))

; Constants
(define RADIUS 2)
(define DOT (circle RADIUS "solid" "red"))

; Defines a struct named "dot"
; "dot" takes in a image(circle), number, number, number
; x y z are used for position
(define-struct dot [circle x y z])
(define POINT1 (make-dot DOT 1 1 1))

; dot -> dot
(check-within (update-point POINT1) (make-dot DOT 1 #i1.26 #i0.983333) EPSILON)
(check-within (update-point (make-dot DOT 1 #i1.26 #i0.983333))
              (make-dot DOT #i1.026 #i1.517566 #i0.969710) EPSILON)
; This function creates a new dot with the same constant image (DOT)
; but with new values that it computes for x, y, and z
; using next-x, next-y, and next-z
; Strategy : Domain Knowledge & Structural Decomposition
(define (update-point up)
  (make-dot
   DOT
   (next-x (dot-x up)
           (dot-y up)
           (dot-z up))
   (next-y (dot-x up)
           (dot-y up)
           (dot-z up))
   (next-z (dot-x up)
           (dot-y up)
           (dot-z up))))

; More Constants
; This was defined strategically below the "update-point" function
; POINT2 is created based off of POINT1
; POINT3 is created based off of POINT2
; POINT4 is created based off of POINT3
(define POINT2 (update-point POINT1))
(define POINT3 (update-point POINT2))
(define POINT4 (update-point POINT3))

; Defines a struct named "lorenz"
; lorenz takes in four dots
; lorenz also becomes the world state
(define-struct lorenz [point1 point2 point3 point4])

; DefaultWorldState takes in a lorenz which is composed of four dots
; The first dot is (1, 1, 1) and the 2nd/3rd/4th dots
; are determined through calculation by using "update-point"
; based off each previous point
; (EXAMPLES: Point 2 based off Point 1, Point 3 based off Point 2, etc)
(define WORLD (make-lorenz POINT1 POINT2 POINT3 POINT4))

; Empty scene to place lorenz model on
(define BACKGROUND (empty-scene 600 600))

; render : LorenzWorldState -> Scene (Image)
(check-within (render WORLD)
              (draw-dots (lorenz-point1 WORLD)
                         (lorenz-point2 WORLD)
                         (lorenz-point3 WORLD)
                         (lorenz-point4 WORLD))
              EPSILON)
; Places the image with the current coordinates
; by calling the draw-dots function which uses
; the current four points of the world, or lorenz structure.
; Strategy : Structural Decomposition
(define (render world)
  (draw-dots (lorenz-point1 world)
             (lorenz-point2 world)
             (lorenz-point3 world)
             (lorenz-point4 world)))

; connect-dots : dot dot Image -> Image
(check-within (connect-dots POINT1 POINT2 BACKGROUND)
              (add-line BACKGROUND
                        (+ 300 (* 10 (dot-x POINT1)))
                        (+ 300 (* 10 (dot-y POINT1)))
                        (+ 300 (* 10 (dot-x POINT2)))
                        (+ 300 (* 10 (dot-y POINT2))) "black") EPSILON)
; Connects the points with the built-in add-line function
; Given two points and the image
; interp. The images that will be given will be a nested
; connect-dots function except the last one which will be BACKGROUND
; Strategy : Function Composition
(define (connect-dots point-a point-b pic)
  (add-line
   pic
   (+ 300 (* 10 (dot-x point-a)))
   (+ 300 (* 10 (dot-y point-a)))
   (+ 300 (* 10 (dot-x point-b)))
   (+ 300 (* 10 (dot-y point-b)))
   "black"))

; draw-dots : dot dot dot dot -> Image
(check-within (draw-dots POINT1 POINT2 POINT3 POINT4)
  (connect-dots POINT1 POINT2
    (connect-dots POINT2 POINT3
      (connect-dots POINT3 POINT4
        (place-images
         (list (dot-circle POINT1)
               (dot-circle POINT2)
               (dot-circle POINT3)
               (dot-circle POINT4))
         (list (make-posn (+ 300 (* 10 (dot-x POINT1)))
                          (+ 300 (* 10 (dot-y POINT1))))
               (make-posn (+ 300 (* 10 (dot-x POINT2)))
                          (+ 300 (* 10 (dot-y POINT2))))
               (make-posn (+ 300 (* 10 (dot-x POINT3)))
                          (+ 300 (* 10 (dot-y POINT3))))
               (make-posn (+ 300 (* 10 (dot-x POINT4)))
                          (+ 300 (* 10 (dot-y POINT4))))) BACKGROUND))))
        EPSILON)
; Takes in four dots and places them as points
; while also connecting each point with a line
; using connect-dots
; Point 1 to Point 2 to Point 3 to Point 4
; on a empty scene background
; Strategy: Structural Composition
(define (draw-dots point1 point2 point3 point4)
  (connect-dots
   point1 point2
   (connect-dots
    point2 point3
    (connect-dots
     point3 point4
     (place-images
      (list (dot-circle point1)
            (dot-circle point2)
            (dot-circle point3)
            (dot-circle point4))
      (list (make-posn (+ 300 (* 10 (dot-x point1)))
                       (+ 300 (* 10 (dot-y point1))))
            (make-posn (+ 300 (* 10 (dot-x point2)))
                       (+ 300 (* 10 (dot-y point2))))
            (make-posn (+ 300 (* 10 (dot-x point3)))
                       (+ 300 (* 10 (dot-y point3))))
            (make-posn (+ 300 (* 10 (dot-x point4)))
                       (+ 300 (* 10 (dot-y point4))))) BACKGROUND)))))

; update-lorenz lorenz -> lorenz
(check-within
 WORLD
 (make-lorenz (make-dot DOT 1 1 1)
              (make-dot DOT 1 #i1.26 #i0.983333)
              (make-dot DOT #i1.026 #i1.517566 #i0.969710)
              (make-dot DOT #i1.0751566000 #i1.7797211 #i0.9594212938))
 EPSILON)


; update-lorenz : LorenzWorldState -> LorenzWorldState
(check-within
 (update-lorenz WORLD)
 (make-lorenz
  (make-dot DOT 1 #i1.26 #i0.983333)
  (make-dot DOT #i1.026 #i1.517566 #i0.969710)
  (make-dot DOT #i1.0751566000 #i1.7797211 #i0.9594212938)
  (make-dot DOT #i1.14561305 #i2.052652455637904 #i0.9529715148335759))
 EPSILON)
; Takes in a lorenz model and creates a new one
; based off the current points in the current lorenz model.
; Strategy : Structural Composition
(define (update-lorenz ul)
  (make-lorenz (update-point (lorenz-point1 ul))
               (update-point (lorenz-point2 ul))
               (update-point (lorenz-point3 ul))
               (update-point (lorenz-point4 ul))))         

; update-world : LorenzWorldState -> LorenzWorldState
(check-within (update-world WORLD) (update-lorenz WORLD) EPSILON)
; Takes in a LorenzWorldState and passes it
; to the update-lorenz function to create a new LorenzWorldState
; Strategy : Function Composition
(define (update-world uw)
  (update-lorenz uw))

; LorenzWorldState -> LorenzWorldState
(define (start initial-world)
  (big-bang initial-world
    [to-draw render]
    [on-tick update-world .1]))


; Starts the World
; (start WORLD)

#|
The three functions next-x, next-y, and next-z compute the new positions
for the attractor given the old positions. That is, next-x consumes the
current (x,y,z) position and returns a new x coordinate. Ditto for
next-y and next-z.
Note that the “#i” in front of the time step signifies that this is an
“inexact” number. See the documentation on check-within to help you
testing functions that use those “inexact” numbers. There is a lot to
say about these kinds of numbers; for now just now that there may be
some (usually slight) imprecision in these numbers.
Design a world structure that animates the motion of the Lorenz
attractor. The world structure should hold the three most recent points
that the attractor has visited.
Start by designing a structure for three dimensional points, much like
the one for posns, except with three coordinates. Include some examples
and be sure to include the initial point for the Lorenz simulation,
namely the point where x=1, y=1, and z=1.
To model the Lorenz attractor, you need to track the position in three
dimensional space, but to draw it, you need to map that two dimensions.
Do that by discarding the ‘z’ coordinate, multiplying the ‘x’ and ‘y’
coordinates by 10 and then adding 300 to them. Use an empty scene of
size 600x600 to draw the image.
The Wikipedia page (https://en.wikipedia.org/wiki/Lorenz_system, near
the top) has an animation of the Lorenz attractor. Your world program
should look something like the dot that moves around, except instead
of showing the entire picture in the background, it should show the
only the four most recent points, connected by three lines.
Putting all of these pieces together, the first three line segments
you see should have (approximately) these coordinates:
 (310,310)       -> (310,312.6)
 (310,312.6)     -> (310.26,315.18)
 (310.26,315.18) -> (310.75,317.8)

|#