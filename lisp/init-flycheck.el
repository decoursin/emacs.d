;; Copied from PUrcell
;; Not being used
;; Untested

(require-package 'flycheck)
(require-package 'flycheck-pos-tip)
;; (require-package 'flycheck-tip)

(eval-after-load 'flycheck '(flycheck-clojure-setup))
(add-hook 'after-init-hook #'global-flycheck-mode)

(eval-after-load 'flycheck '(setq flycheck-display-errors-function #'flycheck-pos-tip-error-messages))

;; alternatively, you could use this instead of flycheck-pos-tip
;; (flycheck-tip-use-timer 'verbose)

  ;; Nick, do I want this?
  ;; Override default flycheck triggers
  ;; (setq flycheck-check-syntax-automatically '(save idle-change mode-enabled)
  ;;       flycheck-idle-change-delay 0.8)

  ;; Nick, do I want this?
  ;; (setq flycheck-display-errors-function #'flycheck-display-error-messages-unless-error-list))


(provide 'init-flycheck)

;; Copied from jcf
;; Maybe use this instead? First, what is flycheck?
;(use-package flycheck
;  :init (global-flycheck-mode)
;  :config
;  (setq flycheck-check-syntax-automatically '(save idle-change mode-enabled)
;        flycheck-idle-change-delay 0.8
;        flycheck-mode-line nil)
;  (use-package flycheck-pos-tip
;    :init
;    (setq flycheck-display-errors-function
;          #'flycheck-pos-tip-error-messages)))
