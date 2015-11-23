;; Build by Nick DeCoursin
; https://melpa.org/#/evil-magit

(require-package 'magit)
(require-package 'evil-magit)

(require 'magit)
(require 'evil-magit)

(add-hook 'magit-mode-hook 'evil-local-mode)
(add-hook 'git-rebase-mode-hook 'evil-local-mode)

(provide 'init-magit)
