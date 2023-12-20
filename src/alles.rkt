#lang racket/base

(require (for-syntax racket/base)
         racket/gui/base
         racket/class
         racket/system
         racket/match
         racket/string
         "threading.rkt")

(define frame
  (new frame% [label "alles"]
              [x 300] [y 300]
              [style '()]
              [width 900] [height 100]
              [alignment '(left center)]))

(define my-canvas%
  (class canvas% ; The base class is canvas%
    ; Define overriding method to handle keyboard events
    (define/override (on-char key-event)
      (handle-key-event key-event))
    (define/override (on-focus bool)
      (unless bool (handle-key-event 'lost-focus)))
    ; Call the superclass init, passing on all init args
    (super-new)))
 
; Make a canvas that handles events in the frame
(define my-canvas (new my-canvas% [parent frame]))

(define initial-label "\n\nPlease insert a key sequence.")

(define msg (new message% [parent frame]
                          [font (make-object font% 16 'modern)]
                          [label initial-label]
                          [vert-margin 12]	 
   	 	                    [horiz-margin 12]))

(define-syntax <> (make-rename-transformer #'string-append))

(define (bash-serialize subcommands)
  (map (λ (cmd) (<> cmd "; ")) subcommands))

(define (collapse subcommands) (foldl <> "" subcommands))
(define (switch-app! command)
  (<> command "sleep 0.1; ydotool key 125:1 15:1 15:0 125:0"))

(define (inspect thing)
  (println thing)
  thing)

(define (symbol->keycode sym)
  (case sym
    [(RESERVED) "0"] [(esc) "1"]
    [(1) "2"] [(2) "3"] [(3) "4"] [(4) "5"] [(5) "6"] [(6) "7"] [(7) "8"] [(8) "9"] [(9) "10"] [(0) "11"] 
    [(-) "12"] [(=) "13"] [(#\backspace) "14"] [(tab) "15"] [(q) "16"] [(w) "17"] [(e) "18"] [(r) "19"]
    [(t) "20"] [(y) "21"] [(u) "22"] [(i) "23"] [(o) "24"] [(p) "25"] [(#\{) "26"] [(#\}) "27"]
    [(#\return) "28"] [(Ctrl) "29"] [(a) "30"] [(s) "31"] [(d) "32"] [(f) "33"] [(g) "34"] [(h) "35"]
    [(j) "36"] [(k) "37"] [(l) "38"] [(#\;) "39"] [(#\') "40"] [(#\`) "41"] [(lshift) "42"] [(#\\) "43"]
    [(z) "44"] [(x) "45"] [(c) "46"] [(v) "47"] [(b) "48"] [(n) "49"] [(m) "50"] [(#\,) "51"] [(#\.) "52"]
    [(/) "53"] [(rshift) "54"] [(*) "55"] #| [(LEFTALT)"56"] |# [(#\space) "57"] #| [(CAPSLOCK) "58"] [(F1) "59"] [(F2) "60"] [(F3) "61"] [(F4) "62"] [(F5) "63"] [(F6) "64"] [(F7) "65"] [(F8) "66"] [(F9) "67"] [(F10) "68"] [(NUMLOCK) "69"] [(SCROLLLOCK) "70"] [(KP7) "71"] [(KP8) "72"] [(KP9) "73"] [(KPMINUS) "74"] [(KP4) "75"] [(KP5) "76"] [(KP6) "77"] [(KPPLUS) "78"] [(KP1) "79"] [(KP2) "80"] [(KP3) "81"] [(KP0) "82"] [(KPDOT) "83"] [(ZENKAKUHANKAKU) "85"] [(102ND) "86"] [(F11) "87"] [(F12) "88"] [(RO) "89"] [(KATAKANA) "90"] [(HIRAGANA) "91"] [(HENKAN) "92"] [(KATAKANAHIRAGANA) "93"] [(MUHENKAN) "94"] [(KPJPCOMMA) "95"] [(KPENTER) "96"] [(RIGHTCTRL) "97"] [(KPSLASH) "98"] [(SYSRQ) "99"] |# [(Alt) "100"] #| [(LINEFEED) "101"] [(HOME) "102"] |# [(up) "103"] #| [(PAGEUP) "104"] |# [(left) "105"] [(right) "106"] #| [(END) "107"] |# [(down) "108"] #| [(PAGEDOWN) "109"] [(INSERT) "110"] |# [(del) "111"] #| [(MACRO) "112"] [(MUTE) "113"] [(VOLUMEDOWN) "114"] [(VOLUMEUP) "115"] [(POWER) "116"] [(KPEQUAL) "117"] [(KPPLUSMINUS) "118"] [(PAUSE) "119"] [(SCALE) "120"] [(KPCOMMA) "121"] [(HANGEUL) "122"] [(HANJA) "123"] [(YEN) "124"] |# [(Super) "125"] [(RSuper) "126"] #| [(COMPOSE) "127"] [(STOP) "128"] [(AGAIN) "129"] [(PROPS) "130"] [(UNDO) "131"] [(FRONT) "132"] [(COPY) "133"] [(OPEN) "134"] [(PASTE) "135"] [(FIND) "136"] [(CUT) "137"] [(HELP) "138"] [(MENU) "139"] [(CALC) "140"] [(SETUP) "141"] [(SLEEP) "142"] [(WAKEUP) "143"] [(FILE) "144"] [(SENDFILE) "145"] [(DELETEFILE) "146"] [(XFER) "147"] [(PROG1) "148"] [(PROG2) "149"] [(WWW) "150"] [(MSDOS) "151"] [(SCREENLOCK) "152"] [(DIRECTION) "153"] [(CYCLEWINDOWS) "154"] [(MAIL) "155"] [(BOOKMARKS) "156"] [(COMPUTER) "157"] [(BACK) "158"] [(FORWARD) "159"] [(CLOSECD) "160"] [(EJECTCD) "161"] [(EJECTCLOSECD) "162"] [(NEXTSONG) "163"] [(PLAYPAUSE) "164"] [(PREVIOUSSONG) "165"] [(STOPCD) "166"] [(RECORD) "167"] [(REWIND) "168"] [(PHONE) "169"] [(ISO) "170"] [(CONFIG) "171"] [(HOMEPAGE) "172"] [(REFRESH) "173"] [(EXIT) "174"] [(MOVE) "175"] [(EDIT) "176"] [(SCROLLUP) "177"] [(SCROLLDOWN) "178"] [(KPLEFTPAREN) "179"] [(KPRIGHTPAREN) "180"] [(NEW) "181"] [(REDO) "182"] [(F13) "183"] [(F14) "184"] [(F15) "185"] [(F16) "186"] [(F17) "187"] [(F18) "188"] [(F19) "189"] [(F20) "190"] [(F21) "191"] [(F22) "192"] [(F23) "193"] [(F24) "194"] [(PLAYCD) "200"] [(PAUSECD) "201"] [(PROG3) "202"] [(PROG4) "203"] [(DASHBOARD) "204"] [(SUSPEND) "205"] [(CLOSE) "206"] [(PLAY) "207"] [(FASTFORWARD) "208"] [(BASSBOOST) "209"] [(PRINT) "210"] [(HP) "211"] [(CAMERA) "212"] [(SOUND) "213"] [(QUESTION) "214"] [(EMAIL) "215"] [(CHAT) "216"] [(SEARCH) "217"] [(CONNECT) "218"] [(FINANCE) "219"] [(SPORT) "220"] [(SHOP) "221"] [(ALTERASE) "222"] [(CANCEL) "223"] [(BRIGHTNESSDOWN) "224"] [(BRIGHTNESSUP) "225"] [(MEDIA) "226"] [(SWITCHVIDEOMODE) "227"] [(KBDILLUMTOGGLE) "228"] [(KBDILLUMDOWN) "229"] [(KBDILLUMUP) "230"] [(SEND) "231"] [(REPLY) "232"] [(FORWARDMAIL) "233"] [(SAVE) "234"] [(DOCUMENTS) "235"] [(BATTERY) "236"] [(BLUETOOTH) "237"] [(WLAN) "238"] [(UWB) "239"] [(UNKNOWN) "240"] [(VIDEO_NEXT) "241"] [(VIDEO_PREV) "242"] [(BRIGHTNESS_CYCLE) "243"] [(BRIGHTNESS_ZERO) "244"] [(DISPLAY_OFF) "245"] [(WIMAX) "246"] [(OK) "352"] [(SELECT) "353"] [(GOTO) "354"] [(CLEAR) "355"] [(POWER2) "356"] [(OPTION) "357"] [(INFO) "358"] [(TIME) "359"] [(VENDOR) "360"] [(ARCHIVE) "361"] [(PROGRAM) "362"] [(CHANNEL) "363"] [(FAVORITES) "364"] [(EPG) "365"] [(PVR) "366"] [(MHP) "367"] [(LANGUAGE) "368"] [(TITLE) "369"] [(SUBTITLE) "370"] [(ANGLE) "371"] [(ZOOM) "372"] [(MODE) "373"] [(KEYBOARD) "374"] [(SCREEN) "375"] [(PC) "376"] [(TV) "377"] [(TV2) "378"] [(VCR) "379"] [(VCR2) "380"] [(SAT) "381"] [(SAT2) "382"] [(CD) "383"] [(TAPE) "384"] [(RADIO) "385"] [(TUNER) "386"] [(PLAYER) "387"] [(TEXT) "388"] [(DVD) "389"] [(AUX) "390"] [(MP3) "391"] [(AUDIO) "392"] [(VIDEO) "393"] [(DIRECTORY) "394"] [(LIST) "395"] [(MEMO) "396"] [(CALENDAR) "397"] [(RED) "398"] [(GREEN) "399"] [(YELLOW) "400"] [(BLUE) "401"] [(CHANNELUP) "402"] [(CHANNELDOWN) "403"] [(FIRST) "404"] [(LAST) "405"] [(AB) "406"] [(NEXT) "407"] [(RESTART) "408"] [(SLOW) "409"] [(SHUFFLE) "410"] [(BREAK) "411"] [(PREVIOUS) "412"] [(DIGITS) "413"] [(TEEN) "414"] [(TWEN) "415"] [(VIDEOPHONE) "416"] [(GAMES) "417"] [(ZOOMIN) "418"] [(ZOOMOUT) "419"] [(ZOOMRESET) "420"] [(WORDPROCESSOR) "421"] [(EDITOR) "422"] [(SPREADSHEET) "423"] [(GRAPHICSEDITOR) "424"] [(PRESENTATION) "425"] [(DATABASE) "426"] [(NEWS) "427"] [(VOICEMAIL) "428"] [(ADDRESSBOOK) "429"] [(MESSENGER) "430"] [(DISPLAYTOGGLE) "431"] [(SPELLCHECK) "432"] [(LOGOFF) "433"] [(DOLLAR) "434"] [(EURO) "435"] [(FRAMEBACK) "436"] [(FRAMEFORWARD) "437"] [(CONTEXT_MENU) "438"] [(MEDIA_REPEAT) "439"] [(DEL_EOL) "448"] [(DEL_EOS) "449"] [(INS_LINE) "450"] [(DEL_LINE) "451"] [(FN) "464"] [(FN_ESC) "465"] [(FN_F1) "466"] [(FN_F2) "467"] [(FN_F3) "468"] [(FN_F4) "469"] [(FN_F5) "470"] [(FN_F6) "471"] [(FN_F7) "472"] [(FN_F8) "473"] [(FN_F9) "474"] [(FN_F10) "475"] [(FN_F11) "476"] [(FN_F12) "477"] [(FN_1) "478"] [(FN_2) "479"] [(FN_D) "480"] [(FN_E) "481"] [(FN_F) "482"] [(FN_S) "483"] [(FN_B) "484"] [(BRL_DOT1) "497"] [(BRL_DOT2) "498"] [(BRL_DOT3) "499"] [(BRL_DOT4) "500"] [(BRL_DOT5) "501"] [(BRL_DOT6) "502"] [(BRL_DOT7) "503"] [(BRL_DOT8) "504"] [(BRL_DOT9) "505"] [(BRL_DOT10) "506"] [(NUMERIC_0) "512"] [(NUMERIC_1) "513"] [(NUMERIC_2) "514"] [(NUMERIC_3) "515"] [(NUMERIC_4) "516"] [(NUMERIC_5) "517"] [(NUMERIC_6) "518"] [(NUMERIC_7) "519"] [(NUMERIC_8) "520"] [(NUMERIC_9) "521"] [(NUMERIC_STAR) "522"] [(NUMERIC_POUND) "523"] |#
    [else (map symbol->keycode sym)]
  ))

(define (nesting->sequence chord-list)
  (if (not (pair? chord-list))
      ""
      (<> (if (list? (car chord-list))
              (<> " " (caar chord-list) ":1"
                  (nesting->sequence (cdar chord-list))
                  " " (caar chord-list) ":0")
              (<> " " (car chord-list) ":1 " (car chord-list) ":0"))
          (nesting->sequence (cdr chord-list)))))

(define (keys keychord)
  (~>> keychord
       (map symbol->keycode)
       (inspect)
       (nesting->sequence)
       (inspect)
       (<> "ydotool key")
       (inspect)
  ))

(define (text string)
  (~>> string
       (<> "ydotool type --key-delay=1 '" _ "'")))

(define (keycode->string keycode)
  (cond
    [(symbol? keycode) (symbol->string keycode)]
    [(char? keycode) (string keycode)]
    [else "how?"]))

(define (wrap-key-descriptor key-descriptor condition modifier-name)
  (if condition
      (string-append "(" modifier-name " " key-descriptor ")")
      key-descriptor))

(define (format-key press release)
  (if (string=? press "release")
      (<> release ":0")
      (<> press ":1")))

(define (cons-single-key-descriptor press release C? M?)
  (~> (format-key press release)
      ; (wrap-key-descriptor M? "Meta")
      ; (wrap-key-descriptor C? "Ctrl")
      ))

(define (get-single-key-descriptor key-event)
  (define keypress-code (send key-event get-key-code))
  (define keyrelease-code (send key-event get-key-release-code))
  (define ctrl-down? (send key-event get-control-down))
  (define meta-down? (send key-event get-meta-down))
  (define keystring
    (cons-single-key-descriptor (keycode->string keypress-code)
                                (keycode->string keyrelease-code)
                                ctrl-down?
                                meta-down?))
  keystring)

(define (++ list el)
  (reverse (cons el (reverse list))))

(define (update-label! msg chord)
  (send msg set-label (apply string-append chord)))

(define-syntax-rule (reset! chord)  (set! chord '()))

(define (fire link)
  (<> "firefox --new-tab '" link "'"))

(define (append-app-switch subcommands)
  (++ subcommands (keys '((Super tab)))))

; (define (append-chord-reset subcommands)
;   (++ subcommands (reset! chord)))

(define (run msg chord . subcommands)
  (~> subcommands
      (append-app-switch)
      ; (append-chord-reset)
      (bash-serialize)
      (collapse)
      (system)
  )
  (reset! chord)
  (update-label! msg chord))

(define handle-key-event
  (let ([chord '()])
    (λ (key-event)
      (case key-event
        [(lost-focus) (reset! chord) (update-label! msg (list initial-label))]
        [else 
          (define single-key-descriptor (get-single-key-descriptor key-event))
          (set! chord (++ chord single-key-descriptor))
          (match chord
            [(list a ... "q:1") (send frame show #f)] [(list a ... "control:1" "w:1" "w:0") (send frame show #f)]
            [(list a ... "g:1" "g:0") (reset! chord) (update-label! msg chord)]

            [(list "s:1" "s:0" "n:1" "n:0")
            (run msg chord (fire "https://search.nixos.org"))]
            [(list "s:1" "s:0" "o:1" "o:0")
            (run msg chord (fire "https://search.nixos.org/options"))]
            [(list "s:1" "s:0" "r:1" "r:0")
            (run msg chord (fire "https://docs.racket-lang.org/search/index.html"))]

            [_ (update-label! msg chord)]
          )]))))

(send my-canvas focus)
(send frame show #t)
