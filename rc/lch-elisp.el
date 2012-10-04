;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; ELISP.EL
;;
;; Copyright (c) 2006 2007 2008 2009 2010 2011 Chao LU
;;
;; Author: Chao LU <loochao@gmail.com>
;; URL: http://www.princeton.edu/~chaol

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Settings for elisp packages.

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code
(message "=> lch-elisp: loading...")

;;; Tabbar-ruler
;; (setq EmacsPortable-global-tabbar nil) ; If you want tabbar
;; (setq EmacsPortable-global-ruler nil)  ; if you want a global ruler
;; (setq EmacsPortable-popup-menu t)      ; If you want a popup menu.
;; (setq EmacsPortable-popup-toolbar nil) ; If you want a popup toolbar

;; (require 'tabbar-ruler)
;;; Bash-completion
(require 'bash-completion)
(bash-completion-setup)

;; Or autoload it:
;; (autoload 'bash-completion-dynamic-complete
;;   "bash-completion"
;;   "BASH completion hook")
;; (add-hook 'shell-dynamic-complete-functions
;;           'bash-completion-dynamic-complete)
;; (add-hook 'shell-command-complete-functions
;;           'bash-completion-dynamic-complete)

;;; Undo-tree
;; Represent undo-history as an actual tree (visualize with C-x u)
(setq undo-tree-mode-lighter "")
(require 'undo-tree)
(global-undo-tree-mode)
(global-set-key (kbd "C-x u") 'undo-tree-visualize)
;;; Markdown-mode
(autoload 'markdown-mode "markdown-mode.el"
  "Major mode for editing Markdown files" t)
(setq auto-mode-alist (cons '("\\.text" . markdown-mode) auto-mode-alist))
(setq auto-mode-alist (cons '("\\.md" . markdown-mode) auto-mode-alist))
;;; Fill-column-indicator
(require 'fill-column-indicator)
(require 'fci-osx-23-fix)
(setq fci-rule-width 1)
(setq fci-rule-color "#111122")

;;; Erc
;; (global-set-key (kbd "C-z erc") (lambda () (interactive)
;;                            (erc :server "irc.freenode.net" :port "6667"
;;                                 :nick "loochao")))

(setq erc-autojoin-channels-alist '(("freenode.net" "#emacs" "#erc")))
(setq erc-interpret-mirc-color t)

;; Kill buffers for channels after /part
(setq erc-kill-buffer-on-part t)
;; Kill buffers for private queries after quitting the server
(setq erc-kill-queries-on-quit t)
;; Kill buffers for server messages after quitting the server
(setq erc-kill-server-buffer-on-quit t)

;;; Weibo
(require 'weibo)
;;; Twittering mode
(require 'twittering-mode)

;; Need support of gnupg, to prevent inputting passwd every time.
(setq twittering-use-master-password t)

;; Some site like sina doesn't like SSL.
(setq twittering-allow-insecure-server-cert t)
(setq twittering-oauth-use-ssl nil)
(setq twittering-use-ssl nil)

;; Display unread tweets and icon.
(twittering-enable-unread-status-notifier)
(setq-default twittering-icon-mode t)

;; Timeline open by default
(setq twittering-initial-timeline-spec-string
      `(":home@sina"
        ;":home@douban"
        ;":home@twitter"
       ))

(set-face-background twittering-zebra-1-face "gray24")
(set-face-background twittering-zebra-2-face "gray22")

;; FIXME

(define-key global-map (kbd "M-8 p")
  'twittering-update-status-interactive)
(define-key global-map (kbd "M-8 M-8")
  'lch-twittering-update-status-interactive)
(define-key global-map (kbd "M-9")
  'lch-twittering-update-status-interactive)
(define-key global-map (kbd "M-8 r")
  'twittering-retweet)

(defun lch-twittering-update-status-interactive ()
  (interactive)
  (let ((spec (twittering-current-timeline-spec)))
    (save-excursion
    (funcall twittering-update-status-function
             nil nil nil spec))))

;;; Textmate
;; Works only for mac.
(when lch-mac-p
  (require 'textmate)
  (textmate-mode))


;;; Viper
;(setq viper-custom-file-name (convert-standard-filename "~/.emacs.d/.viper"))

;;; Windmove
;; use shift + arrow keys to switch between visible buffers
(require 'windmove)
(windmove-default-keybindings 'super)

;;; Saveplace
;; Save point position between sessions
(require 'saveplace)
(setq save-place-file (concat emacs-var-dir "/saveplace"))
;; activate it for all buffers
(setq-default save-place t)


;;; Icicles
;; (require 'icicles)
;; (icy-mode 1)

;;; Gse-number-rect
;; Insert self-incremental number prefix to a rect region.
(require 'gse-number-rect)
(global-set-key "\C-xru" 'gse-number-rectangle)

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
(set-default 'ispell-skip-html t)
(setq ispell-local-dictionary "english")
(setq ispell-extra-args '("--sug-mode=ultra"))
;; (autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker." t)

(defun lch-turn-on-flyspell ()
  "Force flyspell-mode on using a positive argument.  For use in hooks."
  (interactive)
  (flyspell-mode +1))

;; (add-hook 'message-mode-hook 'lch-turn-on-flyspell)
;; (add-hook 'text-mode-hook 'lch-turn-on-flyspell)
;; (add-hook 'nxml-mode-hook 'lch-turn-on-flyspell)
;; (add-hook 'texinfo-mode-hook 'lch-turn-on-flyspell)
;; (add-hook 'TeX-mode-hook 'lch-turn-on-flyspell)

;; (add-hook 'c-mode-common-hook 'flyspell-prog-mode)
;; (add-hook 'lisp-mode-hook 'flyspell-prog-mode)
;; (add-hook 'emacs-lisp-mode-hook 'flyspell-prog-mode)

;; Omit tex keywords
(add-hook 'tex-mode-hook (function (lambda () (setq ispell-parser 'tex))))

;; Personal dict and save personal dict w/o enquiry.
;; (setq ispell-personal-dictionary (concat emacs-var-dir "/personal-dictionary"))
;; (setq ispell-silently-savep t)

;;; BM
(setq bm-restore-repository-on-load t)
(setq bm-repository-file (concat emacs-var-dir "/.bm-repository"))
(setq bm-repository-size nil)      ;; nil == unlimited
(require 'bm)

(set-face-attribute 'bm-persistent-face nil :background "SlateBlue")
;(setq bm-highlight-style 'bm-highlight-line-and-fringe)

(global-set-key (kbd "<f5> <f5>") 'bm-toggle)
(global-set-key (kbd "<f5> <f6>") 'bm-next)
(global-set-key (kbd "<f5> <f4>") 'bm-previous)
(global-set-key (kbd "M-<f5>") 'bm-previous)
(global-set-key (kbd "C-<f5>") 'bm-next)
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

(add-hook 'after-save-hook 'bm-buffer-save)
(add-hook 'after-revert-hook 'bm-buffer-restore)
(setq bm-wrap-search t)
(setq bm-wrap-immediately nil)

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


;;; Calfw
(require 'calfw)
(require 'calfw-org)


;;; Magit
(require 'magit)
(define-key global-map (kbd "<f1> g") 'magit-status)

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
;; Save a list of recent files visited.
(require 'recentf)

;; toggle `recentf' mode
(recentf-mode 1)

;; file to save the recent list into
(setq recentf-save-file (concat emacs-var-dir "/emacs.recentf")
      recentf-max-saved-items 200
      recentf-max-menu-items 30
      recentf-exclude '("/tmp/" "/ssh:"))

(defun lch-recentf-ido-find-file ()
  "Find a recent file using ido."
  (interactive)
  (let ((file (ido-completing-read "Choose recent file: " recentf-list nil t)))
    (when file
      (find-file file))))

;; Key bindings
(define-key global-map (kbd "C-x C-r") 'recentf-open-files)
(define-key global-map (kbd "C-c r") 'lch-recentf-ido-find-file)

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
;; (setq auto-mode-alist (cons '("\\.py$" . python-mode) auto-mode-alist))
;; (setq interpreter-mode-alist (cons '("python" . python-mode)
;;                                       interpreter-mode-alist))
;; (autoload 'python-mode "python-mode" "Python editing mode." t)


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



;;; Package
;; (when (require 'package)
;;   (setq package-archives '(("ELPA" . "http://tromey.com/elpa/")
;; 			   ("gnu" . "http://elpa.gnu.org/packages/")
;; 			   ("marmalade" . "http://marmalade-repo.org/packages/"))))
;; (package-initialize)

;>~~~~~~~~~~ Lisp conf ~~~~~~~~~~<;
(require 'highlight-beyond-fill-column)
(setq highlight-beyond-fill-column-in-modes
      '("emacs-lisp-mode"))


;;; Less
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


;;; Uniquify
;; Make filename unique
(require 'uniquify)
(setq uniquify-buffer-name-style 'post-forward
      uniquify-separator ":")
(setq uniquify-buffer-name-style 'forward)
(setq uniquify-after-kill-buffer-p t)    ; rename after killing uniquified
(setq uniquify-ignore-buffers-re "^\\*") ; don't muck with special buffers

;;; iBuffer
;; ibuffer shows a buffer list that allows to perform almost any
;; imaginable operation on the opened buffers.
(when (require 'ibuffer)
    ;; completely replaces `list-buffer'
    (defalias 'ibuffer-list-buffers 'list-buffer)

    (setq ibuffer-shrink-to-minimum-size t)
    (setq ibuffer-always-show-last-buffer nil)
    (setq ibuffer-sorting-mode 'recency)
    (setq ibuffer-use-header-line t)

    (define-key global-map (kbd "C-x C-b") 'ibuffer)
    )


;;; iDo
(ido-mode t)
(setq ido-enable-prefix nil
      ido-enable-flex-matching t
      ido-create-new-buffer 'always
      ido-use-filename-at-point 'guess
      ido-max-prospects 10
      ido-default-file-method 'selected-window)

(add-to-list 'ido-ignore-directories "target")
(add-to-list 'ido-ignore-directories "node_modules")

;; Use ido everywhere -- seems to be slow.
;; (require 'ido-ubiquitous)
;; (ido-ubiquitous)

(setq ido-save-directory-list-file (concat emacs-var-dir "/emacs-ido-last"))
(define-key global-map (kbd "C-x b") 'ido-switch-buffer)

;(setq ido-show-dot-for-dired t)
;(setq ido-enable-tramp-completion nil)

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




;;; Auto-Complete
(require 'auto-complete)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories emacs-site-lisp)
(ac-config-default)
(setq ac-comphist-file  (concat emacs-var-dir "/ac-comphist.dat"))

(global-auto-complete-mode t)           ;enable global-mode
(setq ac-auto-start t)                  ;automatically start
(setq ac-dwim t)                        ;Do what i mean
(setq ac-override-local-map nil)        ;don't override local map

;; Use Company Backends for Auto-Complete.
;; (require 'ac-company)
;; (ac-company-define-source ac-source-company-elisp company-elisp)
;; (add-hook 'emacs-lisp-mode-hook
;;        (lambda ()
;;          (add-to-list 'ac-sources 'ac-source-company-elisp)))


;;; Vimpulse
;(require 'vimpulse)


;;; Cygwin
;(require 'setup-cygwin)


;;; Cedet
;(require 'cedet)
;(semantic-mode 1)


;;; Sunrise Commander
(require 'sunrise-commander)
(add-to-list 'auto-mode-alist '("\\.srvm\\'" . sr-virtual-mode))
(define-key global-map (kbd "C-M-e") 'sunrise)
(require 'sunrise-x-buttons)
(require 'sunrise-x-loop)
(require 'sunrise-x-mirror)
(require 'sunrise-x-modeline)
(require 'sunrise-x-tabs)
(require 'sunrise-x-tree)



;;;  Highlight-tail
;; (require 'highlight-tail)
;; (message "Highlight-tail loaded - now your Emacs will be even more sexy!")
;; (highlight-tail-mode)


;;; Bat-mode
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



;;; Matlab
(autoload 'matlab-mode "matlab" "Enter MATLAB mode." t)
(setq auto-mode-alist (cons '("\\.m\\'" . matlab-mode) auto-mode-alist))
(autoload 'matlab-shell "matlab" "Interactive MATLAB mode." t)

;;;---- Session ----
;! Save a list of open files in ~/.emacs.d/session.
(require 'session)
(add-hook 'after-init-hook 'session-initialize)


;;; Whitespace-mode
;; Make whitespace-mode with very basic background coloring for whitespaces
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


;;; Highlight Symbol
;; Highlight occurrence of current word, and move cursor to next/prev occurrence
;; see http://xahlee.org/emacs/modernization_isearch.html
(require 'highlight-symbol)
(define-key global-map (kbd "<f9> <f9>") 'highlight-symbol-at-point) ;; This is a toggle
(define-key global-map (kbd "<f9> <f8>") 'highlight-symbol-prev)
(define-key global-map (kbd "<f9> <f10>") 'highlight-symbol-next)
(define-key global-map (kbd "M-<f9>") 'highlight-symbol-prev)
(define-key global-map (kbd "C-<f9>") 'highlight-symbol-next)

;;; Bat Mode
;; For editing Windows's cmd.exe's script; batch, ".bat" file mode.
(autoload 'dos-mode "dos" "A mode for editing Windows cmd.exe batch scripts." t)
(add-to-list 'auto-mode-alist '("\\.bat\\'" . dos-mode))
(add-to-list 'auto-mode-alist '("\\.cmd\\'" . dos-mode))


;;; AutoHotKey Mode
;; a keyboard macro for Windows
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
;; Make emacs open all files in last emacs session.
;; Desktop is already part of Emacs.
;; This functionality is provided by desktop-save-mode ("feature"
;; name: "desktop"). The mode is not on by default in emacs 23, and
;; has a lot options.

;; By default, it read .emacs.desktop.lock file from the
;; dir where Emacs starts from, so when evoke Emacs from
;; FVWM by C-W-2, it reads the file from ~/.

;; Goal: have emacs always auto open the set of opend files in last
;; session, even if emacs crashed in last session or the OS crashed in
;; last session. Also, don't bother users by asking questions like "do
;; you want to save desktop?" or "do you want to override last session
;; file?", because these are annoying and terms like "session" or
;; "desktop" are confusing to most users because it can have many
;; meanings.

;; Some tech detail: set the desktop session file at
;; user-emacs-directory (default is "~/.emacs.d/.emacs.desktop").  This file
;; is our desktop file. It will be auto created and or over-written.
;; if a emacs expert has other desktop session files elsewhere, he can
;; still use or manage those.

;; Save the desktop file automatically if it already exists.
;; Use M-x desktop-save once to save the desktop, eachtime you exit Emacs
;; Or just set (desktop-save-mode 1), so Emacs will save desktop automatically.

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
(message "~~ lch-elisp: done.")

;;; Local Vars.
;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
