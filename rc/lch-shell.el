;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; SHELL.EL
;;
;; Copyright (c) 2006 2007 2008 2009 2010 2011 Chao LU
;;
;; Author: Chao LU <loochao@gmail.com>
;; URL: http://www.princeton.edu/~chaol

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Setting for the terminals.

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
(message "=> lch-shell: loading...")


(defun lch-visit-term-buffer ()
  (interactive)
  (if (not (get-buffer "*ansi-term*"))
      (ansi-term "/bin/bash")
    (switch-to-buffer "*ansi-term*")))

;; regexp to match prompts in the inferior shell
(setq shell-prompt-pattern (concat "^" (system-name) " [^ ]+ \\[[0-9]+\\] "))

;; translate ANSI escape sequences into faces
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)




;;; Popup shell
(defvar th-shell-popup-buffer nil)

(defun th-shell-popup ()
  "Toggle a shell popup buffer with the current file's directory as cwd."
  (interactive)
  (unless (buffer-live-p th-shell-popup-buffer)
    (save-window-excursion (shell "*-Shell-*"))
    (setq th-shell-popup-buffer (get-buffer "*-Shell-*")))
  (let ((win (get-buffer-window th-shell-popup-buffer))
	(dir (file-name-directory (or (buffer-file-name)
				      ;; dired
				      dired-directory
				      ;; use HOME
				      "~/"))))
    (if win
	(delete-window win)
      (pop-to-buffer th-shell-popup-buffer nil t)
      (comint-send-string nil (concat "cd " dir "\n")))))
(global-set-key (kbd "<f1> <f1>") 'th-shell-popup)




;>---- NEWSMTH ----<;
;- Not so good, keep here as an example.
;; (setq xwl-newsmth-buffer-name "newsmth")
;; (defun xwl-bbs-heartbeat ()
;;   "Keep bbs connection alive."
;;   (mapc (lambda (i)
;;           (let ((buf (get-buffer i)))
;;             (when buf
;;               (term-send-string (get-buffer-process (current-buffer)) ""))))
;;         (list xwl-newsmth-buffer-name)))

;; (defun xwl-newsmth ()
;;   (interactive)
;;   (call-interactively 'ansi-term)
;;   (rename-buffer xwl-newsmth-buffer-name)
;;   ;; set input/output coding system to gbk
;;   (set-buffer-process-coding-system 'gbk 'gbk)
;;   (term-send-string (get-buffer-process (current-buffer))
;;                     "ssh loochao@bbs.newsmth.net\n")
;;   ;; FIXME: Apart from using external "expect" utility, any elisp way to wait
;;   ;; for this?
;;   (sleep-for 3)
;;   (term-send-string (get-buffer-process (current-buffer))
;;                     (concat pwbbs "\n"))
;;   (term-send-raw)
;;   (run-at-time t 120 'xwl-bbs-heartbeat))

;; (define-key global-map (kbd "<f2> 4") '(lambda ()
;;                                  (interactive)
;;                                  (xwl-switch-or-create xwl-newsmth-buffer-name 'xwl-newsmth)))
(provide 'lch-shell)
(message "~~ lch-shell: done.")

;;; Local Vars.
;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:

