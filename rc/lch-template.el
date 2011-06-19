;>======== TEMPLATE.EL ========<;

(require 'template)

(template-initialize)
(setq template-default-directories (list (concat emacs-dir "/lib/template")))
(add-to-list 'template-find-file-commands 'ido-exit-minibuffer)

(provide 'lch-template)
