;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; BOOKMARK
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
(message "=> lch-bmk: loading...")

(require 'bookmark)
(defun switch-to-bookmark (bname)
  "Interactively switch to bookmark as `iswitchb' does."
  (interactive (list (flet ((ido-make-buffer-list
                             (default)
                             (bookmark-all-names)))
                       (ido-read-buffer "Jump to bookmark: " nil t))))
  (bookmark-jump bname))
(define-key global-map (kbd "C-c C-b") 'list-bookmarks)

(define-key global-map (kbd "<f5> b") 'list-bookmarks)
(define-key global-map (kbd "<f5> a") 'bookmark-set)
(define-key global-map (kbd "<f5> j") 'switch-to-bookmark)
(setq bookmark-save-flag 1)

;; Bookmark for lines.
;; (require 'bm)
;; (when (require 'bm)
;;   (define-key global-map (kbd "<f5> <SPC>") 'bm-toggle)
;;   (define-key global-map (kbd "<f5> d") 'bm-remove-all-current-buffer)
;;   (define-key global-map (kbd "<f5> D") 'bm-remove-all-all-buffer)
;;   (define-key global-map (kbd "<f5> n") 'bm-next)
;;   (define-key global-map (kbd "<f5> p") 'bm-previous)
;;   (define-key global-map (kbd "<f5> s") 'bm-show)
;;   (define-key global-map (kbd "<f5> a") 'bm-bookmark-annotate))

;; (setq bm-restore-repository-on-load t)

;; ;; make bookmarks persistent as default
;; (setq-default bm-buffer-persistence t)

;; ;; Saving the repository to file when on exit.
;; ;; kill-buffer-hook is not called when emacs is killed, so we
;; ;; must save all bookmarks first.
;; (add-hook 'kill-emacs-hook '(lambda nil
;;                                 (bm-buffer-save-all)
;;                                 (bm-repository-save)))

;; ;; Update bookmark repository when saving the file.
;; (add-hook 'after-save-hook 'bm-buffer-save)

;; ;; Restore bookmarks when buffer is reverted.
;; (add-hook 'after-revert-hook 'bm-buffer-restore)

;; ;; make sure bookmarks is saved before check-in (and revert-buffer)
;; (add-hook 'vc-before-checkin-hook 'bm-buffer-save)

(message "~~ lch-bmk: done.")
(provide 'lch-bmk)
