;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; STARTUP.EL
;;
;; Copyright (c) 2006 2007 2008 2009 2010 2011 Chao LU
;;
;; Author: Chao LU <loochao@gmail.com>
;; URL: http://www.princeton.edu/~chaol

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Startup Funcs

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
(defun lch-startup ()
;  (let ((org-agenda-window-setup 'current-window)))

;   (org-agenda nil "`")
;   (delete-other-windows)
;   (split-window-horizontally 50)
;   (other-window 1)
;   (org-agenda nil "1")
;   (list-bookmarks)
   (set-frame-position (selected-frame) 0 0)
   (set-frame-size (selected-frame) 237 65)
;   (ansi-term "/bin/bash")  ;; load a shell

   (message "Emacs startup time: %d seconds."
	    (float-time (time-since emacs-load-start-time)))
   (sit-for 1.5)
   )
(add-hook 'after-init-hook 'lch-startup t)

;; Maximize the Window
;; This sets the parameters for creating the initial X Windows frame.
;; It positions the emacs frame in the top left corner of the display [0, 0] (measured in pixels) and
;; Then resizes the frame to 237 columns by 65 rows.
;; Unfortunately, the number of columns and rows vary depending on font-size, scroll bar visibility, etc.
;; The dimensions of 237×65 just happen to work for my 1440×900 display, 6×13 font, scroll-bars off, etc.
;; Use the display-pixel-width and display-pixel-height functions to automatically determine the proper size of the emacs frame

(provide 'lch-startup)