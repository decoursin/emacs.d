;; Created by Nick DeCoursin


(require-package 'evil-smartparens)

(require 'evil-smartparens)
(require 'smartparens-html)

(sp-pair "'" nil :actions :rem)
;; (smartparens-strict-mode) ;; wanted?


(setq sp-navigate-reindent-after-up nil)
(setq sp-navigate-close-if-unbalanced nil)

;(add-hook 'lisp-interaction-mode-hook #'evil-smartparens-mode); (deprecated)
(add-hook 'emacs-lisp-mode-hook #'evil-smartparens-mode)
(add-hook 'cider-mode-hook #'evil-smartparens-mode)
(add-hook 'clojure-mode-hook #'evil-smartparens-mode)

(provide 'init-smartparens)
