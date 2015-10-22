;; Copied from Purcell

(require 'ispell)

(when (executable-find ispell-program-name)
  (require 'init-flyspell))

(dolist (hook '(text-mode-hook))
    (add-hook hook (lambda () (flyspell-mode 1))))
(dolist (hook '(change-log-mode-hook log-edit-mode-hook))
    (add-hook hook (lambda () (flyspell-mode -1))))

(provide 'init-spelling)
