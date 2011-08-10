;;;; Leisureread by wolfgang 2011-7-12 10:55 ver1.3

(require 'bookmark)
(when (not (file-exists-p bookmark-default-file))
  (bookmark-save))
(bookmark-load bookmark-default-file t t)

(defvar *leisureread-my-book-path* "./leisureread.txt")
(defvar *leisureread-bookmark-name* "leisureread")
(defvar *leisureread-window-height* 1)

(defun leisureread-initialize-bookmark-if-necessary ()
  ;; if no previous bookmark, create it at first line
  (when (or (null bookmark-alist)
            (null (assoc *leisureread-bookmark-name* bookmark-alist)))
    (find-file *leisureread-my-book-path*)
    (bookmark-set *leisureread-bookmark-name*)
    (bury-buffer))
  ;; if not opened book.txt yet, open it and keep it open
  (when (not (get-file-buffer *leisureread-my-book-path*))
    (save-excursion
      (find-file *leisureread-my-book-path*)
      (bookmark-jump *leisureread-bookmark-name*)
      (bury-buffer))))

(defun leisureread-line-prefix ()
  (concat comment-start "+"))

(defun leisureread-decorate-lines (text)
  (let ((lines (split-string text "\n")))
    (let ((decorated-lines
           (mapcar (lambda (line) (concat (leisureread-line-prefix) line))
                   lines)))
      (reduce (lambda (acc next) (concat acc "\n" next))
              decorated-lines))))


(defun leisureread-on-leisure-line-p ()
  (let ((text (buffer-substring-no-properties
                  (line-beginning-position)
                  (line-end-position))))
    (start-with-p text (leisureread-line-prefix))))

(defun start-with-p (big small)
  (and (>= (length big) (length small))
              (string= small (substring big 0 (length small)))))

(defun leisureread-clear-line ()
  (interactive)
  (while (leisureread-on-leisure-line-p)
    (kill-whole-line)))

(defun leisureread-insert-next-line ()
  (interactive)
  (leisureread-insert-line 'forward-line))

(defun leisureread-insert-previous-line ()
  (interactive)
  (leisureread-insert-line 'previous-line))

(defun leisureread-insert-line (func)
  (leisureread-initialize-bookmark-if-necessary)
  (move-beginning-of-line nil)
  (let ((text ""))
    (while (<= (length text) 1)
      (save-excursion
        (set-buffer (get-file-buffer *leisureread-my-book-path*))
        (funcall func)
        (setq text (buffer-substring-no-properties
                    (line-beginning-position)
                    (line-end-position *leisureread-window-height*)))
        (bookmark-set *leisureread-bookmark-name*)
        (bury-buffer)))
    (save-excursion
      (leisureread-clear-line)
      (insert (leisureread-decorate-lines text))
      (newline))))

(provide 'leisureread)