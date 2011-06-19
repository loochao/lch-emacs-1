;-*- coding: utf-8; mode:emacs-lisp -*-

;>======== CALENDAR ========<;
(message "=> lch-calendar: loading...")

(require 'cal-china-x)

(setq calendar-latitude 40.34) 
(setq calendar-longitude -74.65) 
(setq calendar-location-name "Princeton, NJ")
(setq calendar-time-zone -360)
(setq calendar-standard-time-zone-name "EST")
(setq calendar-daylight-time-zone-name "EDT")

;; remove some holidays
(setq holiday-bahai-holidays nil)       ; get rid of Baha'i holidays
;(setq holiday-general-holidays nil)     ; get rid of too U.S.-centric holidays
(setq holiday-hebrew-holidays nil)      ; get rid of religious holidays
(setq holiday-islamic-holidays nil)     ; get rid of religious holidays
(setq holiday-oriental-holidays nil)    ; get rid of Oriental holidays
(setq holiday-solar-holidays nil)

;; add some Belgian holidays
(setq holiday-local-holidays
      '(
        (holiday-fixed 01 01 "New Year's Day")
        (holiday-fixed 02 14 "Valentine's Day")
        (holiday-fixed 05 01 "Labor Day")
        (holiday-fixed 07 04 "Independence Day")

        ;; holidays with variable dates
        (holiday-float 5 0 2 "Mother's Day")
        (holiday-float 6 0 3 "Father's Day")))

;; user defined holidays
(setq holiday-other-holidays nil)  ; default

;; mark dates of holidays in the calendar
(setq calendar-mark-holidays-flag t)

(message "~~ lch-calendar: done.")
(provide 'lch-calendar)
