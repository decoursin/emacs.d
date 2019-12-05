;;
;; TO start attached shell repl run: M-x shell (shell comamnd)
;; or use the alias below
;;

(defalias 'bash-shell-repl 'shell)

(setq sh-basic-offset 2)
(setq sh-indentation 2)

(setenv "SHELL" "bash")

(add-hook 'shell-mode-hook
	  (lambda () (local-set-key (kbd "S-<return>") 'newline-and-indent)))

(provide 'init-shell)
