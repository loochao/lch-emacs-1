;-*- coding: utf-8 -*-

;>========== W32 ==========<;
(defvar cygwin-root "e:/VAR/VPgm/EMUnixNT/Unix/Cygwin")
(defvar cygwin-bin (concat cygwin-root "/bin"))

(when lch-win32-p 
  (progn
    (setenv "PATH"
            (concat
;FIXME        "C:\\cygwin\\usr\\local\\bin" ";"
;             "C:\\cygwin\\usr\\bin" ";"
;             "C:\\cygwin\\bin" ";"
;             "/usr/bin" ";"
             (getenv "PATH")))

    (setq exec-path
          `(
;            "C:/Program Files/ErgoEmacs 1.8.1/msys/bin/"
	    ,cygwin-root
	    ,cygwin-bin
            (concat cygwin-root "usr/bin/")
;            "C:/Program Files/Java/jdk1.6.0_14/bin/"
;            "C:/Program Files (x86)/Emacs/EmacsW32/gnuwin32/bin/"
            "C:/Windows/system32/"
            "C:/Windows/"
            "C:/Windows/System32/Wbem/"
	    ))))



;>---- Cygwin-mount ----<;
(require 'cygwin-mount)
(cygwin-mount-activate)


(when (and (eq 'windows-nt system-type)
	   (file-readable-p cygwin-root))
  (setq exec-path (cons cygwin-bin exec-path))
  (setenv "PATH" (concat cygwin-bin ";" (getenv "PATH")))

  (setq Info-default-directory-list (append Info-default-directory-list (concat cygwin-root "/usr/info")))

  ;; By default use the Windows HOME.
  ;; Otherwise, uncomment below to set a HOME
  ;;      (setenv "HOME" (concat cygwin-root "/home/loochao"))
  
  ;; NT-emacs assumes a Windows shell. Change to baash.
  (setq shell-file-name "bash")
  (setenv "SHELL" shell-file-name) 
  (setq explicit-shell-file-name shell-file-name)
  (setq ediff-shell shell-file-name)
  (setq explicit-shell-args '("--login" "-i"))
  (setq w32-quote-process-args ?\")

  ;; This removes unsightly ^M characters that would otherwise
  ;; appear in the output of java applications.
  (add-hook 'comint-output-filter-functions 'comint-strip-ctrl-m))

;;;###autoload
(defun bash ()
  "Start `bash' shell."
  (interactive)
  (let ((binary-process-input t)
        (binary-process-output nil))
    (shell)))

(setq process-coding-system-alist
      (cons '("bash" . (raw-text-dos . raw-text-unix)) process-coding-system-alist))

(provide 'lch-w32)
