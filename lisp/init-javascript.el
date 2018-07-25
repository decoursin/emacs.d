(maybe-require-package 'json-mode)
(maybe-require-package 'js2-mode)
(maybe-require-package 'json-reformat-region)
(require-package 'react-snippets)
(require-package 'rjsx-mode)

;; javascript / html
(add-to-list 'auto-mode-alist '("\\.js$" . rjsx-mode))
(add-to-list 'auto-mode-alist '("\\.eslintrc.*$" . json-mode))
(add-to-list 'auto-mode-alist '("\\.babelrc$" . json-mode))

;; indent
(defconst preferred-javascript-indent-level 2)
(setq json-reformat:indent-width 2)
(setq js2-basic-offset 2)
(setq js-indent-level 2)

(eval-after-load "sgml-mode"
  '(progn
     (require 'tagedit)
     (tagedit-add-paredit-like-keybindings)
     (add-hook 'html-mode-hook (lambda () (tagedit-mode 1)))))

(require-package 'rainbow-delimiters)
(dolist (hook '(js2-mode-hook js-mode-hook json-mode-hook))
  (add-hook hook 'rainbow-delimiters-mode))

;; coffeescript
(add-to-list 'auto-mode-alist '("\\.coffee.erb$" . coffee-mode))
(add-hook 'coffee-mode-hook 'subword-mode)
(add-hook 'coffee-mode-hook 'highlight-indentation-current-column-mode)
(add-hook 'coffee-mode-hook
          (defun coffee-mode-newline-and-indent ()
            (define-key coffee-mode-map "\C-j" 'coffee-newline-and-indent)
            (setq coffee-cleanup-whitespace nil)))
(custom-set-variables
 '(coffee-tab-width 2))

;;;;;;;;;;;;;;;;;;;;;; setup-prettier.el

(require-package 'prettier-js)

(setq prettier-js-width-mode 'fill)
(setq prettier-js-args '("--single-quote" "--trailing-comma=all"))

(defun my/use-prettier-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (prettier (and root
                        (expand-file-name "node_modules/.bin/prettier"
                                          root))))
    (when (and prettier (file-executable-p prettier))
      (setq-local prettier-js-command prettier))))

(add-hook 'js-mode-hook 'prettier-js-mode)
(add-hook 'js-mode-hook #'my/use-prettier-from-node-modules)
(add-hook 'js2-mode-hook 'prettier-js-mode)
(add-hook 'js2-mode-hook #'my/use-prettier-from-node-modules)
(add-hook 'web-mode-hook 'prettier-js-mode)
(add-hook 'web-mode-hook #'my/use-prettier-from-node-modules)
;; CSS
(add-hook 'css-mode-hook 'prettier-js-mode)
(add-hook 'css-mode-hook #'my/use-prettier-from-node-modules)
(add-hook 'scss-mode-hook 'prettier-js-mode)
(add-hook 'scss-mode-hook #'my/use-prettier-from-node-modules)

;; (provide 'setup-prettier)

;;;;;;;;;;;;;;;;;;;;;; setup-prettier.el ends here

(provide 'init-javascript)
