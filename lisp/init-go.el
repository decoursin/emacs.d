
(require-package 'go-mode)
(require-package 'go-eldoc)
(require-package 'go-autocomplete)
(require-package 'go-flycheck)

(add-hook 'go-mode-hook 'go-eldoc-setup)

;; learn: https://johnsogg.github.io/emacs-golang.

;;; I don't know what this is.
;; highlight identifiers
(go-guru-hl-identifier-mode)

;; goimports, which organizes the imports at the top of each file. 
(setq gofmt-command "goimports")

(provide 'init-go)