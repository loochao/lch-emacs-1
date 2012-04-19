;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; PROGRAMMING.EL
;;
;; Copyright (c) 2010 2011 Chao LU
;;
;; Author: Chao LU <loochao@gmail.com>
;; URL: http://www.princeton.edu/~chaol

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Some basic configuration for programming languages.

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
(message "=> lch-pgm: loading...")

;;; Highlight Special Keywords
;; Using Greek Symbol to respresent lambda
(font-lock-add-keywords
 nil ;; 'emacs-lisp-mode
 `(("\\<lambda\\>"
    (0 (progn (compose-region (match-beginning 0) (match-end 0)
                              ,(make-char 'greek-iso8859-7 107))
              nil)))))

;; Highlight TODO & FIXME
(make-face 'font-lock-fixme-face)
(make-face 'font-lock-todo-face)
(make-face 'font-lock-lch-face)
(make-face 'font-lock-caution-face)
(make-face 'font-lock-figure-face)
(make-face 'font-lock-why-face)

(modify-face 'font-lock-fixme-face "Black" "Yellow" nil t nil t nil nil)
(modify-face 'font-lock-lch-face "White" "SlateBlue" nil t nil t nil nil)
(modify-face 'font-lock-todo-face  "Black" "Yellow" nil t nil nil nil nil)
(modify-face 'font-lock-caution-face  "White" "DarkRed" nil t nil nil nil nil)
(modify-face 'font-lock-figure-face "White" "DarkRed" nil t nil t nil nil)
(modify-face 'font-lock-why-face "Black" "Cyan" nil t nil t nil nil)

(setq lch-keyword-highlight-modes
     '(php-mode java-mode c-mode c++-mode emacs-lisp-mode scheme-mode
       text-mode outline-mode))

(defun lch-highlight-special-keywords ()
 (mapc (lambda (mode)
         (font-lock-add-keywords
          mode
          '(("\\<\\(FIXME\\)" 1 'font-lock-fixme-face t)
            ("\\<\\(TODO~\\)"  1 'font-lock-todo-face  t)
            ("\\<\\(LCH\\)"  1 'font-lock-lch-face  t)
            ("\\<\\(CAUTION\\)"  1 'font-lock-caution-face t)
            ("\\<\\(FIGURE\\)"  1 'font-lock-figure-face t)
            ("\\<\\(WHY\\)"  1 'font-lock-why-face t)
	    )))
       lch-keyword-highlight-modes))

(lch-highlight-special-keywords)

;;; cc mode
(defun lch-c-mode-common-hook ()
  (setq c-basic-offset 4))

;; this will affect all modes derived from cc-mode, like
;; java-mode, php-mode, etc
(add-hook 'c-mode-common-hook 'lch-c-mode-common-hook)

(defun lch-makefile-mode-hook ()
  (setq indent-tabs-mode t)
  (setq tab-width 4))

(add-hook 'makefile-mode-hook 'lch-makefile-mode-hook)

;;; Perl
(defalias 'perl-mode 'cperl-mode)

(defun lch-cperl-mode-hook ()
  (setq cperl-indent-level 4)
  (setq cperl-continued-statement-offset 8)
  ;; cperl-hairy affects all those variables, but I prefer
  ;; a more fine-grained approach as far as they are concerned
  (setq cperl-font-lock t)
  (setq cperl-electric-lbrace-space t)
  (setq cperl-electric-parens nil)
  (setq cperl-electric-linefeed nil)
  (setq cperl-electric-keywords nil)
  (setq cperl-info-on-command-no-prompt t)
  (setq cperl-clobber-lisp-bindings t)
  (setq cperl-lazy-help-time 3)

  ;; if you want all the bells and whistles
  ;; (setq cperl-hairy)

  (set-face-background 'cperl-array-face nil)
  (set-face-background 'cperl-hash-face nil)
  (setq cperl-invalid-face nil))

(add-hook 'cperl-mode-hook 'lch-cperl-mode-hook t)
;;; Emacs lisp
(defun lch-emacs-lisp-mode-hook ()
  ;(turn-on-eldoc-mode) ;way too slow
  )

(add-hook 'emacs-lisp-mode-hook 'lch-emacs-lisp-mode-hook)

;;; Provide
(provide 'lch-pgm)
(message "~~ lch-pgm: done.")

;;; Local Vars.
;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
