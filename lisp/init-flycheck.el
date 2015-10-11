;; Copied from PUrcell
;; Not being used
;; Untested
(when (maybe-require-package 'flycheck)
  (add-hook 'after-init-hook 'global-flycheck-mode)

  ;; Override default flycheck triggers
  (setq flycheck-check-syntax-automatically '(save idle-change mode-enabled)
        flycheck-idle-change-delay 0.8)

  (setq flycheck-display-errors-function #'flycheck-display-error-messages-unless-error-list))


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
