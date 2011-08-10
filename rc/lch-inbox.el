;>======== INBOX.EL -- TEST SETTING ========<;

;>-------- W3M --------<;

(defun google-file (file)
  "Use google to search for a file named FILE."
  (interactive "sSearch for file: ")
  (w3m-browse-url
   (concat "http://www.google.com/search?q="
           (w3m-url-encode-string
            (concat "+intitle:\"index+of\" -inurl:htm -inurl:html -inurl:php "
                    file)))))

(defun google-file-ffx (file)
  (interactive "sSearch for file: ")
  (browse-url
   (concat "http://www.google.com/search?q=" "+intitle:\"index+of\" -inurl:htm -inurl:html -inurl:php " file)))

;>-------- UTILS --------<;
(defun insert-date (prefix)
  "Insert the current date. With prefix-argument, use ISO format. With
   two prefix arguments, write out the day and month name."
  (interactive "P")
  (let ((format (cond
		 ((not prefix) "%d.%m.%Y")
		 ((equal prefix '(4)) "%Y-%m-%d")
		 ((equal prefix '(16)) "%A, %d. %B %Y")))
	(system-time-locale "En"))
    (insert (format-time-string format))))





