;; Copied from http://www.emacswiki.org/emacs/AdjustParens
;; Created on 11/15/15

(require-package 'adjust-parens)

(require 'adjust-parens)

;; (add-hook 'emacs-lisp-mode-hook #'adjust-parens-mode)
;; (add-hook 'clojure-mode-hook #'adjust-parens-mode)
(add-hook 'emacs-lisp-mode-hook #'my/list-adjust-parens-mode)
(add-hook 'clojure-mode-hook #'my/list-adjust-parens-mode)

(defun my/list-adjust-parens-mode ()
  "Bind <M-left> and <M-right>"
  (local-set-key (kbd "<M-left>") 'my/lisp-dedent-adjust-parens)
  (local-set-key (kbd "<M-right>") 'my/lisp-indent-adjust-parens))

(defun my/lisp-dedent-adjust-parens ()
  (interactive)
  (save-excursion
    (x4-smarter-beginning-of-line)
    (call-interactively 'lisp-dedent-adjust-parens)))
(defun my/lisp-indent-adjust-parens ()
  (interactive)
  (save-excursion
    (x4-smarter-beginning-of-line)
    (call-interactively 'lisp-indent-adjust-parens)))

(defun x4-smarter-beginning-of-line ()
  "Move point to first beginning-of-line or non-whitespace character or first non-whitespace after comment."
  (interactive "^")
  (let ((oldpos (point))
        (indentpos (progn
                     (back-to-indentation)
                     (point)))
        (textpos (progn
                   (beginning-of-line-text)
                   (point))))
    (cond
     ((> oldpos textpos) (beginning-of-line-text))
     ((and (<= oldpos textpos) (> oldpos indentpos))  (back-to-indentation))
     ((and (<= oldpos indentpos) (> oldpos (line-beginning-position))) (beginning-of-line))
     (t (beginning-of-line-text)))))
  
(provide 'init-adjust-parens)
