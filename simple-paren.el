;;; simple-paren.el --- Insert paired delimiter, wrap symbols in front maybe  -*- lexical-binding: t; -*-

;; Version: 0.1
;; Copyright (C) 2016  Andreas Röhler

;; Author: Andreas Röhler <andreas.roehler@online.de>

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;; Keywords: convenience

;;; Commentary: Provide common paired delimiters

;; Wrap symbols at point or at one space befor

;; Examples, curor as pipe-symbol:

;; (defun foo1 | ==> (defun foo1 ()

;; |interactive ==> (interactive)

;; int|eractive ==> int(eractive)

;; (global-set-key [(super ?\()] 'simple-paren-parentize)
;; (global-set-key [(super ?{)] 'simple-paren-brace)
;; (global-set-key [(super ?\[)] 'simple-paren-bracket)
;; (global-set-key [(super ?')] 'simple-paren-singlequote)
;; (global-set-key [(super ?\")] 'simple-paren-doublequote)
;; (global-set-key [(super ?<)] 'simple-paren-lesser-then)
;; (global-set-key [(super ?>)] 'simple-paren-greater-then)

;; keeps padding
;; | foo == ( foo )
;;

;;; Code:

(defvar simple-paren-skip-chars "^\[\]{}(), \t\r\n\f"
  "Skip chars backward not mentioned here. ")

(defun simple-paren--return-complement-char-maybe (erg)
  "For example return \"}\" for \"{\" but keep \"\\\"\". "
  (pcase erg
    (?< ?>)
    (?> ?<)
    (?\( ?\))
    (?\) ?\()
    (?\] ?\[)
    (?\[ ?\])
    (?} ?{)
    (?{ ?})
    ;; '(leftrightsinglequote 8216 8217)
    ;; '(leftrightdoublequote 8220 8221)
    (8216 8217)
    (8220 8221)
    (_ erg)))

(defvar simple-paren-braced-newline (list 'js-mode))

(defun simple-paren--intern (char &optional arg)
  (let ((padding (eq 2 (prefix-numeric-value arg)))
	(no-wrap (eq 4 (prefix-numeric-value arg)))
	end)
    (if no-wrap
	(progn
	  (insert char)
	  (insert (simple-paren--return-complement-char-maybe char)))
      (if (region-active-p)
	  (progn
	    (setq end (copy-marker (region-end)))
	    (goto-char (region-beginning)))
	(unless (or (eobp) (eolp)(member (char-after) (list 32 9)))
	  (skip-chars-backward simple-paren-skip-chars)))
      (insert char)
      (if (region-active-p)
	  (goto-char end)
	(when (and padding (looking-at "\\( \\)?[^ \n]+"))
	  ;; travel symbols after point
	  (skip-chars-forward " "))
	(skip-chars-forward simple-paren-skip-chars)
	;; (forward-sexp)
	(when (and padding (match-string-no-properties 1))
	  (insert (match-string-no-properties 1))))
      (insert (simple-paren--return-complement-char-maybe char))
      (forward-char -1)
      (when (and (eq (char-after) ?})(member major-mode simple-paren-braced-newline))
	(newline 2)
	(indent-according-to-mode)
	(forward-char 1)
	(insert ?\;)
	(forward-line -1)
	(indent-according-to-mode)))))

;; Commands
(defun simple-paren-brace (&optional arg)
  "With \\[universal-argument] insert delimiter literatim.

With active region, wrap around.
With numerical arg 2 honor padding. "
  (interactive "*P")
  (simple-paren--intern 123 arg))

(defun simple-paren-bracket (&optional arg)
  "With \\[universal-argument] insert delimiter literatim.

With active region, wrap around.
With numerical arg 2 honor padding. "
  (interactive "*P")
  (simple-paren--intern 91 arg))

(defun simple-paren-lesserangle (&optional arg)
  "With \\[universal-argument] insert delimiter literatim.

With active region, wrap around.
With numerical arg 2 honor padding. "
  (interactive "*P")
  (simple-paren--intern 60 arg))

(defun simple-paren-greaterangle (&optional arg)
  "With \\[universal-argument] insert delimiter literatim.

With active region, wrap around.
With numerical arg 2 honor padding. "
  (interactive "*P")
  (simple-paren--intern 62 arg))

(defun simple-paren-leftrightsinglequote (&optional arg)
  "With \\[universal-argument] insert delimiter literatim.

With active region, wrap around.
With numerical arg 2 honor padding. "
  (interactive "*P")
  (simple-paren--intern 8216 arg))

(defun simple-paren-leftrightdoublequote (&optional arg)
  "With \\[universal-argument] insert delimiter literatim.

With active region, wrap around.
With numerical arg 2 honor padding. "
  (interactive "*P")
  (simple-paren--intern 8220 arg))

(defun simple-paren-parentize (&optional arg)
  "With \\[universal-argument] insert delimiter literatim.

With active region, wrap around.
With numerical arg 2 honor padding. "
  (interactive "*P")
  (simple-paren--intern 40 arg))

(defun simple-paren-acute-accent (&optional arg)
  "With \\[universal-argument] insert delimiter literatim.

With active region, wrap around.
With numerical arg 2 honor padding. "
  (interactive "*P")
  (simple-paren--intern 180 arg))

(defun simple-paren-backslash (&optional arg)
  "With \\[universal-argument] insert delimiter literatim.

With active region, wrap around.
With numerical arg 2 honor padding. "
  (interactive "*P")
  (simple-paren--intern 92 arg))

(defun simple-paren-backtick (&optional arg)
  "With \\[universal-argument] insert delimiter literatim.

With active region, wrap around.
With numerical arg 2 honor padding. "
  (interactive "*P")
  (simple-paren--intern 96 arg))

(defun simple-paren-colon (&optional arg)
  "With \\[universal-argument] insert delimiter literatim.

With active region, wrap around.
With numerical arg 2 honor padding. "
  (interactive "*P")
  (simple-paren--intern 58 arg))

(defun simple-paren-cross (&optional arg)
  "With \\[universal-argument] insert delimiter literatim.

With active region, wrap around.
With numerical arg 2 honor padding. "
  (interactive "*P")
  (simple-paren--intern 43 arg))

(defun simple-paren-dollar (&optional arg)
  "With \\[universal-argument] insert delimiter literatim.

With active region, wrap around.
With numerical arg 2 honor padding. "
  (interactive "*P")
  (simple-paren--intern 36 arg))

(defun simple-paren-doublequote (&optional arg)
  "With \\[universal-argument] insert delimiter literatim.

With active region, wrap around.
With numerical arg 2 honor padding. "
  (interactive "*P")
  (simple-paren--intern 34 arg))

(defun simple-paren-equalize (&optional arg)
  "With \\[universal-argument] insert delimiter literatim.

With active region, wrap around.
With numerical arg 2 honor padding. "
  (interactive "*P")
  (simple-paren--intern 61 arg))

(defun simple-paren-escape (&optional arg)
  "With \\[universal-argument] insert delimiter literatim.

With active region, wrap around.
With numerical arg 2 honor padding. "
  (interactive "*P")
  (simple-paren--intern 92 arg))

(defun simple-paren-grave-accent (&optional arg)
  "With \\[universal-argument] insert delimiter literatim.

With active region, wrap around.
With numerical arg 2 honor padding. "
  (interactive "*P")
  (simple-paren--intern 96 arg))

(defun simple-paren-hash (&optional arg)
  "With \\[universal-argument] insert delimiter literatim.

With active region, wrap around.
With numerical arg 2 honor padding. "
  (interactive "*P")
  (simple-paren--intern 35 arg))

(defun simple-paren-hyphen (&optional arg)
  "With \\[universal-argument] insert delimiter literatim.

With active region, wrap around.
With numerical arg 2 honor padding. "
  (interactive "*P")
  (simple-paren--intern 45 arg))

(defun simple-paren-singlequote (&optional arg)
  "With \\[universal-argument] insert delimiter literatim.

With active region, wrap around.
With numerical arg 2 honor padding. "
  (interactive "*P")
  (simple-paren--intern 39 arg))

(defun simple-paren-slash (&optional arg)
  "With \\[universal-argument] insert delimiter literatim.

With active region, wrap around.
With numerical arg 2 honor padding. "
  (interactive "*P")
  (simple-paren--intern 47 arg))

(defun simple-paren-star (&optional arg)
  "With \\[universal-argument] insert delimiter literatim.

With active region, wrap around.
With numerical arg 2 honor padding. "
  (interactive "*P")
  (simple-paren--intern 42 arg))

(defun simple-paren-tild (&optional arg)
  "With \\[universal-argument] insert delimiter literatim.

With active region, wrap around.
With numerical arg 2 honor padding. "
  (interactive "*P")
  (simple-paren--intern 126 arg))

(defun simple-paren-underscore (&optional arg)
  "With \\[universal-argument] insert delimiter literatim.

With active region, wrap around.
With numerical arg 2 honor padding. "
  (interactive "*P")
  (simple-paren--intern 95 arg))

(defun simple-paren-whitespace (&optional arg)
  "With \\[universal-argument] insert delimiter literatim.

With active region, wrap around.
With numerical arg 2 honor padding. "
  (interactive "*P")
  (simple-paren--intern 32 arg))

(provide 'simple-paren)
;;; simple-paren.el ends here
