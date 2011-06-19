;-*- coding: utf-8; mode: emacs-lisp -*-

;>======== IRC.EL ========<;
(defvar erc-server-coding-system '(utf-8 . utf-8))

;>---- Set GBK for #linuxfire ----<;
(defvar erc-encoding-coding-alist '(("#linuxfire" . chinese-iso-8bit)))

(defvar erc-nick "loochao"                    ;; nick is used when login.
      erc-user-full-name "Chao (Chris) LU") ;; user-full-name is shown for inquiring. 

;>---- Auto join preset channels ----<;
(erc-autojoin-mode 1)
(defvar erc-autojoin-channels-alist
      '(("oftc.net"                         ;; Aliased by debian.org
         "#debian-zh"
         "#emacs-cn")))

;>---- Change to admin previlige after login ----<;
;; (defun xwl-erc-auto-op ()
;;   (let ((b (buffer-name)))
;;     (when (string= b "#emacs-cn")
;;       (erc-message "PRIVMSG" (concat "chanserv op " b)))))
 
;; (add-hook 'erc-join-hook 'xwl-erc-auto-op)

;>---- Highlight Certain Info ----<;
(erc-match-mode 1)
(defvar erc-keywords '("emms" "python"))
(defvar erc-pals '("rms"))

;>---- Ignore Certain Info ----<;
(defvar erc-ignore-list nil)
(defvar erc-hide-list
      '("JOIN" "PART" "QUIT" "MODE"))

(provide 'lch-irc)
