;; Copied from Purcell
;; Nick, I changed alot of this.

;;Electric Pair mode, a global minor mode, provides a way to easily insert matching delimiters. Whenever you insert an opening delimiter, the matching closing delimiter is automatically inserted as well, leaving point between the two.
(when (fboundp 'electric-pair-mode)
  (electric-pair-mode))
(when (eval-when-compile (version< "24.4" emacs-version))
  (electric-indent-mode 1))

;;----------------------------------------------------------------------------
;; Some basic preferences
;;----------------------------------------------------------------------------
(setq-default
 blink-cursor-interval 0.4
 bookmark-default-file (expand-file-name ".bookmarks.el" user-emacs-directory)
 buffers-menu-max-size 30
 case-fold-search t
; column-number-mode t
 delete-selection-mode t
; ediff-split-window-function 'split-window-horizontally
; ediff-window-setup-function 'ediff-setup-windows-plain
 indent-tabs-mode nil ;If you want to use spaces instead of tabs
 make-backup-files nil
 mouse-yank-at-point t
 save-interprogram-paste-before-kill t
; scroll-preserve-screen-position 'always
; set-mark-command-repeat-pop t ;; what does this do?
; show-trailing-whitespace t
 tooltip-delay 1.5
 truncate-lines nil
 truncate-partial-width-windows nil)
; visible-bell t) ; some bell/noise, seems like crap

;; automatically reloads buffer when changes from elsewhere.
;(global-auto-revert-mode)
;(setq global-auto-revert-non-file-buffers t
;      auto-revert-verbose nil)

;(transient-mark-mode t) ; I don't use marks


;;; Whitespace

(defun sanityinc/no-trailing-whitespace ()
  "Turn off display of trailing whitespace in this buffer."
  (setq show-trailing-whitespace nil))

;; Nick, do i want this?
;;;; But don't show trailing whitespace in SQLi, inf-ruby etc.
;;(dolist (hook '(special-mode-hook
;;                Info-mode-hook
;;                eww-mode-hook
;;                term-mode-hook
;;                comint-mode-hook
;;                compilation-mode-hook
;;                twittering-mode-hook
;;                minibuffer-setup-hook))
;;  (add-hook hook #'sanityinc/no-trailing-whitespace))


;; To use: M x whitespace-cleanup-mode
(require-package 'whitespace-cleanup-mode)

;; To use: M-x just-one-space
;; Result: removes all but 1 space between characters
(global-set-key [remap just-one-space] 'cycle-spacing)


;;; Newline behaviour

;; Nick, do I really want this?
;(global-set-key (kbd "RET") 'newline-and-indent)
;(defun sanityinc/newline-at-end-of-line ()
;  "Move to end of line, enter a newline, and reindent."
;  (interactive)
;  (move-end-of-line 1)
;  (newline-and-indent))

;; Nick, do I really want this?
;(global-set-key (kbd "S-<return>") 'sanityinc/newline-at-end-of-line)



;; Nick, what does htis do?
(when (eval-when-compile (string< "24.3.1" emacs-version))
  ;; https://github.com/purcell/emacs.d/issues/138
  (after-load 'subword
    (diminish 'subword-mode)))


;; Result: for example, changes lambda to lambda-symbol
(when (fboundp 'global-prettify-symbols-mode)
  (global-prettify-symbols-mode))


(when (> emacs-major-version 24)
(require-package 'undo-tree)
(global-undo-tree-mode)
(diminish 'undo-tree-mode)
)


;;;; (deprecated)
;;;; I don't think this is being used. Use visual-star instead
;; Am I using this? I think so but IDK.
;; (require-package 'highlight-symbol)
;; (dolist (hook '(prog-mode-hook html-mode-hook css-mode-hook))
;;   (add-hook hook 'highlight-symbol-mode)
;;   (add-hook hook 'highlight-symbol-nav-mode))
;; (add-hook 'org-mode-hook 'highlight-symbol-nav-mode)
;; (after-load 'highlight-symbol
;;   (diminish 'highlight-symbol-mode)
;;   (defadvice highlight-symbol-temp-highlight (around sanityinc/maybe-suppress activate)
;;     "Suppress symbol highlighting while isearching."
;;     (unless (or isearch-mode
;;                 (and (boundp 'multiple-cursors-mode) multiple-cursors-mode))
;;       ad-do-it)))

;; Nick - what does this do?
(require-package 'browse-kill-ring)
(setq browse-kill-ring-separator "\f")
(global-set-key (kbd "M-Y") 'browse-kill-ring)
(after-load 'browse-kill-ring
  (define-key browse-kill-ring-mode-map (kbd "M-n") 'browse-kill-ring-forward)
  (define-key browse-kill-ring-mode-map (kbd "M-p") 'browse-kill-ring-previous))
(after-load 'page-break-lines
  (push 'browse-kill-ring-mode page-break-lines-modes))


;;----------------------------------------------------------------------------
;; Don't disable narrowing commands
;;----------------------------------------------------------------------------
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-defun 'disabled nil)

;;----------------------------------------------------------------------------
;; Show matching parens
;;----------------------------------------------------------------------------
(show-paren-mode 1)

;;----------------------------------------------------------------------------
;; Expand region
;;----------------------------------------------------------------------------
(require-package 'expand-region)

;;----------------------------------------------------------------------------
;; Don't disable case-change functions
;;----------------------------------------------------------------------------
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)


;;----------------------------------------------------------------------------
;; Handy key bindings
;;----------------------------------------------------------------------------
;; deprecated I use ,-x
;; To be able to M-x without meta
;(global-set-key (kbd "C-x C-m") 'execute-extended-command)

;; deprecated
;; Vimmy alternatives to M-^ and C-u M-^
;(global-set-key (kbd "C-c j") 'join-line)
;(global-set-key (kbd "C-c J") (lambda () (interactive) (join-line 1)))

;; deprecated
;(global-set-key (kbd "C-.") 'set-mark-command)
;(global-set-key (kbd "C-x C-.") 'pop-global-mark)

;; deprecated
;(when (maybe-require-package 'avy)
;  (autoload 'avy-goto-word-or-subword-1 "avy")
;  (global-set-key (kbd "C-;") 'avy-goto-word-or-subword-1))

;;; Nick, learn this if you want fine
;(require-package 'multiple-cursors)
;;; multiple-cursors
;(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
;(global-set-key (kbd "C->") 'mc/mark-next-like-this)
;(global-set-key (kbd "C-+") 'mc/mark-next-like-this)
;(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
;;; From active region to multiple cursors:
;(global-set-key (kbd "C-c c r") 'set-rectangular-region-anchor)
;(global-set-key (kbd "C-c c c") 'mc/edit-lines)
;(global-set-key (kbd "C-c c e") 'mc/edit-ends-of-lines)
;(global-set-key (kbd "C-c c a") 'mc/edit-beginnings-of-lines)


;; deprecated: remove this chunk later
;; Purcell said: Train myself to use M-f and M-b instead
;;(global-unset-key [M-left])
;;(global-unset-key [M-right])



;;;; deprecated
;;(defun kill-back-to-indentation ()
;;  "Kill from point back to the first non-whitespace character on the line."
;;  (interactive)
;;  (let ((prev-pos (point)))
;;    (back-to-indentation)
;;    (kill-region (point) prev-pos)))
;;
;;(global-set-key (kbd "C-M-<backspace>") 'kill-back-to-indentation)


;;----------------------------------------------------------------------------
;; Page break lines
;;----------------------------------------------------------------------------
;This Emacs library provides a global mode which displays ugly form feed characters as tidy horizontal rules.
(require-package 'page-break-lines)
(global-page-break-lines-mode)
(diminish 'page-break-lines-mode)

;;----------------------------------------------------------------------------
;; Fill column indicator
;;----------------------------------------------------------------------------
;; Nick, what is this?
(when (eval-when-compile (> emacs-major-version 23))
  (require-package 'fill-column-indicator)
  (defun sanityinc/prog-mode-fci-settings ()
    (turn-on-fci-mode)
    (when show-trailing-whitespace
      (set (make-local-variable 'whitespace-style) '(face trailing))
      (whitespace-mode 1)))

  ;;(add-hook 'prog-mode-hook 'sanityinc/prog-mode-fci-settings)

  (defun sanityinc/fci-enabled-p ()
    (and (boundp 'fci-mode) fci-mode))

  (defvar sanityinc/fci-mode-suppressed nil)
  (defadvice popup-create (before suppress-fci-mode activate)
    "Suspend fci-mode while popups are visible"
    (let ((fci-enabled (sanityinc/fci-enabled-p)))
      (when fci-enabled
        (set (make-local-variable 'sanityinc/fci-mode-suppressed) fci-enabled)
        (turn-off-fci-mode))))
  (defadvice popup-delete (after restore-fci-mode activate)
    "Restore fci-mode when all popups have closed"
    (when (and sanityinc/fci-mode-suppressed
               (null popup-instances))
      (setq sanityinc/fci-mode-suppressed nil)
      (turn-on-fci-mode)))

  ;; Regenerate fci-mode line images after switching themes
  (defadvice enable-theme (after recompute-fci-face activate)
    (dolist (buffer (buffer-list))
      (with-current-buffer buffer
        (when (sanityinc/fci-enabled-p)
          (turn-on-fci-mode))))))


;;----------------------------------------------------------------------------
;; Shift lines up and down with M-up and M-down. When paredit is enabled,
;; it will use those keybindings. For this reason, you might prefer to
;; use M-S-up and M-S-down, which will work even in lisp modes.
;;----------------------------------------------------------------------------
;; deprecated
;(require-package 'move-dup)
;(global-set-key [M-up] 'md/move-lines-up)
;(global-set-key [M-down] 'md/move-lines-down)
;(global-set-key [M-S-up] 'md/move-lines-up)
;(global-set-key [M-S-down] 'md/move-lines-down)
;
;(global-set-key (kbd "C-c p") 'md/duplicate-down)
;(global-set-key (kbd "C-c P") 'md/duplicate-up)

;;----------------------------------------------------------------------------
;; Fix backward-up-list to understand quotes, see http://bit.ly/h7mdIL
;;----------------------------------------------------------------------------
(defun backward-up-sexp (arg)
  "Jump up to the start of the ARG'th enclosing sexp."
  (interactive "p")
  (let ((ppss (syntax-ppss)))
    (cond ((elt ppss 3)
           (goto-char (elt ppss 8))
           (backward-up-sexp (1- arg)))
          ((backward-up-list arg)))))

(global-set-key [remap backward-up-list] 'backward-up-sexp) ; C-M-u, C-M-up


;;----------------------------------------------------------------------------
;; Cut/copy the current line if no region is active
;;----------------------------------------------------------------------------
;; deprecated
;(require-package 'whole-line-or-region)
;(whole-line-or-region-mode t)
;(diminish 'whole-line-or-region-mode)
;(make-variable-buffer-local 'whole-line-or-region-mode)

;;----------------------------------------------------------------------------
;; Random line sorting
;;----------------------------------------------------------------------------
(defun sort-lines-random (beg end)
  "Sort lines in region randomly."
  (interactive "r")
  (save-excursion
    (save-restriction
      (narrow-to-region beg end)
      (goto-char (point-min))
      (let ;; To make `end-of-line' and etc. to ignore fields.
          ((inhibit-field-text-motion t))
        (sort-subr nil 'forward-line 'end-of-line nil nil
                   (lambda (s1 s2) (eq (random 2) 0)))))))


;; Result: \t and \n are highlighted in strings so they're not hidden
(require-package 'highlight-escape-sequences)
(hes-mode)


;; This is pretty interesting
;; For example, press ", e" and wait a couple seconds...
(require-package 'guide-key)
(setq guide-key/guide-key-sequence '("," "C-x" "C-c" "C-x 4" "C-x 5" "C-c ;" "C-c ; f" "C-c ' f" "C-x n" "C-x C-r" "C-x r"))
;guide-key checks all sequences after that starts with the ones list above
; like ",c" works now too
(setq guide-key/recursive-key-sequence-flag t)
(setq guide-key/popup-window-position 'bottom)
(guide-key-mode 1)
(setq guide-key/idle-delay 6.0)
(diminish 'guide-key-mode)


(provide 'init-editing-utils)
