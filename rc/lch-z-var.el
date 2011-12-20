;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; VAR.EL
;;
;; Copyright (c) 2006 2007 2008 2009 2010 2011 Chao LU
;;
;; Author: Chao LU <loochao@gmail.com>
;; URL: http://www.princeton.edu/~chaol

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Named as z-var, for it should be loaded at last.

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
;(setq emacs-dir "~/Dropbox/.emacs.d") -> dotEmacs
;(setq emacs-var-dir "~/Dropbox/.emacs.d/var") -> dotEmacs

;(setq semanticdb-default-save-directory "~/.emacs.d/.semantic")
(setq tetris-score-file (concat emacs-var-dir "/tetris-scores"))
(setq session-save-file (concat emacs-var-dir "/emacs-session"))
;(setq recentf-save-file (concat emacs-var-dir "/emacs-recentf")) => lch-org.el
;(setq ido-save-directory-list-file (concat emacs-var-dir "/emacs-ido-last")) => lch-elisp.el
(setq bookmark-default-file (concat emacs-var-dir "/emacs-bmk"))
(setq abbrev-file-name (concat emacs-var-dir "/abbrev"))
(setq bbdb-file (concat emacs-var-dir "/bbdb"))

(setq todo-file-do (concat emacs-var-dir "/todo-do"))
(setq todo-file-done (concat emacs-var-dir "/todo-done"))
(setq todo-file-top (concat emacs-var-dir "/todo-top"))

(setq diary-file (concat emacs-var-dir "/diary"))

(provide 'lch-z-var)
