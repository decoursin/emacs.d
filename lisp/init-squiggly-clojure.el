(require-package 'flycheck-clojure)
(require-package 'flycheck-tip)

(require 'flycheck-tip)
(flycheck-tip-use-timer 'verbose)

(add-hook 'cider-mode-hook
	  (lambda () (setq next-error-function #'flycheck-next-error-function)))

(add-hook 'clojure-mode-hook
	  (lambda () (setq next-error-function #'flycheck-next-error-function)))

(provide 'init-squiggly-clojure)
