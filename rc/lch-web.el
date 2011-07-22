;-*- coding: utf-8 -*-

;>======== WEB.EL ========<;

;; Under MAC, has to install w3m through port, and add /opt/local to PATH
;; Have to use the CVS version of w3m for Emacs23
;; % cvs -d :pserver:anonymous@cvs.namazu.org:/storage/cvsroot login
;; CVS password: # No password is set.  Just hit Enter/Return key.
;; % cvs -d :pserver:anonymous@cvs.namazu.org:/storage/cvsroot co emacs-w3m

;; `w3m-browse-url' asks Emacs-w3m to browse a URL.

;; When JavaScript is needed or the "design" is just too bad, use another
;; browser: you can open the page in your graphical browser (at your own
;; risk) by hitting `M' (`w3m-view-url-with-external-browser').
;; For what "risk" means, please see: (info "(emacs-w3m)Gnus")

(if lch-win32-p (add-to-list 'exec-path (concat emacs-dir "/bin/w3m")))
;(setq w3-default-stylesheet "~/.default.css")
(require 'w3m)
(require 'w3m-lnum)

(defvar w3m-buffer-name-prefix "*w3m" "Name prefix of w3m buffer")
(defvar w3m-buffer-name (concat w3m-buffer-name-prefix "*") "Name of w3m buffer")
(defvar w3m-bookmark-buffer-name (concat w3m-buffer-name-prefix "-bookmark*") "Name of w3m buffer")

;>---- General Variable ----<;
(setq w3m-home-page   "http://www.emacswiki.org/"         ; "http://localhost/"
      w3m-use-favicon nil
      w3m-horizontal-shift-columns        1               ; columns used when scrolling a window horizontally
      w3m-default-save-directory          "~/Downloads/"
      w3m-default-display-inline-images   t               ; always display images
      )


(if lch-mac-p
    (progn
      (defun browse-url-firefox-macosx (url &optional new-window)
        (interactive (browse-url-interactive-arg "URL: "))
        (start-process (concat "open -a Firefox" url) nil "open" url))
      (setq browse-url-browser-function 'browse-url-firefox-macosx)))

;; proxy settings example, just uncomment to use.
;; (when (string= (upcase (system-name)) "PC3701")
;;   (eval-after-load "w3m"
;;     '(setq w3m-command-arguments
;; 	   (nconc w3m-command-arguments
;; 		  '("-o" "http_proxy=http://proxy:8080"))))
;;                                         ; FIXME https_proxy for HTTPS support
;;   (setq w3m-no-proxy-domains '("local.com" "sysdoc")))


(setq w3m-command-arguments '("-cookie" "-F")
      ;; w3m-command-arguments
      ;;       (append w3m-command-arguments
      ;;               ;; '("-o" "http_proxy=http://222.43.34.94:3128/"))
      ;;               '("-o" "http_proxy="))
      ;;       w3m-no-proxy-domains '(".edu.cn,166.111.,162.105.,net9.org"))
        )

(setq w3m-process-modeline-format " loaded: %s")

;>-- Using Tab --<;
(define-key w3m-mode-map (kbd "<C-tab>") 'w3m-next-buffer)
(define-key w3m-mode-map [(control shift iso-lefttab)] 'w3m-previous-buffer)

(defun w3m-new-tab ()
  (interactive)
  (w3m-copy-buffer nil nil nil t))

(define-key w3m-mode-map (kbd "C-t") 'w3m-new-tab)
(define-key w3m-mode-map (kbd "C-w") 'w3m-delete-buffer)

(defvar w3m-dir (concat emacs-dir "/site-lisp/w3m/") "Dir of w3m.")
(setq w3m-icon-directory (concat w3m-dir "icons"))

(defun lch-switch-to-w3m ()
  "Switch to an existing w3m buffer or look at bookmarks."
  (interactive)
  (let ((buf (get-buffer "*w3m*")))
    (if buf
        (switch-to-buffer buf)
       (w3m)
;      (w3m-bookmark-view)
      )))
(define-key global-map (kbd "<f3> <f2>") 'lch-switch-to-w3m)

(defun lch-w3m-goto-url ()
  "Type in directly the URL I would like to visit (avoiding to hit `C-k')."
  (interactive)
  (let ((w3m-current-url ""))
    (call-interactively 'w3m-goto-url)))

(defun lch-switch-to-w3m-goto-url ()
  (interactive)
  (let ((buf (get-buffer "*w3m*"))
        (w3m-current-url ""))
    (if buf
        (switch-to-buffer buf)
      (w3m))
    (w3m-new-tab)
    (call-interactively 'w3m-goto-url)
    ))
(define-key global-map (kbd "C-c C-f") 'lch-switch-to-w3m-goto-url)
(define-key global-map (kbd "<f3> <f3>") 'lch-switch-to-w3m-goto-url)

(defun lch-w3m-goto-location ()
  (interactive)
  (let (mylocation)
  (setq mylocation (read-string "Goto URL: "))
  (w3m-browse-url mylocation)
  ))

(defun lch-w3m-mode-hook ()
  (define-key w3m-mode-map (kbd "t") '(lambda() (interactive) (w3m-new-tab) (lch-w3m-goto-url)))
  (define-key w3m-mode-map (kbd "C-t") 'w3m-new-tab)
;  (define-key w3m-mode-map (kbd "g") 'lch-w3m-goto-location)
  (define-key w3m-mode-map (kbd "p") 'w3m-view-previous-page)
  (define-key w3m-mode-map (kbd "n") 'w3m-view-next-page)
  (define-key w3m-mode-map (kbd "b") 'w3m-view-previous-page)
  (define-key w3m-mode-map (kbd "f") 'w3m-view-next-page)
  (define-key w3m-mode-map (kbd "d") 'w3m-delete-buffer)
  (define-key w3m-mode-map (kbd "B") '(lambda() (interactive) (w3m-new-tab) (w3m-bookmark-view)))
  (define-key w3m-mode-map (kbd "H") 'w3m-history)
  (define-key w3m-mode-map (kbd "o") 'w3m-goto-url)
  (define-key w3m-mode-map (kbd "O") 'w3m-goto-url-new-session)
  (define-key w3m-mode-map (kbd "<up>") 'previous-line)
  (define-key w3m-mode-map (kbd "<down>") 'next-line)
  (define-key w3m-mode-map (kbd "<left>") 'backward-char)
  (define-key w3m-mode-map (kbd "<right>") 'forward-char)
  (define-key w3m-mode-map (kbd "<tab>") 'w3m-next-anchor)
  (setq truncate-lines nil))
(add-hook 'w3m-mode-hook 'lch-w3m-mode-hook)




;>---- Cookie Variables ----<;
;; enable cookies (to use sites such as Gmail)
(setq w3m-use-cookies t)

;; functions for cookie processing
(when (require 'w3m-cookie)
  ;; ask user whether accept bad cookies or not
  (setq w3m-cookie-accept-bad-cookies 'ask)

  ;; list of trusted domains
  (setq w3m-cookie-accept-domains
	'("google.com"
	  "yahoo.com" ".yahoo.com"
	  "groups.yahoo.com"
	  )))



;; FIXME toggle a minor mode showing link numbers
;; (when (require 'w3m-lnum)

;;   (defun my-w3m-go-to-linknum ()
;;     "Turn on link numbers and ask for one to go to."
;;     (interactive)
;;     (let ((active w3m-link-numbering-mode))
;;       (when (not active) (w3m-link-numbering-mode))
;;       (unwind-protect
;; 	  (w3m-move-numbered-anchor (read-number "Anchor number: "))
;; 	(when (not active) (w3m-link-numbering-mode))
;; 	(w3m-view-this-url))))

;;   (define-key w3m-mode-map (kbd "f") 'my-w3m-go-to-linknum)

;;   ;; enable link numbering mode by default
;;   (add-hook 'w3m-mode-hook 'w3m-link-numbering-mode))

;>---- wget ----<;
(setq wget-download-directory "~/Downloads")

;>---- Search ----<;
(when (require 'w3m-search)
  (define-key global-map (kbd "<f3> s") 'w3m-search)
  (add-to-list 'w3m-search-engine-alist
	       '("teoma" "http://www.teoma.com/search.asp?t=%s" nil)))

(defvar lch-search-engine-alist
      '(("google" . "http://www.google.com/search?q=")
        ("wikipedia" . "http://en.wikipedia.org/wiki/")
        ("baidu" . "http://www.baidu.com/s?wd=")
        ("definition" . "http://www.answers.com/main/ntquery?s=")
        ("google-file" . "http://www.google.com/search?q=+intitle:\"index+of\" -inurl:htm -inurl:html -inurl:php")
        ("ciba" . "http://www.iciba.com/")
        ))

(defun lch-w3m-browse-url (myurl)
  (interactive)
  (let ((buf (get-buffer "*w3m*"))
        (w3m-current-url ""))
    (if buf
        (switch-to-buffer buf)
      (w3m))
    (w3m-new-tab)
    (w3m-browse-url myurl)
    ))

(defun lch-search-by (engine browser &optional symbolp)
  "search by various engine in browsers.
   When symbolp is nil, search by input; true, search by symbol-at-point"
 (interactive)
 (let (myword myengine myurl)
   (if symbolp
       (progn
            (setq myword
                  (if (and transient-mark-mode mark-active)
                      (buffer-substring-no-properties (region-beginning) (region-end))
                    (thing-at-point 'symbol)))
            (cond ((string= engine "definition") (setq myword (replace-regexp-in-string " " "%20" myword)))
                  (t (setq myword (replace-regexp-in-string " " "_" myword)))))
     (progn (setq myword (read-string (concat engine "(" browser "): ")))))

   (setq myengine (cdr (assoc engine lch-search-engine-alist)))
   (setq myurl (concat myengine myword))

   (cond ((string= browser "ffx") (browse-url myurl))
         ((string= browser "w3m") (lch-w3m-browse-url myurl))
         (t (lch-w3m-browse-url myurl))
   )))

;; (defvar lch-engine-key-alist
;;   '(("1" . "google")
;;     ("2" . "wikipedia")
;;     ("3" . "badidu")
;;     ("4" . "ffx")
;;     ("7" . "ciba")))

;; (defvar lch-browser-key-alist
;;   '(("1" . "ffx")
;;     ("2" . "w3m")
;;     ))

;; FIXME (kbd var) won't work, kbd won't accept variable
;; (dolist (lch-engine lch-engine-key-alist)
;;   (dolist (lch-browser lch-browser-key-alist)
;;     (let ((engine-key  (car lch-engine))
;;           (engine-name (cdr lch-engine))
;;           (browser-key (car lch-browser))
;;           (browser-name (cdr lch-browser)))
;;       (cond ((string= browser-name "ffx") (setq lch-search-key-prefix "<f1>"))
;;             ((string= browser-name "w3m") (setq lch-search-key-prefix "<f2>"))
;;             (t (setq lch-search-key-prefix "<f2>")))
;;       (setq lch-direct-search-key (concat lch-search-key-prefix " " "<f" engine-key ">")
;;             lch-symbol-search-key (concat lch-search-key-prefix " " engine-key))
;;       (define-key global-map (kbd (eval lch-direct-search-key)) '(lambda() (interactive) (lch-search-by engine-name browser-name nil)))
;;       (define-key global-map (kbd lch-symbol-search-key) '(lambda() (interactive) (lch-search-by engine-name browser-name nil)))
;;       )))


(define-key global-map (kbd "<f1> <f1>") '(lambda() (interactive) (lch-search-by "google" "ffx" nil)))
(define-key global-map (kbd "<f1> <f2>") '(lambda() (interactive) (lch-search-by "wikipedia" "ffx" nil)))
(define-key global-map (kbd "<f1> <f3>") '(lambda() (interactive) (lch-search-by "baidu" "ffx" nil)))
(define-key global-map (kbd "<f1> <f4>") '(lambda() (interactive) (lch-search-by "definition" "ffx" nil)))
(define-key global-map (kbd "<f1> <f5>") '(lambda() (interactive) (lch-search-by "google-file" "ffx" nil)))
(define-key global-map (kbd "<f1> <f7>") '(lambda() (interactive) (lch-search-by "ciba" "ffx" nil)))

(define-key global-map (kbd "<f1> 1") '(lambda() (interactive) (lch-search-by "google" "ffx" t)))
(define-key global-map (kbd "<f1> 2") '(lambda() (interactive) (lch-search-by "wikipedia" "ffx" t)))
(define-key global-map (kbd "<f1> 3") '(lambda() (interactive) (lch-search-by "baidu" "ffx" t)))
(define-key global-map (kbd "<f1> 4") '(lambda() (interactive) (lch-search-by "definition" "ffx" t)))
(define-key global-map (kbd "<f1> 5") '(lambda() (interactive) (lch-search-by "google-file" "ffx" t)))
(define-key global-map (kbd "<f1> 7") '(lambda() (interactive) (lch-search-by "ciba" "ffx" t)))

(define-key global-map (kbd "<f2> <f1>") '(lambda() (interactive) (lch-search-by "google" "w3m" nil)))
(define-key global-map (kbd "<f2> <f2>") '(lambda() (interactive) (lch-search-by "wikipedia" "w3m" nil)))
(define-key global-map (kbd "<f2> <f3>") '(lambda() (interactive) (lch-search-by "baidu" "w3m" nil)))
(define-key global-map (kbd "<f2> <f4>") '(lambda() (interactive) (lch-search-by "definition" "w3m" nil)))
(define-key global-map (kbd "<f2> <f5>") '(lambda() (interactive) (lch-search-by "google-file" "w3m" nil)))
(define-key global-map (kbd "<f2> <f7>") '(lambda() (interactive) (lch-search-by "ciba" "w3m" nil)))

(define-key global-map (kbd "<f2> 1") '(lambda() (interactive) (lch-search-by "google" "w3m" t)))
(define-key global-map (kbd "<f2> 2") '(lambda() (interactive) (lch-search-by "wikipedia" "w3m" t)))
(define-key global-map (kbd "<f2> 3") '(lambda() (interactive) (lch-search-by "baidu" "w3m" t)))
(define-key global-map (kbd "<f2> 4") '(lambda() (interactive) (lch-search-by "definition" "w3m" t)))
(define-key global-map (kbd "<f2> 5") '(lambda() (interactive) (lch-search-by "google-file" "w3m" t)))
(define-key global-map (kbd "<f2> 7") '(lambda() (interactive) (lch-search-by "ciba" "w3m" t)))

(provide 'lch-web)
