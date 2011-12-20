;-*- coding: utf-8 -*-
;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; ALIAS.EL
;;
;; Copyright (c) 2006 2007 2008 2009 2010 2011 Chao LU
;;
;; Author: Chao LU <loochao@gmail.com>
;; URL: http://www.princeton.edu/~chaol

;; This file is not part of GNU Emacs.

;;; Commentary:

;; From Leexha:
;; the reason for these aliases is that, often, elisp package names is
;; not intuitive, and should not be the lang name neither. For
;; example, for javascript, those familiar with emacs would intuitive
;; type M-x javascript-mode or M-x js-mode. However, the 2 most robust
;; js packages are called by M-x espresso-mode and M-x
;; js2-mode. Without some insider knowledge, it is difficult to know
;; what function user needs to call for particular major mode he wants.
;; (the mode menu in ErgoEmacs helps, but this is not in GNU Emacs 23)

;; Also, due to elisp not having name space, or a enforced
;; package/module/lib naming system etc, package names shouldn't be
;; just the language name. That is, a particular javascript mode
;; really shouldn't be named javascript-mode, because, different
;; people's packages for js will all compete for that name, and
;; prevents the flexibility of testing or using different versions of
;; major mode for that language. Given the way things are, one ideal
;; fix is to always use a alias to point to the mode where ErgoEmacs
;; decides to be the default for that lang. For example, ErgoEmacs
;; bundles 2 major modes for javascript, js2-mode and espresso-mode,
;; and suppose we decided espresso-mode should be the default, then we
;; can define a alias js-mode to point to espresso-mode. This way,
;; user can intuitively load the package for js, but can also load a
;; different one if he has knowledege about which modes exists for the
;; lang he wants.

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
(message "=> lch-alias: loading...")

(defalias 'ahk-mode 'xahk-mode)
(defalias 'cmd-mode 'dos-mode)
(defalias 'spell-check 'speck-mode)

;;; Commands
(defalias 'gf 'grep-find)
(defalias 'fd 'find-dired)
(defalias 'sh 'shell)

(defalias 'qrr 'query-replace-regexp)
(defalias 'lml 'list-matching-lines)
(defalias 'dml 'delete-matching-lines)
(defalias 'rof 'recentf-open-files)
(defalias 'sl 'sort-lines)

;;; Modes
(defalias 'hm 'html-mode)
(defalias 'tm 'text-mode)
(defalias 'elm 'emacs-lisp-mode)
(defalias 'vbm 'visual-basic-mode)
(defalias 'vlm 'visual-line-mode)
(defalias 'wsm 'whitespace-mode)

;;; Elisp
(defalias 'ee 'eval-expression)
(defalias 'eb 'eval-buffer)
(defalias 'er 'eval-region)
(defalias 'ed 'eval-defun)
(defalias 'ele 'eval-last-sexp)
(defalias 'eis 'elisp-index-search)

(defalias 'ntr 'narrow-to-region)

(message "~~ lch-binding: done.")
(provide 'lch-alias)

;;; Local Vars.
;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
