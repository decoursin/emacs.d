;; Copied from nathantypanski
;; http://nathantypanski.com/blog/2014-08-03-a-vim-like-emacs-config.html

;; TODO: test this
(use-package magit
  :ensure magit
  :config
  (progn
    (evil-set-initial-state 'magit-mode 'normal)
    (evil-set-initial-state 'magit-status-mode 'normal)
    (evil-set-initial-state 'magit-diff-mode 'normal)
    (evil-set-initial-state 'magit-log-mode 'normal)
    (evil-define-key 'normal magit-mode-map
        "j" 'magit-goto-next-section
        "k" 'magit-goto-previous-section)
    (evil-define-key 'normal magit-log-mode-map
        "j" 'magit-goto-next-section
        "k" 'magit-goto-previous-section)
    (evil-define-key 'normal magit-diff-mode-map
        "j" 'magit-goto-next-section
        "k" 'magit-goto-previous-section)))


;; This interferes atleast somewhat with above but maybe add it later? IDK much here.
;; Copied from jcf
;; TODO: put this in separate file
;;(evil-add-hjkl-bindings magit-log-mode-map 'emacs)
;;(evil-add-hjkl-bindings magit-commit-mode-map 'emacs)
;;(evil-add-hjkl-bindings magit-branch-manager-mode-map 'emacs
;;  "K" 'magit-discard-item
;;  "L" 'magit-key-mode-popup-logging)
;;(evil-add-hjkl-bindings magit-status-mode-map 'emacs
;;  "K" 'magit-discard-item
;;  "l" 'magit-key-mode-popup-logging
;;  "h" 'magit-toggle-diff-refine-hunk)

(provide 'init-magit)
