;-*- coding: utf-8 -*-

;>======== WEB.EL ========<;

;- Under MAC, has to install w3m through port, and add /opt/local to PATH
;; Have to use the CVS version of w3m for Emacs23
;; % cvs -d :pserver:anonymous@cvs.namazu.org:/storage/cvsroot login
;; CVS password: # No password is set.  Just hit Enter/Return key.
;; % cvs -d :pserver:anonymous@cvs.namazu.org:/storage/cvsroot co emacs-w3m

;- `w3m-browse-url' asks Emacs-w3m to browse a URL.

;- When JavaScript is needed or the "design" is just too bad, use another
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

(setq w3m-command-arguments '("-cookie" "-F")
      ;; w3m-command-arguments
      ;;       (append w3m-command-arguments
      ;;               ;; '("-o" "http_proxy=http://222.43.34.94:3128/"))
      ;;               '("-o" "http_proxy="))
      ;;       w3m-no-proxy-domains '(".edu.cn,166.111.,162.105.,net9.org"))
        )

(setq w3m-process-modeline-format " loaded: %s")

(defun lch-w3m-mode-hook ()
  (define-key w3m-mode-map (kbd "t") 'w3m-view-this-url-new-session)
  (define-key w3m-mode-map (kbd "p") 'w3m-view-previous-page)
  (define-key w3m-mode-map (kbd "n") 'w3m-view-next-page)
  (define-key w3m-mode-map (kbd "B") 'w3m-view-previous-page)
  (define-key w3m-mode-map (kbd "F") 'w3m-view-next-page)
  (define-key w3m-mode-map (kbd "o") 'w3m-goto-url)
  (define-key w3m-mode-map (kbd "O") 'w3m-goto-url-new-session)
  (define-key w3m-mode-map (kbd "<up>") 'previous-line)
  (define-key w3m-mode-map (kbd "<down>") 'next-line)
  (define-key w3m-mode-map (kbd "<left>") 'backward-char)
  (define-key w3m-mode-map (kbd "<right>") 'forward-char)
  (define-key w3m-mode-map (kbd "<tab>") 'w3m-next-anchor)
  (setq truncate-lines nil))
(add-hook 'w3m-mode-hook 'lch-w3m-mode-hook)

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

(defun lch-w3m-go ()
  "Switch to an existing w3m buffer or look at bookmarks."
  (interactive)
  (let ((buf (get-buffer "*w3m*")))
    (if buf
        (switch-to-buffer buf)
       (w3m)
;      (w3m-bookmark-view)
      )))
(define-key global-map (kbd "<f3> <f3>") 'lch-w3m-go)

(defun lch-w3m-goto-url ()
  "Type in directly the URL I would like to visit (avoiding to hit `C-k')."
  (interactive)
  (let ((w3m-current-url ""))
    (call-interactively 'w3m-goto-url)))
(define-key w3m-mode-map (kbd "U") 'lch-w3m-goto-url)

;>---- General Variable ----<;
(setq w3m-home-page "http://www.princeton.edu/~chaol")
					;-"http://localhost/" ;-"http://www.emacswiki.org/"

;; number of steps in columns used when scrolling a window horizontally
(setq w3m-horizontal-shift-columns 1)  ; 2

(setq w3m-default-save-directory "~/Downloads/")

;; proxy settings example, just uncomment to use.
;; (when (string= (upcase (system-name)) "PC3701")
;;   (eval-after-load "w3m"
;;     '(setq w3m-command-arguments
;; 	   (nconc w3m-command-arguments
;; 		  '("-o" "http_proxy=http://proxy:8080"))))
;;                                         ; FIXME https_proxy for HTTPS support
;;   (setq w3m-no-proxy-domains '("local.com" "sysdoc")))

;>---- Image Variables ----<;

;; always display images
(setq w3m-default-display-inline-images t)

;; show favicon images if they are available
(setq w3m-use-favicon t)

;>---- Cookie Variables ----<;

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

;; enable cookies (to use sites such as Gmail)
(setq w3m-use-cookies t)


;; Search
(when (require 'w3m-search)
  (define-key global-map (kbd "<f3> s") 'w3m-search)
  (add-to-list 'w3m-search-engine-alist
	       '("teoma" "http://www.teoma.com/search.asp?t=%s" nil)))

(defun google (what)
  "Use google to search for WHAT."
  (interactive "sSearch: ")
  (save-window-excursion
    (delete-other-windows)
    (let ((dir default-directory))
      (w3m-browse-url (concat "http://www.google.com/search?q="
			      (w3m-url-encode-string what)))
      (cd dir)
      (recursive-edit))))
(global-set-key (kbd "<f3> g") 'google)

;; toggle a minor mode showing link numbers
(when (require 'w3m-lnum)

  (defun my-w3m-go-to-linknum ()
    "Turn on link numbers and ask for one to go to."
    (interactive)
    (let ((active w3m-link-numbering-mode))
      (when (not active) (w3m-link-numbering-mode))
      (unwind-protect
	  (w3m-move-numbered-anchor (read-number "Anchor number: "))
	(when (not active) (w3m-link-numbering-mode))
	(w3m-view-this-url))))

  (define-key w3m-mode-map (kbd "f") 'my-w3m-go-to-linknum)

  ;; enable link numbering mode by default
  (add-hook 'w3m-mode-hook 'w3m-link-numbering-mode))


;>---- wget ----<;
(setq wget-download-directory "~/Downloads")

(provide 'lch-web)
