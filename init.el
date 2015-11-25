;; Mostly, by Nick DeCoursin :)


;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

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
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
(require 'init-compat)
(require 'init-utils)
(require 'init-site-lisp) ;; Must come before elpa, as it may provide package.el
(require 'init-elpa)      ;; Machinery for installing required packages
(require 'init-exec-path) ;; Set up $PATH

; evil
(require 'init-evil)
(require 'init-evil-tab-page)
;(require 'init-leader) ;TODO wnated?

;;----------------------------------------------------------------------------
;; Allow users to provide an optional "init-preload-local.el"
;;----------------------------------------------------------------------------
(require 'init-preload-local nil t)

;;----------------------------------------------------------------------------
;; Load configs for specific features and modes
;;----------------------------------------------------------------------------

(require-package 'project-local-variables)
(require-package 'fullframe)
(require-package 'diminish)
;; logs keyboard commands to a buffer named 'command-log'.
(require-package 'mwe-log-commands) ;is this working?

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
;(require 'init-spelling)
;(require 'init-sessions.el) ;save desktop? ;testing
(require 'init-mmm)

(require 'init-editing-utils);; haven't learned this yet

;; homemade
(require 'init-ag)
(require 'init-eval-sexp)
(require 'init-eshell)
(require 'init-matlab)
(require 'init-projectile)
;(require 'init-yasnippet) ;learn

;; elisp helper libraries
(require-package 'dash) ; a modern list api for Emacs
(require-package 'dash-functional)
(require-package 's)

;; vcs
(require 'init-vc)
(require 'init-git)
(require 'init-magit)
(require 'init-github)

;; Languages, etc
;(require 'init-compile)
(require 'init-markdown)
;(require 'init-erlang)
(require 'init-javascript)
;(require 'init-php)
;(require 'init-org)
(require 'init-nxml)
(require 'init-html)
(require 'init-css)
(require 'init-haml)
(require 'init-python-mode)
;(require 'init-haskell)
(require 'init-elm)
;(require 'init-ruby-mode)
;(require 'init-rails)
(require 'init-sql)


;; Lisp
;(require 'init-paredit);gross
(require 'init-lisp);untested
(require 'init-adjust-parens)
;(require 'init-slime);untested
(when (>= emacs-major-version 24)
  (require 'init-clojure)
  (require 'init-clojure-cider))
;; (require 'init-clojurescript)
(require 'init-4clojure)

(when *is-a-mac*
  (require-package 'osx-location)
  (require 'init-dash-documentation))
(when *is-linux*
  (require 'init-zeal))
(require-package 'regex-tool); what is this?

;; untested
;;----------------------------------------------------------------------------
;; Allow access from emacsclient
;;----------------------------------------------------------------------------
;(require 'server)
;(unless (server-running-p)
;  (server-start))


;;----------------------------------------------------------------------------
;; Variables configured via the interactive 'customize' interface
;;----------------------------------------------------------------------------
(when (file-exists-p custom-file)
  (load custom-file))

;; Temporary hold elisp stuff "init-temporary"
;; Created by Nick
;; Needed?
(require 'init-temporary nil t); what is the extra 'nil' and 't'?

;;----------------------------------------------------------------------------
;; Locales (setting them earlier in this file doesn't work in X)
;;----------------------------------------------------------------------------
(require 'init-locales)

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

;;;; Functions
(lexical-let ((count 1))
  (defun next-eshell ()
    (interactive)
    (eshell)
    (rename-buffer (concat "*eshell" (number-to-string count) "*"))
    (setq count (1+ count))))

(defun find-eshell (n)
  "Find the eshell"
  (interactive "NSwitch to #: ")
  (if (equal n 0)
      (switch-to-buffer "*eshell0*")
    (switch-to-buffer (concat "*eshell" (number-to-string n) "*"))))

(defun first-eshell ()
  (interactive)
  (let ((b (get-buffer "*eshell0*")))
    (if b
	(switch-to-buffer b)
      (progn
	(eshell)
	(rename-buffer "*eshell0*")))))

;; For some reason, evil-tabs-tabedit doesn't work out-of-the-box, so
;; I implement this wrapper function.
(defun find-file-new-window (filename)
  "Edit a file in a new window."
  (interactive "Fpath: ")
  ;; Set buffer first, to avoid a bug when
  ;; using find-file from eshell after elscreen-create.
    (let ((buffer (find-file-noselect filename)))
	(elscreen-create)
	(switch-to-buffer buffer)))

(defun yank-tab ()
  "Copy the current tab buffer to a new tab"
  (interactive)
  (let ((buffer-name (current-buffer)))
    (elscreen-create)
    (switch-to-buffer buffer-name)))

(defun load-init.el ()
  (interactive)
  (let ((emacs-home (getenv "EMACS_HOME"))
	(home (getenv "HOME")))
    (let ((f1 (concat emacs-home "/init.el"))
	  (f2 (concat home "/.emacs.d/init.el")))
      (if (file-exists-p f1)
	  (find-file f1)
	(when (file-exists-p f2)
	    (find-file f2))))))

(defun magit-clone-github (repository directory protocol)
  (interactive
   (let ((protocol (if current-prefix-arg
                       (magit-read-string-ns "Protocol")
                     "git"))
         (repostory (magit-read-string-ns "Clone repository")))
     (list repostory
           (read-directory-name
            "Clone to: " nil nil nil
            (and (string-match "\\([^/]+\\)\\'" repostory)
                 (match-string 1 repostory)))
           protocol)))
  (magit-clone (if (string= protocol "ssh")
                   (format "git@github.com:%s.git" repository)
                 (format "%s://github.com/%s.git" protocol repository))
               directory))

;; This doesn't work for some reason
;; open eshell in a new tab window
;(defun open-eshell-new-tab
;  (elscreen-create)
;  (eshell))

;; untested yet.
;; For find-files to accept multiply arguments
;(defadvice find-file (around find-files activate)
;  "Also find all files within a list of files. This even works recursively."
;  (if (listp filename)
;      (loop for f in filename do (find-file f wildcards))
;    ad-do-it))

;; what are these xxx-map?
;(substitute-key-definition 'find-file 'find-file-new-window global-map)
;(substitute-key-definition 'find-file 'find-file-new-window esc-map)
;(substitute-key-definition 'find-file 'find-file-new-window ctl-x-map)




;;;Scroll when searching
;; Copied from jcf
(defadvice evil-search-next
    (after advice-for-evil-search-next activate)
  (evil-scroll-line-to-center (line-number-at-pos)))

(defadvice evil-search-previous
    (after advice-for-evil-search-previous activate)
  (evil-scroll-line-to-center (line-number-at-pos)))

;; Add this to dired? Doesn't seem to work.
;; Copied from jcf
;(evil-add-hjkl-bindings dired-mode-map 'emacs)
;(evil-add-hjkl-bindings dired-mode-map 'emacs
;  "J" 'dired-goto-file
;  "K" 'dired-do-kill-lines
;  "L" 'dired-do-redisplay)

;; Copied from jcf
(define-key evil-normal-state-map "Y" (kbd "y$")); Untested

(global-set-key (kbd "C-S-<escape>") 'delete-other-windows)
(global-set-key (kbd "C-S-x") 'elscreen-kill); ,clt tabclose
; Map C-x C-b to buffer-menu rather than list-buffers
; so that it's easy to get rid of no-evil buffer
(global-set-key (kbd "C-x C-b") 'buffer-menu)

(global-set-key (kbd "C-S-o") 'previous-buffer)
(global-set-key (kbd "C-S-i") 'next-buffer)
(global-set-key (kbd "<mouse-9>") 'next-buffer);forward
(global-set-key (kbd "<mouse-8>") 'previous-buffer);back

; maybe someday when tab indents properly
;(define-key evil-normal-state-map [tab] 'other-window)
(setq tab-always-indent nil) ;; allow indenting

;; What does this do?
(setq evil-leader/in-all-states 1)

; evil-leader
;; TODO: ag prefixes
(evil-leader/set-key "ag" 'ag); ,cl close buffer
(evil-leader/set-key "af" 'ag-files); ag pattern
(evil-leader/set-key "ap" 'ag-project); ag pattern
(evil-leader/set-key "ap" 'ag-files); ag pattern

(evil-leader/set-key "cl" 'delete-window); ,cl close buffer
(evil-leader/set-key "cc" 'evilnc-comment-or-uncomment-lines)
(evil-leader/set-key "SPC" 'evilnc-comment-or-uncomment-lines)
(evil-leader/set-key "cp" 'evilnc-copy-and-comment-lines); comment & paste

(evil-leader/set-key "dd" 'dired-jump); ,d dired
(evil-leader/set-key "df" 'delete-this-file)
(evil-leader/set-key "db" 'evil-delete-buffer); buffer delete
;eval
(evil-leader/set-key "eb" 'eval-buffer)
(evil-leader/set-key "ep" 'eval-defun); ep eval-defun-at-point
(evil-leader/set-key "ee" 'eval-epression)
(evil-leader/set-key "er" 'eval-region)
(evil-leader/set-key "es" 'eval-last-sexp)

(evil-leader/set-key "ff" 'find-file);
(evil-leader/set-key "fo" 'helm-multi-occur-all-buffers);
(evil-leader/set-key "fsh" 'find-eshell);
(evil-leader/set-key "fy" 'helm-show-kill-ring);
;git
(evil-leader/set-key "ga" 'git-messenger:popup-message); what is this?
; magit. Read this: https://github.com/magit/magit/issues/1968
(evil-leader/set-key "gcc" 'magit-commit)
(evil-leader/set-key "gcl" 'magit-clone-github)
(evil-leader/set-key "gd" 'magit-diff-dwim)
(evil-leader/set-key "ge" 'ediff)
(evil-leader/set-key "gf" 'ediff-files)
(evil-leader/set-key "gb" 'ediff-buffers)
(evil-leader/set-key "gg" 'magit-dispatch-popup)
(evil-leader/set-key "gl" 'magit-log)
(evil-leader/set-key "gs" 'magit-status)
(evil-leader/set-key "gps" 'magit-stash-popup) ;gp git popup
(evil-leader/set-key "gpg" 'magit-dispatch-popup) ;gp git popup
(evil-leader/set-key "gpd" 'magit-diff-popup) ;gp git popup
(evil-leader/set-key "gpe" 'magit-ediff-popup) ;gp git popup
;help
(evil-leader/set-key "hf" 'describe-function)
(evil-leader/set-key "hF" 'find-function)
(evil-leader/set-key "hs" 'find-function) ; as in source it
(evil-leader/set-key "hk" 'describe-key)
(evil-leader/set-key "hK" 'find-function-on-key); quickly find source by keymap
(evil-leader/set-key "hm" 'describe-mode)
(evil-leader/set-key "hp" 'describe-package)
(evil-leader/set-key "hv" 'describe-variable)
(evil-leader/set-key "hz" 'zeal-at-point)
(evil-leader/set-key "ielm" 'ielm)

(evil-leader/set-key "linit" 'load-init.el)
;projectile
(evil-leader/set-key "pf" 'projectile-find-file)
(evil-leader/set-key "pte" 'projectile-find-file)
(evil-leader/set-key "pd" 'projectile-dired)
(evil-leader/set-key "pag" 'ag-project)

(evil-leader/set-key "nsh" 'next-eshell)

(evil-leader/set-key "rename" 'rename-this-file-and-buffer); ,rename
(evil-leader/set-key "sh" 'first-eshell);
;(evil-leader/set-key "Sh" 'jcf-eshell-here); what is this?

(evil-leader/set-key "yt" 'yank-tab) ; TODO: yt copy buffer like in chromium. write this yourself.
(evil-leader/set-key "x" 'execute-extended-command)
(evil-leader/set-key "w" 'save-buffer); ,w write
(evil-leader/set-key "zp" 'zeal-at-point)


;;; buffers and tabs
;(evil-leader/set-key "b" 'ibuffer);
(evil-leader/set-key "b" 'helm-buffers-list);
(evil-leader/set-key ",fb" 'helm-buffers-list); is this too much??
(evil-leader/set-key "tn" 'elscreen-create); ,tn tabnew
(evil-leader/set-key "te" 'find-file-new-window); ,tn tabnew
(global-set-key (kbd "<f9>") 'elscreen-previous); F9 tabprevious
(global-set-key (kbd "<f10>") 'elscreen-next)	; F10 tabnext
(global-set-key (kbd "<f12>") 'evil-window-split)	; F10 tabnext
(global-set-key (kbd "S-<f12>") 'evil-window-vsplit)	; F10 tabnext

;; Cider & Clojure
(evil-leader/set-key "ce" 'cider-visit-error-buffer)
(evil-leader/set-key "cr" 'cider-switch-to-relevant-repl-buffer)
(evil-leader/set-key "cb" 'cider-switch-to-last-clojure-buffer)
; doesn't work
;(evil-leader/set-key 'cider-repl-mode "k" 'cider-repl-previous-input)
;(evil-leader/set-key 'cider-repl-mode "j" 'cider-repl-next-input)

(evil-leader/set-key-for-mode 'clojure-mode
  "v" 'cider-test-run-test
  "V" 'jcf-cider-test-run-tests
  "cC" 'cider-connect
  "cd" 'cider-debug-defun-at-point
  "cD" 'cider-format-defn
  "cJ" 'cider-jack-in
  "cq" 'cider-quit
  "cR" 'cider-restart
  "cF" 'cider-format-buffer
  "ct" 'typed-clojure-check-ns
  "eb" 'cider-eval-buffer
  "ep" 'cider-eval-defun-at-point
  "es" 'cider-eval-last-sexp
  "er" 'cider-eval-region)

(evil-leader/set-key-for-mode 'cider-repl-mode
  "cq" 'cider-quit
  "cr" 'cider-refresh
  "cR" 'cider-restart)

;;(evil-leader/set-key "te" 'evil-tabs-tabedit); ,te tabedit
;; this ^ doesn't work because evil-tabs-tabedit takes a filename as
;; an argument. Instead, write a function that takes a path and
;; sends that to evil-tabs-tabedit


;; Where did this come from?
;; And what does it do?
;(defun evil-emacs-key-binding (key)
;  (evil-execute-in-emacs-state)
;  (key-binding key))
;
;(defmacro evil-revert-key-binding (state-map key)
;  `(define-key ,state-map ,key (lambda ()
;                                 (interactive)
;                                 (call-interactively
;                                  (evil-emacs-key-binding ,key)))))
;
;(eval-after-load "evil-autoloads"
;  '(add-hook 'evil-after-load-hook
;        (lambda ()
;          (evil-revert-key-binding evil-normal-state-map (kbd "M-."))
;          ;; and so on
;        )))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;; defuns ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
;; IDK if this is having an affect
(add-hook 'after-init-hook
          (lambda ()
		(define-key helm-map [escape] 'helm-keyboard-quit)))

;;; evil-escape ; I dont' know if this is doing anything
;(evil-escape-mode t)
;(setq-default evil-escape-key-sequence (kbd "<escape>"))
;(setq-default evil-escape-delay 0.01)

(defun switch-to-minibuffer-window ()
  "switch to minibuffer window (if active)"
  (interactive)
  (when (active-minibuffer-window)
    (select-window (active-minibuffer-window))))
(global-set-key (kbd "<f7>") 'switch-to-minibuffer-window)


;;; emacs-bash-completion
;;; try doing this again read the directions first
;https://github.com/szermatt/emacs-bash-completion
;(autoload 'bash-completion-dynamic-complete 
;  "bash-completion"
;  "BASH completion hook")
;(add-hook 'shell-dynamic-complete-functions
;  'bash-completion-dynamic-complete)









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


;; TODO:
;set eshell to be starting point
;push to git
;map ,a or something to ag
;try again to get emacs keybindings in ag search
;learn ag-xxxx commands
;map ,p to projectile or something
;remove full-ack, ack, helm-ag
;recentf learn
; git-timemachine and for evil keymaps read this: https://bitbucket.org/lyro/evil/issues/511/let-certain-minor-modes-key-bindings


; performance
;(add-hook 'after-init-hook
;          (lambda ()
;            (message "init completed in %.2fms"
;                     (sanityinc/time-subtract-millis after-init-time before-init-time))))

;;;;;;;;;;;;;;;;;;;;;;;; small changes ;;;;;;;;;;;;;;;;;;;
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

;; Display full pathname for files.
(add-hook 'find-file-hooks
          '(lambda ()
             (setq mode-line-buffer-identification 'buffer-file-truename)))

(setq make-backup-files nil); stop making backup files

;; Always show column numbers
(setq-default column-number-mode t)

; always follow symbolic links
(setq vc-follow-symlinks t)

;; no blinking cursor
(blink-cursor-mode 0)

; Maybe add this later
(tool-bar-mode -1)
(setq inhibit-splash-screen t)
;; (setq inhibit-startup-echo-area-message t)
;; (setq inhibit-startup-message t)

;; Plugins to thinkabout
;https://www.reddit.com/r/emacs/comments/1q99wi/moving_from_paredit_to_smartparens/
; paredit vs evil-paredit vs smartparens vs paxedit vs lispy vs parinfer (new)??
; jcf likes smartparens
; evil cursor colors (to know when I'm in evil mode or not): https://github.com/syl20bnr/spacemacs/blob/master/spacemacs/packages.el#L544
; bind-key (yes this looks great.) (why in attic?
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
; evil-commentary learn it and add it
; evil-escape ??
; eldoc
; expand-region
; projectile
; adaptive-wrap maybe?
; more (I've looked until expand-region): https://github.com/syl20bnr/spacemacs/blob/master/spacemacs/packages.el

;; Test and see if you like this
;; (setq evil-cross-lines t
;;       evil-move-cursor-back nil
;;       evil-want-fine-undo t
;;       evil-symbol-word-search t)
;;;;;;;;;;;;;;;;;;;;;;;; provide

(add-hook 'help-mode-hook #'evil-visual-state)

(provide 'init)

;; Local Variables:
;; coding: utf-8
;; no-byte-compile: t
;; End:
