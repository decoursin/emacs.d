;; Created by Nick DeCoursin

(require-package 'company)

;; what does these two do??
(setq tab-always-indent 'complete)
(add-to-list 'completion-styles 'initials t)

(global-company-mode)

(setq company-idle-delay nil) ; never start completions automatically

(add-to-list 'company-backends 'company-edbi)

(after-load 'company
  (define-key company-active-map (kbd "j") 'company-select-next)
  (define-key company-active-map (kbd "k") 'company-select-previous)
  (define-key company-active-map (kbd "SPC") 'company-complete-selection)
  (define-key company-active-map (kbd "C-SPC") 'company-select-next)
  (define-key company-active-map (kbd "S-C-SPC") 'company-select-previous)
  ;; I don't know what these do/are.
  (setq-default company-backends '((company-capf company-dabbrev-code) company-dabbrev)
                company-dabbrev-other-buffers 'all
                company-tooltip-align-annotations t))

(provide 'init-company)
