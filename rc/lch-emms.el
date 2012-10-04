;;-*- coding:utf-8; -*-

;;; EMMS.EL
;;
;; Copyright (c) 2006-2012 Chao LU
;;
;; Author: Chao LU <loochao@gmail.com>
;; URL: http://www.princeton.edu/~chaol

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Under MAC, need to $port install mplayer mp3info(but does not work for CN)!
;; $port install amixer for volume adjust.

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
(message "=> lch-emms: loading...")
(require 'emms-setup)
(emms-standard)
(emms-default-players)
;; NEWEST FEATURE. Use this if you like living on the edge.
(emms-devel)                                                              ;选择开发者模式

(defvar emms-dir (concat emacs-var-dir "/emms"))                          ;设置EMMS的目录
(setq emms-history-file (concat emms-dir "/emms-history"))                ;播放列表历史记录
(setq emms-cache-file (concat emms-dir "/cache"))                         ;缓存文件
(setq emms-stream-bookmarks-file (concat emms-dir "/streams"))            ;网络电台保存文件
(setq emms-score-file (concat emms-dir "/scores"))                        ;分数文件

(setq emms-lyric-display-p nil)
(setq emms-playlist-buffer-name "*Music*")                                ;设定播放列表的缓存标题
(setq emms-source-file-default-directory "/Volumes/DATA/Music/INBOX")     ;设定默认的播放目录
;(setq emms-player-mplayer-parameters (list "-slave" "-nortc" "-quiet" "-really-quiet")
(when (eq system-type 'windows-nt)
  (setq emms-player-mplayer-command-name
	"d:/MM/MPLAYER/MPlayer/MPLAYER.EXE"))
(setq emms-player-list                                                    ;设定EMMS播放器的优先顺序
      '(emms-player-mplayer
        emms-player-timidity
        emms-player-mpg321
        emms-player-ogg123))

(setq emms-repeat-playlist t)                                             ;设定EMMS启动列表循环播放

;(set-face-foreground 'emms-playlist-selected-face "magenta")
;(set-face-foreground 'emms-playlist-track-face  "green")

;; Prompt in minibuffer which track is playing when switch.
(add-hook 'emms-player-started-hook 'emms-show)
(setq emms-show-format "Now Playing: %s")                                 ;设置 `emms-show' 的显示格式

;; 设置播放列表用自然的方法排序: 艺术家 -> 专辑 -> 序号
(setq emms-playlist-sort-function
      'emms-playlist-sort-by-natural-order)

;;; Modeline
(emms-mode-line-disable)                                                  ;不在Mode-line上显示歌曲信息
(setq emms-playing-time-display-format "")                                ;不显示歌曲播放时间
(require 'emms-mode-line-icon)
(setq emms-mode-line-titlebar-function 'emms-mode-line-playlist-current)

(setq emms-mode-line-icon-before-format "["
      emms-mode-line-format " %s]"
      emms-mode-line-icon-color "black")

;;; Encoding
;(setq emms-info-mp3info-coding-system 'gbk
;      emms-cache-file-codixng-system 'utf-8
      ;; emms-i18n-default-coding-system '(utf-8 . utf-8)
;      )

;;; Utils
(defun lch-add-dir ()
  (interactive)
  (call-interactively 'emms-add-directory-tree)
  (emms-playlist-mode-go))

(defun lch-toggle-playing ()
  (interactive)
  (if emms-player-playing-p
      (emms-pause)
    (emms-start)))

;;; Stream
(setq emms-stream-info-format-string "NS: %s"
      emms-stream-default-action "play"
      emms-stream-popup-default-height 120)
(add-to-list 'emms-info-functions 'kid-emms-info-simple)
;;; Browser
(setq emms-browser-info-genre-format "%i● %n"
      emms-browser-info-artist-format "%i● %n"
      emms-browser-info-album-format "%i◎ %n"
      emms-browser-info-title-format "%i♪ %n")
;;; Binding
(defun lch-emms-init ()
  (interactive)
  (if (and (boundp 'emms-playlist-buffer)
           (buffer-live-p emms-playlist-buffer))
      (emms-playlist-mode-go)
    ;; (emms-playlist-mode-go-popup)
    ;; (if (y-or-n-p "EMMS not started, start it now? ")
    (progn
      (require 'lch-emms)
      (emms-add-directory-tree emms-source-file-default-directory)
      (emms-shuffle)
      (lch-toggle-playing))))

(define-key global-map (kbd "<f12> <f12>") 'lch-emms-init)


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
(message "~~ lch-emms: done.")

;;; One-key-map
(defvar one-key-menu-emms-alist nil
  "`One-Key' menu list for EMMS.")

(setq one-key-menu-emms-alist
      '(
        (("g" . "Playlist Go") . emms-playlist-mode-go)
        (("d" . "Play Directory Tree") . emms-play-directory-tree)
        (("f" . "Play File") . emms-play-file)
        (("i" . "Play Playlist") . emms-play-playlist)
        (("t" . "Add Directory Tree") . emms-add-directory-tree)
        (("c" . "Toggle Repeat Track") . emms-toggle-repeat-track)
        (("w" . "Toggle Repeat Playlist") . emms-toggle-repeat-playlist)
        (("u" . "Play Now") . emms-play-now)
        (("z" . "Show") . emms-show)
        (("s" . "Emms Streams") . emms-streams)
        (("b" . "Emms Browser") . emms-browser)))

(defun one-key-menu-emms ()
  "`One-Key' menu for EMMS."
  (interactive)
  (one-key-menu "emms" one-key-menu-emms-alist t))

(define-key global-map (kbd "<f12> <f11>") 'one-key-menu-emms)
(define-key global-map (kbd "<f5> e") 'one-key-menu-emms)

;;; Lyric
;; (ad-activate 'emms-lyrics-find-lyric)                ;自动下载歌词
;; (setq emms-lyrics-dir (concat emms-dir "lyrics/"))   ;EMMS的歌词目录
;; (setq emms-lyrics-display-format "%s")               ;设置歌词显示格式
;; (setq emms-lyrics-scroll-timer-interval 1.0)         ;歌词滚动延迟
;; (setq emms-lyrics-display-on-minibuffer nil)         ;在minibuffer中显示歌词
;; (setq emms-lyrics-display-on-modeline nil)           ;在modeline中显示歌词
;;; Local Vars.
;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End: