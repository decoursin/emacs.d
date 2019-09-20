(require-package 'racket-mode)

;; racket modes: racket-mode-map, racket-repl-mode-hook, and racket-repl-mode-map.

;;; keybindings are defined in init.el
;; (add-hook 'racket-mode-hook
;; 	  (lambda () (define-key racket-mode-map (kbd "C-c") 'racket-send-region)))

(add-hook 'racket-mode-hook 'company-mode)

;; Bug exists in Racket company backend that opens docs in new window when
;; company-quickhelp calls it. Note hook is appendended for proper ordering.
(add-hook 'company-mode-hook
          '(lambda ()
             (when (and (equal major-mode 'racket-mode)
                        (bound-and-true-p company-quickhelp-mode))
               (company-quickhelp-mode -1))) t)

;; racket-repl-mode overrides the 'eval-window-map, reset this.
(add-hook 'racket-repl-mode-hook
          '(lambda ()
             (local-set-key (kbd "C-w") 'evil-window-map)))

(evil-update-insert-state-bindings nil t)

(setq racket-program "/home/nick/racket/bin/racket")

(provide 'init-racket)