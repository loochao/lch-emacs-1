;-*- coding: utf-8 -*-

;>======== EL-GET ========<;
;> To install, modify el-get.el & package.el(for elpa), and change the path
;> to be Dropbox/.emacs.d/site-lisp

(require 'el-get)
(setq el-get-dir (concat emacs-site-lisp "/el-get/"))
(setq el-get-sources
      '(
	;; el-get
	;; switch-window
	;; emacs-goodies-el      ;Debian collections
	;; auto-complete
	;; (:name magit
	;;        :after (lambda () (global-set-key (kbd "C-x C-z") 'magit-status)))

	;; (:name asciidoc
	;;        :type elpa
	;;        :after (lambda ()
	;; 		(autoload 'doc-mode "doc-mode" nil t)
	;; 		(add-to-list 'auto-mode-alist '("\\.adoc$" . doc-mode))
	;; 		(add-hook 'doc-mode-hook '(lambda ()
	;; 					    (turn-on-auto-fill)
	;; 					    (require 'asciidoc)))))
	
	;; (:name smex				; a better (ido like) M-x
	;;        :after (lambda ()
	;; 		(setq smex-save-file (concat emacs-var-dir "/.smex-items"))
	;; 		(global-set-key (kbd "M-x") 'smex)
	;; 		(global-set-key (kbd "M-X") 'smex-major-mode-commands)))

	;; (:name goto-last-change		; move pointer back to last change
	;;        :after (lambda ()
	;; 		;; when using AZERTY keyboard, consider C-x C-_
	;; 		(global-set-key (kbd "C-x C-/") 'goto-last-change)))	
))

(el-get)

(provide 'lch-el-get)
