;; There should be other stuff in this file, that's actually
;; in init-javascript.el.

(require-package 'flymake-json)

;; Untested yet
(add-hook 'json-mode 'flymake-json-load)
