;; Copied from Purcell
;; Untested
(setq auto-mode-alist
      (append '(("SConstruct\\'" . python-mode)
		("SConscript\\'" . python-mode))
              auto-mode-alist))

(require-package 'pip-requirements)

(require-package 'company-jedi)

;; following was created by me
(require-package 'python-mode)

(autoload 'python-mode "python-mode" "Python Mode." t)
(add-to-list 'auto-mode-alist '("\\.py\\'" . python-mode))
(add-to-list 'interpreter-mode-alist '("python" . python-mode))

(setq flycheck-python-pycompile-executable "python3")

;; for autocompletion
;; (add-hook 'python-mode-hook (lambda () (add-to-list 'company-backends 'company-jedi)))


(provide 'init-python-mode)
