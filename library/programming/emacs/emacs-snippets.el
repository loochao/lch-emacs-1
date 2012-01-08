(defun test()
  (interactive)
  (let (lch-buffer (current-buffer))
  (set-buffer (get-buffer-create "loochao"))
  (erase-buffer)
  (insert "test")

  (sit-for 3)
  (switch-to-buffer lch-buffer))
  )


  (newline 9)

  (insert (propertize "bar" 'face '(:foreground "#33AAFF")))

  (setq lst '(("hello" 5)
              ("later" 2)
              ("bye" 3)))
  (dolist (item lst)
    (dotimes (x (nth 1 item))
      (insert (nth 0 item))))

  (setq lst '("do" "re" "me" "fa"))
  (dolist (i lst)
    (insert i))

  (setq lst (cons '(2 3) '(8 88)))
  (insert (number-to-string (car lst)))
  (insert (number-to-string (length lst)))

  (insert (file-name-directory (buffer-name (other-buffer))))

  (setq ps (point))
  (insert (number-to-string ps))

  (insert-file-contents "~/Dropbox/.emacs.d/rc/lch-init.el")
  (re-search-forward "^lch" nil 2)

  (erase-buffer)
  (insert "Here I am!")
  (insert-file-contents "~/Dropbox/.emacs.d/rc/lch-init.el")
  (forward-char 20)
  (goto-char 588)
  (dotimes '100 (insert "Kaka\n"))
  (insert (buffer-name))
  (insert "\t")
  (insert (number-to-string (buffer-size)))

  (cd "~")
  (unless (file-exists-p "test")
    (make-directory "test"))
  (cd "test")
  (with-temp-buffer
    (insert "loochao")
    (newline)
    ;; (let (lst (directory-files "."))
    ;;      (insert (car lst)))
    (write-region (point-min) (point-max) "loochao")
    )
  (find-file "loochao")

    (goto-char (point-max))
    (insert (number-to-string (point)))
    (newline)
    (insert 31)

    (insert (format-time-string "%Y%M%D_%H%M%S"))
    (newline)

    (dotimes (i (random 5)) (insert "#"))
