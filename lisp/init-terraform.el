;; By: Nick DeCoursin

(require-package 'terraform-mode)
(require-package 'hcl-mode)

;(custom-set-variables
; '(terraform-indent-level 4))

;(custom-set-variables
; '(hcl-indent-level 4))

(require-package 'company-terraform)

(company-terraform-init)

(provide 'init-terraform)
