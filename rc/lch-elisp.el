; -*- coding: utf-8 -*-

;>========== ELISP.EL -- LISP PACKAGES ==========<;


;;; Highlight non-breaking spaces
;; FIXME How does it work?
(require 'disp-table)
(aset standard-display-table
      (make-char 'latin-iso8859-1 (- ?\240 128))
      (vector (+ ?\267 (* 524288 (face-id 'nobreak-space)))))


;;; PP ^L
(require 'pp-c-l)
(setq pp^L-^L-string
      "----------------")
(set-face-attribute 'pp^L-highlight t :foreground "Black" :background "Orange")
(pretty-control-l-mode 1)


;;; Leisure Read
;; FIXME: It wrote ~/lch-bmk, which is bad. Besides, it mess up with
;; the bookmark files, which leads org not working alright.
;; (require 'leisureread)
;; (global-set-key (kbd "C-.") 'leisureread-insert-next-line)
;; (global-set-key (kbd "C-,") 'leisureread-insert-previous-line)
;; (global-set-key (kbd "C-'") 'leisureread-clear-line)


;;; Flyspell
;; By default, it's iSpell, but if aspell is installed:
(when (featurep 'aspell) (setq ispell-program-name "aspell"))
(setq-default ispell-local-dictionary "american")

;; Omit tex keywords
(add-hook 'LaTeX-mode-hook 'flyspell-mode-on)
(add-hook 'tex-mode-hook (function (lambda () (setq ispell-parser 'tex))))

(dolist (hook '(text-mode-hook))
  (add-hook hook (lambda () (flyspell-mode 1))))
(dolist (hook '(change-log-mode-hook log-edit-mode-hook))
  (add-hook hook (lambda () (flyspell-mode -1))))


;;; BM
(setq bm-restore-repository-on-load t)
(setq bm-repository-file (concat emacs-var-dir "/.bm-repository"))
(require 'bm)
(set-face-attribute 'bm-persistent-face nil :background "SlateBlue")
(global-set-key (kbd "<f6> <f6>") 'bm-toggle)
(global-set-key (kbd "<f6> <f7>") 'bm-next)
(global-set-key (kbd "<f6> <f5>") 'bm-previous)
(global-set-key (kbd "M-<f6>") 'bm-previous)
(global-set-key (kbd "C-<f6>") 'bm-next)
;; make bookmarks persistent as default
(setq-default bm-buffer-persistence t)

;; Loading the repository from file when on start up.
(add-hook' after-init-hook 'bm-repository-load)

;; Restoring bookmarks when on file find.
(add-hook 'find-file-hooks 'bm-buffer-restore)

;; Saving bookmark data on killing a buffer
(add-hook 'kill-buffer-hook 'bm-buffer-save)

;; Saving the repository to file when on exit.
;; kill-buffer-hook is not called when emacs is killed, so we
;; must save all bookmarks first.
(add-hook 'kill-emacs-hook '(lambda nil
                              (bm-buffer-save-all)
                              (bm-repository-save)))


;;; Evernote mode
;; (require 'evernote-mode)
;; (setq evernote-enml-formatter-command '("w3m" "-dump" "-I" "UTF8" "-O" "UTF8"))
;; (define-prefix-command 'M0-map)
;; (add-to-list 'exec-path "/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin")
;; (setenv "PATH" (concat "/System/Library/Frameworks/Ruby.framework/Versions/1.8/usr/bin:" (getenv "PATH")))
;; (define-key global-map (kbd "M-0") 'M0-map)
;; (define-key global-map (kbd "M-0 c") 'evernote-create-note)
;; (define-key global-map (kbd "M-0 o") 'evernote-open-note)
;; (define-key global-map (kbd "M-0 s") 'evernote-search-notes)
;; (define-key global-map (kbd "M-0 S") 'evernote-do-saved-search)
;; (define-key global-map (kbd "M-0 w") 'evernote-write-note)
;; (define-key global-map (kbd "M-0 p") 'evernote-post-region)
;; (define-key global-map (kbd "M-0 b") 'evernote-browser)


;;; One-key
(require 'one-key)
(defvar one-key-menu-emms-alist nil
  "`One-Key' menu list for EMMS.")

(setq one-key-menu-emms-alist
      '(
        (("g" . "Playlist Go") . emms-playlist-mode-go)
        (("d" . "Play Directory Tree") . emms-play-directory-tree)
        (("f" . "Play File") . emms-play-file)
        (("i" . "Play Playlist") . emms-play-playlist)
        (("t" . "Add Directory Tree") . emms-add-directory-tree)
        (("c" . "Toggle Repeat Track") . emms-toggle-repeat-track)
        (("w" . "Toggle Repeat Playlist") . emms-toggle-repeat-playlist)
        (("u" . "Play Now") . emms-play-now)
        (("z" . "Show") . emms-show)
        (("s" . "Emms Streams") . emms-streams)
        (("b" . "Emms Browser") . emms-browser)))

(defun one-key-menu-emms ()
  "`One-Key' menu for EMMS."
  (interactive)
  (one-key-menu "emms" one-key-menu-emms-alist t))

(define-key global-map (kbd "<f12> <f11>") 'one-key-menu-emms)


;;; Calfw
(require 'calfw)
(require 'calfw-org)


;;; AucTeX

(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)

(setq preview-gs-command
      (cond (lch-win32-p
             "C:/Program Files/gs/gs8.64/bin/gswin32c.exe")
            (t
             "/usr/texbin/gs")))

;;; Magit
(require 'magit)
(define-key global-map (kbd "C-x g") 'magit-status)


;;; Goto-last-change
(require 'goto-last-change)
(define-key global-map (kbd "C-x C-\\") 'goto-last-change)
(define-key global-map (kbd "<f2> <f2>") 'goto-last-change)
;(require 'goto-last-change)
;; OR auto-load:
(autoload 'goto-last-change "goto-last-change"
 	  "Set point to the position of the last change." t)



;;; Smex
(require 'smex)
(smex-initialize)
(setq smex-save-file (concat emacs-var-dir "/.smex-items"))
(define-key global-map (kbd "M-x") 'smex)
(define-key global-map (kbd "M-X") 'smex-major-mode-commands)


;;; FFAP
(require 'ffap)
(defun lch-ffap ()
  "Find variable function or file at point"
  (interactive)
  (cond ((not (eq (variable-at-point) 0))
          (call-interactively 'describe-variable)
          )
         ((function-called-at-point)
          (call-interactively 'describe-function))
         (t (find-file-at-point))))
(define-key global-map (kbd "C-x f") 'lch-ffap)
(define-key global-map (kbd "<f10> <f10>") 'lch-ffap)


;;; Recentf
(require 'recentf)

;; toggle `recentf' mode
(recentf-mode 1)

;; file to save the recent list into
(setq recentf-save-file (concat emacs-var-dir "/emacs.recentf"))

;; maximum number of items in the recentf menu
(setq recentf-max-menu-items 30)

;; add key binding
(define-key global-map (kbd "C-x C-r") 'recentf-open-files)


;;; Pager

;; Better scrolling in Emacs (doing a `Pg Up' followed by a `Pg Dn' will
;; place the point at the same place)

(require 'pager)
(define-key global-map (kbd "C-v") 'pager-page-down)
(define-key global-map (kbd "M-v") 'pager-page-up)
(define-key global-map '[M-up] 'pager-row-up)
(define-key global-map '[M-kp-8] 'pager-row-up)
(define-key global-map '[M-down] 'pager-row-down)
(define-key global-map '[M-kp-2] 'pager-row-down)


;;; Python
(setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
(setq interpreter-mode-alist (cons '("python" . python-mode)
                                      interpreter-mode-alist))
(autoload 'python-mode "python-mode" "Python editing mode." t)


;;; Cedet
;(require 'cedet)


;;; Rainbow mode
(require 'rainbow-mode)


;;; Autopair
;> Auto insert the other part of Paren.
;; The same as skeleton-insert-pair.
; (require 'autopair)
; (autopair-global-mode) ;; to enable in all buffers


;;; Find-dired
(require 'find-dired)
(setq find-ls-option '("-print0 | xargs -0 ls -ld" . "-ld"))



;;;---- Package ----
;; (when (require 'package)
;;   (setq package-archives '(("ELPA" . "http://tromey.com/elpa/")
;; 			   ("gnu" . "http://elpa.gnu.org/packages/")
;; 			   ("marmalade" . "http://marmalade-repo.org/packages/"))))
;; (package-initialize)

;>~~~~~~~~~~ Lisp conf ~~~~~~~~~~<;
(require 'highlight-beyond-fill-column)
(setq highlight-beyond-fill-column-in-modes
      '("emacs-lisp-mode"))


;;;---- Less ----
;(require 'less)
;; (eval-after-load 'less
;;   '(progn
;;      (setq auto-less-exclude-regexp
;;            (concat auto-less-exclude-regexp
;;                    "\\|"
;;                    (regexp-opt '("todo.org"
;;                                  "outgoing"
;;                                  "*gud"
;;                                  "*anything"
;;                                  ))))
;;      (setq auto-less-exclude-modes
;;            (append auto-less-exclude-modes
;;                    '(proced-mode)))
;;      ))
;(global-less-minor-mode 1)


;;;---- Uniquify ----
;-Make filename unique
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward
      uniquify-separator ":")


;;;------ iBuffer ------
;- ibuffer shows a buffer list that allows to perform almost any
;- imaginable operation on the opened buffers.
(when (require 'ibuffer)
    ;; completely replaces `list-buffer'
    (defalias 'ibuffer-list-buffers 'list-buffer)

    (setq ibuffer-shrink-to-minimum-size t)
    (setq ibuffer-always-show-last-buffer nil)
    (setq ibuffer-sorting-mode 'recency)
    (setq ibuffer-use-header-line t)

    (define-key global-map (kbd "C-x C-b") 'ibuffer)
    )


;;;---- iDo ----
(require 'ido)
(ido-mode t)
(setq ido-save-directory-list-file (concat emacs-var-dir "/emacs-ido-last"))
(setq ido-enable-flex-matching t)
(setq ido-use-filename-at-point 'guess)
;(setq ido-show-dot-for-dired t)
;(setq ido-enable-tramp-completion nil)
(define-key global-map (kbd "C-x b") 'ido-switch-buffer)


;;; Browse-kill-ring

;; (info "(emacs)Kill Ring")
(require 'browse-kill-ring)
(setq browse-kill-ring-separator
      "\n--item------------------------------")
;; temporarily highlight the inserted `kill-ring' entry
(setq browse-kill-ring-highlight-inserted-item t)

;(defface separator-face '((t (:foreground "Orange" :weight bold))) nil)
;(setq browse-kill-ring-separator-face 'separator-face)

(define-key global-map (kbd "C-c k") 'browse-kill-ring)
(browse-kill-ring-default-keybindings)


;;; Hide-region

;; Hide-region
;(require 'hide-region)
;(define-key global-map (kbd "C-c r") 'hide-region-hide)
;(define-key global-map (kbd "C-c R") 'hide-region-unhide)

;; Hide-line
;(require 'hide-lines)
;(define-key global-map (kbd "C-c l") 'hide-lines)
;(define-key global-map (kbd "C-c L") 'show-all-invisible)


;;; Htmlize-buffer
(require 'htmlize)


;;; Dired-jump
;> provide some dired goodies and dired-jump at C-x C-j
(load "dired-x")
;; ;> TC-like file search, just need to press letters.
;; (require 'dired-lis)
;; (dired-lcs-mode 1)


;;; YASnippet
;- Loaded in org.el


;;; Company
;; (add-to-list 'load-path (concat emacs-dir "/site-lisp/company"))
;; (autoload 'company-mode "company" nil t)

;; (setq company-idle-delay 0.2)
;; (setq company-minimum-prefix-length 1)

;> Enable company mode when entering these modes.
;; (dolist (hook (list
;;                'emacs-lisp-mode-hook
;;                'lisp-mode-hook
;;                'lisp-interaction-mode-hook
;; 	       'sh-mode-hook
;; 	       'org-mode-hook))
;;   (add-hook hook 'company-mode))




;;;---- Auto-Complete ----
(require 'auto-complete)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories emacs-site-lisp)
(ac-config-default)
(setq ac-comphist-file  (concat emacs-var-dir "/ac-comphist.dat"))
(global-auto-complete-mode t)

;> Use Company Backends for Auto-Complete.
;; (require 'ac-company)
;; (ac-company-define-source ac-source-company-elisp company-elisp)
;; (add-hook 'emacs-lisp-mode-hook
;;        (lambda ()
;;          (add-to-list 'ac-sources 'ac-source-company-elisp)))


;;;---- Vimpulse ----
;(require 'vimpulse)


;;;---- Cygwin ----
;(require 'setup-cygwin)


;;;---- Cedet ----
;(require 'cedet)
;(semantic-mode 1)


;;;---- Sunrise Commander ----
;(require 'sunrise-commander)
;(define-key global-map (kbd "C-M-e") 'sunrise-cd)
;(sunrise-mc-keys)


;;;---- Highlight-tail ----
; (require 'highlight-tail)
; (message "Highlight-tail loaded - now your Emacs will be even more sexy!")
; (highlight-tail-mode)


;;;---- Bat-mode ----
(when (string-equal system-type "windows-nt")
  (progn
    (setq auto-mode-alist
      (append
       (list (cons "\\.[bB][aA][tT]$" 'bat-mode))
       ;; For DOS init files
       (list (cons "CONFIG\\."   'bat-mode))
       (list (cons "AUTOEXEC\\." 'bat-mode))
       auto-mode-alist))

    (autoload 'bat-mode "bat-mode" "DOS and WIndows BAT files" t)
    )
  )



;;;---- Matlab ----
;; FIXME
;(load-library "matlab-load")
;(matlab-cedet-setup)
;; (autoload 'matlab-mode "matlab" "Enter MATLAB mode." t)
;; (setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))
;; (autoload 'matlab-shell "matlab" "Interactive MATLAB mode." t)


;;;---- AucTeX ----
;(load "auctex.el" nil t t)
;(setq TeX-auto-save t)
;(setq-default TeX-master nil)
;(load "preview-latex.el" nil t t)


;;;---- Session ----
;! Save a list of open files in ~/.emacs.d/session.
(require 'session)
(add-hook 'after-init-hook 'session-initialize)


;;;---- Whitespace-mode  ----
;- Make whitespace-mode with very basic background coloring for whitespaces
(defvar whitespace-style (quote ( spaces tabs newline space-mark tab-mark newline-mark )))

;- Make whitespace-mode and whitespace-newline-mode use "¶" for end of line char and ▷ for tab.
(setq
 whitespace-display-mappings
 '(
   (space-mark 32 [183] [46]) ; normal space, MIDDLE DOT, FULL STOP.
   (space-mark 160 [164] [95])
   (space-mark 2208 [2212] [95])
   (space-mark 2336 [2340] [95])
   (space-mark 3616 [3620] [95])
   (space-mark 3872 [3876] [95])
   (newline-mark 10 [182 10]) ; newlne
   (tab-mark 9 [9655 9] [92 9]) ; tab
))


;;;---- Highlight Symbol ----
;> Highlight occurrence of current word, and move cursor to next/prev occurrence
;> see http://xahlee.org/emacs/modernization_isearch.html
(require 'highlight-symbol)
;; temp hotkeys
(define-key global-map (kbd "<f9> <f9>") 'highlight-symbol-at-point) ; this is a toggle
(define-key global-map (kbd "<f9> <f8>") 'highlight-symbol-next)
(define-key global-map (kbd "<f9> <f10>") 'highlight-symbol-prev)



;;;---- Bat Mode ----
;> For editing Windows's cmd.exe's script; batch, ".bat" file mode.
(autoload 'dos-mode "dos" "A mode for editing Windows cmd.exe batch scripts." t)
(add-to-list 'auto-mode-alist '("\\.bat\\'" . dos-mode))
(add-to-list 'auto-mode-alist '("\\.cmd\\'" . dos-mode))


;;;---- AutoHotKey Mode ----
;> a keyboard macro for Windows
(autoload 'xahk-mode "xahk-mode" "AutoHotKey mode" t)
(add-to-list 'auto-mode-alist '("\\.ahk\\'" . xahk-mode))


;;; Hunspell
;; (when (string-equal system-type "windows-nt")
;;   (when (or (file-exists-p "../bin/hunspell")
;;             (file-exists-p "C:\\Program Files (x86)\\ErgoEmacs\\hunspell")
;;             )
;;     (progn
;;       (add-to-list 'load-path
;;                    (concat (file-name-directory (or load-file-name buffer-file-name)) "../site-lisp/rw-hunspell/") )
;;       (require 'rw-hunspell)
;;       (rw-hunspell-setup)
;;       ) ) )


;;; Desktop
;- Make emacs open all files in last emacs session.
;- Desktop is already part of Emacs.
;- This functionality is provided by desktop-save-mode ("feature"
;- name: "desktop"). The mode is not on by default in emacs 23, and
;- has a lot options.

;- By default, it read .emacs.desktop.lock file from the
;- dir where Emacs starts from, so when evoke Emacs from
;- FVWM by C-W-2, it reads the file from ~/.

;- Goal: have emacs always auto open the set of opend files in last
;- session, even if emacs crashed in last session or the OS crashed in
;- last session. Also, don't bother users by asking questions like "do
;- you want to save desktop?" or "do you want to override last session
;- file?", because these are annoying and terms like "session" or
;- "desktop" are confusing to most users because it can have many
;- meanings.

;- Some tech detail: set the desktop session file at
;- user-emacs-directory (default is "~/.emacs.d/.emacs.desktop").  This file
;- is our desktop file. It will be auto created and or over-written.
;- if a emacs expert has other desktop session files elsewhere, he can
;- still use or manage those.

;- Save the desktop file automatically if it already exists.
;- Use M-x desktop-save once to save the desktop, eachtime you exit Emacs
;- Or just set (desktop-save-mode 1), so Emacs will save desktop automatically.

(require 'desktop)

;(setq desktop-path '("~/.emacs.d/"))
;(setq desktop-dirname "~/.emacs.d/")
;(setq desktop-base-file-name ".emacs-desktop")

(defun desktop-settings-setup()
  (desktop-save-mode 1)
  (setq desktop-save t)
  (setq desktop-load-locked-desktop t)
  (setq desktop-dirname emacs-var-dir)
  (setq desktop-path (list emacs-var-dir))
  (if (file-exists-p (concat desktop-dirname desktop-base-file-name))
      (desktop-read desktop-dirname)))

(add-hook 'after-init-hook 'desktop-settings-setup)

;; (defun desktop-settings-setup ()
;;   "Some settings setup for desktop-save-mode."
;;   (interactive)

;;   ;; At this point the desktop.el hook in after-init-hook was
;;   ;; executed, so (desktop-read) is avoided.
;;   (when (not (eq (emacs-pid) (desktop-owner))) ; Check that emacs did not load a desktop yet
;;     ;; Here we activate the desktop mode
;;     (desktop-save-mode 1)

;;     ;; The default desktop is saved always
;;     (setq desktop-save t)

;;     ;; The default desktop is loaded anyway if it is locked
;;     (setq desktop-load-locked-desktop t)

;;     ;; Set the location to save/load default desktop
;;     (setq desktop-dirname emacs-var-dir)
;;     (setq desktop-path (list emacs-var-dir))

;;     ;; Make sure that even if emacs or OS crashed, emacs
;;     ;; still have last opened files.
;;     (add-hook 'find-file-hook
;;               (lambda ()
;;                 (run-with-timer 5 nil
;;                                 (lambda ()
;;                                   ;; Reset desktop modification time so the user is not bothered
;;                                   (setq desktop-file-modtime (nth 5 (file-attributes (desktop-full-file-name))))
;;                                   (desktop-save user-emacs-directory)))))

;;     ;; Read default desktop
;;     (if (file-exists-p (concat desktop-dirname desktop-base-file-name))
;;     (desktop-read desktop-dirname))
;;     ;; Add a hook when emacs is closed to we reset the desktop
;;     ;; modification time (in this way the user does not get a warning
;;     ;; message about desktop modifications)
;;     (add-hook 'kill-emacs-hook
;;               (lambda ()
;;                 ;; Reset desktop modification time so the user is not bothered
;;                 (setq desktop-file-modtime (nth 5 (file-attributes (desktop-full-file-name))))))
;;     )
;;   )


;;; provide
(provide 'lch-elisp)


;;; Local Vars.
;; Local Variables:
;; mode: emacs-lisp
;; outline-regexp: ";;;;* "
;; End: