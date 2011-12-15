;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; TEX
;;
;; Copyright (c) 2006 2007 2008 2009 2010 2011 Chao LU
;;
;; Author: Chao LU <loochao@gmail.com>
;; URL: http://www.princeton.edu/~chaol

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Setting for latex.

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
(message "=> lch-tex: loading...")

;;; AUCTeX configuration
(load "auctex.el" nil t t)
(load "preview-latex.el" nil t t)

(setq TeX-auto-save t)
(setq TeX-parse-self t)

(setq-default TeX-master nil)

;;; Pdflatex
(setq TeX-PDF-mode t)

;;; Viewer
(setq TeX-view-program-selection
      '((output-dvi "DVI Viewer")
        (output-pdf "PDF Viewer")
        (output-html "HTML Viewer")))
;; this section is good for OS X only
;; TODO add sensible defaults for Linux/Windows
(setq TeX-view-program-list
      '(("DVI Viewer" "open %o")
        ("PDF Viewer" "open %o")
        ("HTML Viewer" "open %o")))

(defun lch-latex-mode-hook ()
  (turn-on-auto-fill)
  (abbrev-mode +1))

(add-hook 'LaTeX-mode-hook 'lch-latex-mode-hook)

(setq preview-gs-command
      (cond (lch-win32-p
             "C:/Program Files/gs/gs8.64/bin/gswin32c.exe")
            (t
             "/usr/texbin/gs")))

;;; provide
(provide 'lch-tex)
(message "~~ lch-tex: done.")

;;; Local Vars.
;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
