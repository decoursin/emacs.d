;; Created by Nick DeCoursin


(require-package 'evil-smartparens)

(require 'evil-smartparens)

(sp-pair "'" nil :actions :rem)
;; (smartparens-strict-mode) ;; wanted?


;(add-hook 'lisp-interaction-mode-hook #'evil-smartparens-mode); (deprecated)
(add-hook 'emacs-lisp-mode-hook #'evil-smartparens-mode)
(add-hook 'cider-mode-hook #'evil-smartparens-mode)
(add-hook 'clojure-mode-hook #'evil-smartparens-mode)

(provide 'init-smartparens)
