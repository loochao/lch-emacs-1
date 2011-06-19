;>-------- Maximize the frame --------<;
;; (if lch-win32-p
;;     (progn
;;       (defun w32-restore-frame (&optional arg)
;; 	"Restore a minimized frame"
;; 	(interactive)
;; 	(w32-send-sys-command 61728 arg))
;;       (defun w32-maximize-frame (&optional arg)
;; 	"Maximize the current frame"
;; 	(interactive)
;; 	(w32-send-sys-command 61488 arg))
;;       (w32-maximize-frame)
;;       (add-hook 'after-make-frame-functions 'w32-maximize-frame)))

;>======== VAR ========<;
;(setq emacs-dir "~/Dropbox/.emacs.d") -> dotEmacs
;(setq emacs-var-dir "~/Dropbox/.emacs.d/var") -> dotEmacs

(setq custom-file (concat emacs-var-dir "/emacs-custom-file"))
(if (file-exists-p custom-file)
    (load-file custom-file))

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
