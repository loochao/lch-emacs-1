;-*- coding: utf-8 -*-

;>======== HIGHLIGHT-LINE ========<;

(message "=> lch-hl-line: loading...")
(require 'hl-line+)

(defun hl-line-toggle-when-idle (&optional arg)
  "Turn on or off using `global-hl-line-mode' when Emacs is idle.
When on, use `global-hl-line-mode' whenever Emacs is idle.
With prefix argument, turn on if ARG > 0; else turn off."
  (interactive "P")
  (setq hl-line-when-idle-p
        (if arg (> (prefix-numeric-value arg) 0) (not hl-line-when-idle-p)))
  (cond (hl-line-when-idle-p
         (timer-activate-when-idle hl-line-idle-timer)
         (message "Turned ON using `global-hl-line-mode' when Emacs is idle."))
        (t
         (cancel-timer hl-line-idle-timer)
         (message "Turned OFF using `global-hl-line-mode' when
         Emacs is idle."))))

(defun hl-line-highlight-now ()
  "Turn on `global-hl-line-mode' and highlight current line now."
  (unless global-hl-line-mode
    (global-hl-line-mode 1)
    (global-hl-line-highlight)
    (add-hook 'pre-command-hook 'hl-line-unhighlight-now)
    ))

(defun hl-line-unhighlight-now ()
  "Turn off `global-hl-line-mode' and unhighlight current line now."
  (global-hl-line-mode -1)
  (global-hl-line-unhighlight)
  (remove-hook 'pre-command-hook 'hl-line-unhighlight-now))

(toggle-hl-line-when-idle 1)
(hl-line-when-idle-interval 1)

(provide 'lch-hl-line)
(message "~~ lch-hl-line: done.")