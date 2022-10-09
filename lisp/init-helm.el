(require-package 'helm)
(require 'helm)
(require 'helm-config)
(require 'helm-regexp)
(require 'helm-command)
(require 'helm-files)

;; (setq helm-ff-history nil)
;; (setq helm-mode-reverse-history nil)

;; What does this do?
;; I had to comment this out because it was causing an error in 28.1
;;(eval-after-load "helm-regexp"
;;  '(setq helm-source-moccur
;;    (helm-make-source "Moccur" 'helm-source-multi-occur :follow 1)))

;; (source: http://stackoverflow.com/q/14726601)
(defun helm-multi-occur-all-buffers ()
  "multi-occur in all buffers backed by files."
  (interactive)
  (helm-multi-occur
   (delq nil
     (mapcar (lambda (b)
           (when (buffer-file-name b) (buffer-name b)))
         (buffer-list)))))

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(global-set-key (kbd "M-x") 'helm-M-x)

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq
 helm-scroll-amount 4			; scroll 8 lines other window using M-<next>/M-<prior>
 helm-quick-update t
 helm-idle-delay 0.01
 helm-input-idle-delay 0.01
 helm-ff-search-library-in-sexp t	; search for library in `require' and `declare-function' sexp.
 helm-split-window-default-side 'other
 helm-split-window-in-side-p t 		; open helm buffer inside current window, not occupy whole other window
; what is this?
; helm-buffers-favorite-modes (append helm-buffers-favorite-modes
;                                     '(picture-mode artist-mode))
 helm-candidate-number-limit 200
 helm-M-x-requires-pattern 0
; I don't like this, gets in the way
; helm-ff-file-name-history-use-recentf t
 helm-move-to-line-cycle-in-source t 	; move to end or beginning of source when reaching top or bottom of source.
 ido-use-virtual-buffers t
 helm-buffers-fuzzy-matching t

 helm-pdfgrep-default-read-command          "evince --page-label=%p '%f'"
 helm-ff-auto-update-initial-value          t
 helm-always-two-windows                    t
 helm-reuse-last-window-split-state         t
 helm-ls-git-status-command                 'magit-status-internal
 helm-dabbrev-cycle-threshold               5)

(helm-mode 1)

(provide 'init-helm)
