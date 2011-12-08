;-*- coding:utf-8 -*-

;>======== UTIL.EL ========<;
;;; Underline prev line.
(defun gse-underline-previous-line ()
  "Underline the previous line with dashes."
  (interactive)
  (let ((start-pos (point))
        (start-col nil)
        (end-col nil))
    (beginning-of-line 0)
    (if (re-search-forward "[^ ]" (save-excursion (end-of-line) (point)) t)
        (progn
          (setq start-col (- (current-column) 1))

          (end-of-line)
          (re-search-backward "[^ ]" nil t)
          (setq end-col (current-column))

          ;; go to next line and insert dashes
          (beginning-of-line 2)
          (insert
           (make-string start-col ?\ )
           (make-string (+ 1 (- end-col start-col)) ?-)
           "\n")
          )
      (goto-char start-pos)
      (error "No text on previous line"))
    ))

(global-set-key (kbd "C-c -") 'gse-underline-previous-line)
(global-set-key (kbd "C-c _") 'gse-underline-previous-line)



;;; Special words
(defvar keywords-critical-pattern
      "\\(BUGS\\|FIXME\\|todo\\|XXX\\|[Ee][Rr][Rr][Oo][Rr]\\|[Mm][Ii][Ss][Ss][Ii][Nn][Gg]\\|[Ii][Nn][Vv][Aa][Ll][Ii][Dd]\\|[Ff][Aa][Ii][Ll][Ee][Dd]\\|[Cc][Oo][Rr][Rr][Uu][Pp][Tt][Ee][Dd]\\)")
(make-face 'keywords-critical)
(set-face-attribute 'keywords-critical nil
                    :foreground "Black" :background "Cyan"
                    :weight 'bold)

;; smaller subset of keywords for ensuring no conflict with Org mode TODO keywords
;; \\|[^*] TODO
(defvar keywords-org-critical-pattern
      "\\(BUGS\\|FIXME\\|XXX\\|[Ee][Rr][Rr][Oo][Rr]\\|[Mm][Ii][Ss][Ss][Ii][Nn][Gg]\\|[Ii][Nn][Vv][Aa][Ll][Ii][Dd]\\|[Ff][Aa][Ii][Ll][Ee][Dd]\\|[Cc][Oo][Rr][Rr][Uu][Pp][Tt][Ee][Dd]\\)")


;; FIXME Highlighting all special keywords but "TODO" in Org mode is already a
;; good step. Though, a nicer integration would be that "TODO" strings in the
;; headings are not touched by this code, and that only "TODO" strings in the
;; text body would be. Don't know (yet) how to do that...
(make-face 'keywords-org-critical)
(set-face-attribute 'keywords-org-critical nil
                    :foreground "Black" :background "Cyan"
                    :weight 'bold)

(setq keywords-normal-pattern "\\([Ww][Aa][Rr][Nn][Ii][Nn][Gg]\\)")
(make-face 'keywords-normal)
(set-face-attribute 'keywords-normal nil
                    :foreground "Black" :background "Magenta2")

;; Set up highlighting of special words for proper selected major modes only
;; No interference with Org mode (which derives from text-mode)
(dolist (mode '(fundamental-mode
                svn-log-view-mode
                text-mode))
  (font-lock-add-keywords mode
                          `((,keywords-critical-pattern 1 'keywords-critical prepend)
                            (,keywords-normal-pattern 1 'keywords-normal prepend))))

;; Set up highlighting of special words for Org mode only
(dolist (mode '(org-mode))
  (font-lock-add-keywords mode
                          `((,keywords-org-critical-pattern 1 'keywords-org-critical prepend)
                            (,keywords-normal-pattern 1 'keywords-normal prepend))))

;; Add fontification patterns (even in comments) to a selected major mode
;; *and* all major modes derived from it
(defun fontify-keywords ()
  (interactive)
;;   (font-lock-mode -1)
;;   (font-lock-mode 1)
  (font-lock-add-keywords nil
                          `((,keywords-critical-pattern 1 'keywords-critical prepend)
                            (,keywords-normal-pattern 1 'keywords-normal prepend))))
;; FIXME                        0                  t

;; Set up highlighting of special words for selected major modes *and* all
;; major modes derived from them
(dolist (hook '(c++-mode-hook
                c-mode-hook
                change-log-mode-hook
                cperl-mode-hook
                css-mode-hook
                emacs-lisp-mode-hook
                html-mode-hook
                java-mode-hook
                latex-mode-hook
                lisp-mode-hook
                makefile-mode-hook
                message-mode-hook
                php-mode-hook
                python-mode-hook
                sh-mode-hook
                shell-mode-hook
                ssh-config-mode-hook))
  (add-hook hook 'fontify-keywords))


;;; Repeat last command passed to `shell-command'
(defun repeat-shell-command ()
  "Repeat most recently executed shell command."
  (interactive)
  (save-buffer)
  (or shell-command-history (error "Nothing to repeat."))
  (shell-command (car shell-command-history)))

(global-set-key (kbd "C-c j") 'repeat-shell-command)


;;; Shift a line up or down
(defun move-line (n)
  "Move the current line up or down by N lines."
  (interactive "p")
  (let ((col (current-column))
        start
        end)
    (beginning-of-line)
    (setq start (point))
    (end-of-line)
    (forward-char)
    (setq end (point))
    (let ((line-text (delete-and-extract-region start end)))
      (forward-line n)
      (insert line-text)
      ;; restore point to original column in moved line
      (forward-line -1)
      (forward-char col))))

(defun move-line-up (n)
  "Move the current line up by N lines."
  (interactive "p")
  (move-line (if (null n) -1 (- n))))

(defun move-line-down (n)
  "Move the current line down by N lines."
  (interactive "p")
  (move-line (if (null n) 1 n)))

(global-set-key (kbd "<C-M-up>") 'move-line-up)
(global-set-key (kbd "<C-M-down>") 'move-line-down)


;;; Digital-clock
(defun my-digital-clock (&optional arg)
  "Show digital clock in the separate Emacs frame.
Show digital clock in the same Emacs frame if called with C-0.
Cancel the clock if called with C-u."
  (interactive "P")
  (and (boundp 'my-digital-clock-timer) (timerp my-digital-clock-timer)
       (cancel-timer my-digital-clock-timer))
  (and (boundp 'my-digital-clock-frame) (framep my-digital-clock-frame)
       (delete-frame my-digital-clock-frame))
  (if (or (not arg) (numberp arg))
      (setq my-digital-clock-timer
            (run-at-time
             t 1
             (lambda ()
               (message "%s"
                        ;; (round (float-time)) ; e.g. 1234567890
                        (format-time-string "%Y-%m-%d %H:%M:%S" (current-time))
                        )))))
  (or arg
      (setq my-digital-clock-frame
            (make-frame
             `((top . 478) (left . 80) (width . 24) (height . 1)
               (name . "TIME")
               (minibuffer . only)
               (buffer-predicate . nil)
               (user-position . t)
               (vertical-scroll-bars . nil)
               (scrollbar-width . 0)
               (menu-bar-lines . 0)
               (foreground-color . "green")
               (background-color . "black")
               ,(cond
                 ((eq window-system 'x)
                  '(font . "-*-Fixed-Medium-R-*--64-*-*-*-C-*-*-*")))
               (cursor-color . "gray2")
               (cursor-type . bar)
               (auto-lower . nil)
               (auto-raise . t)
               (border-width . 0)
               (internal-border-width . 0))))))


(defun lch-insert-date (&optional prefix)
  "Insert the current date in ISO format. With prefix-argument (press C-u once),
add day of week. With two prefix arguments (C-u twice), add day of week and
time."
  (interactive "P")
  (let ((format (cond ((not prefix) "%Y/%m/%d")
                      ((equal prefix '(4)) "%Y-%m-%d %a")
                      ((equal prefix '(16)) "%Y-%m-%d %a %H:%M"))))
    (insert (format-time-string format (current-time)))))
(define-key global-map (kbd "C-c d") 'lch-insert-date)

;;; lch-search
(defun lch-search ()
  (interactive)
  (split-window)
  (other-window 1)
  (switch-to-buffer "*Search*"))


;; ;; Automatically change buffer name of shell into current directory name.
;; (make-variable-buffer-local 'wcy-shell-mode-directory-changed)
;; (setq wcy-shell-mode-directory-changed t)

;; (defun wcy-shell-mode-auto-rename-buffer-output-filter (text)
;;   (if (and (eq major-mode 'shell-mode)
;;            wcy-shell-mode-directory-changed)
;;       (progn
;;         (let ((bn  (concat "sh:" default-directory)))
;;           (if (not (string= (buffer-name) bn))
;;               (rename-buffer bn t)))
;;         (setq wcy-shell-mode-directory-changed nil))))

;; (defun wcy-shell-mode-auto-rename-buffer-input-filter (text)
;;   (if (eq major-mode 'shell-mode)
;;       (if ( string-match "^[ \t]*cd *" text)
;;           (setq wcy-shell-mode-directory-changed t))))
;; (add-hook 'comint-output-filter-functions 'wcy-shell-mode-auto-rename-buffer-output-filter)
;; (add-hook 'comint-input-filter-functions 'wcy-shell-mode-auto-rename-buffer-input-filter )


;;; Automatically add execute permission to a script file.
(defun lch-chmod-x ()
   (and (save-excursion
          (save-restriction
            (widen)
            (goto-char (point-min))
            (save-match-data
              (looking-at "^#!"))))
        (not (file-executable-p buffer-file-name))
        (if (= 0 (shell-command (concat "chmod u+x " buffer-file-name)))
            (message
             (concat "Saved as script: " buffer-file-name)))))

(add-hook 'after-save-hook 'lch-chmod-x)

;;; Start file browser
(defun lch-start-file-browser ()
  "Open current pwd with file browser.
   Currently, just work under Mac OSX."
  (interactive)
  (let (mydir)
  (setq mydir (pwd))
  (string-match "Directory " mydir)
  (setq mydir (replace-match "" nil nil mydir 0))
  (when lch-mac-p (shell-command (format "open -a Finder %s" mydir)))
  ))
(define-key global-map (kbd "<f4> <f4>") 'lch-start-file-browser)


;;; Start terminal
(defun lch-start-terminal ()
  "Open current pwd with terminal.
   Currently, just work under Mac OSX."
  (interactive)
  (let (mydir)
  (setq mydir (pwd))
  (string-match "Directory " mydir)
  (setq mydir (replace-match "" nil nil mydir 0))
  (when lch-mac-p
    (do-applescript
     (format
      "tell application \"Terminal\"
activate
do script \"cd '%s'; bash \"
end tell" mydir)))
  ))
(define-key global-map (kbd "<f1> <f2>") 'lch-start-terminal)


;;; Punctuation substitution
(defun lch-punctuate-buffer ()
  "Substitute Chinese punctuation to English ones"
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "。" nil t)
      (replace-match ". " nil t))
    (goto-char (point-min))
    (while (search-forward "，" nil t)
      (replace-match ", " nil t))
    (goto-char (point-min))
    (while (search-forward "“" nil t)
      (replace-match "\"" nil t))
    (goto-char (point-min))
    (while (search-forward "”" nil t)
      (replace-match "\"" nil t))
    ))


;;; Delete trailing spaces
;; It is better to go to the next line here because this way we can
;; call this with a numeric argument.
(defun delete-trailing-spaces (arg)
  "Remove all the tabs and spaces at the end of lines."
  (interactive "p")
   (while (> arg 0)
     (end-of-line nil)
     (delete-horizontal-space)
     (forward-line 1)
     (decf arg 1)))

;; Remove all the tabs and spaces at the end of the lines.
(defun buffer-delete-trailing-spaces ()
  "Remove all the tabs and spaces at the end of all the lines in the buffer."
  (interactive)
  (message "Deleting trailing spaces...")
  (save-excursion
    (goto-char (point-min))
    (while (not (eobp))
      (delete-trailing-spaces 1)))
  (message "Deleting trailing spaces... done"))


;;; Buffer beautify
(defun buffer-untabify ()
  "Convert all tabs in buffer with multiple spaces, preserving columns."
  (interactive)
  (message "Untabifying buffer...")
  (untabify (point-min) (point-max))
  (message "Untabifying buffer... done"))

(defun buffer-beautify ()
  "Calls both buffer-delete-trailing-spaces and buffer-smart-tabify."
  (interactive)
  (message "Cleaning up buffer...")
  (buffer-delete-trailing-spaces)
  (buffer-smart-tabify)
  (message "Cleaning up buffer... done"))

;;; Compute the length of the marked region
(defun region-length ()
  "length of a region"
  (interactive)
  (message (format "%d" (- (region-end) (region-beginning)))))

;;; Words count
(defun count-words (start end)
  "Print number of words in the region."
  (interactive "r")
  (save-excursion
    (let ((n 0))
      (goto-char start)
      (while (< (point) end)
        (when (forward-word 1)
          (setq n (1+ n))))
      (message "Region has %d words" n)
      n)))


;;; Show ascii table
(defun lch-ascii-table ()
  (interactive)
  (switch-to-buffer "*ascii*")
  (setq buffer-read-only nil)
  (local-set-key "q" 'bury-buffer)
  (erase-buffer)
  (save-excursion
    (let ((i -1))
    (insert "                   ASCII chars from 0 to 127 \n")
    (insert "----------------------------------------------------------------- \n")
    (insert " HEX  DEC CHAR |  HEX  DEC CHAR |  HEX  DEC CHAR |  HEX  DEC CHAR\n")
    (while (< i 31)
      (insert (format "%4x %4d %4s | %4x %4d %4s | %4x %4d %4s | %4x %4d %4s\n"
                      (setq i (+ 1 i)) i (single-key-description i)
                      (setq i (+ 32 i)) i (single-key-description i)
                      (setq i (+ 32 i)) i (single-key-description i)
                      (setq i (+ 32 i)) i (single-key-description i)))
      (setq i (- i 96))
      ))))


;;; Indent whole buffer
(defun indent-whole-buffer ()
  (interactive)
  (save-excursion
    (mark-whole-buffer)
    (indent-for-tab-command)))
(define-key global-map (kbd "C-c i") 'indent-whole-buffer)

;;; insert a time stamp string
(defun lch-insert-time-stamp ()
  "Insert a time stamp."
  (interactive "*")
  (insert (format "%s %s %s %s"
                  comment-start
                  (format-time-string "%Y-%m-%d")
                  (user-login-name)
                  comment-end)))


;;; dos<->unix
(defun dos2unix ()
  "Cut all visible ^M from the current buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "\r" nil t)
      (replace-match ""))))

;; convert a buffer from Unix end of lines to DOS `^M(\n)' end of lines
(defun unix2dos ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "\n" nil t)
      (replace-match "\r\n"))))


;;; Reverse words/region
(defun reverse-words (start end)
  (interactive "r")
  (let ((words (reverse (split-string (buffer-substring start end)))))
    (delete-region start end)
    (dolist (word words)
      (insert word " "))
    (backward-char 1)
    (delete-char 1)))

(defun reverse-region-by-line (beg end)
  (interactive "r")
  (save-excursion
    (goto-char beg)
    (while (and (< (point) end) (re-search-forward "\\=.*$" end t))
      (replace-match (apply #'string
                            (nreverse (string-to-list (match-string 0)))))
      (forward-line))))

;;; Shuffle vector
(defun shuffle-vector (vector)
  "Destructively shuffle the contents of VECTOR and return it."
  (loop
   for pos from (1- (length vector)) downto 1
   for swap = (random (1+ pos))
   unless (= pos swap)
   do (rotatef (aref vector pos)
               (aref vector swap)))
  vector)

;;; Randomize region
(defun randomize-region (start end)
  "Randomly re-order the lines in the region."
  (interactive "r")
  (save-excursion
    (save-restriction
      ;; narrow to the region
      (narrow-to-region start end)
      (goto-char (point-min))
      (let* ((nlines (line-number-at-pos end))
             (lines (make-vector nlines nil)))
        ;;
        (while (not (eobp))
          (setf (aref lines (decf nlines)) ; if it's random backwards
                (delete-and-extract-region (point)
                                           (progn (forward-visible-line 1)
                                                  (point)))))
        ;;
        (let ((rlines (shuffle-vector lines)))
          (dotimes (linenum (length rlines))
            (insert (aref rlines linenum))))))))



;;; Jump to matched paren
;;;###autoload
(defun his-match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (let ((prev-char (char-to-string (preceding-char)))
        (next-char (char-to-string (following-char))))
    (cond ((string-match "[[{(<]" next-char) (forward-sexp 1))
          ((string-match "[\]})>]" prev-char) (backward-sexp 1))
          (t (self-insert-command (or arg 1))))))
(define-key global-map "%" 'his-match-paren)


;;; Split Windows
;;;###autoload
(defun ywb-favorite-window-config (&optional percent)
  "Split window to proper portion"
  (interactive "P")
  (or percent (setq percent 50))
  (setq percent (/ percent 100.0))
  (let (buf)
    (if (> (length (window-list)) 1)
        (setq buf (window-buffer (next-window))))
    (delete-other-windows)
    (let ((maxwidth (window-width)))
      (split-window-horizontally (round (* maxwidth percent))))
    (if buf (save-selected-window
              (pop-to-buffer buf))))
  (call-interactively 'his-transpose-windows))
(define-key global-map (kbd "<f1> w") 'ywb-favorite-window-config)
(define-key global-map (kbd "C-c w") 'ywb-favorite-window-config)


;;; Transpose(Interchange) Two Windows
;;;###autoload
(defun his-transpose-windows (arg)
  "Transpose the buffers shown in two windows."
  (interactive "p")
  (let ((selector (if (>= arg 0) 'next-window 'previous-window)))
    (while (/= arg 0)
      (let ((this-win (window-buffer))
            (next-win (window-buffer (funcall selector))))
        (set-window-buffer (selected-window) next-win)
        (set-window-buffer (funcall selector) this-win)
        (select-window (funcall selector)))
      (setq arg (if (plusp arg) (1- arg) (1+ arg))))))


;;; Kill current buffer without confirmation
(define-key global-map (kbd "C-x C-k") 'kill-current-buffer)

(defun kill-current-buffer ()
  "Kill the current buffer, without confirmation."
  (interactive)
  (kill-buffer (current-buffer)))


;;; Switch or create *scratch*
(defun ywb-create/switch-scratch ()
  (interactive)
  (let ((buf (get-buffer "*scratch*")))
    (switch-to-buffer (get-buffer-create "*scratch*"))
    (when (null buf)
      (lisp-interaction-mode))))
(define-key global-map (kbd "<f1> s") 'ywb-create/switch-scratch)
(define-key global-map (kbd "C-c s") 'ywb-create/switch-scratch)

;;; Alt+F4 closes the frame (Win32 ONLY)
(defun close-frame ()
  "Closes the current frame or kill emacs if there are just one
frame. It simulates the same functionality of the Close button in
the frame title bar."
  (interactive)
  (if multiple-frames
      (delete-frame)
    (save-buffers-kill-terminal)))

(if (and (boundp 'w32-initialized) w32-initialized)
    (define-key global-map (kbd "M-<f4>") 'close-frame))


;;; Zoom
(defun text-scale-normal-size ()
  "Set the height of the default face in the current buffer to its default value."
  (interactive)
  (text-scale-increase 0))

(define-key global-map (kbd "C-0") 'text-scale-normal-size)
(define-key global-map [C-down-mouse-2] 'text-scale-normal-size)
(define-key global-map (kbd "C-=") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)



;;; Go-to-char
;; C-c a x goto x, then press x to go to next 'x'
(defun my-wy-go-to-char (n char)
  "Move forward to Nth occurence of CHAR.
Typing `wy-go-to-char-key' again will move forwad to the next Nth
occurence of CHAR."
  (interactive "p\ncGo to char: ")
  (search-forward (string char) nil nil n)
  (while (char-equal (read-char)
                     char)
    (search-forward (string char) nil nil n))
  (setq unread-command-events (list last-input-event)))
(define-key global-map (kbd "C-x g") 'my-wy-go-to-char)
;(define-key global-map (kbd "M-g") 'my-wy-go-to-char)

;;; Nuke buffers
(defun nuke-some-buffers (&optional list)
  "For each buffer in LIST, kill it silently if unmodified. Otherwise ask.
LIST defaults to all existing live buffers."
  (interactive)
  (if (null list)
      (setq list (buffer-list)))
  (while list
    (let* ((buffer (car list))
           (name (buffer-name buffer)))
      (and (not (string-equal name ""))
           (not (string-equal name "*Messages*"))
           ;; (not (string-equal name "*Buffer List*"))
           (not (string-equal name "*buffer-selection*"))
           (not (string-equal name "*Shell Command Output*"))
           (not (string-equal name "*scratch*"))
           (/= (aref name 0) ? )
           (if (buffer-modified-p buffer)
               (if (yes-or-no-p
                    (format "Buffer %s has been edited. Kill? " name))
                   (kill-buffer buffer))
             (kill-buffer buffer))))
    (setq list (cdr list))))
(define-key global-map (kbd "<f1> n") 'nuke-some-buffers)
(define-key global-map (kbd "C-c n") 'nuke-some-buffers)

;;; Auto scroll
(defvar my-scroll-auto-timer nil)
(defun my-scroll-auto (arg)
  "Scroll text of current window automatically with a given frequency.
With a numeric prefix ARG, use its value as frequency in seconds.
With C-u, C-0 or M-0, cancel the timer."
  (interactive
   (list (progn
           (if (and (boundp 'my-scroll-auto-timer)
                    (timerp  my-scroll-auto-timer))
               (cancel-timer my-scroll-auto-timer))
           (or current-prefix-arg
               (read-from-minibuffer
                "Enter scroll frequency measured in seconds (0 or RET for cancel): "
                nil nil t nil "0")))))
  (if (not (or (eq arg 0) (equal arg '(4))))
      (setq my-scroll-auto-timer (run-at-time t arg 'scroll-up 1))))

(define-key global-map (kbd "<f1> S") 'my-scroll-auto)


;;; Inserts the user name
(defun insert-userid ()
  "Insert the my full name and address"
  (interactive)
        (insert user-full-name))


;;; Process
(define-key global-map (kbd "<f1> p")
                (lambda () (interactive)
                  (let* ((n "*top*")
                         (b (get-buffer n)))
                    (if b (switch-to-buffer b)
                      (if (eq system-type 'windows-nt)
                         (progn
                           (proced)
                           (proced-toggle-tree 1))
                        (ansi-term "top"))
                      (rename-buffer n)
                      (local-set-key "q" '(lambda () (interactive) (kill-buffer (current-buffer))))
                      (hl-line-mode 1)))))


;;; Switch Mode
;; The mode selected last time is remembered.
(defvar switch-major-mode-last-mode nil)
(make-variable-buffer-local 'switch-major-mode-last-mode)

(defun major-mode-heuristic (symbol)
  (and (fboundp symbol)
       (string-match ".*-mode$" (symbol-name symbol))))

(defun switch-major-mode (mode)
  (interactive
   (let ((fn switch-major-mode-last-mode)
         val)
     (setq val
           (completing-read
            (if fn
                (format "Switch major mode to (default %s): " fn)
              "Switch major mode to: ")
            obarray 'major-mode-heuristic t nil nil (symbol-name fn)))
     (list (intern val))))
  (let ((last-mode major-mode))
    (funcall mode)
    (setq switch-major-mode-last-mode last-mode)))
(define-key global-map (kbd "<f1> C-m") 'switch-major-mode)


;;; Inserts Date
(defun insert-date()
"Insert a time-stamp according to locale's date and time format."
(interactive)
(insert (format-time-string "%y.%m.%d %H:%M" (current-time))))

(define-key global-map (kbd "<f1> T") 'insert-date)


;;; New Empty Buffer
(defun new-empty-buffer ()
  "Opens a new empty buffer."
  (interactive)
  (let ((buf (generate-new-buffer "INBOX")))
    (switch-to-buffer buf)
    (funcall (and initial-major-mode))
    (setq buffer-offer-save t)))


;;; M$CMD Shell
(defun cmd-shell (&optional arg)
  "Run cmd.exe (WinNT) or command.com shell. A numeric prefix
arg switches to the specified session, creating it if necessary."
  (interactive "P")
  (let ((buf-name (cond ((numberp arg)
                         (format "*cmd<%s>*" arg))
                        (arg
                         (generate-new-buffer-name "*cmd*"))
                        (t
                         "*cmd*")))
        (explicit-shell-file-name (or (and (w32-using-nt) "cmd.exe")
                                      "command.com")))
    (shell buf-name)))
(define-key global-map (kbd "C-S-<f1>") 'cmd-shell)


;;; MSYS Shell
(defun msys-shell (&optional arg)
  "Run MSYS shell (sh.exe).  It's like a Unix Shell in Windows.
A numeric prefix arg switches to the specified session, creating
it if necessary."
  (interactive "P")
  (let ((buf-name (cond ((numberp arg)
                         (format "*msys<%d>*" arg))
                        (arg
                         (generate-new-buffer-name "*msys*"))
                        (t
                         "*msys*")))
        (explicit-shell-file-name "sh.exe"))
    (shell buf-name)))
(define-key global-map (kbd "C-M-<f1>") 'msys-shell)


;;; Locate Current File
(defun locate-current-file-in-explorer ()
  (interactive)
  (cond
   ;; In buffers with file name
   ((buffer-file-name)
    (shell-command (concat "start explorer /e,/select,\"" (replace-regexp-in-string "/" "\\\\" (buffer-file-name)) "\"")))
   ;; In dired mode
   ((eq major-mode 'dired-mode)
    (shell-command (concat "start explorer /e,\"" (replace-regexp-in-string "/" "\\\\" (dired-current-directory)) "\"")))
   ;; In eshell mode
;   ((eq major-mode 'eshell-mode)
;    (shell-command (concat "start explorer /e,\"" (replace-regexp-in-string "/" "\\\\" (eshell/pwd)) "\"")))
   ;; Use default-directory as last resource
   (t
    (shell-command (concat "start explorer /e,\"" (replace-regexp-in-string "/" "\\\\" default-directory) "\"")))))

(if lch-win32-p (define-key global-map (kbd "<f4> <f4>") 'locate-current-file-in-explorer))


;;; Buffer tabifying
;; Tabifying is a good thing as long as it is used *ONLY* for
;; indentation.  Otherwise it will affect strings as well, which is a
;; _VERY BAD THING_!

(defun buffer-smart-tabify ()
  "Convert multiple spaces in buffer into tabs, preserving columns."
  (interactive)
  (progn
   (message "Tabifying buffer...")
   (save-excursion
     (goto-char (point-min))
     (let ((percent 0) (old-percent 0) (indent-tabs-mode nil)
           (characters (- (point-max) (point-min))) (line 1)
           b e column)
       (while (not (eobp))
         (goto-line line)
         (beginning-of-line)
         (when (looking-at "[ \t]*")
           (setq b (match-beginning 0)
                 e (match-end 0))
           (unless (eq e b)
             (goto-char e)
             (setq column (current-column))
             (unless (equal (buffer-substring b e) (make-string (- e b) ?\ ))
               (delete-region b e)
               (indent-to column))))
         (setq percent (/ (* 100 (point)) characters))
         (when (> percent old-percent)
           (message "Tabifying buffer... (%d%%)" percent))
         (setq old-percent percent)
         (end-of-line)
         (setq line (1+ line)))))
   (message "Tabifying buffer... done")))

;;; Provide
(message "~~ lch-util: done.")
(provide 'lch-util)

;;; Local Vars.
;; Local Variables:
;; mode: emacs-lisp
;; outline-regexp: ";;;;* "
;; End: