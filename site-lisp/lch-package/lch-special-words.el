;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; LCH-SPECIAL-WORDS.EL
;;
;; Copyright (c) 2012 Charles (Chao) LU
;;
;; Author: Charles LU <loochao@gmail.com>
;; URL: http://www.princeton.edu/~chaol

;; This file is not part of GNU Emacs.

;;; Commentary:

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


(provide 'lch-special-words)
;;; Local Vars.
;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End: