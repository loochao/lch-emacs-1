; -*- coding: utf-8 -*-

;>========== EMMS ==========<;
;> Under MAC, need to $port install mplayer mp3info(but does not work for CN)!
;> $port install amixer for volume adjust.
(require 'emms-setup)
(emms-standard)
(emms-default-players)
;> NEWEST FEATURE. Use this if you like living on the edge.
(emms-devel)

(setq emms-lyric-display-p nil)
(setq emms-playlist-buffer-name "*EMMS Playlist*")
(setq emms-source-file-default-directory (concat dropbox-path "/MUSIC/"))
;(setq emms-player-mplayer-parameters (list "-slave" "-nortc" "-quiet" "-really-quiet")
(when (eq system-type 'windows-nt)
  (setq emms-player-mplayer-command-name
	"d:/MM/MPLAYER/MPlayer/MPLAYER.EXE"))
(setq emms-history-file (concat emacs-var-dir "/.emms-history"))

;(set-face-foreground 'emms-playlist-selected-face "magenta")
;(set-face-foreground 'emms-playlist-track-face  "green")

;> Prompt in minibuffer which track is playing when switch.
(add-hook 'emms-player-started-hook 'emms-show)
(setq emms-show-format "Now Playing: %s")

;>-------- Modeline --------<;
(require 'emms-mode-line-icon)
(setq emms-mode-line-titlebar-function 'emms-mode-line-playlist-current)

(setq emms-mode-line-icon-before-format "["
      emms-mode-line-format " %s]"
      emms-mode-line-icon-color "black")

;>-------- Coding --------<;
;(setq emms-info-mp3info-coding-system 'gbk
;      emms-cache-file-codixng-system 'utf-8
      ;; emms-i18n-default-coding-system '(utf-8 . utf-8)
;      )

;>-------- Utils --------<;
(defun lch-add-dir ()
  (interactive)
  (call-interactively 'emms-add-directory-tree)
  (emms-playlist-mode-go))

(defun lch-toggle-playing ()
  (interactive)
  (if emms-player-playing-p
      (emms-pause)
    (emms-start)))

;>-------- Stream --------<;
(setq emms-stream-info-format-string "NS: %s"
      emms-stream-default-action "play"
      emms-stream-popup-default-height 120)

;>-------- Binding --------<;
(define-key global-map (kbd "<f12> <f12>")
		'(lambda ()
		   (interactive)
		   (if (and (boundp 'emms-playlist-buffer)
			    (buffer-live-p emms-playlist-buffer))
		       (emms-playlist-mode-go) ;(emms-playlist-mode-go-popup)
;		     (if (y-or-n-p "EMMS not started, start it now? ")
			 (progn
			   (require 'lch-emms)
			   (emms-add-directory-tree emms-source-file-default-directory)
			   (emms-shuffle)
			   (lch-toggle-playing)))))

(define-key global-map (kbd "<f12> SPC") 'lch-toggle-playing)
(define-key global-map (kbd "<f12> c")   'emms-start)
(define-key global-map (kbd "<f12> x")   'emms-stop)

(define-key global-map (kbd "<f12> <f10>") 'lch-add-dir)
(define-key global-map (kbd "C-<f12>") 'emms-smart-browse)
(define-key global-map (kbd "S-<f12>") 'emms-playlist-mode-go)
(define-key global-map (kbd "M-<f12>") 'emms-stream-popup)

(define-key global-map (kbd "<f12> n")   'emms-next)
(define-key global-map (kbd "<f12> p")   'emms-previous)

(define-key global-map (kbd "<f12> /")   'emms-show)
(define-key global-map (kbd "<f12> s")   'emms-shuffle)

(define-key global-map (kbd "<f12> r")   'emms-toggle-repeat-track)
(define-key global-map (kbd "<f12> R")   'emms-toggle-repeat-playlist)

(define-key emms-playlist-mode-map (kbd "<left>")  (lambda () (interactive) (emms-seek -10)))
(define-key emms-playlist-mode-map (kbd "<right>") (lambda () (interactive) (emms-seek +10)))
(define-key emms-playlist-mode-map (kbd "<down>")  (lambda () (interactive) (emms-seek -60)))
(define-key emms-playlist-mode-map (kbd "<up>")    (lambda () (interactive) (emms-seek +60)))

(provide 'lch-emms)
