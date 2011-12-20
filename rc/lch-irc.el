;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; IRC.EL
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
(defvar erc-server-coding-system '(utf-8 . utf-8))

;;; Set GBK for #linuxfire
(defvar erc-encoding-coding-alist '(("#linuxfire" . chinese-iso-8bit)))

(defvar erc-nick "loochao"                    ;; nick is used when login.
      erc-user-full-name "Chao (Chris) LU") ;; user-full-name is shown for inquiring.

;;; Auto join preset channels
(erc-autojoin-mode 1)
(defvar erc-autojoin-channels-alist
      '(("oftc.net"                         ;; Aliased by debian.org
         "#debian-zh"
         "#emacs-cn")))

;;; Change to admin previlige after login
;; (defun xwl-erc-auto-op ()
;;   (let ((b (buffer-name)))
;;     (when (string= b "#emacs-cn")
;;       (erc-message "PRIVMSG" (concat "chanserv op " b)))))

;; (add-hook 'erc-join-hook 'xwl-erc-auto-op)

;;; Highlight Certain Info
(erc-match-mode 1)
(defvar erc-keywords '("emms" "python"))
(defvar erc-pals '("rms"))

;;; Ignore Certain Info
(defvar erc-ignore-list nil)
(defvar erc-hide-list
      '("JOIN" "PART" "QUIT" "MODE"))

(provide 'lch-irc)
;;; Local Vars.
;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
