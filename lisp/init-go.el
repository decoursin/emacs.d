
(require-package 'go-mode)
(require-package 'go-eldoc)
(require-package 'go-autocomplete)

(add-hook 'go-mode-hook 'go-eldoc-setup)

;; learn: https://johnsogg.github.io/emacs-golang.

;; doesn't work..
;;; I don't know what this is.
;; highlight identifiers
;;(go-guru-hl-identifier-mode)

;; goimports, which organizes the imports at the top of each file. 
(setq gofmt-command "goimports")

(provide 'init-go)
