;; -*- coding:utf-8; mode:emacs-lisp; -*-

;;; CALENDAR
;;
;; Copyright (c) 2006 2007 2008 2009 2010 2011 Chao LU
;;
;; Author: Chao LU <loochao@gmail.com>
;; URL: http://www.princeton.edu/~chaol

;; This file is not part of GNU Emacs.

;;; Commentary

;; commentary goes here.

;;; License

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

;;; Local Vars.
;; Local Variables:
;; mode: emacs-lisp
;; mode: outline-minor
;; outline-regexp: ";;;;* "
;; End:
