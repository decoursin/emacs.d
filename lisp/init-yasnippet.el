;; Copied from Magnars

(require-package 'yasnippet)

;; Use only own snippets, do not use bundled ones
(setq yas-snippet-dirs '("~/.emacs.d/snippets"))

(setq yas-verbosity 1)

;; Wrap around region
(setq yas-wrap-around-region t)
	
(provide 'init-yasnippet)
