;; By Nick DeCoursin
;; Reference: http://tuhdo.github.io/helm-projectile.html

(require-package 'helm-projectile)

(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)

;; workaround for a bug after upgrading projectile version
;; bug here: https://github.com/bbatsov/projectile/issues/1183
(setq projectile-mode-line
         '(:eval (format " Projectile[%s]"
                        (projectile-project-name))))

;; If desired, enable this
;(setq projectile-enable-caching t)


(provide 'init-projectile)
