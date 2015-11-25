;; Build by Nick DeCoursin
; https://melpa.org/#/evil-magit

(require-package 'magit)
(require-package 'evil-magit)

(require 'magit)
(require 'evil-magit)
(require 'fullframe)

(add-hook 'magit-mode-hook 'evil-local-mode)
(add-hook 'git-rebase-mode-hook 'evil-local-mode)

(after-load 'magit
  (fullframe magit-status
	     magit-mode-quit-window))

;;; Nick learn
;; (when (maybe-require-package 'magit)
;;   (setq-default
;;    magit-process-popup-time 10
;;    magit-diff-refine-hunk t
;;    magit-completing-read-function 'magit-ido-completing-read))

;; (after-load 'magit
;;   (define-key magit-status-mode-map (kbd "C-M-<up>") 'magit-section-up)
;;   (add-hook 'magit-popup-mode-hook 'sanityinc/no-trailing-whitespace))

;; (when (maybe-require-package 'git-commit)
;;   (add-hook 'git-commit-mode-hook 'goto-address-mode))


(when *is-a-mac*
  (after-load 'magit
    (add-hook 'magit-mode-hook (lambda () (local-unset-key [(meta h)])))))

;;;;;; ediff
;; remap -> ediff-copy-A-to-B with diff other
;; add mapping of key "!" to ediff-update-diffs

;; Nick think about adding something like this
;;http://oremacs.com/2015/01/17/setting-up-ediff/
;; (defun ora-ediff-hook ()
;;   (ediff-setup-keymap)
;;   (define-key ediff-mode-map "j" 'ediff-next-difference)
;;   (define-key ediff-mode-map "k" 'ediff-previous-difference))

(provide 'init-magit)
