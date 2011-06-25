;-*- coding:utf-8; mode:emacs-lisp; -*-

;>======== BINDING.EL ========<;
;> (info "(emacs)Key Bindings")
(message "=> lch-binding: loading...")

;>-------- Fn map defined in dotEmacs file --------<;
(define-key global-map (kbd "<home>") 'beginning-of-buffer)
(define-key global-map (kbd "<end>") 'end-of-buffer)

;>-------- F2 --------<;
;(define-key global-map (kbd "C-<f2>") 'ediff)
(define-key global-map (kbd "C-<f2>") 'shell)
(define-key global-map (kbd "S-<f2>") 'eshell)
;(define-key global-map (kbd "C-S-<f2>") 'cmd-shell)                          ;; => lch-util.el
;(define-key global-map (kbd "C-M-<f2>") 'msys-shell)                         ;; => lch-util.el

;>-------- Org Mode --------<;



;>-------- Keybinding Table --------<;
;; [from http://www-xray.ast.cam.ac.uk/~gmorris/dotemacs.html]
(defun my-keytable (arg)
  "Print the key bindings in a tabular form."
  (interactive "sEnter a modifier string:")
  (with-output-to-temp-buffer "*Key table*"
    (let* ((i 0)
	   (keys (list "a" "b" "c" "d" "e" "f" "g" "h" "i" "j" "k" "l" "m"
		       "n" "o" "p" "q" "r" "s" "t" "u" "v" "w" "x" "y" "z"
		       "<return>" "<down>" "<up>" "<right>" "<left>"
		       "<home>" "<end>" "<f1>" "<f2>" "<f3>" "<f4>" "<f5>"
		       "<f6>" "<f7>" "<f8>" "<f9>" "<f10>" "<f11>" "<f12>"
		       "1" "2" "3" "4" "5" "6" "7" "8" "9" "0"
		       "`" "~" "!" "@" "#" "$" "%" "^" "&" "*" "(" ")" "-"
		       "_" "=" "+" "\\" "|" "{" "[" "]" "}" ";" "'" ":"
		       "\"" "<" ">" "," "." "/" "?"))
	   (n (length keys))
	   (modifiers (list "" "S-" "C-" "M-" "M-C-"))
	   (k))
      (or (string= arg "") (setq modifiers (list arg)))
      (setq k (length modifiers))
      (princ (format " %-10.10s |" "Key"))
      (let ((j 0))
	(while (< j k)
	  (princ (format " %-28.28s |" (nth j modifiers)))
	  (setq j (1+ j))))
      (princ "\n")
      (princ (format "_%-10.10s_|" "__________"))
      (let ((j 0))
	(while (< j k)
	  (princ (format "_%-28.28s_|"
			 "_______________________________"))
	  (setq j (1+ j))))
      (princ "\n")
      (while (< i n)
	(princ (format " %-10.10s |" (nth i keys)))
	(let ((j 0))
	  (while (< j k)
	    (let* ((binding
		    (key-binding (read-kbd-macro (concat (nth j modifiers)
							 (nth i keys)))))
		   (binding-string "_"))
	      (when binding
		(if (eq binding 'self-insert-command)
		    (setq binding-string (concat "'" (nth i keys) "'"))
		  (setq binding-string (format "%s" binding))))
	      (setq binding-string
		    (substring binding-string 0 (min (length
						      binding-string) 28)))
	      (princ (format " %-28.28s |" binding-string))
	      (setq j (1+ j)))))
	(princ "\n")
	(setq i (1+ i)))
      (princ (format "_%-10.10s_|" "__________"))
      (let ((j 0))
	(while (< j k)
	  (princ (format "_%-28.28s_|"
			 "_______________________________"))
	  (setq j (1+ j))))))
  (delete-window)
;  (hscroll-mode)
  (setq truncate-lines t))


;; You can get a list of all the disabled functions by typing
;; `M-: (let(lst)(mapatoms(lambda(x)(if(get x 'disabled)(push x lst))))lst) RET'


(defmacro rloop (clauses &rest body)
  (if (null clauses)
      `(progn ,@body)
    `(loop ,@(car clauses) do (rloop ,(cdr clauses) ,@body))))

(defun all-bindings ()
  (interactive)
  (message "all-bindings: wait a few seconds please...")
  (let ((data
         (with-output-to-string
           (let ((bindings '()))
             (rloop ((for C in '("" "C-"))       ; Control
                     (for M in '("" "M-"))       ; Meta
                     (for A in '("" "A-"))       ; Alt
                     (for S in '("" "S-"))       ; Shift
                     (for H in '("" "H-"))       ; Hyper
                     (for s in '("" "s-"))       ; super
                     (for x from 32 to 127))
                    (let* ((k (format "%s%s%s%s%s%s%c" C M A S H s x))
                           (key (ignore-errors (read-kbd-macro k))))
                      (when key
                        (push
                         (list k
                               (format "%-12s  %-12s  %S\n" k key
                                       (or
                                        ;; (string-key-binding key)
                                        ;; What is this string-key-binding?
                                        (key-binding key))))
                         bindings))))
             (dolist (item
                      (sort bindings
                            (lambda (a b)
                              (or (< (length (first a))
                                     (length (first b)))
                                  (and (= (length (first a))
                                          (length (first b)))
                                       (string< (first a)
                                                (first b)))))))
               (princ (second item)))))))
    (switch-to-buffer (format "Keybindings in %s" (buffer-name)))
    (erase-buffer)
    (insert data)
    (goto-char (point-min))
    (values)))


(message "~~ lch-binding: done.")
(provide 'lch-binding)
