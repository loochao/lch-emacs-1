;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; CONFIGURATION.EL
;;
;; Copyright (c) 2006 2007 2008 2009 2010 2011 Chao LU
;;
;; Author: Chao LU <loochao@gmail.com>
;; URL: http://www.princeton.edu/~chaol

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Configuration

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
(message "=> lch-conf: loading...")

;; (require 'lch-autoloads)
(require 'lch-init)
(require 'one-key)
(require 'lch-ui)
(require 'lch-ui-theme)
(require 'lch-elisp)
;; (require 'lch-el-get)
(require 'lch-coding)
(require 'lch-binding)
(require 'lch-mouse)
(require 'lch-template)
(require 'lch-skeleton)
(require 'lch-alias)
(require 'lch-util)
(require 'lch-pgm)
(require 'lch-dict)
(require 'lch-emms)
(require 'lch-web)
(require 'lch-auto-mode)
(require 'lch-z-var)
(require 'lch-dired)
(require 'lch-calendar)
(require 'lch-shell)
(require 'lch-bmk)
(require 'lch-tex)
(require 'lch-org)
;(require 'lch-org-latex)
(require 'lch-org-export)
(require 'lch-org-agenda)
(require 'lch-erc)
(require 'lch-outline)

(if lch-win32-p (require 'lch-w32))
(if lch-mac-p (require 'lch-mac))
(if (and lch-mac-p lch-aquamacs-p) (require 'lch-aquamacs))

;(eval-after-load 'dired '(progn (require 'lch-dired)))

;(require 'lch-hl-line)
;(require 'xwl-shell)

(provide 'lch-conf)
(message "~~ lch-conf: done.")

;;; Local Vars.
;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
