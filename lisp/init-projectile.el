;; By Nick DeCoursin
;; Reference: http://tuhdo.github.io/helm-projectile.html

(require-package 'helm-projectile)

(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)

(add-to-list 'projectile-globally-ignored-directories "*node_modules")

;; workaround for a bug after upgrading projectile version
;; bug here: https://github.com/bbatsov/projectile/issues/1183
(setq projectile-mode-line
      '(:eval (format " Projectile[%s]"
                      (projectile-project-name))))

;; Shorter modeline
(after-load 'projectile
  (setq-default
   projectile-mode-line
   '(:eval
     (if (file-remote-p default-directory)
         " Proj"
       (format " Proj[%s]" (projectile-project-name))))))

(provide 'init-projectile)
