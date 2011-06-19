;-*- coding: utf-8 -*-
;>======== INIT.EL  ========<;
;- (info "(emacs)Customization")
(message "=> lch-init: loading...")

;- Default major mode for new buffers and any files with unspecified mode
(when (locate-library "org.el")
     (setq-default major-mode 'org-mode))

;- Auto-reload file when modified from external app
;; whenever an external process changes a file underneath emacs, and there
;; was no unsaved changes in the corresponding buffer, just revert its
;; content to reflect what's on-disk.
(global-auto-revert-mode 1)

;; Transient mark
(when window-system (transient-mark-mode 1))

;; Set default browser
(setq browse-url-browser-function 'browse-url-firefox)

;(setq left-fringe-width 12)

;>---- Mouse Jump away ----<;
(mouse-avoidance-mode 'jump)

;>---- Turn on the functions disabled by default ----<;
(put 'upcase-region    'disabled nil)
(put 'downcase-region  'disabled nil)
(put 'overwrite-mode   'disabled t)
(put 'narrow-to-page   'disabled nil)
(put 'narrow-to-region 'disabled nil)
;>- Turn on all the disabled functions
(setq disabled-command-function nil)

;>---- Display page delimiter ^L as a horizontal line ----<;
;(aset standard-display-table ?\^L (vconcat (make-vector 64 ?-) "^L"))

;>---- 'y' for 'yes', 'n' for 'no' ----<;
(fset 'yes-or-no-p 'y-or-n-p)

;>---- Bigger kill-ring ----<;
(setq kill-ring-max 200)

;>---- Close the picture startup ----<;
(setq inhibit-startup-message t)

;>---- Alter the scratch message ----<;
(setq initial-scratch-message "")
;(setq initial-scratch-message "Welcome to the world of Emacs")

;>---- Setup for newline auto-appending support ----<;
(setq next-line-add-newline t)

;>---- Don't beep at me ----<;
;(setq visible-bell t)
;>~ No ring no screen shaking.
(setq ring-bell-function 'ignore)

;>---- Line trancation enable ----<;
(setq truncate-partial-width-windows nil) 

;>---- Display column & line number ----<;
(column-number-mode 1)
(line-number-mode 1)

;>---- Time stamp support ----<;
(setq time-stamp-active t)
(setq time-stamp-warn-inactive t)
;(setq time-stamp-format "%:y-%02m-%02d %02H:%02M:%02S Lu Chao")
;(add-hook 'write-file-hooks 'time-stamp)

;>---- New line ----<;
;; Interchange these two keys.
;; Under most cases, indent is needed after enter.
(define-key global-map (kbd "C-m") 'newline-and-indent)
(define-key global-map (kbd "C-j") 'newline)

;>---- Directly delete current line ----<;
;(define-key global-map (kbd "C-k") 'kill-whole-line)

;>---- Set default major mode org-mode ----<;
;> Enabled in Org-mode
;(setq major-mode 'org-mode)

;>---- Display picture ----<;
(auto-image-file-mode)

;>---- Grammar highlight ----<;
;> Significant functionality depends on font-locking being active.
;> For all buffers
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)

;> For Org buffers only
;> (add-hook 'org-mode-hook 'turn-on-font-lock)

;>---- BMK FILW ----<;
;> Not only on exit, but on every modification
(setq bookmark-save-flag 1)

;>---- Allow emacs cocopy&paste with X11 apps ----<;
(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

;>---- Start server for emacsclient ----<;
;>- Start the emacs server only if another instance of the server is not running.
(require 'server)
(if (eq (server-running-p server-name) nil)
    (server-start))
(remove-hook 'kill-buffer-query-functions 'server-kill-buffer-query-function)

;>---- Delete-selection as usual soft ----<;
;> Select and press a key to delete, like MSWord
(delete-selection-mode t)

;>---- Enable some function ----<;
(put 'narrow-to-region 'disabled nil)
(put 'erase-buffer 'disabled nil)

;>-------- BACKUP POLICIES --------<;
(setq make-backup-files t
      version-control t
      kept-old-versions 2
      kept-new-versions 5
      delete-old-versions t
      backup-by-copying t
      backup-by-copying-when-linked t
      backup-by-copying-when-mismatch t)

;> Backup path
(setq backup-directory-alist '(("" . "~/.emacs.var/backup")))
;; Don't make backup files
;(setq make-backup-files nil backup-inhibited t)

;>-------- DIARY FILE --------<;
;(setq diary-file "~/.emacs.var/.diary")
;(add-hook 'diary-hook 'appt-make-list)
;(setq diary-mail-addr "loochao@gmail.com")


;>-------- AUTO-FILL --------<;
;> Turn on auto-fill mode for all major modes
;(setq-default auto-fill-function 'do-auto-fill)
;> Auto fill length
(set-fill-column 100)
;> Automatically turn on auto-fill-mode when editing text files
;(add-hook 'text-mode-hook 'turn-on-auto-fill)

;>-------- TRUNCATE-LINES --------<;
;> t means aaaaa->
(set-default 'truncate-lines nil)
;; Toggles between line wrapping in the current buffer.
(defun lch-toggle-line-wrapping ()
  "Toggles between line wrapping in the current buffer."
  (interactive)
  (if (eq truncate-lines nil)
      (progn
        (setq truncate-lines t)
        (redraw-display)
        (message "Setting truncate-lines to t"))
    (setq truncate-lines nil)
    (redraw-display)
    (message "Setting truncate-lines to nil"))
  )
(define-key global-map (kbd "C-c ^") 'lch-toggle-line-wrapping)

;>-------- AUTO COMPILE EL FILES --------<;
(defun elisp-compile-hook ()
  (add-hook 'after-save-hook (lambda () (byte-compile-file (buffer-file-name
(current-buffer)))) nil t))
(add-hook 'emacs-lisp-mode-hook 'elisp-compile-hook)

(defun byte-recompile-directory-all (bytecomp-directory &optional bytecomp-force)
  (interactive "DByte recompile directory: ")
  (byte-recompile-directory bytecomp-directory 0 bytecomp-force))

(defun byte-recompile-special-directory (&optional bytecomp-force)
  (interactive)
  (byte-recompile-directory "~/.emacs.d/rc" 0 bytecomp-force))

;>-------- ALIASES --------<;
(defalias 'wku 'w3m-print-this-url)
(defalias 'wkl 'w3m-print-current-url)
(defalias 'afm 'auto-fill-mode)

;>-------- TIME SETTING --------<;
;; Display format in 24hr format
(setq display-time-24hr-format t)
;; Display time date
(setq display-time-day-and-date t)
;; Time altering frequency
(setq display-time-interval 10)

;; (setq display-time-format "<%V-%u> %m/%d/%H:%M")
(setq display-time-format "%a(%V) %m-%d/%H:%M")

(display-time)
;>-------- LOCAL VARIABLES --------<;
;- (info "(emacs)Variables")
;- (info "(emacs)Directory Variables")

;; file local variables specifications are obeyed, without query -- RISKY!
(setq enable-local-variables t)

;; obey `eval' variables -- RISKY!
(setq enable-local-eval t)

;; record safe values for some local variables
(setq safe-local-variable-values
      '((TeX-master . t)
        (balloon-help-mode . -1)
        (flyspell-mode . t)
        (flyspell-mode . -1)
        (ispell-local-dictionary . "en_US")
        (ispell-mode . t)
	(byte-compile . nil)
	(auto-compile-lisp . nil)
;        (org-export-latex-title-command . "\\maketitle[logo=Forem]")
      ))

;>-------- EXPANSIONS & COMPLETIONS --------<;
(setq hippie-expand-try-functions-list
      '(try-expand-dabbrev
        try-expand-whole-kill
        ;senator-try-expand-semantic
        try-expand-dabbrev-visible
        try-expand-dabbrev-from-kill
        try-expand-dabbrev-all-buffers
        try-expand-all-abbrevs
        try-complete-file-name-partially
        try-complete-file-name
        try-expand-list
        ;try-complete-lisp-symbol-partially
        ;try-complete-lisp-symbol
        try-expand-line
	try-expand-line-all-buffers))

;>-------- USER INFO --------<;
(setq user-full-name "LooChao<LooChao@gmail.com>")
(setq user-mail-address "LooChao@gmail.com")

;>-------- GREP & FIND --------<;
;- (info "(emacs)Dired and Find")
;; Search for files with names matching a wild card pattern and Dired the output
(define-key global-map (kbd "C-c 1") 'find-name-dired)

;; Search for files with contents matching a wild card pattern and Dired the output
(define-key global-map (kbd "C-c 2") 'find-grep-dired)

;; Run grep via find, with user-specified arguments
(define-key global-map (kbd "C-c 3") 'grep-find)

;; ignore `.svn' and `CVS' directories
;; FIXME
;; (setq grep-find-command
;;       (concat "find . \\( -path '*/.svn' -o -path '*/CVS' \\) -prune -o -type f "
;; 	      "-print0 | " "xargs -0 -e grep -i -n -e "))

;>-------- AUTO SAVE FILES IN ONE PLACE --------<;
;- Put autosave files (i.e. #foo#) in one place, *NOT*
;; scattered all over the file system!

;; auto-save every 100 input events
(setq auto-save-interval 100)

;; auto-save after 15 seconds idle time
(setq auto-save-timeout 15)

(defvar autosave-dir
 (concat "~/.emacs.var/auto-save-list/" (user-login-name) "/"))
(make-directory autosave-dir t)

(defun auto-save-file-name-p (filename)
  (string-match "^#.*#$" (file-name-nondirectory filename)))

(defun make-auto-save-file-name ()
  (concat autosave-dir
   (if buffer-file-name
      (concat "#" (file-name-nondirectory buffer-file-name) "#")
    (expand-file-name
     (concat "#%" (buffer-name) "#")))))

;>-------- PRINT FOR W32 --------<;
(if lch-win32-p
    (progn
      (require 'w32-winprint)
      (define-key global-map (kbd "<f2> p") 'w32-winprint-print-buffer-htmlize)
      (define-key global-map (kbd "<f2> P") 'w32-winprint-print-buffer-notepad)))

(message "~~ lch-init: done.")
(provide 'lch-init)