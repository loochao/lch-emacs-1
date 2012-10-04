;-*- coding: utf-8 -*-

(setq org-agenda-time-grid '((daily require-timed)
			     "________"
			     (0800 1000 1200 1400 1600 1800 2000 2200)))

(define-key global-map (kbd "<f8>") 'org-agenda)
(setq org-agenda-custom-commands
      '(
        ("=" "ALL" tags "#A|DAILY|DUALLY|WEEKLY|RECUR|AUDIO|CAR|MOBILE|#B|#C|IDEA")
	("-" agenda "DAY/FOCUS" ((org-agenda-ndays 1)))
	 ;; ("1m" "MOBILE" tags "MOBILE/ACTIVE")
	 ;; ("1a" "AUDIO" tags "AUDIO/ACTIVE")
	 ;; ("1c" "CAR" tags "CAR/ACTIVE")
	 ;; ("1d" "RECUR DAILY" tags "DAILY/ACTIVE")
	 ;; ("1D" "RECUR DUALLY" tags "DUALLY/ACTIVE")
	 ;; ("1t" "RECUR TRIPLY" tags "TRIPLY/ACTIVE")
	 ;; ("1w" "RECUR WEEKLY" tags "WEEKLY/ACTIVE")
        ("`" "ALL TODO"
         (
	  (tags "#A/ACTIVE|WAITING")
	  (tags "#B|OBTAIN/ACTIVE")
          (tags "DAILY/TOFNSH")
	  (tags "DAILY|DUALLY|WEEKLY|RECUR/ACTIVE")
          (tags "MOBILE|AUDIO|CAR/ACTIVE")
	  (tags "#C/ACTIVE")
          ))
        ("1" "ACTIVE TODO-#A"
         (
                                        ;	  (tags "PLAN/ACTIVE" ((org-agenda-overriding-header
                                        ;		 ";>--------PLAN--------<;")))
	  (tags "#A/ACTIVE|WAITING" ((org-agenda-overriding-header
                                      ";>--------ACTIVE & #A TASKs--------<;")))
	  (agenda "Week Agenda" ((org-agenda-ndays 12)
				 (org-agenda-sorting-strategy
				  (quote ((agenda time-up priority-down tag-up))))
				 (org-deadline-warning-days 0)
				 (org-agenda-overriding-header
				  "\n;>--------AGENDA--------<;")))
	  (tags "#A/PENDING" ((org-agenda-overriding-header
                               ";>--------PENDING #A TASKs--------<;")))
          ))
	 ("2" "ACTIVE BLOCKS"
	  (
           (tags "MOBILE|AUDIO|CAR/ACTIVE")
           (tags "DAILY|DUALLY|WEEKLY/ACTIVE")
           (tags "#B|OBTAIN/ACTIVE")
           (tags "#C/ACTIVE")
	   )
	  )
 	 ("3" "RECUR BLOCKS"
	  (
	   (tags "DAILY/ACTIVE")
	   ;(tags "DUALLY/TOFNSH")
	   (tags "DUALLY/ACTIVE")
	   (tags "WEEKLY/ACTIVE")
	   ;(tags "RECUR/ACTIVE")
	   ))
	 ("4" "FUN ITEMS" tags "FUN")
         ("0" .  "MISCITEMS")
	 ("01" "TODO-#A QUEUE" tags "#A-ACTIVE")
	 ("02" "TODO-#B/#C/OBT QUEUE" tags "#B|OBTAIN|#C/QUEUE")
	 ("03" "ACM QUEUE" tags "AUDIO|CAR|MOBILE/QUEUE")
	 ("04" "TODO-#B" tags "#B")
	 ("05" "OBTAIN" tags "OBTAIN")
	 ("06" "TODO-#C" tags "#C")
;	 ("10" "TEST" occur-tree "Title="Quantum Mechanics"")
;	       (agenda "")
;	       (todo "ACTIVE|NEXT|QUEUE")
;	       (tags "ACTIVE|TIMEBOX|MOBILE|AUDIO|CAR|DAILY|DUALLY|WEEKLY")
;	  (todo "ACTIVE")
;	  (tags "CAR")
;	       ))

;	  ("lpq" "Quantum Mechanics" tags "KEYWORD=\"Quantum Mechanics,\"")
      ("p" "Printed agenda"
         ((agenda "" ((org-agenda-ndays 7)                      ;; overview of appointments
                      (org-agenda-start-on-weekday nil)         ;; calendar begins today
                      (org-agenda-repeating-timestamp-show-all t)
                      (org-agenda-entry-types '(:timestamp :sexp))))
          (agenda "" ((org-agenda-ndays 1)                      ;; daily agenda
                      (org-deadline-warning-days 7)             ;; 7 day advanced warning for deadlines
                      (org-agenda-todo-keyword-format "[ ]")
                      (org-agenda-scheduled-leaders '("" ""))
                      (org-agenda-prefix-format "%t%s")))
          (todo "#B"                                          ;; todos sorted by context
                ((org-agenda-prefix-format "[ ] %T: ")
                 (org-agenda-sorting-strategy '(tag-up priority-down))
                 (org-agenda-todo-keyword-format "")
                 (org-agenda-overriding-header "\nTasks by Context\n------------------\n"))))
         ()
         )
 	("p" . "Priorities")
        ("pa" "A items" tags-todo "+PRIORITY=\"A\"")
        ("pb" "B items" tags-todo "+PRIORITY=\"B\"")
        ("pc" "C items" tags-todo "+PRIORITY=\"C\"")

	("t" . "Tags")
	("ta" "ALL #B" tags "#B" ((org-agenda-prefix-format "[ ] %T: ")
                 (org-agenda-sorting-strategy '(tag-up priority-down))
                 (org-agenda-todo-keyword-format "")
                 (org-agenda-overriding-header "8<========ALL #B========>8")
		 (org-agenda-with-colors t)
		 (org-agenda-compact-blocks nil)
		 (org-agenda-remove-tags t)))
	("te" "Emacs #B" tags "#B" ((org-agenda-files (list (concat org-source-dir "/iPrv.org")))))
        )
      )

(provide 'lch-org-agenda)