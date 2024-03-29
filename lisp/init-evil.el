;; Author: Nick DeCoursin

;; MUST be set before (require 'evil)
;; C-u is half-page up in evil-mode
(setq evil-want-C-u-scroll t)


;; special order is needed with evil-leader see here:
;; https://github.com/cofi/evil-leader/issues/10

;;;;;;; Evil
(require-package 'evil)
(require-package 'evil-leader)
;(require-package 'evil-jumper); Evil-jumper (vim style C-o and C-i jump between buffers)
(require-package 'evil-tabs)
(require-package 'evil-visualstar)
(require-package 'evil-surround)
(require-package 'evil-terminal-cursor-changer)
(require-package 'evil-anzu)
(require-package 'evil-nerd-commenter); jcf used comment-dwim he says instead of nc

;;;;; evil-collection stuff
(require-package 'evil-collection)
(setq evil-want-keybinding nil)

(setq evil-collection-mode-list '(magit))
(when (require 'evil-collection nil t)
  (evil-collection-init))

;;;visual-star
(global-evil-visualstar-mode)
(setq-default evil-symbol-word-search t);# search for symbol not word
;;; jump
;(global-evil-jumper-mode)

(when (> emacs-major-version 24)
	(global-evil-visualstar-mode)
	(setq-default evil-symbol-word-search t);# search for symbol not word ; idk exactly
	;;; jump
	;(global-evil-jumper-mode)
)
(require 'evil)
(require 'evil-collection)

;;; leader
; Must enable global-evil-leader-mode before evil-mode
(require 'evil-leader) ;; shouldn't need this but do.
; initial evil state per mode
; Copied from jcf 
;;else I could do this: (setq evil-leader/in-all-states t); Untested.
(setq evil-leader/in-all-states t); this could pose problems, then resort to this:

;;In insert mode, Evil uses linear undo. If you want fine grain undo:
;; (setq evil-want-fine-undo t)

;; sets initial states
;; like: (evil-set-initial-state 'ibuffer-mode 'normal)
(loop for (mode . state)
      in '((bc-menu-mode . emacs)
           (ag-mode . normal) ;; doesn't seem to have an effect
           (ag . normal) ;; doesn't seem to have an effect
           (bookmark-bmenu-mode . normal) ;; what mode is this?
           (sunrise-mode . normal) ;; what mode is this?
           (dired-mode . normal)
           (ibuffer-mode . normal)
           (cider-repl-mode . insert) ;;added. emacs? or normal? or insert?
           (eshell-mode . insert)
           (git-rebase-mode . emacs)
           (grep-mode . emacs)
           (sql-mode . normal)
           (helm-grep-mode . emacs)
           (help-mode . normal)
           (ielm-mode . insert)
           (magit-mode . normal)
           (magit-popup-mode . normal)
           (magit-branch-manager-mode . emacs)
           (matlab-mode . normal)
           (mag-menu-mode . emacs) ; ack-menu
           (nrepl-mode . insert)
           (prodigy-mode . normal)
           (rdictcc-buffer-mode . emacs)
           (shell-mode . insert)
           (term-mode . emacs)
           (wdired-mode . normal))
      do (evil-set-initial-state mode state))

;; Other modes to think about:
;; I probably don't want this because the stuff above does this but better.
;(mapcar 'set-mode-to-default-emacs
;        '(dired
;          cider-classpath-mode
;          cider-doc-mode
;          cider-docview-mode
;          cider-popup-buffer-mode
;          cider-stacktrace-mode
;          cider-test-report-mode
;          deft-mode
;          occur-mode
;          term-mode
;          eshell
;          magit-branch-manager-mode
;          magit-commit-mode
;          magit-log-mode
;          magit-popup-mode
;          magit-popup-sequence-mode
;          git-rebase-mode
;          log-view-mode
;          project-explorer-mode
;          paradox-menu-mode
;          neotree-mode
;          diff-mode))

;; manual-entry. Nick move this where appropriate
(evil-set-initial-state 'man-mode 'motion) ;; motion or emacs or normal??

(evil-leader/set-leader ",")
(global-evil-leader-mode) ;; must be before (evil-mode 1)
; enable <leader> in Dired, GNUs, Magit, and Notmuch.
; doesn't seem to work

;; Nick what does this do?
(setq evil-leader/no-prefix-mode-rx '("dired-mode"
                                      "gnus-.*-mode"
                                      ;; "magit-.*-mode"
                                      "notmuch-.*-mode"))
;;; evil
(evil-mode 1)
;;; tabs
(global-evil-tabs-mode t)
(elscreen-start)
;;; surround
;(global-evil-surround-mode 1)
; `s' for surround instead of `substitute'
;(evil-define-key 'visual evil-surround-mode-map "s" 'evil-surround-region)
;(evil-define-key 'normal evil-surround-mode-map "s" 'evil-surround-region)
;(evil-define-key 'visual evil-surround-mode-map "S" 'evil-substitute)
;s(evil-define-key 'normal evil-surround-mode-map "S" 'evil-substitute)
;;; anzu
(after-load 'evil
  (require 'evil-anzu))
;;; terminal-cursor-changer ;; does this actually do anything??
(require 'evil-terminal-cursor-changer)
(setq evil-visual-state-cursor '("green" box)); █
(setq evil-insert-state-cursor '("green" bar)); ⎸
(setq evil-emacs-state-cursor '("blue" hbar)); _

(evil-set-undo-system 'undo-tree)

;; deprecated
;(defun copy-to-clipboard ()
;  (interactive)
;  (if (display-graphic-p)
;      (progn
;        (message "Yanked region to x-clipboard!")
;        (call-interactively 'clipboard-kill-ring-save)
;        )
;    (if (region-active-p)
;        (progn
;          (shell-command-on-region (region-beginning) (region-end) "xsel -i -b")
;          (message "Yanked region to clipboard!")
;          (deactivate-mark))
;      (message "No region active; can't yank to clipboard!")))
;  )
;
;(evil-define-command paste-from-clipboard()
;  (if (display-graphic-p)
;      (progn
;        (clipboard-yank)
;        (message "graphics active")
;        )
;    (insert (shell-command-to-string "xsel -o -b"))
;    )
;  )

;; I probably don't want this because the stuff above does this but better
;; Copied from expez
;(defun set-mode-to-default-emacs (mode)
;  (evil-set-initial-state mode 'emacs))

; Nick: IDK.
;;; https://bitbucket.org/lyro/evil/issue/432/edebug-mode-map-cant-take-effect-for-the
(add-hook 'edebug-mode-hook 'evil-normalize-keymaps)

;; Total hack
(add-hook 'help-mode-hook #'evil-visual-state)
(add-hook 'dired-mode-hook #'evil-visual-state)
(add-hook 'cider-repl-mode-hook #'evil-visual-state)
(add-hook 'Ag #'evil-visual-state)
;; (add-hook 'magit-mode-hook #'evil-visual-state)

(add-hook 'dired-mode-hook (lambda () (run-at-time ".1 sec" 1 (lambda () (execute-kbd-macro (kbd "<escape>"))))))

;;; The kbd macro actually breaks things. Find alternative or remove entirely.
;(add-hook 'help-mode-hook (lambda () (run-at-time ".1 sec" 1 (lambda () (execute-kbd-macro (kbd "<escape>"))))))
;; The problem with these hooks is that they're being run when
;; cider-repl, for example, is booting up which run <escape> that
;; quits it.
;(add-hook 'cider-repl-mode-hook (lambda () (run-at-time ".1 sec" 1 (lambda () (execute-kbd-macro (kbd "<escape>"))))))
;; (add-hook 'magit-mode-hook (lambda () (run-at-time ".1 sec" 1 (lambda () (execute-kbd-macro (kbd "<escape>"))))))

;; What does provide do??
(provide 'init-evil)
