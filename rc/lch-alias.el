;-*- coding: utf-8 -*-

;>======== ALIAS.EL  ========<;

;; From Leexha:
;; the reason for these aliases is that, often, elisp package names is
;; not intuitive, and should not be the lang name neither. For
;; example, for javascript, those familiar with emacs would intuitive
;; type M-x javascript-mode or M-x js-mode. However, the 2 most robust
;; js packages are called by M-x espresso-mode and M-x
;; js2-mode. Without some insider knowledge, it is difficult to know
;; what function user needs to call for particular major mode he wants.
;; (the mode menu in ErgoEmacs helps, but this is not in GNU Emacs 23)

;; also, due to elisp not having name space, or a enforced
;; package/module/lib naming system etc, package names shouldn't be
;; just the language name. That is, a particular javascript mode
;; really shouldn't be named javascript-mode, because, different
;; people's packages for js will all compete for that name, and
;; prevents the flexibility of testing or using different versions of
;; major mode for that language. Given the way things are, one ideal
;; fix is to always use a alias to point to the mode where ErgoEmacs
;; decides to be the default for that lang. For example, ErgoEmacs
;; bundles 2 major modes for javascript, js2-mode and espresso-mode,
;; and suppose we decided espresso-mode should be the default, then we
;; can define a alias js-mode to point to espresso-mode. This way,
;; user can intuitively load the package for js, but can also load a
;; different one if he has knowledege about which modes exists for the
;; lang he wants.

(message "=> lch-alias: loading...")

(defalias 'ahk-mode 'xahk-mode)
(defalias 'cmd-mode 'dos-mode)
(defalias 'spell-check 'speck-mode)

;; Commands
(defalias 'gf 'grep-find)
(defalias 'fd 'find-dired)
(defalias 'sh 'shell)

(defalias 'qrr 'query-replace-regexp)
(defalias 'lml 'list-matching-lines)
(defalias 'dml 'delete-matching-lines)
(defalias 'rof 'recentf-open-files)
(defalias 'sl 'sort-lines)

;; Modes
(defalias 'hm 'html-mode)
(defalias 'tm 'text-mode)
(defalias 'elm 'emacs-lisp-mode)
(defalias 'vbm 'visual-basic-mode)
(defalias 'vlm 'visual-line-mode)
(defalias 'wsm 'whitespace-mode)

;; Elisp
(defalias 'ee 'eval-expression)
(defalias 'eb 'eval-buffer)
(defalias 'er 'eval-region)
(defalias 'ed 'eval-defun)
(defalias 'ele 'eval-last-sexp)
(defalias 'eis 'elisp-index-search)

(defalias 'ntr 'narrow-to-region)

(message "~~ lch-binding: done.")
(provide 'lch-alias)
