;>======== PROGRAMMING.EL ========<;

;>---- Lisp mode ----<;
(defun xwl-lisp-mode-hook ()
  ;; (which-func-mode 1)
  ;(eldoc-mode 1)

  (set (make-local-variable 'outline-regexp) ";>---- ") ;FIXME
;  (outline-minor-mode 1)
;  (unless (string= "*scratch*" (buffer-name))
;    (outline-minor-mode))
  (local-set-key (kbd "<backtab>") 'lisp-complete-symbol)
  (local-set-key (kbd "<S-tab>") 'lisp-complete-symbol)
  (local-set-key (kbd "C-c C-r") 'eval-region))


(add-hook 'lisp-mode-hook 'xwl-lisp-mode-hook)
(add-hook 'lisp-interaction-mode-hook 'xwl-lisp-mode-hook)
(add-hook 'emacs-lisp-mode-hook 'xwl-lisp-mode-hook)

;>---- Highlight Special Keywords ----<;
;>-- Using Greek Symbol to respresent lambda --<;
(font-lock-add-keywords
 nil ;; 'emacs-lisp-mode
 `(("\\<lambda\\>"
    (0 (progn (compose-region (match-beginning 0) (match-end 0)
                              ,(make-char 'greek-iso8859-7 107))
              nil)))))

;>-- Highlight TODO & FIXME --<;
(make-face 'font-lock-fixme-face)
(make-face 'font-lock-todo-face)
(make-face 'font-lock-lch-face)
(make-face 'font-lock-caution-face)

(modify-face 'font-lock-fixme-face "Black" "Yellow" nil t nil t nil nil)
(modify-face 'font-lock-lch-face "White" "SlateBlue" nil t nil t nil nil)
(modify-face 'font-lock-todo-face  "Black" "Yellow" nil t nil nil nil nil)
(modify-face 'font-lock-caution-face  "White" "DarkRed" nil t nil nil nil nil)

(setq xwl-keyword-highlight-modes
     '(php-mode java-mode c-mode c++-mode emacs-lisp-mode scheme-mode
       text-mode outline-mode))

(defun xwl-highlight-special-keywords ()
 (mapc (lambda (mode)
         (font-lock-add-keywords
          mode
          '(("\\<\\(FIXME\\)" 1 'font-lock-fixme-face t)
;            ("\\<\\(TODO\\)"  1 'font-lock-todo-face  t)
            ("\\<\\(LCH\\)"  1 'font-lock-lch-face  t)
            ("\\<\\(CAUTION\\)"  1 'font-lock-caution-face t)
	    )))
       xwl-keyword-highlight-modes))

(xwl-highlight-special-keywords)

(provide 'lch-pgm)
