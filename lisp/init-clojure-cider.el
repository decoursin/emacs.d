;; Copied from Purcell
;; Haven't learned yet
;; Changes:
;; 1) up/down to cider-repl-next/previous-input
;; 2) don't show on *cider-error* buffer on error
;; 3) 'cider-eval-sexp-fu
;; 3) See comments for changes

(require 'init-clojure)
(require-package 'emacs '(24))

(require-package 'cider)
(require-package 'ac-cider)
(require-package 'flycheck-clojure)
;(require-package 'cider-eval-sexp-fu); Nick added

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; nrepl with Clojure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;


;; try these
;(define-key cider-repl-mode-map (kbd "<home>") nil)
;(define-key cider-repl-mode-map (kbd "<tab>") 'complete-symbol)
;(define-key cider-mode-map (kbd "<tab>") 'complete-symbol)

;; Pretty print results in repl
(setq cider-repl-use-pretty-printing t)

;; Nick, what is this?
;; Don't prompt for symbols
(setq cider-prompt-for-symbol nil)

(setq nrepl-popup-stacktraces nil)

(after-load 'cider
  (add-hook 'cider-repl-mode-hook 'ac-cider-setup)
  (add-hook 'cider-mode-hook 'ac-cider-setup)
  (setq cider-show-error-buffer 'nil) ; don't show on error

  (after-load 'auto-complete
    (add-to-list 'ac-modes 'cider-repl-mode))

  (add-hook 'cider-repl-mode-hook 'set-auto-complete-as-completion-at-point-function)
  (add-hook 'cider-mode-hook 'set-auto-complete-as-completion-at-point-function)
  (add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
  (add-hook 'cider-interaction-mode-hook 'cider-turn-on-eldoc-mode);; Nick added this. Untested though. What is cider-interaction-mode-hook lol?
  ;(add-hook 'cider-repl-mode-hook 'subword-mode); I'm not use to this. Treats words when separated by - dashes.
  ;(add-hook 'cider-repl-mode-hook 'paredit-mode); Eee I don't like this.
  (define-key cider-mode-map (kbd "C-c C-d") 'ac-cider-popup-doc)

  ;; none of these work. Error is: wrong type argument: keymapp ...
  ;(define-key cider-repl-mode-hook (kbd "<up>") 'cider-repl-previous-input);untested
  ; what does no-prefix-mode-rx do?
  ;(define-key cider-repl-mode-hook (kbd "C-p") 'cider-repl-previous-input);untested
 ;(define-key cider-repl-mode-hook (kbd "<down>") 'cider-repl-next-input);untested

  ;; nrepl isn't based on comint
  (add-hook 'cider-repl-mode-hook
            (lambda () (setq show-trailing-whitespace nil))))

;; Specify history file
;; is this working?
(setq cider-history-file "~/.emacs.d/nrepl-history")

;; I probably don't need both of these, is one doing the other?
(add-hook 'cider-mode-hook 'my-cider-mode-enable-flycheck)
;; (after-load 'flycheck
;;   (flycheck-clojure-setup))

(defun my-cider-mode-enable-flycheck ()
  (when (and (s-ends-with-p ".clj" (buffer-file-name))
             (not (s-ends-with-p "/dev/user.clj" (buffer-file-name))))
    (flycheck-mode 1)))

;; What is this?
;; eastwood is causing problems just fyi
;; (eval-after-load 'flycheck '(add-to-list 'flycheck-checkers 'clojure-cider-eastwood))

(provide 'init-clojure-cider)
