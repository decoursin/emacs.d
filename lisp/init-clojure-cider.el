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
(require-package 'flycheck-clojure)

(require 'cider-interaction)
(require 'cider-client)
(require 'cider-test)
(require 'cider-eldoc)
(require 'cider-doc)
(require 'cider-compat)
(require 'cider-resolve)

;(require-package 'cider-eval-sexp-fu); Nick added

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; nrepl with Clojure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun cider-namespace-refresh ()
  (interactive)
  (cider-interactive-eval
   "(require 'clojure.tools.namespace.repl)
    (clojure.tools.namespace.repl/refresh)"))

(defalias 'nick-cider-namespace-refresh 'cider-namespace-refresh)

(add-hook 'cider-mode-hook
   '(lambda () (add-hook 'after-save-hook
    '(lambda ()
       (if (and (boundp 'cider-mode) cider-mode)
	   (cider-namespace-refresh))))))

;; try these
;(define-key cider-repl-mode-map (kbd "<home>") nil)
;(define-key cider-repl-mode-map (kbd "<tab>") 'complete-symbol)
;(define-key cider-mode-map (kbd "<tab>") 'complete-symbol)

;; Pretty print results in repl
(setq cider-repl-use-pretty-printing t)

;; idk
(setq cider-stacktrace-default-filters '(tooling dup))

(setq cider-repl-history-size 1000)

;; Nick, what is this?
;; Don't prompt for symbols
(setq cider-prompt-for-symbol nil)


(setq nrepl-popup-stacktraces nil)

(after-load 'cider
  (setq cider-show-error-buffer 'nil) ; don't show on error

  (add-hook 'cider-mode-hook 'cider-turn-on-eldoc-mode)
  (add-hook 'cider-repl-mode-hook 'company-mode)
  (add-hook 'cider-mode-hook 'company-mode)

  (add-hook 'cider-interaction-mode-hook 'cider-turn-on-eldoc-mode);; Nick added this. Untested though. What is cider-interaction-mode-hook lol?

  (add-hook 'cider-repl-mode-hook
	    (lambda () (local-set-key (kbd "S-<return>") 'cider-repl-newline-and-indent)))

  ;; TODO: move to last point automatically. eshell does this.
  ;; TODO: when "end-history" delete. Tried this. Doesn't work. Can only submit a bug in cider.
  (add-hook 'cider-repl-mode-hook
	    (lambda () (local-set-key (kbd "<up>") 'cider-repl-previous-input)))
  (add-hook 'cider-repl-mode-hook
	    (lambda () (local-set-key (kbd "<down>") 'cider-repl-next-input)))
  (add-hook 'cider-repl-mode-hook
	    (lambda () (local-set-key (kbd "S-<up>") 'cider-repl-next-matching-input)))
  (add-hook 'cider-repl-mode-hook
	    (lambda () (local-set-key (kbd "S-<down>") 'cider-repl-previous-matching-input)))

  ;; none of these work. Error is: wrong type argument: keymapp ...
  ;; (define-key 'cider-repl-mode-hook (kbd "<up>") 'cider-repl-previous-input);untested
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
(after-load 'flycheck
  (flycheck-clojure-setup))

(defun my-cider-mode-enable-flycheck ()
  (when (and (s-ends-with-p ".clj" (buffer-file-name))
             (not (s-ends-with-p "/dev/user.clj" (buffer-file-name))))
    (flycheck-mode 1)))

;; What is this?
;; eastwood is causing problems just fyi
(eval-after-load 'flycheck '(add-to-list 'flycheck-checkers 'clojure-cider-eastwood))


(defalias 'cider-current-repl-buffer #'cider-current-connection
  "The current REPL buffer.
Return the REPL buffer given by `cider-current-connection'.")

(provide 'init-clojure-cider)
