;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; CODING.EL
;;
;; Copyright (c) 2006 2007 2008 2009 2010 2011 Chao LU
;;
;; Author: Chao LU <loochao@gmail.com>
;; URL: http://www.princeton.edu/~chaol

;; This file is not part of GNU Emacs.

;;; Commentary:

;; commentary

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
(message "=> lch-coding: loading...")

(cond
 ((eq window-system 'w32)
  (set-language-environment "Chinese-GB18030")
  (setq file-name-coding-system 'gb18030)
  (let ((l '(chinese-gb2312
	     gb18030-2-byte
	     gb18030-4-byte-bmp
	     gb18030-4-byte-ext-1
	     gb18030-4-byte-ext-2
	     gb18030-4-byte-smp)))
    (dolist (elt l)
      (map-charset-chars #'modify-category-entry elt ?|)
      (map-charset-chars
       (lambda (range ignore)
	 (set-char-table-range char-width-table range 2))
       elt))))
 )

(if (not (eq system-type 'windows-nt))
    (progn
      (set-language-environment "UTF-8")
      (prefer-coding-system       'utf-8)
      (set-default-coding-systems 'utf-8)
      (set-terminal-coding-system 'utf-8)
      (set-keyboard-coding-system 'utf-8)
      (setq locale-coding-system 'utf-8)
      (set-selection-coding-system 'utf-8)
      (setq file-name-coding-system 'utf-8)
      (setq coding-system-for-read 'utf-8)
      (setq coding-system-for-write 'utf-8)
      (setq buffer-file-coding-system 'utf-8)))

;; (case system-type
;;  ((windows-nt)
;;   (prefer-coding-system 'gbk))
;;  (t
;;   (prefer-coding-system 'utf-8-emacs)))

;>---- Language Environment ----<;
(define-key global-map (kbd "<f11> u")
                (lambda() (interactive)
                  (set-language-environment "UTF-8")
                  (message "language-environment is UTF-8")))

(define-key global-map (kbd "<f11> U") '(lambda () (interactive)
                                   (revert-buffer-with-coding-system 'utf-8)
				   (message "buffer reverted with utf-8")))

(define-key global-map (kbd "<f11> c")
                (lambda() (interactive)
                  (set-language-environment "Chinese-GB18030")
                  (message "language-environment is Chinese-GB18030")))

(define-key global-map (kbd "<f11> C") '(lambda () (interactive)
                                   (revert-buffer-with-coding-system 'gb18030)
				   (message "buffer reverted with gb18030")))

(message "lch-coding done...")
(provide 'lch-coding)

;;; Local Vars.
;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
