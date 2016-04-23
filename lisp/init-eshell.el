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

;; Also copied some from here: http://writequit.org/org/settings.html#sec-1-3-6

(require 'em-cmpl)
(require 'em-prompt)
(require 'em-term)

;;; helm eshell
(require-package 'pcomplete-extension)

(add-hook 'eshell-mode-hook
          (lambda ()
            (eshell-cmpl-initialize)
            (define-key eshell-mode-map [remap pcomplete] 'helm-esh-pcomplete)
            (define-key eshell-mode-map (kbd "M-p") 'helm-eshell-history)))

;;; done helm eshell

  (setq
   ;; buffer shorthand -> echo foo > #'buffer
   eshell-buffer-shorthand t ; what is this?
   eshell-cmpl-ignore-case t ; what is this?
   eshell-cmpl-cycle-completions nil ;; don't jump to conclusion
   eshell-history-size 10000
   eshell-hist-ignoredups t
   
   eshell-error-if-no-glob t ; what is this?
   eshell-glob-case-insensitive t ; what is this?
   eshell-scroll-to-bottom-on-input 'all
   ;; treat 'echo' like shell echo
   eshell-plain-echo-behavior t)

   ;; Visual commands
   (setq eshell-visual-commands '("vi" "screen" "top" "less" "more" "lynx"
   							      "ncftp" "pine" "tin" "trn" "elm" "vim"
   							      "nmtui" "alsamixer" "htop" "el" "elinks"
   							      ))
   (setq eshell-visual-subcommands '(("git" "log" "diff" "show")))

  ; what does this do?
  (defun pcomplete/sudo ()
    (let ((prec (pcomplete-arg 'last -1)))
      (cond ((string= "sudo" prec)
             (while (pcomplete-here*
                     (funcall pcomplete-command-completion-function)
                     (pcomplete-arg 'last) t))))))

  (add-hook 'eshell-mode-hook
            (lambda ()
              (define-key eshell-mode-map ;; autocomplete emacs functions
                (kbd "C-SPC")
                ;(kbd "<tab>")
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
