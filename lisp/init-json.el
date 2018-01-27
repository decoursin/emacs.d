;; There should be other stuff in this file, that's actually
;; in init-javascript.el.

(require-package 'flymake-json)

(add-to-list 'auto-mode-alist '("\\.eslintrc.*$" . json-mode))
(add-to-list 'auto-mode-alist '("\\.babelrc$" . json-mode))

;; Untested yet
(add-hook 'json-mode 'flymake-json-load)
