;; By Nick DeCoursin
;; Reference: http://tuhdo.github.io/helm-projectile.html

(require-package 'helm-projectile)

(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)

;; If desired, enable this
;(setq projectile-enable-caching t)


(provide 'init-projectile)
