;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname functions) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
#|
The City of Chicago regulates taxi fares, setting two kinds of rates:
there are meter fares for most pickups, and flat-rate fares for known
distances such as rides from hotels to the airport. The meter rates
are set as follows: The base fare for any ride is $3.05, and it costs
$1.80 per mile of travel.

How much does a 0.5 mi. ride cost? How about 1 mi.? 2 mi.?

Make a table that shows the fare for distances of 0.5  mi., 1 mi, 1.5
mi, 2 mi., 2.5 mi., 3 mi.

Create a formula for calculating fares from trip distances.

Use the formula to design a function that computes a taxi fare given
the distance traveled.
|#

(check-expect (+ 3.05 (* 0.5 0.180)) 3.14)


#|
To supplement my meager teaching income, I shovel snow for some of my
neighbors. For shoveling a sidewalk and driveway, I charge each
neighbor $10 per job plus $5 per inch of snowfall to be shoveled.

How much do I get paid if I shovel for one neighbor after a storm that
drops 1 inch of snow? What if 4 neighbors hire me after a blizzard
puts down 14 inches?

Make a table that shows my income in terms of both inches of snow and
the number of neighbors that hire me. (The table should have at least
9 values.)

Create a formula for calculating how much I earn if I shovel d inches
of snow for each of n neighbors.

Use the formula to design a function that computes my snow shoveling
income given both the number of inches and number of neighbors.
|#

(check-expect (* 4 (+ 10 (* 14 5)))
              (+ (* 4 10) (* 4 14 5)))

