;;-*- coding:utf-8; mode:emacs-lisp; -*-

;;; WEB.EL
;;
;; Copyright (c) 2006 2007 2008 2009 2010 2011 Chao LU
;;
;; Author: Chao LU <loochao@gmail.com>
;; URL: http://www.princeton.edu/~chaol

;; This file is not part of GNU Emacs.

;;; Commentary:

;; ;; Under MAC, has to install w3m through port, and add /opt/local to PATH
;; Have to use the CVS version of w3m for Emacs23
;; % cvs -d :pserver:anonymous@cvs.namazu.org:/storage/cvsroot login
;; CVS password: # No password is set.  Just hit Enter/Return key.
;; % cvs -d :pserver:anonymous@cvs.namazu.org:/storage/cvsroot co emacs-w3m

;; `w3m-browse-url' asks Emacs-w3m to browse a URL.

;; When JavaScript is needed or the "design" is just too bad, use another
;; browser: you can open the page in your graphical browser (at your own
;; risk) by hitting `M' (`w3m-view-url-with-external-browser').
;; For what "risk" means, please see: (info "(emacs-w3m)Gnus")

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code
(if lch-win32-p (add-to-list 'exec-path (concat emacs-dir "/bin/w3m")))
;(setq w3-default-stylesheet "~/.default.css")
(require 'w3m)
(require 'w3m-lnum)

(defvar w3m-buffer-name-prefix "*w3m" "Name prefix of w3m buffer")
(defvar w3m-buffer-name (concat w3m-buffer-name-prefix "*") "Name of w3m buffer")
(defvar w3m-bookmark-buffer-name (concat w3m-buffer-name-prefix "-bookmark*") "Name of w3m buffer")

;;; General Setting
(defvar w3m-dir (concat emacs-var-dir "/w3m") "Dir of w3m.")

(setq w3m-icon-directory (concat w3m-dir "/icons"))
(setq w3m-default-save-directory "~/Downloads")
(setq w3m-bookmark-file (concat w3m-dir "/w3m-bookmark.html"))
(setq w3m-cookie-file (concat w3m-dir "/w3m-cookie"))
(setq w3m-session-file (concat w3m-dir "/w3m-session"))

(setq w3m-use-cookies t)
(setq w3m-home-page "http://www.princeton.edu/~chaol")
(setq w3m-use-favicon nil)
(setq w3m-horizontal-shift-columns 1)

(setq w3m-use-header-line-title t)
(setq w3m-view-this-url-new-session-in-background t)
(setq w3m-new-session-in-background t)
(setq w3m-session-time-format "%Y-%m-%d %A %H:%M")      ;上次浏览记录的时间显示格式
(setq w3m-favicon-use-cache-file t)                     ;使用网站图标的缓存文件
(setq w3m-show-graphic-icons-in-mode-line nil)          ;在mode-line显示网站图标
(setq w3m-keep-arrived-urls 50000)                      ;浏览历史记录的最大值
(setq w3m-keep-cache-size 1000)                         ;缓存的大小
(setq w3m-default-display-inline-images nil)            ;默认不显示网页中的图像
(setq w3m-toggle-inline-images-permanently t)           ;继续保持当前buffer的图像状态
(setq w3m-enable-google-feeling-lucky nil)              ;禁止使用 Google Lucky
(setq w3m-use-filter t)                                 ;开启过滤
(setq w3m-fb-mode t)                                    ;让标签和创建它的FRAME关联
(setq w3m-session-load-crashed-sessions t)              ;默认加载崩溃的对话
(w3m-fb-mode 1)                                         ;可以显示FRAME
(setq w3m-edit-function (quote find-file-other-window)) ;在其他窗口编辑当前页面
(setq w3m-session-deleted-save nil)                     ;关闭一个标签时不保存

;;; Set browse function to firefox/w3m
(if lch-mac-p
    (progn
      (defun browse-url-firefox-macosx (url &optional new-window)
        (interactive (browse-url-interactive-arg "URL: "))
        (start-process (concat "open -a Firefox" url) nil "open" url))
      (setq browse-url-browser-function 'browse-url-firefox-macosx)))

(defun lch-browse-url-firefox ()
  (interactive)
  (let (url (w3m-print-current-url))
    (start-process (concat "open -a Firefox" url) nil "open" url)))

;; Set browse function to be w3m
(setq browse-url-browser-function 'w3m-browse-url)
(autoload 'w3m-browse-url "w3m" "Ask a WWW browser to show a URL." t)

(define-key global-map (kbd "C-x m") 'browse-url-at-point)

;;; Proxy
;; proxy settings example, just uncomment to use.
;; (when (string= (upcase (system-name)) "PC3701")
;;   (eval-after-load "w3m"
;;     '(setq w3m-command-arguments
;; 	   (nconc w3m-command-arguments
;; 		  '("-o" "http_proxy=http://proxy:8080"))))
;; FIXME https_proxy for HTTPS support
;;   (setq w3m-no-proxy-domains '("local.com" "sysdoc")))

;;; Arguments
(setq w3m-command-arguments '("-cookie" "-F")
      ;; w3m-command-arguments
      ;;       (append w3m-command-arguments
      ;;               ;; '("-o" "http_proxy=http://222.43.34.94:3128/"))
      ;;               '("-o" "http_proxy="))
      ;;       w3m-no-proxy-domains '(".edu.cn,166.111.,162.105.,net9.org"))
        )

;;; Modeline
(setq w3m-process-modeline-format " loaded: %s")

;;; Tab
(define-key w3m-mode-map (kbd "<C-tab>") 'w3m-next-buffer)
(define-key w3m-mode-map [(control shift iso-lefttab)] 'w3m-previous-buffer)

(defun w3m-new-tab ()
  (interactive)
  (w3m-copy-buffer nil nil nil t))
(define-key w3m-mode-map (kbd "C-t") 'w3m-new-tab)

(defun my-w3m-rename-buffer (url)
  "base buffer name on title"
  (let* ((size 32)
         (title w3m-current-title)
         (name (truncate-string-to-width
                (replace-regexp-in-string " " "_" title)
                size)))
    (rename-buffer name t)))
(add-hook 'w3m-display-hook 'my-w3m-rename-buffer)

(defadvice w3m-modeline-title (around my-w3m-modeline-title)
  "prevent original function from running; cleanup remnants"
  (setq w3m-modeline-separator ""
        w3m-modeline-title-string ""))
(ad-activate 'w3m-modeline-title)

;;; Google filter
(defun my-w3m-filter-rules-for-google (&rest args)
  "Filter rules for Google in w3m."
  (goto-char (point-min))
  (while (re-search-forward             ;remove publicize from google.cn or google.com
          "\\(赞助商链接\\|<h2>Sponsored Links</h2>\\).*aclk.*\\(</cite></ol><p>\\|在此展示您的广告\\)"
          nil t)
    (replace-match ""))
  (while (re-search-forward             ;remove publicize from google.com (English)
          "<h2>Sponsored Links</h2>.*aclk.*<h2>Search Results</h2>"
          nil t)
    (replace-match "")))
(eval-after-load "w3m-filter"
  '(add-to-list 'w3m-filter-rules
                '("\\`http://www\\.google\\.\\(cn\\|com\\)/"
                  my-w3m-filter-rules-for-google)))

;;; Utils
(defun lch-switch-to-w3m ()
  "Switch to an existing w3m buffer or look at bookmarks."
  (interactive)
  (let ((buf (get-buffer "*w3m*")))
    (if buf
        (switch-to-buffer buf)
       (w3m)
;      (w3m-bookmark-view)
      )))
(define-key global-map (kbd "<f3> <f2>") 'lch-switch-to-w3m)

(defun lch-w3m-goto-url ()
  "Type in directly the URL I would like to visit (avoiding to hit `C-k')."
  (interactive)
  (let ((w3m-current-url ""))
    (call-interactively 'w3m-goto-url)))

(defun lch-switch-to-w3m-goto-url ()
  (interactive)
  (let ((buf (get-buffer "*w3m*"))
        (w3m-current-url ""))
    (if buf
        (switch-to-buffer buf)
      (w3m))
    (w3m-new-tab)
    (call-interactively 'w3m-goto-url)
    ))
(define-key global-map (kbd "C-z C-f") 'lch-switch-to-w3m-goto-url)
(define-key global-map (kbd "<f3> <f3>") 'lch-switch-to-w3m-goto-url)

(defun lch-w3m-goto-location ()
  (interactive)
  (let (mylocation)
  (setq mylocation (read-string "Goto URL: "))
  (w3m-browse-url mylocation)
  ))

;;; Cookie
;; functions for cookie processing
(when (require 'w3m-cookie)
  ;; ask user whether accept bad cookies or not
  (setq w3m-cookie-accept-bad-cookies 'ask)
  ;; list of trusted domains
  (setq w3m-cookie-accept-domains
	'("google.com"
	  "yahoo.com" ".yahoo.com"
	  "groups.yahoo.com"
	  )))

;;; w3m-lnum
;; FIXME toggle a minor mode showing link numbers
;; (when (require 'w3m-lnum)

;;   (defun my-w3m-go-to-linknum ()
;;     "Turn on link numbers and ask for one to go to."
;;     (interactive)
;;     (let ((active w3m-link-numbering-mode))
;;       (when (not active) (w3m-link-numbering-mode))
;;       (unwind-protect
;; 	  (w3m-move-numbered-anchor (read-number "Anchor number: "))
;; 	(when (not active) (w3m-link-numbering-mode))
;; 	(w3m-view-this-url))))

;;   (define-key w3m-mode-map (kbd "f") 'my-w3m-go-to-linknum)

;;   ;; enable link numbering mode by default
;;   (add-hook 'w3m-mode-hook 'w3m-link-numbering-mode))


;;; Delicious
;; FIXME
(defun lch-delicious-url ()
  "Post either the url under point or the url of the current w3m page to delicious."
  (interactive)
  (let ((w3m-async-exec nil))
    (if (thing-at-point-url-at-point)
        (unless (eq (current-buffer) (w3m-alive-p))
          (w3m-goto-url (thing-at-point-url-at-point))))
    (w3m-goto-url
     (concat "http://del.icio.us/loochao?"
             "url="    (w3m-url-encode-string w3m-current-url)
             "&title=" (w3m-url-encode-string w3m-current-title)))))
(define-key global-map (kbd "<f1> d") 'lch-delicious-url)

;;; Wget
(setq wget-download-directory "~/Downloads")

(defun w3m-download-with-wget (loc)
  (interactive "DSave to: ")
  (let ((url (or (w3m-anchor) (w3m-image))))
    (if url
        (let ((proc (start-process "wget" (format "*wget %s*" url)
                                   "wget" "--passive-ftp" "-nv"
                                   "-P" (expand-file-name loc) url)))
          (with-current-buffer (process-buffer proc)
            (erase-buffer))
          (set-process-sentinel proc (lambda (proc str)
                                       (message "wget download done"))))
      (message "Nothing to get"))))

(defun w3m-download-with-curl (loc)
  (define-key w3m-mode-map "c"
    (lambda (dir)
      (interactive "DSave to: ")
      (cd dir)
      (start-process "curl" "*curl*" "curl.exe" "-O" "-s" (w3m-anchor)))))
;;; Search
(defun google ()
  "Googles a query or region if any."
  (interactive)
  (browse-url
   (concat
    "http://www.google.com/search?ie=utf-8&oe=utf-8&q="
    (if mark-active
        (buffer-substring (region-beginning) (region-end))
      (read-string "Google: ")))))

;; FIXME search by firefox doesn't work.
(when (require 'w3m-search)
  (define-key global-map (kbd "<f3> s") 'w3m-search)
  (add-to-list 'w3m-search-engine-alist
	       '("teoma" "http://www.teoma.com/search.asp?t=%s" nil)))

(defvar lch-search-engine-alist
      '(("google" . "http://www.google.com/search?q=")
        ("wikipedia" . "http://en.wikipedia.org/wiki/")
        ("baidu" . "http://www.baidu.com/s?wd=")
        ("definition" . "http://www.answers.com/main/ntquery?s=")
        ("google-file" . "http://www.google.com/search?q=+intitle:\"index+of\" -inurl:htm -inurl:html -inurl:php")
        ("ciba" . "http://www.iciba.com/")
        ))

(defun lch-w3m-browse-url (myurl)
  (interactive)
  (let ((buf (get-buffer "*w3m*"))
        (w3m-current-url ""))
    (if buf
        (switch-to-buffer buf)
      (w3m))
    (w3m-new-tab)
    (w3m-browse-url myurl)
    ))

(defun lch-search-by (engine browser &optional symbolp)
  "search by various engine in browsers.
   When symbolp is nil, search by input; true, search by symbol-at-point"
 (interactive)
 (let (myword myengine myurl)
   (if symbolp
       (progn
            (setq myword
                  (if (and transient-mark-mode mark-active)
                      (buffer-substring-no-properties (region-beginning) (region-end))
                    (thing-at-point 'symbol)))
            (cond ((string= engine "definition") (setq myword (replace-regexp-in-string " " "%20" myword)))
                  (t (setq myword (replace-regexp-in-string " " "_" myword)))))
     (progn (setq myword (read-string (concat engine "(" browser "): ")))))

   (setq myengine (cdr (assoc engine lch-search-engine-alist)))
   (setq myurl (concat myengine myword))

   (cond ((string= browser "ffx") (browse-url myurl))
         ((string= browser "w3m") (lch-w3m-browse-url myurl))
         (t (lch-w3m-browse-url myurl))
   )))

(defun lch-search-w3m-google ()
  (interactive)
  (lch-search-by "google" "w3m" nil))

(defun lch-search-ffx-google ()
  (interactive)
  (lch-search-by "google" "ffx" nil))

;; (defvar lch-engine-key-alist
;;   '(("1" . "google")
;;     ("2" . "wikipedia")
;;     ("3" . "badidu")
;;     ("4" . "ffx")
;;     ("7" . "ciba")))

;; (defvar lch-browser-key-alist
;;   '(("1" . "ffx")
;;     ("2" . "w3m")
;;     ))

;; FIXME (kbd var) won't work, kbd won't accept variable
;; (dolist (lch-engine lch-engine-key-alist)
;;   (dolist (lch-browser lch-browser-key-alist)
;;     (let ((engine-key  (car lch-engine))
;;           (engine-name (cdr lch-engine))
;;           (browser-key (car lch-browser))
;;           (browser-name (cdr lch-browser)))
;;       (cond ((string= browser-name "ffx") (setq lch-search-key-prefix "<f1>"))
;;             ((string= browser-name "w3m") (setq lch-search-key-prefix "<f2>"))
;;             (t (setq lch-search-key-prefix "<f2>")))
;;       (setq lch-direct-search-key (concat lch-search-key-prefix " " "<f" engine-key ">")
;;             lch-symbol-search-key (concat lch-search-key-prefix " " engine-key))
;;       (define-key global-map (kbd (eval lch-direct-search-key)) '(lambda() (interactive) (lch-search-by engine-name browser-name nil)))
;;       (define-key global-map (kbd lch-symbol-search-key) '(lambda() (interactive) (lch-search-by engine-name browser-name nil)))
;;       )))
(global-unset-key (kbd "M-="))
(global-unset-key (kbd "M--"))

(define-key global-map (kbd "M-= b") '(lambda() (interactive) (lch-search-by "baidu" "ffx" nil)))
(define-key global-map (kbd "M-= c") '(lambda() (interactive) (lch-search-by "ciba" "ffx" nil)))
(define-key global-map (kbd "M-= d") '(lambda() (interactive) (lch-search-by "definition" "ffx" nil)))
(define-key global-map (kbd "M-= f") '(lambda() (interactive) (lch-search-by "google-file" "ffx" nil)))
(define-key global-map (kbd "M-= g") '(lambda() (interactive) (lch-search-by "google" "ffx" nil)))
(define-key global-map (kbd "M-= w") '(lambda() (interactive) (lch-search-by "wikipedia" "ffx" nil)))

(define-key global-map (kbd "M-= B") '(lambda() (interactive) (lch-search-by "baidu" "ffx" t)))
(define-key global-map (kbd "M-= C") '(lambda() (interactive) (lch-search-by "ciba" "ffx" t)))
(define-key global-map (kbd "M-= D") '(lambda() (interactive) (lch-search-by "definition" "ffx" t)))
(define-key global-map (kbd "M-= F") '(lambda() (interactive) (lch-search-by "google-file" "ffx" t)))
(define-key global-map (kbd "M-= G") '(lambda() (interactive) (lch-search-by "google" "ffx" t)))
(define-key global-map (kbd "M-= W") '(lambda() (interactive) (lch-search-by "wikipedia" "ffx" t)))

(define-key global-map (kbd "M-- b") '(lambda() (interactive) (lch-search-by "baidu" "w3m" nil)))
(define-key global-map (kbd "M-- c") '(lambda() (interactive) (lch-search-by "ciba" "w3m" nil)))
(define-key global-map (kbd "<f7> <f8>") '(lambda() (interactive) (lch-search-by "ciba" "w3m" t)))
(define-key global-map (kbd "M-- d") '(lambda() (interactive) (lch-search-by "definition" "w3m" nil)))
(define-key global-map (kbd "M-- f") '(lambda() (interactive) (lch-search-by "google-file" "w3m" nil)))
(define-key global-map (kbd "M-- g") '(lambda() (interactive) (lch-search-by "google" "w3m" nil)))
(define-key global-map (kbd "M-- w") '(lambda() (interactive) (lch-search-by "wikipedia" "w3m" nil)))

(define-key global-map (kbd "M-- B") '(lambda() (interactive) (lch-search-by "baidu" "w3m" t)))
(define-key global-map (kbd "M-- C") '(lambda() (interactive) (lch-search-by "ciba" "w3m" t)))
(define-key global-map (kbd "<f7> <f6>") '(lambda() (interactive) (lch-search-by "ciba" "w3m" t)))
(define-key global-map (kbd "M-- D") '(lambda() (interactive) (lch-search-by "definition" "w3m" t)))
(define-key global-map (kbd "M-- F") '(lambda() (interactive) (lch-search-by "google-file" "w3m" t)))
(define-key global-map (kbd "M-- G") '(lambda() (interactive) (lch-search-by "google" "w3m" t)))
(define-key global-map (kbd "M-- W") '(lambda() (interactive) (lch-search-by "wikipedia" "w3m" t)))

(provide 'lch-web)

;;; Websites
(defun w3m-emacswiki-recent-changes ()
  "View recent changes of EmacsWiki.org."
  (interactive)
  (w3m-goto-url-new-session "http://www.emacswiki.org/cgi-bin/wiki/RecentChanges" t))
(define-key global-map (kbd "<f3> 1") 'w3m-emacswiki-recent-changes)

(defun w3m-emacswiki-random ()
  "Get the random pages from emacswiki."
  (interactive)
  (w3m-goto-url-new-session "http://www.emacswiki.org/cgi-bin/wiki?action=random" nil t))
(define-key global-map (kbd "<f3> 2") 'w3m-emacswiki-random)
;;; Bindings
(defun lch-w3m-mode-hook ()
  (define-key w3m-mode-map (kbd "b") '(lambda() (interactive) (w3m-new-tab) (w3m-bookmark-view)))
  (define-key w3m-mode-map (kbd "d") 'w3m-delete-buffer)
  (define-key w3m-mode-map (kbd "g") 'lch-search-w3m-google)
  (define-key w3m-mode-map (kbd "H") 'w3m-history)
  (define-key w3m-mode-map (kbd "M-h") 'w3m-db-history)
  (define-key w3m-mode-map (kbd "t") '(lambda() (interactive) (w3m-new-tab) (lch-w3m-goto-url)))
  (define-key w3m-mode-map (kbd "C-t") 'w3m-new-tab)
  (define-key w3m-mode-map (kbd "[") 'w3m-view-previous-page)
  (define-key w3m-mode-map (kbd "]") 'w3m-view-next-page)
  (define-key w3m-mode-map (kbd "p") 'w3m-previous-buffer)
  (define-key w3m-mode-map (kbd "n") 'w3m-next-buffer)
  (define-key w3m-mode-map (kbd ",") 'w3m-previous-buffer)
  (define-key w3m-mode-map (kbd ".") 'w3m-next-buffer)
  (define-key w3m-mode-map (kbd "^") 'w3m-view-parent-pag)e
  (define-key w3m-mode-map (kbd "C-6") 'w3m-view-parent-page)
  (define-key w3m-mode-map (kbd "o") 'lch-w3m-goto-url)
  (define-key w3m-mode-map (kbd "O") 'w3m-goto-url-new-session)
  (define-key w3m-mode-map (kbd "s") 'w3m-search)
  (define-key w3m-mode-map (kbd "<up>") 'previous-line)
  (define-key w3m-mode-map (kbd "<down>") 'next-line)
  (define-key w3m-mode-map (kbd "<left>") 'backward-char)
  (define-key w3m-mode-map (kbd "<right>") 'forward-char)
  (define-key w3m-mode-map (kbd "<tab>") 'w3m-next-anchor)
  (define-key w3m-mode-map (kbd "}") 'w3m-next-image)
  (define-key w3m-mode-map (kbd "{") 'w3m-previous-image)
  (define-key w3m-mode-map (kbd ">") 'scroll-left)
  (define-key w3m-mode-map (kbd "<") 'scroll-right)
  (define-key w3m-mode-map (kbd "\\") 'w3m-view-source)
  (define-key w3m-mode-map (kbd "=") 'w3m-view-header)
  (define-key w3m-mode-map (kbd "C-<return>") 'w3m-view-this-url-new-session)
;FIXME(define-key w3m-mode-map (kbd "<C-mouse-1>") 'w3m-view-this-url-new-session)
  (setq truncate-lines nil))
(add-hook 'w3m-mode-hook 'lch-w3m-mode-hook)


;; Global map
(defun lch-w3m-bookmark-view ()
  (interactive)
  (w3m-new-tab)
  (w3m-bookmark-view))
(define-key global-map (kbd "<f3> b") 'lch-w3m-bookmark-view)

(define-key global-map (kbd "<f1> s") 'lch-search-w3m-google)
(define-key global-map (kbd "<f3> g") 'lch-search-w3m-google)

;;; Local Vars.
;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
