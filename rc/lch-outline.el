; -*- coding: utf-8 -*-

;>========== OUTLINE.EL ==========<;
;; (info "(emacs)Outline Mode")
;; bind the outline-minor-mode-prefix C-c @ to C-o
(global-unset-key (kbd "C-o"))
(add-hook 'outline-minor-mode-hook
          (lambda ()
            (local-set-key (kbd "C-o") 'outline-mode-prefix-map)
            (hide-body)))

;; ; Outline-minor-mode key map
;; (define-prefix-command 'cm-map nil "Outline-")
;; ; HIDE
;; (define-key cm-map "q" 'hide-sublevels)    ; Hide everything but the top-level headings
;; (define-key cm-map "t" 'hide-body)         ; Hide everything but headings (all body lines)
;; (define-key cm-map "o" 'hide-other)        ; Hide other branches
;; (define-key cm-map "c" 'hide-entry)        ; Hide this entry's body
;; (define-key cm-map "l" 'hide-leaves)       ; Hide body lines in this entry and sub-entries
;; (define-key cm-map "d" 'hide-subtree)      ; Hide everything in this entry and sub-entries
;; ; SHOW
;; (define-key cm-map "a" 'show-all)          ; Show (expand) everything
;; (define-key cm-map "e" 'show-entry)        ; Show this heading's body
;; (define-key cm-map "i" 'show-children)     ; Show this heading's immediate child sub-headings
;; (define-key cm-map "k" 'show-branches)     ; Show all sub-headings under this heading
;; (define-key cm-map "s" 'show-subtree)      ; Show (expand) everything in this heading & below
;; ; MOVE
;; (define-key cm-map "u" 'outline-up-heading)                ; Up
;; (define-key cm-map "n" 'outline-next-visible-heading)      ; Next
;; (define-key cm-map "p" 'outline-previous-visible-heading)  ; Previous
;; (define-key cm-map "f" 'outline-forward-same-level)        ; Forward - same level
;; (define-key cm-map "b" 'outline-backward-same-level)       ; Backward - same level
;; (global-set-key (kbd "C-o") cm-map)

;; Add hook to the following major modes so that the outline minor mode starts automatically.
;; Outline mode is better to be enabled only in document modes.
(dolist (hook '(emacs-lisp-mode-hook
                latex-mode-hook
                text-mode-hook
                change-log-mode-hook
                makefile-mode-hook))
  (add-hook hook 'outline-minor-mode))

(defun body-p ()
  (save-excursion
    (outline-back-to-heading)
    (outline-end-of-heading)
    (and (not (eobp))
         (progn (forward-char 1)
                (not (outline-on-heading-p))))))

(defun body-visible-p ()
  (save-excursion
    (outline-back-to-heading)
    (outline-end-of-heading)
    (outline-visible)))

(defun subheadings-p ()
  (save-excursion
    (outline-back-to-heading)
    (let ((level (funcall outline-level)))
      (outline-next-heading)
      (and (not (eobp))
           (< level (funcall outline-level))))))

(defun subheadings-visible-p ()
  (interactive)
  (save-excursion
    (outline-next-heading)
    (outline-visible)))

(defun outline-do-close ()
  (interactive)
  (if (outline-on-heading-p)
      (cond ((and (body-p) (body-visible-p))
             (hide-entry))
            ((and (subheadings-p)
                  (subheadings-visible-p))
             (hide-subtree))
            (t (outline-previous-visible-heading 1)))
    (outline-back-to-heading t)))

(defun outline-do-open ()
  (interactive)
  (if (outline-on-heading-p)
      (cond ((and (subheadings-p)
                  (not (subheadings-visible-p)))
             (show-children))
            ((and (body-p)
                  (not (body-visible-p)))
             (show-entry))
            (t (show-entry)))
    (outline-next-visible-heading 1)))

(define-key outline-mode-map '[left] 'outline-do-close)
(define-key outline-mode-map '[right] 'outline-do-open)
(define-key outline-minor-mode-map '[left] 'outline-do-close)
(define-key outline-minor-mode-map '[right] 'outline-do-open)

(define-key outline-minor-mode-map [M-left] 'hide-body)
(define-key outline-minor-mode-map [M-right] 'show-all)
(define-key outline-minor-mode-map [M-up] 'outline-previous-heading)
(define-key outline-minor-mode-map [M-down] 'outline-next-heading)
(define-key outline-minor-mode-map [C-M-left] 'hide-sublevels)
(define-key outline-minor-mode-map [C-M-right] 'show-children)
(define-key outline-minor-mode-map [C-M-up] 'outline-previous-visible-heading)
(define-key outline-minor-mode-map [C-M-down] 'outline-next-visible-heading)

(define-key outline-mode-map (kbd "M-<left>") 'hide-body)
(define-key outline-mode-map (kbd "M-<right>") 'show-all)
(define-key outline-mode-map (kbd "M-<up>") 'outline-previous-heading)
(define-key outline-mode-map (kbd "M-<down>") 'outline-next-heading)
(define-key outline-mode-map (kbd "C-M-<left>") 'hide-sublevels)
(define-key outline-mode-map (kbd "C-M-<right>") 'show-children)
(define-key outline-mode-map (kbd "C-M-<up>") 'outline-previous-visible-heading)
(define-key outline-mode-map (kbd "C-M-<down>") 'outline-next-visible-heading)

(when (require 'outline-magic)
  (add-hook 'outline-minor-mode-hook
            (lambda ()
              (define-key outline-minor-mode-map
                (kbd "<M-tab>") 'outline-cycle))))

(defun org-cycle-global ()
  (interactive)
  (org-cycle t))

(defun org-cycle-local ()
  (interactive)
  (save-excursion
    (move-beginning-of-line nil)
    (org-cycle)))

(global-set-key (kbd "C-M-]") 'org-cycle-global) ; ok on Elisp, not on LaTeX
(global-set-key (kbd "M-]") 'org-cycle-local) ; ok on Elisp, not on LaTeX

(message "~~ lch-outline: done.")
(provide 'lch-outline)
