;; Copied from purcell
;; Havne't learned this yet.
;; Read this about dired (with evil): http://nathantypanski.com/blog/2014-08-03-a-vim-like-emacs-config.html
;; more dired learning material: http://sachachua.com/blog/2014/04/emacs-drawings-dired-moving-around/

;(require-package 'dired+) ;; can't find dired+ :(
;(require-package 'dired-sort) ;; can't find dired-sort

(setq-default diredp-hide-details-initially-flag nil
              dired-dwim-target t)

;; Prefer g-prefixed coreutils version of standard utilities when available
(let ((gls (executable-find "gls")))
  (when gls (setq insert-directory-program gls)))

(after-load 'dired
  ;(require 'dired+)
  ;(require 'dired-sort)
  (when (fboundp 'global-dired-hide-details-mode)
    (global-dired-hide-details-mode -1))
  (setq dired-recursive-deletes 'top)
  (define-key dired-mode-map [mouse-2] 'dired-find-file)
  (add-hook 'dired-mode-hook
            (lambda () (guide-key/add-local-guide-key-sequence "%"))))

(when (maybe-require-package 'diff-hl)
  (after-load 'dired
    (add-hook 'dired-mode-hook 'diff-hl-dired-mode)))

;; c to create new file
(define-key dired-mode-map "c" 'find-file)

(provide 'init-dired)
