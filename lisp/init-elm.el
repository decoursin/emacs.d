;; Copied from Purcell

(when (maybe-require-package 'elm-mode)
  (when (maybe-require-package 'flycheck-elm)
    (after-load 'elm-mode
      (flycheck-elm-setup))))

(add-hook 'elm-mode-hook #'evil-smartparens-mode)

(provide 'init-elm)
