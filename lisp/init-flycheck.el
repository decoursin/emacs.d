
;;; documenation for flycheck can be found here:
;;; https://media.readthedocs.org/pdf/flycheck/31/flycheck.pdf

(use-package flycheck :ensure t)
(use-package flycheck-joker :ensure t)
(use-package flycheck-clojure)
(use-package flycheck-pos-tip)
(use-package flycheck-tip)

;;; enable clojure cider checkers
;; (after-load 'cider
;;   (after-load 'flycheck
;;     (flycheck-clojure-setup)))

(add-hook 'after-init-hook #'global-flycheck-mode)

;; warnings only
(set-face-attribute 'flycheck-warning nil :underline nil)
(set-face-attribute 'flycheck-fringe-warning nil :foreground (face-attribute 'fringe :background))
(setq flycheck-error-list-minimum-level 'error)
(setq flycheck-navigation-minimum-level 'errors)

;;; frequency
(setq flycheck-check-syntax-automatically '(mode-enabled save idle-change))
;; (setq flycheck-idle-change-delay 0.8)

;;; disable checkers
(with-eval-after-load 'flycheck
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc
                                             ;; clojure-cider-kibit
                                             ;; clojure-cider-eastwood
                                             ;; clojure-cider-typed
                                             )))

;; Make flycheck recognize packages in loadpath
;; i.e (require 'company) will not give an error now
(setq flycheck-emacs-lisp-load-path 'inherit)


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
