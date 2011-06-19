;-*- coding: utf-8 -*-

;>========== BOOKMARK ========<;
(message "=> lch-bmk: loading...")

(require 'bookmark)
(defun switch-to-bookmark (bname)
  "Interactively switch to bookmark as `iswitchb' does."
  (interactive (list (flet ((ido-make-buffer-list
                             (default)
                             (bookmark-all-names)))
                       (ido-read-buffer "Jump to bookmark: " nil t))))
  (bookmark-jump bname))
(define-key global-map (kbd "C-c C-b") 'switch-to-bookmark)

(define-key global-map (kbd "<f5> <f5>") 'list-bookmarks)
(define-key global-map (kbd "S-<f5>") 'bookmark-set)
(define-key global-map (kbd "C-<f5>") 'switch-to-bookmark)
(setq bookmark-save-flag 1)

;>-------- BM --------<;
;> Bookmark for lines.
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
