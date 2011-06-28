;-*- coding:utf-8 -*-

;>======== UTIL.EL ========<;

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

;; Compute the length of the marked region
(defun region-length ()
  "length of a region"
  (interactive)
  (message (format "%d" (- (region-end) (region-beginning)))))

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


;; Show ascii table
(defun ascii-table ()
  "Print the ascii table. Based on a defun by Alex Schroeder <asc@bsiag.com>"
  (interactive)
  (switch-to-buffer "*ASCII*")
  (erase-buffer)
  (insert (format "ASCII characters up to number %d.\n" 254))
  (let ((i 0))
    (while (< i 254)
      (setq i (+ i 1))
      (insert (format "%4d %c\n" i i))))
  (goto-char (point-min)))

(defun indent-whole-buffer ()
  (interactive)
  (save-excursion
    (mark-whole-buffer)
    (indent-for-tab-command)))
(define-key global-map (kbd "C-c i") 'indent-whole-buffer)

;; insert a time stamp string
(defun lch-insert-time-stamp ()
  "Insert a time stamp."
  (interactive "*")
  (insert (format "%s %s %s %s"
                  comment-start
                  (format-time-string "%Y-%m-%d")
                  (user-login-name)
                  comment-end)))

(defun lch-insert-date (prefix)
  "Insert the current date in ISO format. With prefix-argument,
add day of week. With two prefix arguments, add day of week and
time."
  (interactive "P")
  (let ((format (cond ((not prefix) "%Y-%m-%d")
                      ((equal prefix '(4)) "%Y-%m-%d %a")
                      ((equal prefix '(16)) "%Y-%m-%d %a %H:%M"))))
    (insert (format-time-string format))))

(defun dos2unix ()
  "Cut all visible ^M from the current buffer."
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "\r" nil t)
      (replace-match ""))))

;; convert a buffer from Unix end of lines to DOS `^M' end of lines
(defun unix2dos ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "\n" nil t)
      (replace-match "\r\n"))))

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


(defun shuffle-vector (vector)
  "Destructively shuffle the contents of VECTOR and return it."
  (loop
   for pos from (1- (length vector)) downto 1
   for swap = (random (1+ pos))
   unless (= pos swap)
   do (rotatef (aref vector pos)
               (aref vector swap)))
  vector)

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



;>-- Jump to matched paren --<;
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

;>-- Split Windows --<;
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

;>-- Transpose(Interchange) Two Windows --<;
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

;>-- Kill current buffer without confirmation --<;
(define-key global-map (kbd "C-x C-k") 'kill-current-buffer)

(defun kill-current-buffer ()
  "Kill the current buffer, without confirmation."
  (interactive)
  (kill-buffer (current-buffer)))

;>---- Switch or create *scratch ----<;
(defun ywb-create/switch-scratch ()
  (interactive)
  (let ((buf (get-buffer "*scratch*")))
    (switch-to-buffer (get-buffer-create "*scratch*"))
    (when (null buf)
      (lisp-interaction-mode))))
(define-key global-map (kbd "<f1> s") 'ywb-create/switch-scratch)
(define-key global-map (kbd "C-c s") 'ywb-create/switch-scratch)

;>-- In Windows, Alt+F4 closes the frame --<;
;>-(or kill emacs if it is the last frame)
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

;>-- Increase/decrease font size --<;
(defun text-scale-normal-size ()
  "Set the height of the default face in the current buffer to its default value."
  (interactive)
  (text-scale-increase 0))

(define-key global-map (kbd "C-0") 'text-scale-normal-size)
(define-key global-map [C-down-mouse-2] 'text-scale-normal-size)
(define-key global-map (kbd "C-=") 'text-scale-increase)
(define-key global-map (kbd "C--") 'text-scale-decrease)


;>---- Go-to-char ----<;
;> C-c a x goto x, then press x to go to next 'x'
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
(define-key global-map (kbd "C-c a") 'my-wy-go-to-char)

;>-- Kills live buffers, leaves some emacs work buffers --<;
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

(defun my-find-thing-at-point ()
  "Find variable, function or file at point."
  (interactive)
  (cond ((not (eq (variable-at-point) 0))
         (call-interactively 'describe-variable))
        ((function-called-at-point)
         (call-interactively 'describe-function))
        (t (find-file-at-point))))

(define-key global-map (kbd "<f1> C-f") 'my-find-thing-at-point)

(defun lookup-word-definition ()
  "Look up the current word's definition in a browser.
If a region is active (a phrase), lookup that phrase."
 (interactive)
 (let (myword myurl)
   (setq myword
         (if (and transient-mark-mode mark-active)
             (buffer-substring-no-properties (region-beginning) (region-end))
           (thing-at-point 'symbol)))

  (setq myword (replace-regexp-in-string " " "%20" myword))
  (setq myurl (concat "http://www.answers.com/main/ntquery?s=" myword))

  (browse-url myurl)
  ;; (w3m-browse-url myurl) ;; if you want to browse using w3m
   ))

(define-key global-map (kbd "<f1> C-a") 'lookup-word-definition)

(defun lookup-wikipedia ()
  "Look up the word under cursor in Wikipedia.
This command generates a url for Wikipedia.com and switches you
to browser. If a region is active (a phrase), lookup that phrase."
 (interactive)
 (let (myword myurl)
   (setq myword
         (if (and transient-mark-mode mark-active)
             (buffer-substring-no-properties (region-beginning) (region-end))
           (thing-at-point 'symbol)))
  (setq myword (replace-regexp-in-string " " "_" myword))
  (setq myurl (concat "http://en.wikipedia.org/wiki/" myword))
  (browse-url myurl)
   ))

(define-key global-map (kbd "<f1> <f2>") 'lookup-wikipedia)

(defun lookup-google ()
  "Look up the word under cursor in Wikipedia.
This command generates a url for Wikipedia.com and switches you
to browser. If a region is active (a phrase), lookup that phrase."
 (interactive)
 (let (myword myurl)
   (setq myword
         (if (and transient-mark-mode mark-active)
             (buffer-substring-no-properties (region-beginning) (region-end))
           (thing-at-point 'symbol)))

  (setq myword (replace-regexp-in-string " " "_" myword))
  (setq myurl (concat "http://www.google.com/search?q=" myword))
  (browse-url myurl)
   ))
(define-key global-map (kbd "<f1> <f1>") 'lookup-google)

;>---- Inserts the user name ----<;
(defun insert-userid ()
  "Insert the my full name and address"
  (interactive)
        (insert user-full-name))

;>---- Process ----<;
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

;>---- Switch Mode ----<;
;>~~ The mode selected last time is remembered.
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

;>---- Inserts Date ----<;
(defun insert-date()
"Insert a time-stamp according to locale's date and time format."
(interactive)
(insert (format-time-string "%y.%m.%d %H:%M" (current-time))))

(define-key global-map (kbd "<f1> T") 'insert-date)

;>---- New Empty Buffer ----<;
(defun new-empty-buffer ()
  "Opens a new empty buffer."
  (interactive)
  (let ((buf (generate-new-buffer "INBOX")))
    (switch-to-buffer buf)
    (funcall (and initial-major-mode))
    (setq buffer-offer-save t)))

;>---- M$CMD Shell ----<;
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

;>---- MSYS Shell ----<;
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

;>---- Locate Current File ----<;
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

(provide 'lch-util)
