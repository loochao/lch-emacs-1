;; lch-skeleton.el -- Setting for Skeleton
;; =======================================

(define-skeleton org-center-skeleton
  "Inserts org center block"
  nil
> "#+begin_center"\n
> _ \n
> "#+end_center"\n)
(define-key global-map (kbd "<f5> c") 'org-center-skeleton)

(define-skeleton org-example-skeleton
  "inserts org example block"
  nil
> "#+begin_example"\n
> _ \n
> "#+end_example"\n)
(define-key global-map (kbd "<f5> e") 'org-example-skeleton)


(define-skeleton org-file-skeleton
  "inserts org center block"
  nil
"[[./data/" _ "][]]"\n)
(define-key global-map (kbd "<f5> f") 'org-file-skeleton)


(define-skeleton org-head-skeleton
  "inserts org header"
  "#+INFOJS_OPT: toc:nil view:info mouse:underline buttons:nil\n"
  "#+INFOJS_OPT: up:http://orgmode.org/worg/\n"
  "#+INFOJS_OPT: home:http://orgmode.org\n"
  "#+OPTIONS: num:nil\n"
  )
(define-key global-map (kbd "<f5> h") 'org-head-skeleton)

(define-skeleton org-html-skeleton
  "Inserts org center block"
  nil
> "#+begin_html"\n
> _ \n
> "#+end_html"\n)
(define-key global-map (kbd "<f5> H") 'org-html-skeleton)

(define-skeleton org-image-skeleton
  "Inserts org center block"
  nil
"[[./image/" _ "]]"\n)
(define-key global-map (kbd "<f5> i") 'org-image-skeleton)

(define-skeleton org-lib-image-skeleton
  "Inserts org center block"
  nil
"[[./library/" _ "]]"\n)
(define-key global-map (kbd "<f5> I") 'org-lib-image-skeleton)

(define-skeleton org-src-lisp-skeleton
  "Inserts org src block"
  nil
> "#+begin_src lisp"\n
> _ \n
> "#+end_src"\n)
(define-key global-map (kbd "<f5> s l") 'org-src-lisp-skeleton)

;> The other choise autopair in lch-elisp.el
(setq skeleton-pair t)
(define-key global-map (kbd "(") 'skeleton-pair-insert-maybe)
(define-key global-map (kbd "[") 'skeleton-pair-insert-maybe)
(define-key global-map (kbd "{") 'skeleton-pair-insert-maybe)
;(define-key global-map (kbd "<") 'skeleton-pair-insert-maybe)
(define-key global-map (kbd "\"") 'skeleton-pair-insert-maybe)

;; (define-skeleton 1exp 
;;   "Input #+BEGIN_EXAMPLE #+END_EXAMPLE in org-mode"
;; ""
;; "#+BEGIN_EXAMPLE\n"
;;  _ "\n" 
;; "#+END_EXAMPLE"
;; )
 
;; (define-abbrev org-mode-abbrev-table "iexp" "" '1exp)

;; (define-skeleton 1src 
;;   "Input #+begin_src #+end_src in org-mode"
;; ""
;; "#+begin_src lisp \n"
;;  _ "\n" 
;; "#+end_src"
;; )
 
;; (define-abbrev org-mode-abbrev-table "isrc" "" '1src)

;; (define-skeleton 1prop 
;;   "Input :PROPERTIES: :END: in org-mode"
;; ""
;; >":PROPERTIES:\n"
;; > _ "\n" 
;; >":END:"
;; )
 
;; (define-abbrev org-mode-abbrev-table "iprop" "" '1prop)

;; (define-skeleton insert-emacser-code
;;   ""
;;   ""
;;   "#+BEGIN_HTML\n"
;; "<pre lang=\"lisp\" line=\"1\">\n"
;; _"\n"
;; "</pre>\n"
;; "#+END_HTML\n"
;; )

;; (define-abbrev org-mode-abbrev-table "ihtml"  "" 'insert-emacser-code)

(provide 'lch-skeleton)
