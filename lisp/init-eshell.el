;; Copied from jcf
;; Changes:
;; 1) helm-esh-pcomplete to C-SPC
;; 2) behave like linux

; Eshell provides an Emacs Lisp enabled shell.
; 
; Always insert text at the prompt.
; Allow symbol names to be used for redirection targets.
; This makes it possible to redirect output like so:
; Ignore case when completing filenames.
; Error when a glob matches nothing. This mirrors the default behaviour of zsh.
; Make globs case-insensitive.
; NODE_NO_READLINE=1 tells Node.js, and hence npm to avoid use of escape codes because they don’t print well.

  (setq
   eshell-buffer-shorthand t ; what is this?
   eshell-cmpl-ignore-case t ; what is this?
   eshell-cmpl-cycle-completions nil ;; don't jump to conclusion
   eshell-history-size 10000
   eshell-hist-ignoredups t
   
   eshell-error-if-no-glob t ; what is this?
   eshell-glob-case-insensitive t ; what is this?
   eshell-scroll-to-bottom-on-input 'all)
  (defun jcf-eshell-here ()
    (interactive)
    (eshell "here"))

  ; what does this do?
  (defun pcomplete/sudo ()
    (let ((prec (pcomplete-arg 'last -1)))
      (cond ((string= "sudo" prec)
             (while (pcomplete-here*
                     (funcall pcomplete-command-completion-function)
                     (pcomplete-arg 'last) t))))))

  ; what does the first (define ...) do?
  (add-hook 'eshell-mode-hook
            (lambda ()
              (define-key eshell-mode-map ;; autocomplete emacs functions
                (kbd "C-SPC")
                'helm-esh-pcomplete)
              (define-key eshell-mode-map
                (kbd "M-p")
                'helm-eshell-history)
              (setq pcomplete-cycle-completions nil);tab complete like bash
              (eshell/export "NODE_NO_READLINE=1")))

;; eshell alias
(defun eshell/emacs (file)
    (find-file-new-window file))
(defun eshell/e (file)
    (find-file-new-window file))
(defun eshell/f (file)
    (find-file-new-window file))

(provide 'init-eshell)
