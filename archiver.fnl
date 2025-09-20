(local conf {:row-init 647 :row-end 655 :col-init 1166 :col-end 1174})

(fn make-dir [dirname]
  (os.execute (.. "mkdir -p ./" dirname))
  dirname)

(fn make-cmd [dir row col count]
  (let [url (string.format "https://backend.wplace.live/files/s0/tiles/%d/%d.png"
                           row col)]
    (string.format "wget \"%s\" -O ./%s/%d_%d_%d.png" url dir count row col)))

(fn populate-cmds [dir grid]
  (var count 0)
  (let [{: row-init : row-end : col-init : col-end} grid
        cmds []]
    (for [row row-init row-end]
      (for [col col-init col-end]
        (table.insert cmds (make-cmd dir row col count))
        (set count (+ count 1))))
    cmds))

(fn call-cmds! [cmds]
  (print (.. "Remaining: " (tostring (length cmds))))
  (let [remaining []]
    (each [_i cmd (ipairs cmds)]
      (let [succ (os.execute cmd)]
        (print cmd)
        (when (not succ)
          (table.insert remaining cmd))))
    remaining))

(local dir (make-dir (os.date "%s")))
(var cmds (populate-cmds dir conf))
(while (> (length cmds) 0)
  (print (string.format "Calling %d commands!" (length cmds)))
  (os.execute "sleep 1")
  (set cmds (call-cmds! cmds)))

(print "Done!")
