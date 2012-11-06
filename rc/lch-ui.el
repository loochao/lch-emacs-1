;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; UI.EL
;;
;; Copyright (c) 2006 2007 2008 2009 2010 2011 Chao LU
;;
;; Author: Chao LU <loochao@gmail.com>
;; URL: http://www.princeton.edu/~chaol

;; This file is not part of GNU Emacs.

;;; Commentary:

;; Setting for UI.

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
(message "=> lch-ui: loading...")

;;; Frame parameters
(setq default-frame-alist
      (append
       '(
	 (default-fringes-outside-margins . 1)
	 (default-left-fringe-width . 12)
	 (default-left-margin-width . 14)
	 (cursor-color . "sienna1")
         ;; (background-color . "Black")
         ;; (foreground-color . "moccasin")
         ;; (top . 42)
         ;; (left . 42)
         ;; (height . 47)
         ;; (width . 128)
         ) default-frame-alist))


(if (not lch-mac-p)
    (when (fboundp 'menu-bar-mode)
      (menu-bar-mode -1)))

(when (fboundp 'scroll-bar-mode)
  (scroll-bar-mode -1))

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))

;; (setq default-indicate-empty-lines t)
(setq default-indicate-buffer-boundaries 'left)


;;; Menu
;; get rid of the Games in the Tools menu
;; (define-key menu-bar-tools-menu [games] nil)


;;; Modeline
;(require 'modeline-posn)
(setq size-indication-mode t)
(add-to-list 'default-mode-line-format
             '((mark-active
                (:eval (format "Selected: %d line(s), %d char(s) "
                               (count-lines (region-beginning)
                                            (region-end))
                               (- (region-end) (region-beginning)))))))


;;; Font
;; You can get text properties of any char by typing `C-u C-x ='

;; Under Windows, you can get the current font string by typing
;; `(insert (format "\n%S" (w32-select-font)))' followed by `C-x C-e'

;; You can find the current font by typing
;; `M-x ielm RET (frame-parameters) RET'
;; see the line `font'

;; To check if some font is available in Emacs do following:
;;    1.   Switch to the `*scratch*' buffer.
;;    2.   Type `(prin1-to-string (x-list-fonts "font-you-want-to-check or
;;         pattern"))'.
;;    3.   Place the cursor after the last closing paren and hit
;;         `C-j'. List of the names of available fonts matching given
;;         pattern will appear in the current buffer (`*scratch*').
;;    4.   For listing of all available fonts, use
;;         `(prin1-to-string (x-list-fonts "*"))' or
;;         `(dolist (i (x-list-fonts "*")) (princ i) (terpri))'
;;         for a better output.

;; Format: "-a-b-c-d-e-f-g-h-i-j-k-l-"
;; where
;;
;; a = foundry
;;
;; b = font family <<<
;;
;; c = weight
;;     Valid options: `bold', `demibold', `light', `medium', `normal'.
;;
;; d = slant
;;     Valid options: `i' for italic and `r' for roman.
;;
;; e = set width
;;     Ignored by NT-Emacs.
;;
;; f = pixels
;;     Nominal font height in pixels. (Eg. 13 pixels roughly corresponds to
;;     10 points (a point is 1/72 of an inch) on a 96dpi monitor, so the
;;     font spec above is selecting a 10 point bold Courier font)
;;
;; g = points in tenths of a point
;;     10 point is 100
;;
;; h = horiz resolution in dpi
;;     I think these numbers represent the "design resolution" of the font -
;;     on X, fonts are typically designed for 75dpi or 100dpi screens (under
;;     Windows,most monitors are assumed to be 96dpi I believe). NT-Emacs
;;     ignores these values.
;;
;; i = vertical resolution in dpi
;;     I think these numbers represent the "design resolution" of the font -
;;     on X, fonts are typically designed for 75dpi or 100dpi screens (under
;;     Windows,most monitors are assumed to be 96dpi I believe). NT-Emacs
;;     ignores these values.
;;
;; j = spacing
;;     Spacing as in mono-spaced or proportionally spaced.
;;     Values are `c' (constant) or `m' (monospace) to mean fixed-width or
;;     `p' for proportionally spaced.
;;
;; k = average width in tenths of a pixel
;;
;; l = character set
;;     NT-Emacs understands: ansi, oem, symbol to refer to the standard
;;     Windows character sets (the first two, at least, are locale
;;     dependant). "iso8859" and "iso8859-1" are accepted as synonyms for
;;     ansi.

;; Use `xfontsel' utility (or the command-line `xlsfonts') to try out
;; different fonts. After choosing a font, click the select button in
;; `xfontsel' window. This will copy font name you choose to copy & paste
;; buffer.
;; Edit your `~/.Xresources' file to have a line with "Emacs.font".
;; Then do a `xrdb -merge ~/.Xresources' or restart your X11 to validate the
;; modification. I let emacs do this for me:

(if lch-mac-p
    (setq default-frame-alist
          (append
           '((font . "-apple-Monaco-medium-normal-normal-*-21-*-*-*-m-0-fontset-startup"))
           default-frame-alist)))
(if lch-mac-p
    (set-face-font 'modeline "-apple-Monaco-medium-normal-normal-*-18-*-*-*-m-0-fontset-startup")
  (set-face-font 'modeline "-outline-Lucida Console-normal-normal-normal-mono-18-*-*-*-c-*-iso8859-1"))


;;; Cursor
;; Don't blink
(and (fboundp 'blink-cursor-mode) (blink-cursor-mode (- (*) (*) (*))))

;; bar-cursor-mode
(require 'bar-cursor)
(bar-cursor-mode 1)

;; Change cursor color and type according to some minor modes.
(defvar lch-read-only-color       "gray")
;; valid values are t, nil, box, hollow, bar, (bar . WIDTH), hbar,
;; (hbar . HEIGHT); see the docs for set-cursor-type
(defvar lch-read-only-cursor-type 'hbar)
(defvar lch-overwrite-color       "red")
(defvar lch-overwrite-cursor-type 'bar)
(defvar lch-normal-color          "sienna1")
(defvar lch-normal-cursor-type    'box)

(defun lch-set-cursor-according-to-mode ()
  "change cursor color and type according to some minor modes."
  (cond
   (buffer-read-only
    (set-cursor-color lch-read-only-color)
    (setq cursor-type lch-read-only-cursor-type))
   (overwrite-mode
    (set-cursor-color lch-overwrite-color)
    (setq cursor-type lch-overwrite-cursor-type))
   (t
    (set-cursor-color lch-normal-color)
    (setq cursor-type lch-normal-cursor-type))))

(defun aquamacs-cursor ()
  (set-cursor-color lch-normal-color)
  (setq cursor-type lch-normal-cursor-type))

;; FIXME Doesn'et work with Aquamacs
(if (not lch-aquamacs-p) (add-hook 'post-command-hook 'lch-set-cursor-according-to-mode)
  (add-hook 'after-init-hook 'aquamacs-cursor))

;;; Titlebar
;; %f: Full path of current file.
;; %b: Buffer name.
(setq frame-title-format "LooChao@%b")
;; (setq frame-title-format "FIRST THING FIRST / DO IT NOW!!")
(setq icon-title-format "Emacs - %b")

(set-face-background 'isearch "darkCyan")
(set-face-foreground 'isearch "white")
(set-face-background 'region "gray50")

;;; Menu-bar+
(eval-after-load "menu-bar" '(require 'menu-bar+))


;;; Tabbar
(require 'tabbar)
;; (tabbar-mode)
;; (setq tabbar-cycling-scope (quote tabs))

(defun tabbar-buffer-groups ()
  "Return the list of group names the current buffer belongs to.
Return a list of one element based on major mode."
  (list
   (cond
    ((or (get-buffer-process (current-buffer))
         ;; Check if the major mode derives from `comint-mode' or
         ;; `compilation-mode'.
         (tabbar-buffer-mode-derived-p
          major-mode '(comint-mode compilation-mode)))
     "Process"
     )
    ((member (buffer-name)
             '("*scratch*" "*Messages*")) "Common")
    ((member (buffer-name)
             '("gtd.org" "home.org" "other.org" "study.org" "work.org")) "GTD")
    ((eq major-mode 'dired-mode) "Dired")
    ((memq major-mode
           '(help-mode apropos-mode Info-mode Man-mode)) "Help")
    ((memq major-mode
           '(rmail-mode
             rmail-edit-mode vm-summary-mode vm-mode mail-mode
             mh-letter-mode mh-show-mode mh-folder-mode
             gnus-summary-mode message-mode gnus-group-mode
             gnus-article-mode score-mode gnus-browse-killed-mode))
     "Mail")
    (t
     ;; Return `mode-name' if not blank, `major-mode' otherwise.
     (if (and (stringp mode-name)
              ;; Take care of preserving the match-data because this
              ;; function is called when updating the header line.
              (save-match-data (string-match "[^ ]" mode-name)))
         mode-name
       (symbol-name major-mode))
     ))))

(set-face-attribute 'tabbar-default nil
                    :inherit nil
                    :weight 'normal
                    :width 'normal
                    :slant 'normal
                    :underline nil
                    :strike-through nil
                    ;; inherit from frame                   :inverse-video
                    :stipple nil
                    :background "gray80"
                    :foreground "black"
                    ;;              :box '(:line-width 2 :color "white" :style nil)
                    :box nil
                    :family "Lucida Grande")

(set-face-attribute 'tabbar-selected nil
                    :background "gray95"
                    :foreground "gray20"
                    :inherit 'tabbar-default
                    :box '(:line-width 3 :color "grey95" :style nil))
;;                  :box '(:line-width 2 :color "white" :style released-button))

(set-face-attribute 'tabbar-unselected nil
                    :inherit 'tabbar-default
                    :background "gray80"
                    :box '(:line-width 3 :color "grey80" :style nil))

(defface tabbar-selected-highlight '((t
                                      :foreground "black"
                                      :background "gray95"))
  "Face for selected, highlighted tabs."
  :group 'tabbar)

(defface tabbar-unselected-highlight '((t
                                        :foreground "black"
                                        :background "grey75"
                                        :box (:line-width 3 :color "grey75"
                                                          :style nil)))
  "Face for unselected, highlighted tabs."
  :group 'tabbar)

(set-face-attribute 'tabbar-button nil
                    :inherit 'tabbar-default
                    :box nil)

(set-face-attribute 'tabbar-separator nil
                    :background "grey50"
                    :foreground "grey50"
                    :height 1.0)

;; NOT working under win32
(global-set-key (kbd "s-h") 'tabbar-backward-group)
(global-set-key (kbd "s-l") 'tabbar-forward-group)
(global-set-key (kbd "s-j") 'tabbar-backward)
(global-set-key (kbd "s-k") 'tabbar-forward)


;;; Pretty Control L
;(require 'pp-c-l)
;(pretty-control-l-mode 1)

;;; Theme
;; (add-to-list 'load-path (concat emacs-dir "/site-lisp/color-theme"))
;; (require 'color-theme)
;; (color-theme-arjen)

;(set-foreground-color "MistyRose3")
;(set-background-color "Black")

;;; Parentheses
;; Comment this paragraph, so the highlight-parentheses will work.
;; Paren color set in color-theme-lch.el
(if (fboundp 'show-paren-mode)
    (progn
      (show-paren-mode 1)
      (setq show-paren-delay 0)
      (setq show-paren-style 'parentheses)
      ;; (setq show-paren-style 'expression)
      ))

;; Highlight paren when inside (red)
(require 'highlight-parentheses)

;; Have to define global-highlight-parentheses-mode to enable it all the time
(defun turn-on-highlight-parentheses-mode ()
  (highlight-parentheses-mode t))
(define-global-minor-mode global-highlight-parentheses-mode
  highlight-parentheses-mode
  turn-on-highlight-parentheses-mode)
(global-highlight-parentheses-mode)


;;; Line-num
;; vi style set num
(require 'setnu)

;;; Cycle color
(defun lch-cycle-fg-color (num)
  ""
  (interactive "p")
  (let (colorList colorToUse currentState nextState)
    (setq colorList (list
		     "MistyRose3"  "Wheat3" "Wheat2" "OliveDrab" "YellowGreen"))
    (setq currentState (if (get 'lch-cycle-fg-color 'state) (get 'lch-cycle-fg-color 'state) 0))
    (setq nextState (% (+ currentState (length colorList) num) (length colorList)))
    (setq colorToUse (nth nextState colorList))
    (set-frame-parameter nil 'foreground-color colorToUse)
    (redraw-frame (selected-frame))
    (message "Current foreColor is %s" colorToUse)

    (put 'lch-cycle-fg-color 'state nextState))
  )

(defun lch-cycle-fg-color-foward ()
  "Switch to the next color, in the current frame.
See `cycle-color'."
  (interactive)
  (lch-cycle-fg-color 1)
  )
(define-key global-map (kbd "<f11> 1") 'lch-cycle-fg-color-foward)

(defun lch-cycle-fg-color-backward ()
  "Switch to the next color, in the current frame.
See `cycle-color'."
  (interactive)
  (lch-cycle-fg-color -1)
  )
(define-key global-map (kbd "<f11> 2") 'lch-cycle-fg-color-backward)

(defun lch-cycle-bg-color (num)
  ""
  (interactive "p")
  (let (colorList colorToUse currentState nextState)
    (setq colorList (list
		     "Black" "DarkSlateGray"))
    (setq currentState (if (get 'lch-cycle-bg-color 'state) (get 'lch-cycle-bg-color 'state) 0))
    (setq nextState (% (+ currentState (length colorList) num) (length colorList)))
    (setq colorToUse (nth nextState colorList))
    (set-frame-parameter nil 'background-color colorToUse)
    (redraw-frame (selected-frame))
    (message "Current backColor is %s" colorToUse)

    (put 'lch-cycle-bg-color 'state nextState))
  )

(defun lch-cycle-bg-color-foward ()
  "Switch to the next color, in the current frame.
See `cycle-color'."
  (interactive)
  (lch-cycle-bg-color 1)
  )
(define-key global-map (kbd "<f11> 3") 'lch-cycle-bg-color-foward)

(defun lch-cycle-bg-color-backward ()
  "Switch to the next color, in the current frame.
See `cycle-color'."
  (interactive)
  (lch-cycle-bg-color -1)
  )
(define-key global-map (kbd "<f11> 4") 'lch-cycle-bg-color-backward)

;;; Cycle fonts
(defun cycle-font (num)
  "Change font in current frame.
Each time this is called, font cycles thru a predefined set of fonts.
If NUM is 1, cycle forward.
If NUM is -1, cycle backward.
Warning: tested on Windows Vista only."
  (interactive "p")

  ;; this function sets a property ¡°state¡±. It is a integer. Possible values are any index to the fontList.
  (let (fontList fontToUse currentState nextState )
    (setq fontList (list
		    "-outline-Lucida Console-normal-normal-normal-mono-18-*-*-*-c-*-iso8859-1"
		    "-outline-Lucida Console-normal-normal-normal-mono-21-*-*-*-c-*-iso8859-1"
		    "-outline-Lucida Console-normal-normal-normal-mono-24-*-*-*-c-*-iso8859-1"
		    "-outline-Monaco-normal-normal-normal-mono-18-*-*-*-c-*-iso8859-1"
		    "-outline-Monaco-normal-normal-normal-mono-21-*-*-*-c-*-iso8859-1"
		    "-outline-Monaco-normal-normal-normal-mono-24-*-*-*-c-*-iso8859-1"
;		    "-*-Courier New-normal-r-*-*-24-112-96-96-c-*-iso8859-1"
;		    "-outline-Lucida Sans Unicode-normal-normal-normal-sans-24-*-*-*-p-*-iso8859-1"
                    ))
    ;; fixed-width "Courier New" "Unifont"  "FixedsysTTF" "Miriam Fixed" "Lucida Console" "Lucida Sans Typewriter"
    ;; variable-width "Code2000"
    (setq currentState (if (get 'cycle-font 'state) (get 'cycle-font 'state) 0))
    (setq nextState (% (+ currentState (length fontList) num) (length fontList)))

    (setq fontToUse (nth nextState fontList))
    (set-frame-parameter nil 'font fontToUse)
    (redraw-frame (selected-frame))
    (message "Current font is: %s" fontToUse )

    (put 'cycle-font 'state nextState)
    )
  )

(defun cycle-font-foward ()
  "Switch to the next font, in the current frame.
See `cycle-font'."
  (interactive)
  (cycle-font 1)
  )
(define-key global-map (kbd "<f11> 5") 'cycle-font-foward)

(defun cycle-font-backward ()
  "Switch to the previous font, in the current frame.
See `cycle-font'."
  (interactive)
  (cycle-font -1)
  )

(define-key global-map (kbd "<f11> 6") 'cycle-font-backward)

;;; Toggle line space
(defun toggle-line-spacing ()
"Toggle line spacing between no extra space to extra half line height."
(interactive)
(if (eq line-spacing nil)
    (setq-default line-spacing 0.5) ; add 0.5 height between lines
  (setq-default line-spacing nil)   ; no extra heigh between lines
  ))

(define-key global-map (kbd "<f11> l") 'toggle-line-spacing)

;;; W32 max/restore frame
(if lch-win32-p
    (when (fboundp 'w32-send-sys-command)
         (progn
           (defun w32-restore-frame ()
             "Restore a minimized frame"
             (interactive)
             (w32-send-sys-command 61728))
           (defun w32-maximize-frame ()
             "Maximize the current frame"
             (interactive)
             (w32-send-sys-command 61488))
           (define-key global-map (kbd "<f11> m") 'w32-maximize-frame))))

;;; Auto Select Fonts
(defun qiang-font-existsp (font)
  (if (null (x-list-fonts font))
      nil t))

(defvar font-list '("Microsoft Yahei" "文泉驿等宽微米黑" "黑体" "新宋体" "宋体"))
(eval-when-compile (require 'cl)) ;; find-if is in common list package
(find-if #'qiang-font-existsp font-list)

(defun qiang-make-font-string (font-name font-size)
  (if (and (stringp font-size)
           (equal ":" (string (elt font-size 0))))
      (format "%s%s" font-name font-size)
    (format "%s %s" font-name font-size)))

(defun qiang-set-font (english-fonts
                       english-font-size
                       chinese-fonts
                       &optional chinese-font-size)
  "english-font-size could be set to \":pixelsize=18\" or a integer.
If set/leave chinese-font-size to nil, it will follow english-font-size"
  (require 'cl)                         ; for find if
  (let ((en-font (qiang-make-font-string
                  (find-if #'qiang-font-existsp english-fonts)
                  english-font-size))
        (zh-font (font-spec :family (find-if #'qiang-font-existsp chinese-fonts)
                            :size chinese-font-size)))

    ;; Set the default English font
    ;;
    ;; The following 2 method cannot make the font settig work in new frames.
    ;; (set-default-font "Consolas:pixelsize=18")
    ;; (add-to-list 'default-frame-alist '(font . "Consolas:pixelsize=18"))
    ;; We have to use set-face-attribute
    (message "Set English Font to %s" en-font)
    (set-face-attribute
     'default nil :font en-font)

    ;; Set Chinese font
    ;; Do not use 'unicode charset, it will cause the english font setting invalid
    (message "Set Chinese Font to %s" zh-font)
    (dolist (charset '(kana han symbol cjk-misc bopomofo))
      (set-fontset-font (frame-parameter nil 'font)
                        charset
                        zh-font))))
(if (not lch-mac-p)
    (qiang-set-font
     '("Lucida Console" "Monaco" "Consolas" "DejaVu Sans Mono" "Monospace" "Courier New") ":pixelsize=21"
     '("Microsoft Yahei" "文泉驿等宽微米黑" "黑体" "新宋体" "宋体")))

(provide 'lch-ui)
(message "~~ lch-ui: done.")

;;; Local Vars.
;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
