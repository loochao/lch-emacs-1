;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; MOUSE.EL
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
;(define-key global-map (kbd "<mouse-1>") 'mouse-set-point) ;Default
;(define-key global-map (kbd "<down-mouse-1>") 'mouse-drag-region) ;Default
;(define-key global-map (kbd "<mouse-2>") 'mouse-yank-at-click)
;(define-key global-map (kbd "<mouse-3>") 'mouse-save-then-kill)

(define-key global-map [C-wheel-up] 'text-scale-increase)
(define-key global-map [C-wheel-down] 'text-scale-decrease)
;(define-key global-map [C-down-mouse-2] 'text-scale-normal-size) ;> utils.el

;; Right-click opens the context menu
(define-key global-map [mouse-3] 'ergoemacs-context-menu)

(defvar edit-popup-menu
      '(keymap
	(undo menu-item "Undo" undo
	      :enable (and
		       (not buffer-read-only)
		       (not
			(eq t buffer-undo-list))
		       (if
			   (eq last-command 'undo)
			   (listp pending-undo-list)
			 (consp buffer-undo-list)))
	      :help "Undo last operation")
	(separator-undo menu-item "--")
	(cut menu-item "Cut" clipboard-kill-region
	     :help "Delete text in region and copy it to the clipboard"
	     :keys "Meta+w")
	(copy menu-item "Copy" clipboard-kill-ring-save
	      :help "Copy text in region to the clipboard"
	      :keys "Ctrl+w")
	(paste menu-item "Paste" clipboard-yank
	       :help "Paste text from clipboard"
	       :keys "Ctrl+y")
	(paste-from-menu menu-item "Paste from Kill Menu" yank-menu
			 :enable (and
				  (cdr yank-menu)
				  (not buffer-read-only))
			 :help "Choose a string from the kill ring and paste it")
	(clear menu-item "Clear" delete-region
	       :enable (and mark-active (not buffer-read-only))
	       :help "Delete the text in region between mark and current position"
	       :keys "Del")
	(separator-select-all menu-item "--")
	(mark-whole-buffer menu-item "Select All" mark-whole-buffer
			   :help "Mark the whole buffer for a subsequent cut/copy")))

(defun ergoemacs-context-menu (event)
  "Pop up a context menu."
  (interactive "e")
  (popup-menu edit-popup-menu))

(provide 'lch-mouse)

;;; Local Vars.
;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:

