;-*- coding: utf-8 -*-

;>========== SHELL ==========<;
;; regexp to match prompts in the inferior shell
(setq shell-prompt-pattern (concat "^" (system-name) " [^ ]+ \\[[0-9]+\\] "))

;; translate ANSI escape sequences into faces
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)


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
