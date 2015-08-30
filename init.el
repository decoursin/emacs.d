
;;; This file bootstraps the configuration, which is divided into
;;; a number of other files.


(let ((minver "23.3"))
  (when (version<= emacs-version "23.1")
    (error "Your Emacs is too old -- this config requires v%s or higher" minver)))
(when (version<= emacs-version "24")
  (message "Your Emacs is old, and some functionality in this config will be disabled. Please upgrade if possible."))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))
(require 'init-benchmarking)

(defconst *spell-check-support-enabled* nil) ;; Enable with t if you prefer
(defconst *is-a-mac* (eq system-type 'darwin))
(defconst *is-linux* (eq system-type 'gnu/linux))

;;----------------------------------------------------------------------------
;; Bootstrap config
;;----------------------------------------------------------------------------
(setq custom-file (expand-file-name "custom.el" user-emacs-directory)) ; nick - not being used
(require 'init-compat)
(require 'init-utils)
(require 'init-site-lisp) ;; Must come before elpa, as it may provide package.el
;; Calls (package-initialize)
(require 'init-elpa)      ;; Machinery for installing required packages
(require 'init-exec-path) ;; Set up $PATH
;TODO: evil-commentary learn it and add it
(require 'init-evil) ;; Set up evil, evil-leader, evil-jumper
;(require 'init-leader) ;TODO wnated?

;;----------------------------------------------------------------------------
;; Allow users to provide an optional "init-preload-local.el"
;;----------------------------------------------------------------------------
(require 'init-preload-local nil t)

;;----------------------------------------------------------------------------
;; Load configs for specific features and modes
;;----------------------------------------------------------------------------

(require-package 'project-local-variables)
(require-package 'diminish)
;; logs keyboard commands to a buffer named 'command-log'.
(require-package 'mwe-log-commands) ;is this working?
(require-package 'ack)

(require 'init-frame-hooks)
(require 'init-themes)
(require 'init-osx-keys) ;; makes changes to Linux too; TODO: rename or something
(require 'init-dired)
(require 'init-grep)
(require 'init-uniquify)
(require 'init-ibuffer)

(require 'init-helm)
(require 'init-hippie-expand)
(require 'init-auto-complete)
;(require 'init-sessions.el) ;save desktop? ;testing
(require 'init-mmm)

(require 'init-editing-utils);; haven't learned this yet

;; homemade
(require 'init-eval-sexp)
(require 'init-eshell)

(require 'init-vc)
(require 'init-git)
(require 'init-github)

;(require 'init-paredit);gross
(require 'init-lisp);untested
;(require 'init-slime);untested
(when (>= emacs-major-version 24)
  (require 'init-clojure)
  (require 'init-clojure-cider))

;;	  package-archives )
;;(push '("melpa" . "http://melpa.milkbox.net/packages/")
;;	  package-archives)
;;
;;;; activate all the packages (in particular autoloads)
;;(package-initialize)
;;
;;;; prevent warning
;;(require 'cl)

;;(setq pkgs-to-install
;;      (let ((uninstalled-pkgs (remove-if 'package-installed-p required-pkgs)))
;;        (remove-if-not '(lambda (pkg) (y-or-n-p (format "Package %s is missing. Install it? " pkg))) uninstalled-pkgs)))
;;
;;(when (> (length pkgs-to-install) 0)
;;  (package-refresh-contents)
;;  (dolist (pkg pkgs-to-install)
;;    (package-install pkg)))


;;;;;;;;;;;;;;;;;;;;;;;;nick

;;; helpful reminders:
; M-p (while in repl) ; cider-repl-previous-input
; M-n (while in repl) ; next command
; C-h f function-name
; C-h k key-sequence
; C-h v variable-name
; C-h m ; to view current minor modes
; M-x eval-region ; re-evaluate changed region in .emacs
; M-x eval-expression ; re-evaluate expression
; M-x load-file ; re-load .emacs
; M-x occur ; search open buffers
;;; eval emacs sexp
; C-x C-e ; which is eval-last-sexp
; ‘C-u C-x C-e’ ; same thing but prints to the buffer
; C-h v then to evaluate a variable
; M-: ; eval-expression
;determine emacs version > http://ergoemacs.org/emacs/elisp_determine_OS_version.html




;; change yes or no prompt to y or n prompts:
(fset 'yes-or-no-p 'y-or-n-p)


;; inhibit annoying minibuffer messages 
;;http://superuser.com/questions/669701/emacs-disable-some-minibuffer-messages
(when (eval-when-compile (> emacs-major-version 24))
  (let ((inhibit-message t))
     (message "Listen to me, you!")))

;; Stop disabling commands
;;http://trey-jackson.blogspot.com/2007/12/emacs-tip-3-disabling-commands.html
;(setq disabled-command-hook nil)


;; TODO: test this
;; Copied from jcf
;; TODO: put this in separate file
(evil-add-hjkl-bindings magit-log-mode-map 'emacs)
(evil-add-hjkl-bindings magit-commit-mode-map 'emacs)
(evil-add-hjkl-bindings magit-branch-manager-mode-map 'emacs
  "K" 'magit-discard-item
  "L" 'magit-key-mode-popup-logging)
(evil-add-hjkl-bindings magit-status-mode-map 'emacs
  "K" 'magit-discard-item
  "l" 'magit-key-mode-popup-logging
  "h" 'magit-toggle-diff-refine-hunk)

;;;Scroll when searching
;; Copied from jcf
(defadvice evil-search-next
    (after advice-for-evil-search-next activate)
  (evil-scroll-line-to-center (line-number-at-pos)))

(defadvice evil-search-previous
    (after advice-for-evil-search-previous activate)
  (evil-scroll-line-to-center (line-number-at-pos)))

;;TODO: Add this to dired??
;; Copied from jcf
(evil-add-hjkl-bindings dired-mode-map 'emacs)
(evil-add-hjkl-bindings dired-mode-map 'emacs
  "J" 'dired-goto-file
  "K" 'dired-do-kill-lines
  "L" 'dired-do-redisplay)

;; Copied from jcf
(define-key evil-normal-state-map "Y" (kbd "y$")); Untested

(global-set-key (kbd "C-S-<escape>") 'delete-other-windows)

; evil-leader
(evil-leader/set-key "rename" 'rename-file-and-buffer); ,rename
(evil-leader/set-key "cl" 'delete-window); ,cl close buffer
(evil-leader/set-key "cc" 'evilnc-comment-or-uncomment-lines)
(evil-leader/set-key "cp" 'evilnc-copy-and-comment-lines); comment & paste
(evil-leader/set-key "w" 'save-buffer); ,w write
(evil-leader/set-key "f" 'helm-find-files); ,f
(evil-leader/set-key ",fo" 'helm-occur); ,f
(evil-leader/set-key ",fy" 'helm-show-kill-ring); ,f
(evil-leader/set-key "dd" 'dired); ,d dired
(evil-leader/set-key "db" 'kill-buffer)
(evil-leader/set-key "df" 'delete-this-file)
(evil-leader/set-key "eb" 'eval-buffer)
(evil-leader/set-key "ed" 'eval-defun)
(evil-leader/set-key "ee" 'eval-expression)

(evil-leader/set-key "er" 'eval-region)
(evil-leader/set-key "es" 'eval-last-sexp)

(evil-leader/set-key "ga" 'git-messenger:popup-message); what is this?
; magit. Read this: https://github.com/magit/magit/issues/1968
(evil-leader/set-key "gc" 'magit-commit)
(evil-leader/set-key "gl" 'magit-log)
(evil-leader/set-key "gs" 'magit-status)
(evil-leader/set-key "hf" 'describe-function)
(evil-leader/set-key "hF" 'find-function)
(evil-leader/set-key "hk" 'describe-key)
(evil-leader/set-key "hK" 'find-function-on-key); quickly find source by keymap
(evil-leader/set-key "hm" 'describe-mode)
(evil-leader/set-key "hp" 'describe-package)
(evil-leader/set-key "hv" 'describe-variable)
;(evil-leader/set-key "i" 'ielm)
(evil-leader/set-key "pi" 'package-install)
(evil-leader/set-key "pl" 'package-list-packages)
(evil-leader/set-key "sh" 'eshell);
;(evil-leader/set-key "Sh" 'jcf-eshell-here); what is this?
(evil-leader/set-key "x" 'execute-extended-command)


;;; buffers and tabs
;(evil-leader/set-key "b" 'ibuffer);
(evil-leader/set-key "b" 'helm-buffers-list);
(evil-leader/set-key ",fb" 'helm-buffers-list); is this too much??
(evil-leader/set-key "tn" 'elscreen-create); ,tn tabnew
(global-set-key (kbd "<f9>") 'elscreen-previous); F9 tabprevious
(global-set-key (kbd "<f10>") 'elscreen-next)	; F10 tabnext
(global-set-key (kbd "<f12>") 'evil-window-split)	; F10 tabnext
(global-set-key (kbd "S-<f12>") 'evil-window-vsplit)	; F10 tabnext

;; Cider & Clojure
(evil-leader/set-key "ce" 'cider-visit-error-buffer)
(evil-leader/set-key "cr" 'cider-switch-to-relevant-repl-buffer)
(evil-leader/set-key "cb" 'cider-switch-to-last-clojure-buffer)

(evil-leader/set-key-for-mode 'clojure-mode
  "v" 'cider-test-run-test
  "V" 'jcf-cider-test-run-tests
  "cC" 'cider-connect
  "cJ" 'cider-jack-in
  "cq" 'cider-quit
  "cR" 'cider-restart
  "ct" 'typed-clojure-check-ns
  "eb" 'cider-eval-buffer
  "ed" 'cider-eval-defun-at-point
  "es" 'cider-eval-last-sexp
  "er" 'cider-eval-region)

(evil-leader/set-key-for-mode 'cider-repl-mode
  "cq" 'cider-quit
  "cr" 'cider-refresh
  "cR" 'cider-restart)

(defun nick-tab-edit (n) 
    (interactive "nPath:") ;   which is read with the Minibuffer.
    (evil-tabs-tabedit path))

(evil-leader/set-key "te" 'nick-tab-edit); ,te tabedit
;;(evil-leader/set-key "te" 'evil-tabs-tabedit); ,te tabedit
;; this ^ doesn't work because evil-tabs-tabedit takes a filename as
;; an argument. Instead, write a function that takes a path and
;; sends that to evil-tabs-tabedit

(global-set-key (kbd "C-S-x") 'elscreen-kill); ,clt tabclose

;;;Found here: http://stackoverflow.com/questions/8483182/evil-mode-best-practice
;;;; esc quits!!! instead of (or along with) C-g
(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))
(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
;; I might want this at a later time, but right now it breaks things.
;(define-key helm-map (kbd "ESC") 'helm-keyboard-quit)

;;; evil-escape ; I dont' know if this is doing anything
;(evil-escape-mode t)
;(setq-default evil-escape-key-sequence (kbd "<escape>"))
;(setq-default evil-escape-delay 0.01)

;;; emacs-bash-completion
;;; try doing this again read the directions first
;https://github.com/szermatt/emacs-bash-completion
;(autoload 'bash-completion-dynamic-complete 
;  "bash-completion"
;  "BASH completion hook")
;(add-hook 'shell-dynamic-complete-functions
;  'bash-completion-dynamic-complete)

;(global-set-key (kbd ", s h") 'shell)

(show-paren-mode 1); Options-> "Highlight matchinn parens"

;http://www.unexpected-vortices.com/clojure/10-minute-emacs-for-clojure.html
;(setq-default inhibit-startup-screen t); hide welcome screen in emacs

(setq make-backup-files nil); stop making backup files

;; Always show column numbers
(setq-default column-number-mode t)

;; Display full pathname for files.
;(add-hook 'find-file-hooks
;          '(lambda ()
;             (setq mode-line-buffer-identification 'buffer-file-truename)))

;; For easy window scrolling up and down.
(global-set-key "\M-n" 'scroll-up-line)
(global-set-key "\M-p" 'scroll-down-line)

; Map C-x C-b to buffer-menu rather than list-buffers
; so that it's easy to get rid of no-evil buffer
(global-set-key (kbd "C-x C-b") 'buffer-menu)

; not working
;(global-set-key (kbd "C-P") 'package-list-packages)

; always follow symbolic links
(setq vc-follow-symlinks t)

;; no blinking cursor
(blink-cursor-mode 0)

;; Plugins to thinkabout
;https://www.reddit.com/r/emacs/comments/1q99wi/moving_from_paredit_to_smartparens/
; paredit vs evil-paredit vs smartparens vs paxedit vs lispy??
; jcf likes smartparens
; evil cursor colors (to know when I'm in evil mode or not): https://github.com/syl20bnr/spacemacs/blob/master/spacemacs/packages.el#L544
; bind-key (yes this looks great.) (why in attic?)
; ack
; helm || ido
; dired-x
; magit
; eldoc-mode (shows argument list of function call)
; recentf-mode (previously edited files)
; Uniquify (override default mechanism for setting buffer names)
; evil-lisp-state
; evil-iedit-state
; evil-nerd-commenter
; evil-escape ??
; eldoc
; expand-region
; projectile
; adaptive-wrap maybe?
; more (I've looked until expand-region): https://github.com/syl20bnr/spacemacs/blob/master/spacemacs/packages.el





(defun switch-to-minibuffer-window ()
  "switch to minibuffer window (if active)"
  (interactive)
  (when (active-minibuffer-window)
    (select-window (active-minibuffer-window))))
(global-set-key (kbd "<f7>") 'switch-to-minibuffer-window)


;; remove this
;;; https://gist.github.com/sebasmagri/9727631
;;; PATH used by default in emacs is not that used in interactive shells. Thus, it would miss
;;; paths set in the shell's rc file.

;;; The login shell could print warnings or errors on initialization, so we isolate the PATH and
;;; use a simple regexp to get the real value
;;(let ((interactive-shell-path (shell-command-to-string "$SHELL -l -i -c 'echo \"***\n$PATH\n***\"'")))
;;  (string-match ".*\\*\\*\\*\\\n\\(.*\\)\n\\*\\*\\*.*" interactive-shell-path)
;;  (let ((clean-shell-path (match-string 1 interactive-shell-path)))
;;    (setenv "PATH" clean-shell-path) ;;; normal PATH
;;    (setq eshell-path-env clean-shell-path) ;;; PATH in eshell
;;    (setq exec-path (split-string clean-shell-path path-separator)) ;;; exec-path
;;    )
;;  )
