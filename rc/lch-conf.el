; -*- coding: utf-8 -*-

;>========== CONFIGURATION ==========<;
(message "=> lch-conf: loading...")

;(require 'lch-autoloads)
(require 'lch-init)
(require 'lch-ui)
(require 'lch-ui-theme)
(require 'lch-elisp)
;(require 'lch-el-get)
(require 'lch-coding)
(require 'lch-binding)
(require 'lch-mouse)
(require 'lch-template)
(require 'lch-skeleton)
(require 'lch-alias)
(require 'lch-util)
(require 'lch-pgm)
(require 'lch-dict)
;(require 'lch-irc)
(require 'lch-emms)
(require 'lch-web)
(require 'lch-auto-mode)
(require 'lch-z-var)
(require 'lch-dired)
(require 'lch-calendar)
(require 'lch-shell)
(require 'lch-bmk)

(require 'lch-org)
;(require 'lch-org-latex)
(require 'lch-org-export)
(require 'lch-org-agenda)
(require 'lch-outline)

(if lch-win32-p (require 'lch-w32))
(if lch-mac-p (require 'lch-mac))
(if (and lch-mac-p lch-aquamacs-p) (require 'lch-aquamacs))

;(eval-after-load 'dired '(progn (require 'lch-dired)))

;(require 'lch-hl-line)
;(require 'xwl-shell)
(message "~~ lch-conf: done.")
(provide 'lch-conf)
