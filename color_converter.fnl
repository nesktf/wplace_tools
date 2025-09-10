(local chima (require :chimatools))
(local insp (require :inspect))
(local ctx (chima.context.new))
(local ffi (require :ffi))

(fn write-to-file [path str]
  (case (io.open path "wb")
    file (do
           (file:write str)
           (file:close))
    (nil) (print (.. "Failed to open " path))))

(fn parse-color-str [str]
  (let [color-start (str:find "#")
        cols []]
    (if (= color-start nil)
        nil
        (let [len (- (str:len) color-start)]
          (for [i color-start len 2]
            (let [hex (str:sub (+ i 1) (+ i 2))
                  num (tonumber hex 16)]
              (when (not= num nil)
                (table.insert cols num))))
          cols))))

(fn to-color-str [col]
  (var str "#")
  (each [_i comp (ipairs col)]
    (set str (.. str (string.format "%X" comp))))
  str)

(fn wpl-lvl-pixels [lvl]
  (let [lvl-pow (* (math.floor lvl) (math.pow 30 .65))
        pxl-pow (math.pow lvl-pow (/ 1 .65))]
    (math.ceil pxl-pow)))

(fn wpl-lvl-remaining [lvl painted]
  (- (wpl-lvl-pixels lvl) painted))

(print (wpl-lvl-pixels 108) (wpl-lvl-remaining 108 39771))

(local colors [{:name "black" :value [0 0 0]}
               {:name "dark-gray" :value [60 60 60]}
               {:name "gray" :value [120 120 120]}
               {:name "light-gray" :value [210 210 210]}
               {:name "white" :value [255 255 255]}
               {:name "deep-red" :value [96 0 24]}
               {:name "red" :value [237 28 36]}
               {:name "orange" :value [255 127 39]}
               {:name "gold" :value [246 170 9]}
               {:name "yellow" :value [249 221 59]}
               {:name "light-yellow" :value [255 250 188]}
               {:name "dark-green" :value [14 185 104]}
               {:name "green" :value [19 230 123]}
               {:name "light-green" :value [135 255 94]}
               {:name "dark-teal" :value [12 129 110]}
               {:name "teal" :value [16 174 166]}
               {:name "light-teal" :value [19 225 190]}
               {:name "cyan" :value [96 247 242]}
               {:name "dark-blue" :value [40 80 158]}
               {:name "blue" :value [64 147 228]}
               {:name "indigo" :value [107 80 246]}
               {:name "light-indigo" :value [153 177 251]}
               {:name "dark-purple" :value [120 12 153]}
               {:name "purple" :value [170 56 185]}
               {:name "light-purple" :value [224 159 249]}
               {:name "dark-pink" :value [203 0 122]}
               {:name "pink" :value [236 31 128]}
               {:name "light-pink" :value [243 141 169]}
               {:name "dark-brown" :value [104 70 52]}
               {:name "brown" :value [149 104 42]}
               {:name "beige" :value [248 178 119]}
               {:name "medium-gray" :value [170 170 170]}
               {:name "dark-red" :value [165 14 30]}
               {:name "light-red" :value [250 128 114]}
               {:name "dark-orange" :value [228 92 26]}
               {:name "dark-goldenrod" :value [156 132 49]}
               {:name "goldenrod" :value [197 173 49]}
               {:name "light-goldenrod" :value [232 212 95]}
               {:name "dark-olive" :value [74 107 58]}
               {:name "olive" :value [90 148 74]}
               {:name "light-olive" :value [132 197 115]}
               {:name "dark-cyan" :value [15 121 159]}
               {:name "light-cyan" :value [187 250 242]}
               {:name "light-blue" :value [125 199 255]}
               {:name "dark-indigo" :value [77 49 184]}
               {:name "dark-slate-blue" :value [74 66 132]}
               {:name "slate-blue" :value [122 113 196]}
               {:name "light-slate-blue" :value [181 174 241]}
               {:name "dark-peach" :value [155 82 73]}
               {:name "peach" :value [209 128 120]}
               {:name "light-peach" :value [250 182 164]}
               {:name "light-brown" :value [219 164 99]}
               {:name "dark-tan" :value [123 99 82]}
               {:name "tan" :value [156 132 107]}
               {:name "light-tan" :value [214 181 148]}
               {:name "dark-beige" :value [209 128 81]}
               {:name "light-beige" :value [255 197 165]}
               {:name "dark-stone" :value [109 100 63]}
               {:name "stone" :value [148 140 107]}
               {:name "light-stone" :value [205 197 158]}
               {:name "dark-slate" :value [51 57 65]}
               {:name "slate" :value [109 117 141]}
               {:name "light-slate" :value [179 185 209]}])

(local paid-names {:medium-gray [170 170 170]
                   :dark-red [165 14 30]
                   :light-red [250 128 114]
                   :dark-orange [228 92 26]
                   :dark-goldenrod [156 132 49]
                   :goldenrod [197 173 49]
                   :light-goldenrod [232 212 95]
                   :dark-olive [74 107 58]
                   :olive [90 148 74]
                   :light-olive [132 197 115]
                   :dark-cyan [15 121 159]
                   :light-cyan [187 250 242]
                   :light-blue [125 199 255]
                   :dark-indigo [77 49 184]
                   :dark-slate-blue [74 66 132]
                   :slate-blue [122 113 196]
                   :light-slate-blue [181 174 241]
                   :dark-peach [155 82 73]
                   :peach [209 128 120]
                   :light-peach [250 182 164]
                   :light-brown [219 164 99]
                   :dark-tan [123 99 82]
                   :tan [156 132 107]
                   :light-tan [214 181 148]
                   :dark-beige [209 128 81]
                   :light-beige [255 197 165]
                   :dark-stone [109 100 63]
                   :stone [148 140 107]
                   :light-stone [205 197 158]
                   :dark-slate [51 57 65]
                   :slate [109 117 141]
                   :light-slate [179 185 209]})

(local base-colors (icollect [_ color (ipairs colors)]
                     (if (= (. paid-names color.name) nil)
                         color
                         nil)))

; (do
;   (var content "GIMP Palette\n")
;   (each [_ color (ipairs base-colors)]
;     (let [[r g b] color.value
;           name color.name]
;       (set content (.. content (string.format "%d %d %d\t %s\n" r g b name)))))
;   (write-to-file "wplace_pobre.gpl" content))
;
; (os.exit 1)

(fn clamp-color [r g b]
  ;; https://www.compuphase.com/cmetric.htm#:~:text=A%20low%2Dcost%20approximation
  (var col (. base-colors 1))
  (var min-dist math.huge)
  (each [_ color (ipairs base-colors)]
    (let [[pr pg pb] color.value
          rmean (/ (+ pr r) 2)
          dr (- pr r)
          dg (- pg g)
          db (- pb b)
          x (math.floor (/ (* (+ 512 rmean) dr dr) 256))
          y (* 4 dg dg)
          z (math.floor (/ (* (- 767 rmean) db db) 256))
          dist (math.sqrt (+ x y z))]
      (when (< dist min-dist)
        (set min-dist dist)
        (set col color))))
  col.value)

(local in-file (. arg 1))
(when (not= (type in-file) "string")
  (print "No file provided")
  (os.exit 1))

(local out-file (.. "converted-" in-file))

(fn write-file [src]
  (var non-empties 0)
  (print (string.format "Image size: %dx%d - Channels: %d" src.width src.height
                        src.channels))
  (let [chima-empty (chima.color.new 0 0 0 0)
        dst (chima.image.new ctx src.width src.height src.channels chima-empty)
        stride (* src.channels 1)
        src-data (ffi.cast :uint8_t* src.data)
        dst-data (ffi.cast :uint8_t* dst.data)]
    (for [y 0 (- src.height 1)]
      (for [x 0 (- src.width 1)]
        (let [pixel-pos (* (+ (* y src.width) x) stride)
              src-pixel (+ src-data pixel-pos)
              dst-pixel (+ dst-data pixel-pos)
              r (. src-pixel 0)
              g (. src-pixel 1)
              b (. src-pixel 2)
              a (. src-pixel 3)
              [nr ng nb] (clamp-color r g b)]
          (when (not= a 0)
            (set non-empties (+ non-empties 1)))
          (set (. dst-pixel 0) nr)
          (set (. dst-pixel 1) ng)
          (set (. dst-pixel 2) nb)
          (set (. dst-pixel 3) a))))
    (dst:write out-file chima.image.format.png)
    (print (string.format "File written at %s (%d pixels)" out-file non-empties))))

(case (chima.image.load ctx nil in-file)
  src (write-file src)
  (nil err _ret) (do
                   (print err)
                   (os.exit 1)))
