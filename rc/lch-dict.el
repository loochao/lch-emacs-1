;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; DICTIONARY
;;
;; Copyright (c) 2006 2007 2008 2009 2010 2011 Chao LU
;;
;; Author: Chao LU <loochao@gmail.com>
;; URL: http://www.princeton.edu/~chaol

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Dictionary client for dict.org.
;; To use, call dictionary-lookup-definition to lookup def of word under cursor.

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

(message "=> lch-dict: loading...")
(add-to-list 'load-path
             (concat (file-name-directory (or load-file-name buffer-file-name)) "../site-lisp/dictionary-1.8.7")
)
(autoload 'dictionary-search "dictionary" "Ask for a word and search it in all dictionaries" t)
(autoload 'dictionary-match-words "dictionary" "Ask for a word and search all matching words in the dictionaries" t)
(autoload 'dictionary-lookup-definition "dictionary" "Unconditionally lookup the word at point." t)
(autoload 'dictionary "dictionary" "Create a new dictionary buffer" t)
(autoload 'dictionary-mouse-popup-matching-words "dictionary" "Display entries matching the word at the cursor" t)
(autoload 'dictionary-popup-matching-words "dictionary" "Display entries matching the word at the point" t)
(autoload 'dictionary-tooltip-mode "dictionary" "Display tooltips for the current word" t)
(autoload 'global-dictionary-tooltip-mode "dictionary" "Enable/disable dictionary-tooltip-mode for all buffers" t)

(define-key global-map (kbd "<f7> <f6>") 'dictionary-search)
;(define-key global-map (kbd "<f7> <f8>") 'dictionary-match-words)

(setq dictionary-default-dictionary "*") ;"wn"

(setq dictionary-tooltip-dictionary "wn"
      global-dictionary-tooltip-mode nil
      dictionary-tooltip-mode nil)

(defun xwl-dictionary-next-dictionary ()
  (interactive)
  (end-of-line)
  (search-forward-regexp "^From" nil t)
  (beginning-of-line))

(defun xwl-dictionary-prev-dictionary ()
  (interactive)
  (beginning-of-line)
  (search-backward-regexp "^From" nil t)
  (beginning-of-line))

(defun xwl-dictionary-mode-hook ()
  ;; faces
  (set-face-foreground 'dictionary-word-entry-face "magenta")

  (define-key dictionary-mode-map (kbd "<backtab>") 'dictionary-prev-link)
  (define-key dictionary-mode-map (kbd "n") 'xwl-dictionary-next-dictionary)
  (define-key dictionary-mode-map (kbd "p") 'xwl-dictionary-prev-dictionary))

(add-hook 'dictionary-mode-hook 'xwl-dictionary-mode-hook)

(require 'wordnet)

(define-key global-map (kbd "M-s") '(lambda ()
                               (interactive)
                               (require 'lch-dict)
                               (call-interactively 'dictionary-search)))

(provide 'lch-dict)
(message "~~ lch-dict: done.")