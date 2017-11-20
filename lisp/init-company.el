;; Created by Nick DeCoursin

(require-package 'company)

(global-company-mode)

(setq company-idle-delay nil) ; never start completions automatically


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
