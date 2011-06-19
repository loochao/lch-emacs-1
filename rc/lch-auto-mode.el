;-*- coding: utf-8 -*-

;>======== AUTO-MODE-ALIST ========<;
(message "=> lch-auto-mode: loading...")
(setq auto-mode-alist
      (append '(
                ("\\.css\\'"                           . css-mode)
;                ("\\.\\(htm\\|html\\|xhtml\\)$"        . nxhtml-mode)
;                ("\\.sql$"                             . sql-mode)
;;                ("\\.js$"                              . java-mode)

                ;; sorted by chapter
                ("\\.\\(diffs?\\|patch\\|rej\\)\\'"    . diff-mode)
                ("\\.txt$"                             . org-mode)
                ("\\.dat$"                             . ledger-mode)

                ("\\.log$"                             . text-mode)
                ("\\.tex$"                             . LaTeX-mode)
                ("\\.tpl$"                             . LaTeX-mode)
                ("\\.cgi$"                             . perl-mode)
                ("[mM]akefile"                         . makefile-mode)
                ("\\.bash$"                            . shell-script-mode)
                ("\\.expect$"                          . tcl-mode)

                (".ssh/config\\'"                      . ssh-config-mode)
                ("sshd?_config\\'"                     . ssh-config-mode)
                ) auto-mode-alist))

(message "~~ lch-auto-mode: done.")
(provide 'lch-auto-mode)