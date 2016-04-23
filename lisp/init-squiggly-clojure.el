(require-package 'flycheck-clojure)
(require-package 'flycheck-tip)

(eval-after-load 'flycheck '(flycheck-clojure-setup))

(require 'flycheck-tip)
(flycheck-tip-use-timer 'verbose)

(add-hook 'cider-mode-hook
	  (lambda () (setq next-error-function #'flycheck-next-error-function)))

(add-hook 'clojure-mode-hook
	  (lambda () (setq next-error-function #'flycheck-next-error-function)))

(provide 'init-squiggly-clojure)
