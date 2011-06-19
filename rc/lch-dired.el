;-*- coding: utf-8 -*-

;>======== DIRED ========<;
;; keybinding
;; c: terminal;
;; f: finder;
;; r: wdired;
;; s a: sort-show-all
;; s t: sort-by-date
;; s x: sort-by-extension
;; s z: sort-by-size
;; v: w3m-find-file;
;; V: ywb-w3m-find-file;
;; w: copy filename;
;; z: compress file;
;; * f: find-name-dired;
;; * g: grep-find;

(require 'dired)
(require 'ansi-color)
(require 'dired-aux)
(require 'dired-x)
(require 'dired-single)
(require 'wdired)         ;Part of Emacs since 22, treat dired buffer as file, easy to rename
(require 'xwl-util)       ;To load xwl-shell-command-asynchronously etc.
(ignore-errors (require 'emms-player-mplayer))
;(require 'dired-sort-menu)

;>-- Allows recursive deletes --<;
(setq dired-recursive-deletes 'top)

;>---- Switch infos on/off ----<;
;(require 'dired-details)
;(dired-details-install)
;(setq dired-details-hidden-string " ")
;(require 'dired-details+)

;>---- Set Face ----<;
(eval-after-load 'dired '(progn (require 'dired-filetype-face)))

(setq dired-recursive-copies 'always)
(define-key dired-mode-map (kbd "r") 'wdired-change-to-wdired-mode)
(define-key dired-mode-map (kbd "* f") 'find-name-dired)
(define-key dired-mode-map (kbd "* g") 'grep-find)
(define-key dired-mode-map (kbd "w") (lambda ()
                                       (interactive)
                                       (dired-copy-filename-as-kill 0)))
;>-------- Util --------<;
;>---- Open current directory in Finder, Explorer, etc. ----<;
(define-key dired-mode-map (kbd "f")
  '(lambda ()
     (interactive)
     (let ((d (dired-current-directory)))
       (case window-system
         ((w32)
          (w32-shell-execute "open" d))
         ((ns mac)
          (xwl-shell-command-asynchronously (format "open -a Finder %s" d)))
         ((x)
          (xwl-shell-command-asynchronously (concat "nautilus --browser " d)))))))

;>---- Open current directory in a console/terminal ----<;
(define-key dired-mode-map (kbd "c")
  '(lambda ()
     (interactive)
     (let ((d (dired-current-directory)))
       (case window-system
         ((w32)
          (xwl-shell-command-asynchronously "start cmd.exe"))
         ((ns mac)
          (do-applescript (format "
tell application \"Terminal\"
  activate
  do script \"cd '%s'; bash\"
end tell" d)))
         ((x)
          (xwl-shell-command-asynchronously "gnome-terminal"))))))

(defun xwl-dired-w3m-find-file ()
  (interactive)
  (let ((file (file-name-nondirectory (dired-get-filename))))
    (if (y-or-n-p (format "Use emacs-w3m to browse %s? " file))
	(w3m-find-file file))))
(define-key dired-mode-map (kbd "v") 'xwl-dired-w3m-find-file)

;> Use tar to compress marked file or dir.
;; On Compressed file, uncompress it instead.
(defun ywb-dired-compress-dir ()
  (interactive)
  (let ((files (dired-get-marked-files t)))
    (if (and (null (cdr files))
             (string-match "\\.\\(tgz\\|tar\\.gz\\)" (car files)))
        (shell-command (concat "tar -xvf " (car files)))
      (let ((cfile (concat (file-name-nondirectory
                            (if (null (cdr files))
                                (car files)
                              (directory-file-name default-directory))) ".tgz")))
        (setq cfile
              (read-from-minibuffer "Compress file name: " cfile))
        (shell-command (concat "tar -zcvf " cfile " " (mapconcat 'identity files " ")))))
    (revert-buffer)))

;> Similar to TC, use the SAME buffer to quickview files
(defvar ywb-dired-quickview-buffer nil)
(defun ywb-dired-quickview ()
  (interactive)
  (if (buffer-live-p ywb-dired-quickview-buffer)
      (kill-buffer ywb-dired-quickview-buffer))
  (setq ywb-dired-quickview-buffer
        (find-file-noselect (dired-get-file-for-visit)))
  (display-buffer ywb-dired-quickview-buffer))

;;;###autoload
(defun ywb-dired-w3m-visit ()
  (interactive)
  (let ((file (dired-get-filename nil t)))
    (w3m-goto-url
     (if (string-match "^[a-zA-Z]:" file)
         (ywb-convert-cygwin-path file)
       (concat "file://" file)))))

;> Use W to get filename.
;; C-1 W to get Windows path.
;; C-2 W to get Cygwin path.
;; C-3 W to get Windows dir path.
;;;###autoload
(defun ywb-dired-copy-fullname-as-kill (&optional arg)
  "In dired mode, use key W to get the full name of the file"
  (interactive "P")
  (let (file)
    (setq file (dired-get-filename nil t))
    (or (not arg)
        (cond ((= arg 1)
               (setq file (convert-standard-filename file)))
              ((= arg 2)
               (setq file (ywb-convert-to-cygwin-path file)))
              ((= arg 3)
               (setq file (convert-standard-filename (file-name-directory file))))))
    (if (eq last-command 'kill-region)
        (kill-append file nil)
      (kill-new file))
    (message "%s" file)))

;> Cygwin path conversion
(defun ywb-convert-to-cygwin-path (path)
  (concat "file:///cygdrive/" (substring path 0 1) (substring path 2)))
(defun ywb-convert-cygwin-path (path)
  (setq path (substring path 17))
  (concat (substring path 0 1) ":" (substring path 1)))


(add-hook 'dired-mode-hook (lambda ()
(define-key dired-mode-map "z" 'ywb-dired-compress-dir)
(define-key dired-mode-map "V" 'ywb-dired-w3m-visit)
(define-key dired-mode-map "W" 'ywb-dired-copy-fullname-as-kill)
(define-key dired-mode-map "\C-q" 'ywb-dired-quickview)))

;>-------- Omit --------<;
(setq dired-omit-size-limit nil)

(setq dired-omit-files
      (concat "^\\.?#\\|^\\.$\\|^\\.\\.$\\|^#.*#$\\|^nohup.out$\\|\\.jlc$"
              "\\|\\$NtUninstallKB.*\\|"
              (regexp-opt '("TAGS" "cscope.out" "distribution.policy.s60"
                            "Distribution.Policy.S60"))))

(setq dired-omit-extensions
      '("CVS/" ".o" "~" ".bin" ".lbin" ".fasl" ".ufsl" ".ln" ".blg"
	".bbl" ".elc" ".lof" ".glo" ".idx" ".lot" ".fmt" ".tfm"
	".class" ".fas" ".x86f" ".sparcf" ".lo" ".la"
	".toc" ".aux" ".cp" ".fn" ".ky" ".pg" ".tp" ".vr" ".cps"
	".fns" ".kys" ".pgs" ".tps" ".vrs" ".pyc" ".pyo" ".idx" ".lof"
	".lot" ".glo" ".blg" ".bbl" ".cp" ".cps" ".fn" ".fns" ".ky"
	".kys" ".pg" ".pgs" ".tp" ".tps" ".vr" ".vrs" ".flc"
        ".hi" ".p_hi" ".p_o" ".hi-boot" ".o-boot" ".p_o-boot"
        ".p_hi-boot" ".hs-boot" ".obj" ".ncb" ".suo" ".user" ".idb"
        ".pdb" ".moc" ".manifest" ".ilk"))

;>-------- Sort --------<;
(setq dired-listing-switches "-lh")

;; Sort methods that affect future sessions
(defun dired-sort-by-default ()
  (interactive)
  (setq dired-listing-switches "-lh")
  (dired-sort-other dired-listing-switches))

(defun dired-sort-by-ctime ()
  "Dired sort by create time."
  (interactive)
  (dired-sort-other (concat dired-listing-switches "ct")))

(defun dired-sort-by-utime ()
  "Dired sort by access time."
  (interactive)
  (dired-sort-other (concat dired-listing-switches "ut")))

(defun dired-sort-by-time ()
  "Dired sort by time."
  (interactive)
  (dired-sort-other (concat dired-listing-switches "t")))

(defun dired-sort-by-name ()
  "Dired sort by name."
  (interactive)
  (dired-sort-other (concat dired-listing-switches "")))

(defun dired-sort-by-show-all ()
  (interactive)
  (setq dired-listing-switches "-lhA")
  (dired-sort-other dired-listing-switches))

;; Sort methods that affect current session only
(defun dired-sort-by-date ()
  (interactive)
  (dired-sort-other
   (concat dired-listing-switches "t")))

;; FIXME: fix this for mac. like: ls | rev | sort | rev
(defun dired-sort-by-extenstion ()
  (interactive)
  (dired-sort-other
   (concat dired-listing-switches "X")))

;; FIXME
(defun dired-sort-by-invisible-only ()
  (interactive)
  (dired-sort-other
   (concat dired-listing-switches "d .*")))

(defun dired-sort-by-size ()
  (interactive)
  (dired-sort-other
   (concat dired-listing-switches "S")))

(define-key dired-mode-map (kbd "s") nil)
(define-key dired-mode-map (kbd "s RET") 'dired-sort-by-default)
(define-key dired-mode-map (kbd "s a") 'dired-sort-by-show-all)
(define-key dired-mode-map (kbd "s t") 'dired-sort-by-date)
(define-key dired-mode-map (kbd "s x") 'dired-sort-by-extenstion)
(define-key dired-mode-map (kbd "s .") 'dired-sort-by-invisible-only)
(define-key dired-mode-map (kbd "s z") 'dired-sort-by-size)

;>-------- Binding --------<;
(define-key dired-mode-map (kbd "M-<") (lambda ()
                                         (interactive)
					 (goto-char (point-min))
                                         (dired-next-line 2)))

(define-key dired-mode-map (kbd "M->") (lambda ()
                                         (interactive)
					 (goto-char (point-max))
                                         (dired-previous-line 1)))
;>- TC-like F4 View file
;(define-key dired-mode-map (kbd "<f4>") 'dired-find-file)
;(define-key dired-mode-map (kbd "<f7>") 'dired-create-directory)

;>-------- Dired mode hook --------<;
;; if dired's already loaded, then the keymap will be bound

(defun lch-dired-mode-init ()
  ;> Dired-Omit-Mode (provided in dired-x mode)
  ;; lets you hide uninteresting files
  ;; such as backup files and AutoSave  files
  (dired-omit-mode 1)
  
  (local-unset-key (kbd "<up>"))
  (local-unset-key (kbd "<down>"))
  (local-unset-key (kbd "<left>"))
  (local-unset-key (kbd "<right>"))
;  (define-key dired-mode-map (kbd "6") 'dired-up-directory)
  (define-key dired-mode-map (kbd "6")  '(lambda () (interactive) (joc-dired-single-buffer "..")))
  (define-key dired-mode-map [return] 'joc-dired-single-buffer)
  (define-key dired-mode-map [mouse-1] 'joc-dired-single-buffer-mouse)
  (lambda () (require 'dired-sort-menu))
  (hl-line-mode))

(if (boundp 'dired-mode-map)
        ;; we're good to go; just add our bindings
        (lch-dired-mode-init)
  ;; it's not loaded yet, so add our bindings to the load-hook
  (add-hook 'dired-load-hook 'lch-dired-mode-init))

(define-key global-map (kbd "<C-f3>") 'joc-dired-magic-buffer)
(define-key global-map (kbd "<M-f3>") 'joc-dired-toggle-buffer-name)

(provide 'lch-dired)
