;; Author Nick DeCoursin on 08/30/2015
;; http://emacswiki.org/emacs/EvaluatingExpressions

;; eval-sexp-fu just adds a little functionality that
;; highlights or *flashes* the expressions that are evaluated.
(require-package 'eval-sexp-fu)
(require 'eval-sexp-fu)


;; just for print printing
(global-set-key [remap eval-expression] 'pp-eval-expression)

(provide 'init-eval-sexp)
