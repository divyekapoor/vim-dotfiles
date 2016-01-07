;; Copyright 2007 Google Inc. All rights reserved.
;;
;; soy-mode.el -- Major mode for editing Soy files.
;;
;; Author: Kai Huang (kai@google.com)


;; Font face definitions.
(defvar template-tag-face
  (progn
    (make-face 'template-tag-face)
    (set-face-foreground 'template-tag-face "#009900")
    (set-face-bold-p 'template-tag-face t)
    'template-tag-face))
(defvar control-tag-face
  (progn
    (make-face 'control-tag-face)
    (set-face-foreground 'control-tag-face "#CC00CC")
    'control-tag-face))
(defvar call-tag-face
  (progn
    (make-face 'call-tag-face)
    (set-face-foreground 'call-tag-face "#009900")
    'call-tag-face))
(defvar msg-tag-face
  (progn
    (make-face 'msg-tag-face)
    (set-face-foreground 'msg-tag-face "#CCCCCC")
    'msg-tag-face))
(defvar print-tag-face
  (progn
    (make-face 'print-tag-face)
    (set-face-foreground 'print-tag-face "#663300")
    'print-tag-face))
(defvar html-block-tag-face
  (progn
    (make-face 'html-block-tag-face)
    (set-face-foreground 'html-block-tag-face "#0033FF")
    'html-block-tag-face))
(defvar html-tag-face
  (progn
    (make-face 'html-tag-face)
    (set-face-foreground 'html-tag-face "#0099FF")
    'html-tag-face))
(defvar html-comment-face
  (progn
    (make-face 'html-comment-face)
    (set-face-foreground 'html-comment-face "#FF9900")
    'html-comment-face))
(defvar special-char-face
  (progn
    (make-face 'special-char-face)
    (set-face-foreground 'special-char-face "#663300")
    'special-char-face))
(defvar new-line-char-face
  (progn
    (make-face 'new-line-char-face)
    (set-face-foreground 'new-line-char-face "#663300")
    (set-face-bold-p 'new-line-char-face t)
    'new-line-char-face))


;; Basic setup.
(defvar soy-mode-hook nil)
(add-to-list 'auto-mode-alist '("\\.soy\\'" . soy-mode))


;; We don't use keywords to do syntax highlighting.
(defconst soy-font-lock-keywords
  (list )
  "No keywords. All tags matched as comments."
)


;; Modify syntax table to find all HTML and Soy tags as "comments".
(defvar soy-mode-syntax-table
  (let ((syntax-table (make-syntax-table)))
    ;; This is a hack! We use comments to find all HTML and Soy tags!
    (modify-syntax-entry ?\< "< n" syntax-table)
    (modify-syntax-entry ?\> "> n" syntax-table)
    (modify-syntax-entry ?\{ "< bn" syntax-table)  ;; comment type "b"
    (modify-syntax-entry ?\} "> bn" syntax-table)  ;; comment type "b"
    ;; Turn off all strings.
    (modify-syntax-entry ?\" "." syntax-table)
    (modify-syntax-entry ?\' "." syntax-table)
    syntax-table
  )
  "Syntax table for soy-mode"
)


;; Identifies tags and maps them to their corresponding font faces.
(defun soy-syntactic-face-function (state)
  (let ((comment-type (nth 7 state)))  ;; see "parser state" in elisp docs
    (cond
      ((eq comment-type t)  ;; Soy tag is comment type "b"
       (cond
         ((looking-at "/?template\\b") template-tag-face)
         ((looking-at "/?msg\\b") msg-tag-face)
         ((looking-at "\\(/?call\\|/?param\\)\\b") call-tag-face)
         ((looking-at "sp\\b") special-char-face)
         ((looking-at "\\(/?if\\|else\\(if\\)?\\|/?for\\(each\\)?\\)\\b") control-tag-face)
         ((looking-at "\\(nil\\|\\\\t\\|lb\\|rb\\)\\b") special-char-face)
         ((looking-at "\\\\[rn]\\b") new-line-char-face)
         (t print-tag-face)
       ))
      ((null comment-type)  ;; HTML tag
       (cond
         ((looking-at "!--") html-comment-face)
         ((looking-at "\\(/?div\\|/?t\\(able\\|[hrd]\\|head\\|body\\|foot\\)\\|/?h[r1-6]\\|/?form\\)\\b") html-block-tag-face)
         (t html-tag-face)
       ))
    )
  )
)

;; indendation
(defvar soy-indentation 2
  "regular indentation for soy files")
(defvar soy-continuation-line-indentation 4
  "indentation for the continuation lines of a multi-line tag")
(defconst soy-doubleopening "^[^{<\n]*\\({switch\\)"
  "Regular expressin matching if there is a soy tag like {switch} that should
be considered opening two levels, so that a {case} is still indented, even
though it can act as a closing tag")
(defconst soy-opening
  (concat "^[^{<\n]*\\("
          "{\\(call\\|delcall\\|param\\)\\(}\\|[^}]*\\(\n\\|[^/]}\\)\\)" ; for call/param verify that they're not self-finishing
          "\\|{template\\|{deltemplate\\|{msg\\|{if\\|{else\\|{case\\|{foreach\\|"
          "<div\\|<span\\|<h[0-9]\\|<a \\|<html\\|<table\\|<tr\\|<td\\)")
  "Regular expression matching if there is an opening soy tag till the end of this line")
(defconst soy-neutral-opening
  (concat "^[^{<\n]*\\("
          "<div.*</div>\\|<span.*</span>\\|<h[0-9].*</h>\\|<a .*</a>"
          "\\|{\\(call\\|msg\\|param\\).*{/"
          "\\)")
  "Regular expression matching if there is an opening tag closed in the same line")
(defconst soy-doubleclosing "^[^{<\n]*\\({/switch\\)"
  "The closing tags corresponding to the soy-doubleopening ones")
(defconst soy-closing
  "^[^{<\n]*\\(</\\|{else\\|{case\\|{/\\)"
  "Regular expression matching if there is a closing soy tag till the end of this line")
(defconst soy-unfinishedtag
  "^[^{<\n]*\\(<[^/][^>\n]*\\|{[^/][^}\n]*\\)\n"
  "Regular expression matching if, till the end of this line, there is the beginning
of a tag spanning multiple lines")
(defconst soy-finishestag
  "^\\([^{<\n]*>\\|[^<\n]*{[^<\n]*}[^<\n]*>\\|^[^{\n]*}\\)"
   "Regular expression matching if this line contains the end of a tag that started before point")
(defconst soy-begin-of-multiline-comment
  "^[ \t]*/\\*\\([^/]\\|[^*]/\\)*\n"
  "Regular expression matching a line that starts a
/*
 * comment like this
 * extending over several lines
 */")
(defconst soy-end-of-multiline-comment
  "^[ \t]*\\*/"
  "Regular expression matching a line ending a comment extending serveral lines")

(defun soy-indent-line ()
  "Indent current line as soy-template."
  (interactive)
  (save-excursion
    (indent-line-to
     (max
      0
      (catch 'indent
        (save-excursion
          (beginning-of-line)
          (if (bobp) (throw 'indent 0))
          (let ((indent-out (cond ((looking-at soy-doubleclosing) (- (* 2 soy-indentation)))
                                  ((looking-at soy-closing) (- soy-indentation))
                                  (t 0))))
            (save-excursion
              (forward-line -1)
              (if (looking-at soy-begin-of-multiline-comment)
                  (throw 'indent (+ (current-indentation) 1)))
              (if (looking-at soy-end-of-multiline-comment)
                  (throw 'indent (- (current-indentation) 1)))
              (if (looking-at soy-unfinishedtag)
                  (throw 'indent (+ (current-indentation) soy-continuation-line-indentation)))
              (if (looking-at soy-finishestag) ; scan backwards for the beginning of the tag
                  (while (not (looking-at soy-unfinishedtag))
                    (forward-line -1)))
              (if (looking-at soy-doubleopening)
                  (throw 'indent (+ (current-indentation) (* 2 soy-indentation) indent-out)))
              (if (looking-at soy-neutral-opening)
                  (throw 'indent (+ (current-indentation) indent-out)))
              (if (looking-at soy-opening)
                  (throw 'indent (+ (current-indentation) soy-indentation indent-out)))
                (throw 'indent (+ (current-indentation) indent-out))))))))))


;; Finally, define the mode and provide it.
(defun soy-mode ()
  (interactive)
  (kill-all-local-variables)

  (set-syntax-table soy-mode-syntax-table)

  (set (make-local-variable 'font-lock-defaults)
    '(soy-font-lock-keywords
      nil nil nil nil
      (font-lock-syntactic-face-function . soy-syntactic-face-function)))
   (set (make-local-variable 'indent-line-function) 'soy-indent-line)

  (setq major-mode 'soy-mode)
  (setq mode-name "Soy")
  (run-hooks 'soy-mode-hook)
)

(provide 'soy-mode)
