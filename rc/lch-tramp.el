;;-*- coding:utf-8; mode:emacs-lisp; -*-
;;; TRAMP.EL
;;
;; Copyright (c) 2006 2007 2008 2009 2010 2011 Chao LU
;;
;; Author: Chao LU <loochao@gmail.com>
;; URL: http://www.princeton.edu/~chaol

;; This file is not part of GNU Emacs.

;;; Commentary:

;; (info "(emacs)Remote Files")
;; (info "(tramp)Top")
;;
;; TRAMP - Transparent Remote Access, Multiple Protocols
;; (other protocols than just FTP)
;;
;; Examples:
;; C-x C-f /method:user@host:/path/file
;; C-x C-f /ssh:loochao@server:/home/loochao/.bashrc
;; C-x C-f /plink:loochao@server:/home/loochao/.bashrc (from Windows)
;; C-x C-f /sudo:root@localhost:/etc/group
;; C-x C-f /su::/etc/hosts (Please note the double)

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

;;; Code:

;; (info "(tramp)Configuration") of TRAMP for use

;; (setq tramp-default-user "chaol"
;;       tramp-default-host "hats.princeton.edu")
;; (add-to-list 'tramp-default-method-alist
;;              '("hats.princeton.edu" "" "ssh"))
;; (add-to-list 'tramp-default-method-alist
;;              '("loochao" "" "sudo"))
;; (add-to-list 'tramp-default-user-alist
;;              '("" "hats.princeton.edu" "root"))

;; Default transfer method (info "(tramp)Default Method")
;; You might try out the `rsync' method, which saves the remote files
;; quite a bit faster than SSH. It's based on SSH, so it works the same,
;; just saves faster.
(setq tramp-default-method  ; `scp' by default
      (cond (lch-win32-p
	     ;; (issues with Cygwin `ssh' which does not cooperate with
	     ;; Emacs processes -> use `plink' from PuTTY, it definitely
	     ;; does work under Windows)
	     ;; C-x C-f /plink:myuser@host:/some/directory/file
	     "plink")
	    (t
	     "ssh")))

;;; Default user (info "(tramp)Default User")
(setq tramp-default-user "chaol")
(setq tramp-default-method "ssh")
(setq tramp-default-host "hats.princeton.edu")

;;; How many seconds passwords are cached
;; (info "(tramp)Password handling") for several connections
(setq password-cache-expiry 36000)  ; default is 16

;;; String used for end of line in rsh connections
;; (info "(tramp)Remote shell setup") hints
(setq tramp-rsh-end-of-line  ; `\n' by default
      (cond (lch-win32-p
	     "\n")
	    (t
	     "\r")))


;;; Faster auto saves (info "(tramp)Auto-save and Backup") configuration
(setq tramp-auto-save-directory temporary-file-directory)
;(setq tramp-remote-path (quote ("/usr/xpg4/bin" "/bin" "/usr/bin" "/usr/sbin" "/usr/local/bin" "/usr/ccs/bin" "/local/bin" "/local/freeware/bin" "/local/gnu/bin" "/usr/freeware/bin" "/usr/pkg/bin" "/usr/contrib/bin" "/p/perl/bin")))

;;; (info "(tramp)Traces and Profiles")
;;; Debugging
(setq tramp-verbose 9)  ; default is 0

;; Open a file as root
;; (defvar find-file-root-prefix "/sudo:root@localhost:"
;;   "*The filename prefix used to open a file with `find-file-root'.
;;       This should look something like \"/sudo:root@localhost:\" (new style
;;       TRAMP) or \"/[sudo:root@localhost]/\" (XEmacs or old style TRAMP).")

;; (defvar find-file-root-history nil
;;   "History list for files found using `find-file-root'.")

;; (defvar find-file-root-hook nil
;;   "Normal hook for functions to run after finding a \"root\" file.")

;; (defun find-file-root ()
;;   "*Open a file as the root user.
;;       Prepends `find-file-root-prefix' to the selected file name so that it
;;       maybe accessed via the corresponding TRAMP method."
;;   (interactive)
;;   (require 'tramp)
;;   (let* (;; We bind the variable `file-name-history' locally so we can
;; 	 ;; use a separate history list for "root" files.
;; 	 (file-name-history find-file-root-history)
;; 	 (name (or buffer-file-name default-directory))
;; 	 (tramp (and (tramp-tramp-file-p name)
;; 		     (tramp-dissect-file-name name)))
;; 	 path dir file)
;;     ;; If called from a "root" file, we need to fix up the path.
;;     (when tramp
;;       (setq path (tramp-file-name-path tramp)
;; 	    dir (file-name-directory path)))
;;     (when (setq file (read-file-name "Find file (UID = 0): " dir path))
;;       (find-file (concat find-file-root-prefix file))
;;       ;; If this all succeeded save our new history list.
;;       (setq find-file-root-history file-name-history)
;;       ;; allow some user customization
;;       (run-hooks 'find-file-root-hook))))

;; (defface find-file-root-header-face
;;   '((t (:foreground "white" :background "red3")))
;;   "*Face use to display header-lines for files opened as root.")

;; (defun find-file-root-header-warning ()
;;   "*Display a warning in header line of the current buffer.
;;       This function is suitable to add to `find-file-root-hook'."
;;   (let* ((warning "WARNING: EDITING FILE WITH ROOT PRIVILEGES!")
;; 	 (space (+ 6 (- (frame-width) (length warning))))
;; 	 (bracket (make-string (/ space 2) ?-))
;; 	 (warning (concat bracket warning bracket)))
;;     (setq header-line-format
;; 	  (propertize warning 'face 'find-file-root-header-face))))

;; (add-hook 'find-file-root-hook 'find-file-root-header-warning)

;; (global-set-key (kbd "C-x C-S-r") 'find-file-root)

(provide 'lch-tramp)

;; Open file by sudo -- Not working FIXME
;; (defun lch-sudo-edit (&optional arg)
;;   (interactive "p")
;;   (if (or arg (not buffer-file-name))
;;       (find-file (concat "/sudo:root@localhost:" (ido-read-file-name "File: ")))
;;     (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

;;; TRAMP NOTEs
;; ;; new proxy system (introduced with Tramp 2.1, instead of the old
;; ;; "multi-hop" filename syntax) to edit files on a remote server by going
;; ;; via another server
;; (when (boundp 'tramp-default-proxies-alist)
;;   (add-to-list 'tramp-default-proxies-alist
;;                '("10.10.13.123" "\\`root\\'" "/ssh:%h:")))
;; ;; Opening `/sudo:10.10.13.123:' would connect first `10.10.13.123' via
;; ;; `ssh' under your account name, and perform `sudo -u root' on that
;; ;; host afterwards. It is important to know that the given method is
;; ;; applied on the host which has been reached so far.
;; ;; The trick is to think from the end.

;;; Local Vars.
;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
