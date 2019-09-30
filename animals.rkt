;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname animals) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)


;; eye: image -> image
;; to draw the cat's eye
(define eye
  (overlay (circle 5 "solid" "black")
           (circle 9 "solid" "blue")
           (circle 18 "outline" "black")))

;; right-ear: image -> image
;; to define the right ear of the cat
(define right-ear
 (underlay (rotate 13(triangle/sss 40 40 40 "solid" "black"))
          (rotate 13 (triangle/sss 15 15 15 "solid" "pink"))))

;; left-ear: image -> image
;; to define the left ear of the cat by reversing the right
(define left-ear
  (flip-horizontal right-ear))

;; nose: image -> image
;; to define the nose
(define nose
  (overlay (beside (circle 2 "solid" "black")
                   (circle 1 "solid" "pink")
                   (circle 2 "solid" "black"))
           (rotate 180(triangle 20 "solid" "pink"))))

;; mouth: image -> image
;; to define the mouth of the cat
(define mouth
  (rectangle 30 2 "solid" "white"))

;; cat-with-eyes-nose-mouth: image -> image
;; to make the eyes, mouth and nose of the cat align with each other
(define cat-with-eyes-and-nose
  (overlay (above (beside eye eye) (circle 1 "solid" "black")
                  nose (circle 3 "solid" "black") mouth)
           (circle 60 "solid" "black")))

;; cat: image -> image
;; to define the cat
(define cat
  (overlay/align
   "center"
   "top"
   (beside left-ear
          (rectangle 60 0 "solid" "red")
          right-ear)
   cat-with-eyes-and-nose))

cat
