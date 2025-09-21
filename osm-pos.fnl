(local zoom-lvl 19)
(local anchors-corner
       [;; bottom right
        {:chunk {:x 651 :y 1170}
         :pos {:x 0 :y 0}
         :view {:x 3000 :y 2000}
         :coord {:lat -24.8466448026336 :lng -65.56631869072267}}
        ;; bottom left
        {:chunk {:x 650 :y 1170}
         :pos {:x 999 :y 0}
         :view {:x 2999 :y 2000}
         :coord {:lat -24.8466448026336 :lng -65.56649447197267}}
        ;; top left
        {:chunk {:x 650 :y 1169}
         :pos {:x 999 :y 999}
         :view {:x 2999 :y 1999}
         :coord {:lat -24.84648529234923 :lng -65.56649447197267}}
        ;; top right
        {:chunk {:x 651 :y 1169}
         :pos {:x 0 :y 999}
         :view {:x 3000 :y 1999}
         :coord {:lat -24.84648529234923 :lng -65.56631869072267}}])

;; chunk 651 1170
(local anchors-single
       [;; top left of the chunk
        {:pos {:x 0 :y 0}
         :view {:x 3000 :y 2000}
         :coord {:lat -24.8466448026336 :lng -65.56631869072267}}
        ;; bottom right of the chunk
        {:pos {:x 999 :y 999}
         :view {:x 3999 :y 2999}
         :coord {:lat -25.005892703813565 :lng -65.39071322197266}}
        ;; top right of the chunk
        {:pos {:x 999 :y 0}
         :view {:x 3999 :y 2000}
         :coord {:lat -24.8466448026336 :lng -65.39071322197266}}
        ;; bottom left of the chunk
        {:pos {:x 0 :y 999}
         :view {:x 3000 :y 2999}
         :coord {:lat -25.005892703813565 :lng -65.56631869072267}}])

;; When rendering the map, lat maps to y and lng to x in world space
(local pixel-ratios
       {;; left to right 
        :x-lng (- (. anchors-corner 1 :coord :lng)
                  (. anchors-corner 2 :coord :lng))
        ;; bottom to top
        :y-lat (- (. anchors-corner 2 :coord :lat)
                  (. anchors-corner 3 :coord :lat))})

(local chunk-ratios {:x-lng (* pixel-ratios.x-lng 1000)
                     :y-lat (* pixel-ratios.y-lat 1000)})

(print (* chunk-ratios.x-lng 651) (* chunk-ratios.y-lat 1170))

(fn rad->deg [rad-ang]
  (* rad-ang (/ 180 math.pi)))

(fn deg->rad [deg-ang]
  (* deg-ang (/ math.pi 180)))

(fn sinh [x]
  (/ (- (math.exp x) (math.exp (- x))) 2))

;; https://wiki.openstreetmap.org/wiki/Slippy_map_tilenames#Common_programming_languages
(fn coord->osmtile [lat lng zoom]
  (let [lat-rad (deg->rad lat)
        n (math.pow 2 zoom)
        nz-1 (/ n 2)
        xtile (* n (/ (+ lng 180) 360))
        lat-log (math.log (+ (math.tan lat-rad) (/ 1 (math.cos lat-rad))))
        ytile (* nz-1 (- 1 (/ lat-log math.pi)))]
    {: xtile : ytile : zoom}))

(fn osmtile->coord [xtile ytile zoom]
  (let [n (math.pow 2 zoom)
        lng (- (* (/ xtile n) 360) 180)
        lat-sinh (sinh (* math.pi (- 1 (* 2 (/ ytile n)))))
        lat (rad->deg (math.atan lat-sinh))]
    {: lat : lng : zoom}))

(each [_i {: _chunk : _pos : coord} (ipairs anchors-corner)]
  (let [{: lat : lng} coord
        {: xtile : ytile} (coord->osmtile lat lng zoom-lvl)
        {:lat lat2 :lng lng2} (osmtile->coord xtile ytile zoom-lvl)]
    (print (string.format "(%f,%f) -> (%d,%d) -> (%f,%f)" lat lng xtile ytile
                          lat2 lng2))))
