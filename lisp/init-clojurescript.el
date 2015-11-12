
;; Doesn't seem to load with emacs 25+
(require-package 'inf-clojure)

(defun figwheel-repl ()
  (interactive)
  (run-clojure "lein figwheel"))

(add-hook 'clojure-mode-hook #'inf-clojure-minor-mode)

(provide 'init-clojurescript)
