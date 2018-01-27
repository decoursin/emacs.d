
;;; documenation for flycheck can be found here:
;;; https://media.readthedocs.org/pdf/flycheck/31/flycheck.pdf

(use-package flycheck :ensure t)
(use-package flycheck-joker :ensure t)
(use-package flycheck-clojure)
(use-package flycheck-pos-tip)
(use-package flycheck-tip)
(use-package flycheck-flow)

;;; enable clojure cider checkers
(after-load 'cider
  (after-load 'flycheck
    (flycheck-clojure-setup)))

(add-hook 'after-init-hook #'global-flycheck-mode)

;; warnings only
(set-face-attribute 'flycheck-warning nil :underline nil)
(set-face-attribute 'flycheck-fringe-warning nil :foreground (face-attribute 'fringe :background))
(setq flycheck-error-list-minimum-level 'error)
(setq flycheck-navigation-minimum-level 'errors)

;;; frequency
(setq flycheck-check-syntax-automatically '(mode-enabled save))
;; (setq flycheck-idle-change-delay 1.)

;;; disable checkers
(with-eval-after-load 'flycheck
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc
                                             ;; clojure-cider-kibit
                                             ;; clojure-cider-eastwood
                                             clojure-cider-typed
                                             ;; clojure-joker
                                             javascript-jshint
                                             ;; javascript-jscs
                                             ;; javascript-gjslint
                                             )))

;;;;;;;;;;;;;;;;;;;;;; javascript

(flycheck-add-mode 'javascript-eslint 'rjsx-mode)

;; use local eslint from node_modules before global
;; http://emacs.stackexchange.com/questions/21205/flycheck-with-file-relative-eslint-executable
(defun my/use-eslint-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (eslint (and root
                      (expand-file-name "node_modules/eslint/bin/eslint.js"
                                        root))))
    (when (and eslint (file-executable-p eslint))
      (setq-local flycheck-javascript-eslint-executable eslint))))
(add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)

(defun my/use-flow-from-node-modules ()
  (let* ((root (locate-dominating-file
                (or (buffer-file-name) default-directory)
                "node_modules"))
         (flow (and root
                    (expand-file-name "node_modules/flow-bin/vendor/flow"
                                      root))))
    (when (and flow (file-executable-p flow))
      (setq-local flycheck-javascript-flow-executable flow))))


(add-hook 'flycheck-mode-hook #'my/use-eslint-from-node-modules)
(add-hook 'flycheck-mode-hook #'my/use-flow-from-node-modules)

;; Flycheck + Flowtype
(require 'flycheck-flow)
(flycheck-add-next-checker 'javascript-flow 'javascript-eslint)

;;;;;;;;;;;;;;;;;;;;; end JS

;; customize flycheck temp file prefix
(setq-default flycheck-temp-prefix ".flycheck")

;; Make flycheck recognize packages in loadpath
;; i.e (require 'company) will not give an error now
(setq flycheck-emacs-lisp-load-path 'inherit)

(eval-after-load 'flycheck
  '(setq flycheck-display-errors-function #'flycheck-pos-tip-error-messages))

;; (eval-after-load 'flycheck '(setq flycheck-display-errors-function #'flycheck-pos-tip-error-messages))

;; alternatively, you could use this instead of flycheck-pos-tip
;; (flycheck-tip-use-timer 'verbose)

;; Nick, do I want this?
;; (setq flycheck-display-errors-function #'flycheck-display-error-messages-unless-error-list))

;;; funcs

(defvar syntax-checking-enable-by-default t
  "Enable syntax-checking by default.")

(defun spacemacs/add-flycheck-hook (mode)
  "Use flycheck in MODE by default, if `syntax-checking-enable-by-default' is
true."
  (when (and syntax-checking-enable-by-default
             (listp flycheck-global-modes)
             (not (eq 'not (car flycheck-global-modes))))
    (push mode flycheck-global-modes)))


(spacemacs/add-flycheck-hook 'emacs-lisp-mode)

(provide 'init-flycheck)

;; Copied from jcf
;; Maybe use this instead? First, what is flycheck?
;; (use-package flycheck
;;  :init (global-flycheck-mode)
;;  :config
;;  (setq flycheck-check-syntax-automatically '(save idle-change mode-enabled)
;;        flycheck-idle-change-delay 0.8
;;        flycheck-mode-line nil)
;;  (use-package flycheck-pos-tip
;;    :init
;;    (setq flycheck-display-errors-function
;;          #'flycheck-pos-tip-error-messages)))
