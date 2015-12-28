
(require-package 'avy)
(require-package 'ace-jump-helm-line)

(require 'avy)
(require 'ace-jump-helm-line)

;; C-' to avy style jump options in helm
(eval-after-load "helm"
  '(define-key helm-map (kbd "C-j") 'ace-jump-helm-line))

;;; (deprecated) use C-j instead
(defun avy-goto-conditional ()
  (interactive)
  (avy--generic-jump "\\s(\\(if\\|cond\\|when\\|unless\\)\\b" nil 'pre))

(defun avy-goto-paren ()
  (interactive)
  (avy--generic-jump "(\\|)" nil 'pre))

(defun avy-goto-bracket ()
  (interactive)
  (avy--generic-jump "{\\|\\[\\|}\\|\\]" nil 'pre))

(defun avy-goto-double-quote ()
  (interactive)
  (avy--generic-jump "\"" nil 'pre))

(defun avy-goto-single-quote ()
  (interactive)
  (avy--generic-jump "'" nil 'pre))


(provide 'init-avy)
