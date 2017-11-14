;; Copied from Purcell
;; Haven't learned yet
;; Changes:
;; 1) up/down to cider-repl-next/previous-input
;; 2) don't show on *cider-error* buffer on error
;; 3) 'cider-eval-sexp-fu
;; 3) See comments for changes

(require 'init-clojure)

(use-package cider)

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

(add-hook 'clojure-mode-hook
   '(lambda () (add-hook 'after-save-hook
    '(lambda ()
       (if (and (boundp 'clojure-mode) clojure-mode)
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

  (add-hook 'cider-mode-hook 'eldoc-mode)
  (add-hook 'cider-repl-mode-hook 'company-mode)
  (add-hook 'cider-mode-hook 'company-mode)

  (add-hook 'cider-interaction-mode-hook 'eldoc-mode);; Nick added this. Untested though. What is cider-interaction-mode-hook lol?

  (add-hook 'cider-repl-mode-hook
	    (lambda () (local-set-key (kbd "S-<return>") 'cider-repl-newline-and-indent)))

  ;; TODO: move to last point automatically. eshell does this.
  ;; TODO: when "end-history" delete. Tried this. Doesn't work. Can only submit a bug in cider.
  ;; history
  (add-hook 'cider-repl-mode-hook (lambda () (local-set-key (kbd "<up>") 'cider-repl-backward-input)))
  (add-hook 'cider-repl-mode-hook (lambda () (local-set-key (kbd "<down>") 'cider-repl-forward-input)))
  (add-hook 'cider-repl-mode-hook (lambda () (local-set-key (kbd "S-<up>") 'cider-repl-next-matching-input)))
  (add-hook 'cider-repl-mode-hook (lambda () (local-set-key (kbd "S-<down>") 'cider-repl-previous-matching-input)))
  (add-hook 'cider-repl-mode-hook (lambda () (local-set-key (kbd "M-p") 'cider-repl-backward-input)))
  (add-hook 'cider-repl-mode-hook (lambda () (local-set-key (kbd "M-n") 'cider-repl-forward-input)))
  (add-hook 'cider-repl-mode-hook (lambda () (local-set-key (kbd "S-M-p") 'cider-repl-previous-matching-input)))
  (add-hook 'cider-repl-mode-hook (lambda () (local-set-key (kbd "S-M-n") 'cider-repl-next-matching-input)))
  (add-hook 'cider-repl-mode-hook (lambda () (local-set-key (kbd "C-M-p") 'cider-repl-previous-input)))
  (add-hook 'cider-repl-mode-hook (lambda () (local-set-key (kbd "C-M-n") 'cider-repl-next-input)))


  (add-hook 'cider-repl-mode-hook (lambda () (local-unset-key (kbd "C-j"))))

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

;; better spacing)
(setq clojure-indent-style :align-arguments)

;; (deprecated)
;; (add-hook 'cider-mode-hook 'my-cider-mode-enable-flycheck)
;; (defun my-cider-mode-enable-flycheck ()
;;   (when (and (s-ends-with-p ".clj" (buffer-file-name))
;;              (not (s-ends-with-p "/dev/user.clj" (buffer-file-name))))
;;     (flycheck-mode 1)))

;; What is this?
;; eastwood is causing problems just fyi
;; (eval-after-load 'flycheck '(add-to-list 'flycheck-checkers 'clojure-cider-eastwood))

;; For figwheel
;;
;; You'll also need to add this to your project.clj
;; :profiles {:dev {:dependencies [[com.cemerick/piggieback "0.2.2"]]
;;                  :repl-options {:nrepl-middleware [cemerick.piggieback/wrap-cljs-repl]}}})
;;
(setq cider-cljs-lein-repl "(do (use 'figwheel-sidecar.repl-api) (start-figwheel!) (cljs-repl))")

(defalias 'cider-current-repl-buffer #'cider-current-connection
  "The current REPL buffer.
Return the REPL buffer given by `cider-current-connection'.")

(provide 'init-clojure-cider)
