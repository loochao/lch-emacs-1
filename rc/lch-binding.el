;-*- coding:utf-8; mode:emacs-lisp; -*-

;>======== BINDING.EL ========<;
;> (info "(emacs)Key Bindings")
(message "=> lch-binding: loading...")

;>-------- Fn map defined in dotEmacs file --------<;
(define-key global-map (kbd "<home>") 'beginning-of-buffer)
(define-key global-map (kbd "<end>") 'end-of-buffer)

;>-------- F1 --------<;

;>-------- F2 --------<;
;(define-key global-map (kbd "C-<f2>") 'ediff)
(define-key global-map (kbd "C-<f2>") 'shell)
(define-key global-map (kbd "M-1") 'shell)
;(define-key global-map (kbd "S-<f2>") 'eshell)
;(define-key global-map (kbd "C-S-<f2>") 'cmd-shell)                          ;; => lch-util.el
;(define-key global-map (kbd "C-M-<f2>") 'msys-shell)                         ;; => lch-util.el
;(define-key global-map (kbd "M-<f2>") 'call-last-kbd-macro)

(define-key global-map (kbd "<f2> c") 'calendar)
(define-key global-map (kbd "<f2> d") 'dired)
(define-key global-map (kbd "<f2> f") 'auto-fill-mode)
(define-key global-map (kbd "<f2> l") 'lisp-mode)
(define-key global-map (kbd "<f2> o") 'org-mode)
(define-key global-map (kbd "<f2> O") 'outline-minor-mode)
(define-key global-map (kbd "<f2> s") 'flyspell-mode)
(define-key global-map (kbd "<f2> v") 'less-minor-mode)
(define-key global-map (kbd "<f2> w") 'whitespace-mode)

;>-------- F3 --------<;
;(define-key global-map (kbd "<f3>") ')
;(define-key global-map (kbd "<C-f3>") 'joc-dired-magic-buffer)
;(define-key global-map (kbd "<M-f3>") 'joc-dired-toggle-buffer-name)

;(define-key global-map (kbd "<f3> <f3>") 'lch-w3m-go)                        ;; => lch-w3m.el
;(define-key global-map (kbd "<f3> s") 'w3m-search)                           ;; => lch-w3m.el
(define-key global-map (kbd "<f3> t") 'w3m-goto-url-new-session)
(define-key global-map (kbd "<f3> o") 'w3m-goto-url)
(define-key global-map (kbd "<f3> y") 'w3m-print-this-url)
(define-key global-map (kbd "<f3> l") 'w3m-print-current-url)

;>-------- F4 --------<;
;> Binding to Namespace (Such as Org, w3m...)
;(define-key global-map (kbd "<f4> <f4>") 'lch-open-file-browser)                ;; => lch-util.el
;C-x f ffap

;; Org
(define-key global-map (kbd "<f4> o a") 'org-agenda-list)
(define-key global-map (kbd "<f4> o d") 'org-deadline)
(define-key global-map (kbd "<f4> o i") 'org-toggle-iimage-in-org)
(define-key global-map (kbd "<f4> o j") 'org-journal-entry)
(define-key global-map (kbd "<f4> o p") 'org-insert-property-drawer)
(define-key global-map (kbd "<f4> o r") 'org-remember)
(define-key global-map (kbd "<f4> o s") 'org-schedule)
(define-key global-map (kbd "<f4> o t") 'org-todo-list)
;(if lch-win32-p                                                              ;; => lch-util.el
;(define-key global-map (kbd "<f4>-<f4>") 'locate-current-file-in-explorer))

;>-------- F5 --------<;
;> Skeleton related stuff
;(define-key global-map (kbd "<f5> c") 'org-center-skeleton)                  ;; => lch-skeleton.el
;(define-key global-map (kbd "<f5> e") 'org-example-skeleton)                 ;; => lch-skeleton.el
;(define-key global-map (kbd "<f5> h") 'org-head-skeleton)                    ;; => lch-skeleton.el
;(define-key global-map (kbd "<f5> i") 'org-image-skeleton)                   ;; => lch-skeleton.el
;(define-key global-map (kbd "<f5> s l") 'org-src-lisp-skeleton)              ;; => lch-skeleton.el

;; (define-key global-map (kbd "C-c C-b") 'switch-to-bookmark)

;; (define-key global-map (kbd "<f5> <f5>") 'list-bookmarks)
;; (define-key global-map (kbd "S-<f5>") 'bookmark-set)
;; (define-key global-map (kbd "C-<f5>") 'switch-to-bookmark)



;>-------- F6 --------<;
;(define-key global-map (kbd "<f6> e") 'org-export-as-html)                   ;; => lch-org.el
;(define-key global-map (kbd "<f6> o") 'org-publish)                          ;; => lch-org.el
;(define-key global-map (kbd "<f6> p") 'lch-org-publish-org)                  ;; => lch-org.el
;(define-key global-map (kbd "<f6> P") 'lch-org-publish-prv)                  ;; => lch-org.el
;(define-key global-map (kbd "<f6> w") 'lch-org-publish-worg)                 ;; => lch-org.el


;>-------- F7 --------<;

;(define-key global-map (kbd "C-0") 'org-capture)                             ;; => lch-org.el
;<f7> i 'org-capture --> INBOX                                                ;; => lch-org.el

;>-------- F8 --------<;
;(define-key global-map (kbd "<f8>") 'org-agenda)                             ;; => lch-org.el

;>-------- F9 --------<;
;> 0 ;> =: Bookmark related stuffs.
;> alpha:  org files.
;(defvar org-source-dir "~/Dropbox/org/org" "org source dir") ;; => dotEmacs
;(defvar pub-html-dir "~/Dropbox/org/public_html" "html dir") ;; => dotEmacs

;(define-key global-map (kbd "<f9> <f9>") 'highlight-symbol-at-point)         ;; => lch-util.el
;(define-key global-map (kbd "C-<f9>") 'highlight-symbol-next)                ;; => lch-util.el
;(define-key global-map (kbd "S-<f9>") 'highlight-symbol-prev)                ;; => lch- util.el


(define-key global-map (kbd "<f9> 1") (lambda() (interactive) (dired org-source-dir)))
(define-key global-map (kbd "<f9> 2") (lambda() (interactive) (dired org-private-dir)))
(define-key global-map (kbd "<f9> 3") (lambda() (interactive) (dired (concat org-source-dir "/public_html"))))
(if (boundp 'dropbox-path)
    (define-key global-map (kbd "<f9> 4") (lambda() (interactive) (dired dropbox-path))))
(define-key global-map (kbd "<f9> a") (lambda() (interactive) (find-file (concat org-source-dir "/Art-Ent.org"))))
(define-key global-map (kbd "<f9> b") (lambda() (interactive) (find-file (concat dropbox-path "/Library/LCH_LIB.bib"))))
(define-key global-map (kbd "<f9> B") (lambda() (interactive) (find-file (concat org-source-dir "/Bib-Edu.org"))))
(define-key global-map (kbd "<f9> c") (lambda() (interactive) (find-file (concat org-source-dir "/Culture.org"))))
(define-key global-map (kbd "<f9> C") (lambda() (interactive) (find-file (concat org-source-dir "/ComputerSE.org"))))
(define-key global-map (kbd "<f9> e") (lambda() (interactive) (find-file (concat org-source-dir "/Emacs.org"))))
(define-key global-map (kbd "<f9> E") (lambda() (interactive) (find-file (concat org-source-dir "/English.org"))))
(define-key global-map (kbd "<f9> C-e") (lambda() (interactive) (find-file (concat org-source-dir "/Economy.org"))))
(define-key global-map (kbd "<f9> g") (lambda() (interactive) (find-file (concat org-source-dir "/generality.org"))))
(define-key global-map (kbd "<f9> h") (lambda() (interactive) (find-file (concat org-source-dir "/Humor.org"))))
(define-key global-map (kbd "<f9> H") (lambda() (interactive) (find-file (concat org-source-dir "/Html.org"))))
(define-key global-map (kbd "<f9> C-h") (lambda() (interactive) (find-file (concat org-source-dir "/History.org"))))

(define-key global-map (kbd "<f9> i c") (lambda() (interactive) (find-file (concat org-private-dir "/iCount.org"))))
(define-key global-map (kbd "<f9> i d") (lambda() (interactive) (find-file (concat org-private-dir "/iDea.org"))))
(define-key global-map (kbd "<f9> i l") (lambda() (interactive) (find-file (concat org-private-dir "/iLog.org"))))
(define-key global-map (kbd "<f9> i n") (lambda() (interactive) (find-file (concat org-private-dir "/index.org"))))
(define-key global-map (kbd "<f9> i r") (lambda() (interactive) (find-file (concat org-private-dir "/iRsch.org"))))
(define-key global-map (kbd "<f9> i s") (lambda() (interactive) (find-file (concat org-private-dir "/iStuff.org"))))
(define-key global-map (kbd "<f9> i p") (lambda() (interactive) (find-file (concat org-private-dir "/iPrv.org"))))

(define-key global-map (kbd "<f9> l") (lambda() (interactive) (find-file (concat org-source-dir "/Life.org"))))
(define-key global-map (kbd "<f9> L") (lambda() (interactive) (find-file (concat org-source-dir "/Library.org"))))
(define-key global-map (kbd "<f9> m") (lambda() (interactive) (find-file (concat org-source-dir "/Mathematics.org"))))
(define-key global-map (kbd "<f9> M") (lambda() (interactive) (find-file (concat org-source-dir "/Miscellaneous.org"))))
(define-key global-map (kbd "<f9> C-m") (lambda() (interactive) (find-file (concat org-source-dir "/Methodology.org"))))
(define-key global-map (kbd "<f9> O") (lambda() (interactive) (find-file (concat org-source-dir "/Opera.org"))))
(define-key global-map (kbd "<f9> p") (lambda() (interactive) (find-file (concat org-source-dir "/Pearl.org"))))
(define-key global-map (kbd "<f9> P") (lambda() (interactive) (find-file (concat org-source-dir "/Programming.org"))))
(define-key global-map (kbd "<f9> C-p") (lambda() (interactive) (find-file (concat org-source-dir "/iPU.org"))))
(define-key global-map (kbd "<f9> M-p") (lambda() (interactive) (find-file (concat org-source-dir "/Physics.org"))))
(define-key global-map (kbd "<f9> r") (lambda() (interactive) (find-file (concat org-source-dir "/Refile.org"))))
(define-key global-map (kbd "<f9> s") (lambda() (interactive) (find-file (concat org-source-dir "/Softip.org"))))
(define-key global-map (kbd "<f9> S") (lambda() (interactive) (find-file (concat org-source-dir "/Sitemap.org"))))
(define-key global-map (kbd "<f9> u") (lambda() (interactive) (find-file (concat org-source-dir "/Unix.org"))))
(define-key global-map (kbd "<f9> W") (lambda() (interactive) (dired (concat dropbox-path "/GIT/Worg"))))


(if lch-win32-p
  (progn
    (define-key global-map (kbd "<f9> r") (lambda() (interactive) (find-file "e:/EDU/RSCH/Org/RSCH.org")))
    (define-key global-map (kbd "<f9> w a") (lambda() (interactive) (find-file "d:/SYS/WINMNGR/AHK/AutoHotKey.ini")))
    (define-key global-map (kbd "<f9> w e") (lambda() (interactive) (dired "e:/")))
    (define-key global-map (kbd "<f9> w g") (lambda() (interactive) (dired "e:/Var/URoot/git/")))
    (define-key global-map (kbd "<f9> w t") (lambda() (interactive) (dired "e:/Tmp/")))
    (define-key global-map (kbd "<f9> w s") (lambda() (interactive) (dired "e:/Tmp/SPgm")))
    (define-key global-map (kbd "<f9> w t") (lambda() (interactive) (find-file "e:/TMP/DOC/TEX/Untitled1.tex")))))

;>-------- F10 --------<;

;> Find file & dir map.
;> File in emacs.d/rc has the initial letter as its invoker.
(define-key global-map (kbd "<f10> 1") (lambda() (interactive) (dired (concat emacs-dir "/rc"))))
(define-key global-map (kbd "<f10> 2") (lambda() (interactive) (dired (concat emacs-lib-dir "/dotfiles"))))
(define-key global-map (kbd "<f10> 3") (lambda() (interactive) (dired emacs-site-lisp)))
(define-key global-map (kbd "<f10> 4") (lambda() (interactive) (dired emacs-lib-dir)))
(define-key global-map (kbd "<f10> 5") (lambda() (interactive) (dired (concat dropbox-path "/Repository/git/Worg"))))
(define-key global-map (kbd "<f10> 6") (lambda() (interactive) (dired "~/Downloads")))
(define-key global-map (kbd "<f10> 9") (lambda() (interactive) (find-file "/ssh:chaol@hats.princeton.edu:/u/chaol")))
(define-key global-map (kbd "<f10> 0") (lambda() (interactive) (find-file "/sudo::/")))

(if lch-win32-p (define-key global-map (kbd "<f10> a")
		  (lambda() (interactive) (find-file "d:/SYS/WINMNGR/AHK/AutoHotKey.ini"))))
(define-key global-map (kbd "<f10> b") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-binding.el"))))(define-key global-map (kbd "<f10> B") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-bmk.el"))))
(define-key global-map (kbd "<f10> c") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-conf.el"))))
(define-key global-map (kbd "<f10> d") (lambda() (interactive) (find-file "~/.emacs")))
(define-key global-map (kbd "<f10> D") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-dired.el"))))
(define-key global-map (kbd "<f10> e") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-elisp.el"))))
(define-key global-map (kbd "<f10> E") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-env.el"))))
(define-key global-map (kbd "<f10> C-e") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-emms.el"))))
(define-key global-map (kbd "<f10> M-e") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-elisp-el-get.el"))))
(define-key global-map (kbd "<f10> g") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-gnus.el"))))
(define-key global-map (kbd "<f10> i") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-init.el"))))

(define-key global-map (kbd "<f10> o o") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-org.el"))))
(define-key global-map (kbd "<f10> o a") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-org-agenda.el"))))
(define-key global-map (kbd "<f10> o l") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-org-latex.el"))))
(define-key global-map (kbd "<f10> o p") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-org-publish.el"))))

(define-key global-map (kbd "<f10> O") (lambda() (interactive) (find-file "~/org/public_html/theme/org.css")))
(define-key global-map (kbd "<f10> s") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-skeleton.el"))))
(define-key global-map (kbd "<f10> t") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-ui-theme.el"))))
(if (eq system-type 'windows-nt)
    (define-key global-map (kbd "<f10> t") (lambda() (interactive) (find-file "d:/TCMD/wincmd.ini"))))
(define-key global-map (kbd "<f10> u") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-util.el"))))

;>---- F10+v Vimperator ----<;
(defvar vimp-dir "~/vimperator")
(define-key global-map (kbd "<f10> v 1") (lambda() (interactive) (dired vimp-dir)))
(define-key global-map (kbd "<f10> v 2") (lambda() (interactive) (dired (concat vimp-dir "/colors"))))
(define-key global-map (kbd "<f10> v 3") (lambda() (interactive) (dired (concat vimp-dir "/plugin"))))
(define-key global-map (kbd "<f10> v 4") (lambda() (interactive) (dired (concat vimp-dir "/info"))))

(define-key global-map (kbd "<f10> v d") (lambda() (interactive) (find-file "~/.vimperatorrc")))
(define-key global-map (kbd "<f10> v i") (lambda() (interactive) (find-file (concat vimp-dir "/lch-init.vimp"))))
(define-key global-map (kbd "<f10> v k") (lambda() (interactive) (find-file (concat vimp-dir "/lch-key.vimp"))))
(define-key global-map (kbd "<f10> v p") (lambda() (interactive) (find-file (concat vimp-dir "/lch-plugin.vimp"))))
(define-key global-map (kbd "<f10> v u") (lambda() (interactive) (find-file (concat vimp-dir "/lch-ui.vimp"))))
(define-key global-map (kbd "<f10> v U") (lambda() (interactive) (find-file (concat vimp-dir "/lch-util.vimp"))))
;>----

(define-key global-map (kbd "<f10> U") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-ui.el"))))
(define-key global-map (kbd "<f10> w") (lambda() (interactive) (find-file (concat emacs-dir "/rc/lch-web.el"))))


;>-------- F11 --------<;
;~~>- UI related stuffs.
(define-key global-map (kbd "<f11> <f11>") 'menu-bar-mode)
(define-key global-map (kbd "C-<f11>") 'tabbar-mode)
(define-key global-map (kbd "S-<f11>") 'tool-bar-mode)
(define-key global-map (kbd "M-<f11>") 'setnu-mode)
(define-key global-map (kbd "C-S-<f11>") 'ruler-mode)
(define-key global-map (kbd "C-M-<f11>") 'whitespace-mode)

;(define-key global-map (kbd "<f11> <f1>") 'color-theme-arjen)                 ;; => lch-ui-theme.el
;(define-key global-map (kbd "<f11> <f2>") 'color-theme-dimilar)               ;; => lch-ui-theme.el
;(define-key global-map (kbd "<f11> <f3>") 'color-theme-dimilartty)            ;; => lch-ui-theme.el
;(define-key global-map (kbd "<f11> <f4>") 'color-theme-tango)                 ;; => lch-ui-theme.el
;(define-key global-map (kbd "<f11> <f5>") 'color-theme-tango)                 ;; => lch-ui-theme.el
;(define-key global-map (kbd "<f11> <f6>") 'color-theme-railscasts)            ;; => lch-ui-theme.el
;(define-key global-map (kbd "<f11> <f7>") 'color-theme-jimmy)                 ;; => lch-ui-theme.el

;(define-key global-map (kbd "<f11> 1") 'lch-cycle-color-forward)              ;; => lch-ui.el
;(define-key global-map (kbd "<f11> 2") 'lch-cycle-color-backward)             ;; => lch-ui.el
;(define-key global-map (kbd "<f11> 3") 'lch-cycle-font-forward)               ;; => lch-ui.el
;(define-key global-map (kbd "<f11> 4") 'lch-cycle-font-backward)              ;; => lch-ui.el

;(define-key global-map (kbd "<f11> u")
;  (set-language-environment "UTF-8"))                                         ;; => lch-coding.el
; <f11> U => revert buffer with utf-8                                        ;; => lch-coding.el
;(define-key global-map (kbd "<f11> c")
;  (set-language-environment "Chinese-GB18030"))  ;; => lch-coding.el
; <f11> C => revert buffer with gb18030                                      ;; => lch-coding.el

(define-key global-map (kbd "<f11> h") 'hl-line-mode)
;(define-key global-map (kbd "<f11> l") 'toggle-line-spacing)                  ;; => lch-ui.el
(define-key global-map (kbd "<f11> L") 'setnu-mode)
;(define-key global-map (kbd "<f11> m") 'w32-maximize-frame)                   ;; => lch-ui.el
(define-key global-map (kbd "<f11> M") 'menu-bar-mode)
(define-key global-map (kbd "<f11> r") 'ruler-mode)
(define-key global-map (kbd "<f11> t") 'tool-bar-mode)
(define-key global-map (kbd "<f11> T") 'tabbar-mode)
;(define-key global-map (kbd "<f1> w") 'lch-toggle-line-wrapping)              ;; => lch-init.el
(define-key global-map (kbd "<f11> W") 'whitespace-mode)

;>-------- F12 --------<;
;> EMMS
;; (define-key global-map (kbd "<f12> <f12>") 'emms-pause)                     ;; => All in lch-emms.el
;; (define-key global-map (kbd "<f12> c")   'emms-start)
;; (define-key global-map (kbd "<f12> x")   'emms-stop)

;; (define-key global-map (kbd "<f12> n")   'emms-next)
;; (define-key global-map (kbd "<f12> p")   'emms-previous)

;; (define-key global-map (kbd "<f12> /")   'emms-show)
;; (define-key global-map (kbd "<f12> s")   'emms-shuffle)

;; (define-key global-map (kbd "<f12> r")   'emms-toggle-repeat-track)
;; (define-key global-map (kbd "<f12> R")   'emms-toggle-repeat-playlist)

;>-------- Ctrl Map --------<;
;(define-key global-map (kbd "C-=") 'text-scale-increase)                     ;; => lch-util.el
;(define-key global-map (kbd "C--") 'text-scale-decrease)                     ;; => lch-util.el
;(define-key global-map (kbd "C-0") 'text-scale-normal-size)                  ;; => lch-util.el
;(define-key global-map (kbd "C-j") 'newline)                                 ;; => lch-init.el
;(define-key global-map (kbd "C-m") 'newline-and-indent)                      ;; => lch-init.el
;(define-key global-map (kbd "C-z") 'undo)

(define-key global-map (kbd "C-\\") 'hippie-expand)
(define-key global-map (kbd "C-,") 'previous-buffer)
(define-key global-map (kbd "C-.") 'next-buffer)
(define-key global-map (kbd "C-'") 'other-window)
(define-key global-map (kbd "C-;") 'comment-or-uncomment-region)
(define-key global-map (kbd "C-/") '(lambda () (interactive)
                               (require 'xwl-wubi)
                               (toggle-input-method)))
(define-key global-map (kbd "C-2") 'set-mark-command)

;>-------- Ctrl+X Map --------<;

;>-------- Ctrl+C && F1 Map --------<;
;; => User defined functions.
;(define-key global-map (kbd "<f1> <f1>") 'lookup-google)                     ;; => lch-util.el
;(define-key global-map (kbd "<f1> <f2>") 'lookup-wikipedia)                  ;; => lch-util.el
;(define-key global-map (kbd "<f1> a") 'wy-go-to-char)                        ;; => lch-util.el
; (<f1> 4 'newsmth)                                                           ;; => lch-shell.el

(define-key global-map (kbd "<f1> C-a") 'lookup-word-definition)              ;; => lch-util.el
(define-key global-map (kbd "<f1> c") 'comment-region)
(define-key global-map (kbd "C-c c") 'comment-region)
(define-key global-map (kbd "<f1> C") 'list-colors-display)
;; CAUTION
(define-key global-map (kbd "C-6")
		'(lambda () (interactive)
		   (require 'lch-dired)
		   (call-interactively 'dired-jump)))
(define-key global-map (kbd "<f1> e") 'eval-buffer)
(define-key global-map (kbd "C-c e") 'eval-buffer)
(define-key global-map (kbd "<f1> E") 'erase-buffer)
(define-key global-map (kbd "<f1> f") 'find-dired)
(define-key global-map (kbd "C-c f") 'find-dired)
;(define-key global-map (kbd "C-c C-f") 'lch-w3m-goto-url)                    ;; => lch-web.el
(define-key global-map (kbd "<f1> C-f") 'fill-region)
(define-key global-map (kbd "<f1> g") 'grep-find)
(define-key global-map (kbd "C-c g") 'grep-find)
;(global-set-key (kbd "C-c C-g") 'lch-google-search-w3m)                      ;; => lch-web.el
;(global-set-key (kbd "<f1> C-g") 'lch-google-search-w3m)                     ;; => lch-web.el
(define-key global-map (kbd "<f1> G") 'find-grep-dired)
(define-key global-map (kbd "<f1> i") 'indent-region)
;(define-key global-map (kbd "<f1> C-m") 'switch-major-mode)                  ;; => lch-util.el
;(define-key global-map (kbd "<f1> n") 'nuke-some-buffers)                    ;; => lch-util.el
;(define-key global-map (kbd "C-c n") 'nuke-some-buffers)                     ;; => lch-util.el
;(define-key global-map (kbd "<f1> l") 'i-toggle-line-wrapping)               ;; => lch-init.el
;(define-key global-map (kbd "<f1> C-m") 'dictionary-match-words)             ;; => lch-elisp.el
(define-key global-map (kbd "<f1> N") 'narrow-to-region)

(add-hook 'occur-mode-hook
	  (lambda () (setq truncate-lines t)))
(define-key global-map (kbd "C-o")
		'(lambda () (interactive)
		   (call-interactively 'occur)
		   (other-window 1)))
; (<f1> p 'process)                                                           ;; => lch-util.el
(define-key global-map (kbd "<f1> r") 'recentf-open-files)
(define-key global-map (kbd "<f1> R") 'revert-buffer)
;(define-key global-map (kbd "<f1> S") 'my-scroll-auto)                       ;; => lch-util.el
;(define-key global-map (kbd "C-c s") 'ywb-create/switch-scratch)             ;; => lch-util.el
;(define-key global-map (kbd "<f1> s") 'ywb-create/switch-scratch)            ;; => lch-util.el
;(define-key global-map (kbd "<f1> C-s") 'dictionary-search)                  ;; => lch-elisp.el
(define-key global-map (kbd "<f1> u") 'uncomment-region)
(define-key global-map (kbd "C-c u") 'uncomment-region)
(define-key global-map (kbd "<f1> C-u") 'revert-buffer)
(define-key global-map (kbd "<f1> v") 'view-mode)
(define-key global-map (kbd "C-c v") 'view-mode)
(define-key global-map (kbd "C-c C-v") 'view-mode)
(setq view-mode-hook
      (lambda ()
        (define-key view-mode-map "h" 'backward-char)
        (define-key view-mode-map "l" 'forward-char)
        (define-key view-mode-map "j" 'next-line)
        (define-key view-mode-map "k" 'previous-line)
	(define-key view-mode-map "q" 'bury-buffer)
	(define-key view-mode-map "u" 'view-scroll-page-backward)
	))

;(define-key global-map (kbd "<f1> w") 'ywb-favorite-window-config)          ;; => lch-util.el
(define-key global-map (kbd "<f1> W") 'widen)
(define-key global-map (kbd "<f1> <f2>") 'lookup-wikipedia)                  ;; => lch-util.el

(define-key global-map (kbd "<f1> $") 'toggle-truncate-lines)
(define-key global-map (kbd "<f1> ^") 'lch-toggle-line-wrapping)             ;; => lch-init.el

;>-------- Alt Map --------<;
(define-key global-map (kbd "M-o") '(lambda ()
                               (interactive)
                               (other-window -1)))
(eval-after-load 'dired
  '(progn
     (define-key dired-mode-map (kbd "C-o") nil)
     (define-key dired-mode-map (kbd "M-o") nil)
     ))

;>-------- Ctrl X Map --------<;
;(define-key global-map (kbd "C-x b") 'ibuffer)                               ;; => lch-elisp.el
;(global-set-key (kbd "C-x C-b") 'ido-switch-buffer)                          ;; => lch-elisp.el
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-x g") 'goto-line)

;>>> lch-dict.el
;; (define-key global-map (kbd "M-s") '(lambda ()
;;                                (interactive)
;;                                (require 'xwl-dictionary)
;;                                (call-interactively 'dictionary-search)))

;>-------- MISC --------<;
;>>> lch-skeleton.el
; (define-key global-map (kbd "(") 'skeleton-pair-insert-maybe)
; (define-key global-map (kbd "[") 'skeleton-pair-insert-maybe)
; (define-key global-map (kbd "{") 'skeleton-pair-insert-maybe)
; ;(define-key global-map (kbd "<") 'skeleton-pair-insert-maybe)
; (define-key global-map (kbd "\"") 'skeleton-pair-insert-maybe)

;>-------- Alt Map --------<;
;(define-key global-map (kbd "M-<f4>") 'close-frame)                          ;; => lch-util.el

;>-------- Org Mode --------<;



;>-------- Keybinding Table --------<;
;; [from http://www-xray.ast.cam.ac.uk/~gmorris/dotemacs.html]
(defun my-keytable (arg)
  "Print the key bindings in a tabular form."
  (interactive "sEnter a modifier string:")
  (with-output-to-temp-buffer "*Key table*"
    (let* ((i 0)
	   (keys (list "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m"
		       "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"
		       "<return>" "<down>" "<up>" "<right>" "<left>"
		       "<home>" "<end>" "<f1>" "<f2>" "<f3>" "<f4>" "<f5>"
		       "<f6>" "<f7>" "<f8>" "<f9>" "<f10>" "<f11>" "<f12>"
		       "1" "2" "3" "4" "5" "6" "7" "8" "9" "0"
		       "`" "~" "!" "@" "#" "$" "%" "^" "&" "*" "(" ")" "-"
		       "_" "=" "+" "\\" "|" "{" "[" "]" "}" ";" "'" ":"
		       "\"" "<" ">" "," "." "/" "?"))
	   (n (length keys))
	   (modifiers (list "" "S-" "C-" "M-" "M-C-"))
	   (k))
      (or (string= arg "") (setq modifiers (list arg)))
      (setq k (length modifiers))
      (princ (format " %-10.10s |" "Key"))
      (let ((j 0))
	(while (< j k)
	  (princ (format " %-28.28s |" (nth j modifiers)))
	  (setq j (1+ j))))
      (princ "\n")
      (princ (format "_%-10.10s_|" "__________"))
      (let ((j 0))
	(while (< j k)
	  (princ (format "_%-28.28s_|"
			 "_______________________________"))
	  (setq j (1+ j))))
      (princ "\n")
      (while (< i n)
	(princ (format " %-10.10s |" (nth i keys)))
	(let ((j 0))
	  (while (< j k)
	    (let* ((binding
		    (key-binding (read-kbd-macro (concat (nth j modifiers)
							 (nth i keys)))))
		   (binding-string "_"))
	      (when binding
		(if (eq binding 'self-insert-command)
		    (setq binding-string (concat "'" (nth i keys) "'"))
		  (setq binding-string (format "%s" binding))))
	      (setq binding-string
		    (substring binding-string 0 (min (length
						      binding-string) 28)))
	      (princ (format " %-28.28s |" binding-string))
	      (setq j (1+ j)))))
	(princ "\n")
	(setq i (1+ i)))
      (princ (format "_%-10.10s_|" "__________"))
      (let ((j 0))
	(while (< j k)
	  (princ (format "_%-28.28s_|"
			 "_______________________________"))
	  (setq j (1+ j))))))
  (delete-window)
;  (hscroll-mode)
  (setq truncate-lines t))


;; You can get a list of all the disabled functions by typing
;; `M-: (let(lst)(mapatoms(lambda(x)(if(get x 'disabled)(push x lst))))lst) RET'


(defmacro rloop (clauses &rest body)
  (if (null clauses)
      `(progn ,@body)
    `(loop ,@(car clauses) do (rloop ,(cdr clauses) ,@body))))

(defun all-bindings ()
  (interactive)
  (message "all-bindings: wait a few seconds please...")
  (let ((data
         (with-output-to-string
           (let ((bindings '()))
             (rloop ((for C in '("" "C-"))       ; Control
                     (for M in '("" "M-"))       ; Meta
                     (for A in '("" "A-"))       ; Alt
                     (for S in '("" "S-"))       ; Shift
                     (for H in '("" "H-"))       ; Hyper
                     (for s in '("" "s-"))       ; super
                     (for x from 32 to 127))
                    (let* ((k (format "%s%s%s%s%s%s%c" C M A S H s x))
                           (key (ignore-errors (read-kbd-macro k))))
                      (when key
                        (push
                         (list k
                               (format "%-12s  %-12s  %S\n" k key
                                       (or
                                        ;; (string-key-binding key)
                                        ;; What is this string-key-binding?
                                        (key-binding key))))
                         bindings))))
             (dolist (item
                      (sort bindings
                            (lambda (a b)
                              (or (< (length (first a))
                                     (length (first b)))
                                  (and (= (length (first a))
                                          (length (first b)))
                                       (string< (first a)
                                                (first b)))))))
               (princ (second item)))))))
    (switch-to-buffer (format "Keybindings in %s" (buffer-name)))
    (erase-buffer)
    (insert data)
    (goto-char (point-min))
    (values)))

(message "~~ lch-binding: done.")
(provide 'lch-binding)
