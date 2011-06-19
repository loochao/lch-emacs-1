;-*- coding: utf-8 -*-

;>========== MAC ==========<;
;> Use Spotlight as locate in OSX
(setq locate-command "mdfind")

;> Define a function to setup additional path
(defun my-add-path (path-element)
"Add the specified path element to the Emacs PATH"
   (interactive "DEnter directory to be added to path: ")
       (if (file-directory-p path-element)
          (setenv "PATH"
            (concat (expand-file-name path-element)
              path-separator (getenv "PATH")))))

;> Set localized PATH for OS X
(if (fboundp 'my-add-path)
    (let ((my-paths (list
                     "/opt/local/bin"
                     "/usr/local/bin"
                     "/usr/local/sbin"
                     "~/bin")))
      (dolist (path-to-add my-paths (getenv "PATH"))
        (my-add-path path-to-add))))
(provide 'lch-mac)
