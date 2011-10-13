;;; color-theme-lch.el

;; Modified from color-theme-arjen

;; This file is NOT part of GNU Emacs

;; This file is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 3, or (at your option)
;; any later version.

;; This file is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to
;; the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Commentary:

;;; Code:

(require 'color-theme)

(defun color-theme-lch ()
  "Color theme by LooChao"
  (interactive)
  (color-theme-install
   '(color-theme-lch
     ((background-color . "black")
      (background-mode . dark)
      (border-color . "black")
      (cursor-color . "burlywood")
      (foreground-color . "MistyRose3")
      (mouse-color . "sienna1"))

     (modeline ((t (:background "DarkRed" :foreground "white" :box (:line-width 1 :style released-button)))))
     (modeline-mousable ((t (:background "DarkRed" :foreground "white"))))
     (modeline-mousable-minor-mode ((t (:background "DarkRed" :foreground "white"))))
                                        ;     (mode-line-buffer-id ((t (:foreground "pink" :bold t))))
     (mode-line-emphasis ((t (:foreground "#99ccff"))))
     (mode-line-highlight ((t (:foreground "#55ff55"))))
     (fringe ((t (:background "black"))))

     (border ((t (:background "black"))))
     (buffer-menu-buffer ((t (:bold t :weight bold))))
     (minibuffer-prompt ((t (:bold t :foreground "DarkSeaGreen"))))
     (bookmark-menu-heading ((t (:foreground "#ffff55"))))

     (font-lock-comment-delimiter-face ((t (:foreground "#999988"))))
     (font-lock-comment-face ((t (:foreground "#999988"))))
     (font-lock-constant-face ((t (:foreground "Aquamarine"))))
     (font-lock-doc-face ((t (:foreground "gray30"))))
     (font-lock-doc-string-face ((t (:foreground "DarkOrange"))))
     (font-lock-end-statement ((t (:foreground "CornflowerBlue"))) t)
     (font-lock-function-name-face ((t (:foreground "YellowGreen"))))
     (font-lock-operator-face ((t (:foreground "LightGoldenrod"))) t)
     (font-lock-keyword-face ((t (:foreground "SlateBlue"))))
     (font-lock-preprocessor-face ((t (:foreground "Aquamarine"))))
     (font-lock-reference-face ((t (:foreground "SlateBlue"))))
     (font-lock-string-face ((t (:foreground "Orange"))))
     (font-lock-type-face ((t (:foreground "Green"))))
     (font-lock-variable-name-face ((t (:foreground "DarkSeaGreen"))))
     (font-lock-warning-face ((t (:bold t :foreground "Pink"))))

     (show-paren-match-face ((t (:background "SlateBlue" :foreground "White"))))
     (show-paren-mismatch-face ((t (:background "Red" :foreground "White"))))
     (emms-playlist-selected-face ((t (:foreground "SteelBlue3"))))
     (emms-playlist-track-face ((t (:foreground "DarkSeaGreen"))))

     (ac-candidate-face ((t (:background "LightGray" :foreground "black"))))
     (ac-completion-face ((t (:background "DarkSeaGreen" :foreground "white"))))
     (ac-selection-face ((t (:background "DarkSeaGreen" :foreground "white"))))
     (ac-yasnippet-candidate-face ((t (:background "sandybrown" :foreground "black"))))
     (ac-yasnippet-selection-face ((t (:background "coral3" :foreground "white"))))

     (yas/field-highlight-face ((t (:background "DimGrey"))))
     (yas/mirror-highlight-face ((t (:background "gray22"))))

     (dired-directory ((t (:foreground "DarkSeaGreen"))))
     (dired-flagged ((t (:bold t :foreground "#ff9966" :weight bold))))
     (dired-header ((t (:foreground "DarkSeaGreen"))))
     (dired-ignored ((t (:foreground "#555555"))))
     (dired-mark ((t (:foreground "#78a355"))))
     (dired-marked ((t (:background "#222222"))))
                                        ;     (dired-perm-write ((t (:background "black" :foreground "#666699" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "outline" :family "Monaco"))))
     (dired-symlink ((t (:foreground "#4682b4"))))
     (dired-warning ((t (:bold t :foreground "#ff6600" :weight bold))))

     (org-agenda-column-dateline ((t (:background "grey30" :strike-through nil :underline nil :slant normal :weight normal :height 113 :family "Monaco"))))
     (org-agenda-date ((t (nil))))
     (org-agenda-date-today ((t (:italic t :bold t :slant italic :weight bold))))
     (org-agenda-date-weekend ((t (:bold t :weight bold))))
     (org-agenda-dimmed-todo-face ((t (:foreground "grey50"))))
     (org-agenda-done ((t (:foreground "PaleGreen"))))
     (org-agenda-restriction-lock ((t (:background "skyblue4"))))
     (org-agenda-structure ((t (:foreground "LightSkyBlue"))))
     (org-archived ((t (:foreground "grey70"))))
     (org-block ((t (:foreground "grey70"))))
     (org-checkbox ((t (:bold t :weight bold))))
     (org-checkbox-statistics-done ((t (nil))))
     (org-checkbox-statistics-todo ((t (nil))))
     (org-clock-overlay ((t (:background "SkyBlue4"))))
     (org-code ((t (:foreground "#555555"))))
     (org-column ((t (:background "grey30" :strike-through nil :underline nil :slant normal :weight normal :height 113 :family "Monaco"))))
     (org-column-title ((t (:bold t :background "grey30" :underline t :weight bold))))
     (org-date ((t (:foreground "#50b7c1"))))
     (org-done ((t (:bold t :foreground "PaleGreen" :weight bold))))
     (org-drawer ((t (:foreground "LightSkyBlue"))))
     (org-ellipsis ((t (:foreground "LightGoldenrod" :underline t))))
     (org-footnote ((t (:foreground "#339900"))))
     (org-formula ((t (:foreground "chocolate1"))))
     (org-headline-done ((t (:foreground "LightSalmon"))))
     (org-hide ((t (:foreground "black"))))
     (org-latex-and-export-specials ((t (:foreground "burlywood"))))
     (org-level-1 ((t (:foreground "YellowGreen" :height 1.1))))
     (org-level-2 ((t (:foreground "DarkSeaGreen" :height 1.0))))
     (org-level-3 ((t (:foreground "LightBlue" :height 1.0))))
     (org-level-4 ((t (:foreground "tomato" :height 1.0))))
     (org-level-5 ((t (:foreground "#b9fc6d"))))
     (org-level-6 ((t (:foreground "#9651cc"))))
     (org-level-7 ((t (:foreground "#f3715c"))))
     (org-level-8 ((t (:foreground "#7ec0ee"))))
     (org-link ((t (:foreground "#cccccc" :underline t))))
     (org-meta-line ((t (:foreground "#95917e"))))
     (org-mode-line-clock ((t (nil))))
     (org-property-value ((t (nil))))
     (org-quote ((t (:inherit org-block :slant italic))))
     (org-scheduled ((t (:foreground "PaleGreen"))))
     (org-scheduled-previously ((t (:foreground "chocolate1"))))
     (org-scheduled-today ((t (:foreground "PaleGreen"))))
     (org-sexp-date ((t (:foreground "#50b7c1"))))
     (org-special-keyword ((t (:foreground "LightSalmon"))))
     (org-table ((t (:foreground "#555555"))))
     (org-tag ((t (:bold t :foreground "#55ff55" :weight bold))))
     (org-target ((t (:underline t))))
     (org-time-grid ((t (:foreground "LightGoldenrod"))))
     (org-todo ((t (:bold t :foreground "#ff5555" :weight bold))))
     (org-upcoming-deadline ((t (:foreground "chocolate1"))))
     (org-verbatim ((t (:foreground "#555555" :underline t))))
     (org-verse ((t (:inherit org-block :slant italic))))
     (org-warning ((t (:bold t :foreground "#ff6600" :weight bold))))

     (outline-1 ((t (:foreground "#FCAF3E"))))
     (outline-2 ((t (:foreground "#4682b4"))))
     (outline-3 ((t (:foreground "#4682b4"))))
     (outline-4 ((t (:foreground "#95917e"))))
     (outline-5 ((t (:foreground "#ffff55"))))
     (outline-6 ((t (:foreground "#78a355"))))
     (outline-7 ((t (:foreground "#f3715c"))))
     (outline-8 ((t (:foreground "#7ec0ee"))))

     (custom-button ((t (:background "lightgrey" :foreground "black" :box (:line-width 2 :style released-button)))))
     (custom-button-mouse ((t (:background "grey90" :foreground "black" :box (:line-width 2 :style released-button)))))
     (custom-button-pressed ((t (:background "lightgrey" :foreground "black" :box (:line-width 2 :style pressed-button)))))
     (custom-button-pressed-unraised ((t (:foreground "violet"))))
     (custom-button-unraised ((t (nil))))
     (custom-changed ((t (:background "blue1" :foreground "white"))))
     (custom-comment ((t (:background "dim gray"))))
     (custom-comment-tag ((t (:foreground "gray80"))))
     (custom-documentation ((t (nil))))
     (custom-face-tag ((t (:bold t :foreground "light blue" :weight bold))))
     (custom-group-tag ((t (:bold t :foreground "light blue" :weight bold :height 1.2 :family "Sans Serif"))))
     (custom-group-tag-1 ((t (:bold t :foreground "pink" :weight bold :height 1.2 :family "Sans Serif"))))
     (custom-invalid ((t (:background "red1" :foreground "yellow1"))))
     (custom-link ((t (:foreground "#7ec0ee"))))
     (custom-modified ((t (:background "blue1" :foreground "white"))))
     (custom-rogue ((t (:background "black" :foreground "pink"))))
     (custom-saved ((t (:underline t))))
     (custom-set ((t (:background "white" :foreground "blue1"))))
     (custom-state ((t (:foreground "lime green"))))
     (custom-themed ((t (:background "blue1" :foreground "white"))))
     (custom-variable-button ((t (:bold t :underline t :weight bold))))
     (custom-variable-tag ((t (:bold t :foreground "light blue" :weight bold))))
     (custom-visibility ((t (:foreground "#7ec0ee" :height 0.8))))

     (font-latex-bold-face ((t (:bold t :foreground "OliveDrab" :weight bold))))
     (font-latex-doctex-documentation-face ((t (:background "#333"))))
     (font-latex-doctex-preprocessor-face ((t (:background "#333"))))
     (font-latex-italic-face ((t (:foreground "OliveDrab" :underline t))))
     (font-latex-math-face ((t (:foreground "burlywood"))))
     (font-latex-sectioning-0-face ((t (:foreground "yellow" :height 1.6105100000000008 :family "Sans Serif"))))
     (font-latex-sectioning-1-face ((t (:foreground "yellow" :height 1.4641000000000006 :family "Sans Serif"))))
     (font-latex-sectioning-2-face ((t (:foreground "yellow" :height 1.3310000000000004 :family "Sans Serif"))))
     (font-latex-sectioning-3-face ((t (:foreground "yellow" :height 1.2100000000000002 :family "Sans Serif"))))
     (font-latex-sectioning-4-face ((t (:foreground "yellow" :height 1.1 :family "Sans Serif"))))
     (font-latex-sectioning-5-face ((t (:foreground "yellow" :family "Sans Serif"))))
     (font-latex-sedate-face ((t (:foreground "LightGray"))))
     (font-latex-slide-title-face ((t (:bold t :weight bold :height 1.2 :family "Sans Serif"))))
     (font-latex-string-face ((t (:foreground "#e6db74"))))
     (font-latex-subscript-face ((t (:height 0.8))))
     (font-latex-superscript-face ((t (:height 0.8))))
     (font-latex-verbatim-face ((t (:foreground "burlywood" :family "Monospace"))))
     (font-latex-warning-face ((t (:bold t :foreground "red" :weight bold))))

     (info-header-node ((t (:italic t :bold t :foreground "white" :slant italic :weight bold))))
     (info-header-xref ((t (:foreground "#7ec0ee"))))
     (info-menu-header ((t (:bold t :weight bold :family "Sans Serif"))))
     (info-menu-star ((t (:foreground "red1"))))
     (info-node ((t (:italic t :bold t :foreground "white" :slant italic :weight bold))))
     (info-title-1 ((t (:bold t :weight bold :height 1.728 :family "Sans Serif"))))
     (info-title-2 ((t (:bold t :weight bold :height 1.44 :family "Sans Serif"))))
     (info-title-3 ((t (:bold t :weight bold :height 1.2 :family "Sans Serif"))))
     (info-title-4 ((t (:bold t :weight bold :family "Sans Serif"))))
     (info-xref ((t (:foreground "#7ec0ee"))))
     (info-xref-visited ((t (:foreground "violet"))))

     (speedbar-button-face ((t (:foreground "green3"))))
     (speedbar-directory-face ((t (:foreground "#cccccc"))))
     (speedbar-file-face ((t (:foreground "wheat"))))
     (speedbar-highlight-face ((t (:background "#333333"))))
     (speedbar-selected-face ((t (:foreground "#ff5500"))))
     (speedbar-separator-face ((t (:background "lightblue" :foreground "black"))))
     (speedbar-tag-face ((t (:foreground "yellow"))))

     (ido-first-match ((t (:foreground "pink"))))
     (ido-incomplete-regexp ((t (:bold t :foreground "#ff6600" :weight bold))))
     (ido-indicator ((t (:background "red1" :foreground "yellow1" :width condensed))))
     (ido-only-match ((t (:foreground "SlateBlue"))))
     (ido-subdir ((t (:foreground "#b9fc6d"))) )


     )))

(provide 'color-theme-lch)
;;; color-theme-lch.el ends here
