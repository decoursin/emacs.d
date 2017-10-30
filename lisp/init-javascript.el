;; Nick, here's a new
;; guide: https://github.com/xiaohanyu/oh-my-emacs/blob/master/modules/ome-javascript.org
;; another guide: https://yoo2080.wordpress.com/2012/03/15/js2-mode-setup-recommendation/
;; Copied from Purcell
;; Untested
;; IDK much about this file

(maybe-require-package 'json-mode)
(maybe-require-package 'js2-mode)
(maybe-require-package 'json-reformat-region)
(require-package 'js-comint)
(require-package 'react-snippets)

(defcustom preferred-javascript-mode
  (first (remove-if-not #'fboundp '(js2-mode js-mode)))
  "Javascript mode to use for .js files."
  :type 'symbol
  :group 'programming
  :options '(js2-jsx-mode js2-mode js-mode))

; indent
(defconst preferred-javascript-indent-level 4)
(setq json-reformat:indent-width 4)
(setq js2-basic-offset 4)

;; js2-jsx-mode
(add-to-list 'auto-mode-alist '("\\.jsx?\\'" . js2-jsx-mode))
(add-to-list 'interpreter-mode-alist '("node" . js2-jsx-mode))

;;; TODO: try this Nick
;;; Link: https://github.com/syl20bnr/spacemacs/blob/a298a5a311dfe8b449b5f538740303f1ab3d5695/layers/%2Bframeworks/react/packages.el
;; (defun spacemacs//setup-react-mode ()
;;   "Adjust web-mode to accommodate react-mode"
;;   (emmet-mode 0)
;;   ;; See https://github.com/CestDiego/emmet-mode/commit/3f2904196e856d31b9c95794d2682c4c7365db23
;;   (setq-local emmet-expand-jsx-className? t)
;;   ;; Enable js-mode snippets
;;   (yas-activate-extra-mode 'js-mode)
;;   ;; Force jsx content type
;;   (web-mode-set-content-type "jsx")
;;   ;; Don't auto-quote attribute values
;;   (setq-local web-mode-enable-auto-quoting nil)
;;   ;; Why do we do this ?
;;   (defadvice web-mode-highlight-part (around tweak-jsx activate)
;;     (let ((web-mode-enable-part-face nil))
;;       ad-do-it)))
;; 
;; (add-hook 'js2-jsx-mode-hook 'spacemacs//setup-react-mode)

(defun setup-js2-mode-syntax-checker ()
  (flycheck-select-checker 'javascript-eslint)
  (flycheck-mode))

;; Need to first remove from list if present, since elpa adds entries too, which
;; may be in an arbitrary order
(eval-when-compile (require 'cl))
(setq auto-mode-alist (cons `("\\.\\(js\\|es6\\)\\(\\.erb\\)?\\'" . ,preferred-javascript-mode)
                            (loop for entry in auto-mode-alist
                                  unless (eq preferred-javascript-mode (cdr entry))
                                  collect entry)))


;; js2-mode

;; Change some defaults: customize them to override
(setq-default js2-bounce-indent-p nil)
(after-load 'js2-mode
  ;; js2 mode's syntax error highlighting defaults
  (setq-default js2-mode-show-parse-errors t
                js2-mode-show-strict-warnings t)
  ;; ... but enable it if flycheck can't handle javascript
  (autoload 'flycheck-get-checker-for-buffer "flycheck")
  ;;;; deprecate by Nick
  ;; (defun sanityinc/disable-js2-checks-if-flycheck-active ()
  ;;   (unless (flycheck-get-checker-for-buffer)
  ;;     (set (make-local-variable 'js2-mode-show-parse-errors) t)
  ;;     (set (make-local-variable 'js2-mode-show-strict-warnings) t)))
  ;; (add-hook 'js2-mode-hook 'sanityinc/disable-js2-checks-if-flycheck-active)

  (add-hook 'js2-mode-hook (lambda () (setq mode-name "JS2")))

  (add-hook 'js2-mode-hook #'setup-js2-mode-syntax-checker)

  (after-load 'js2-mode
    (js2-imenu-extras-setup)))

;; js-mode
(setq-default js-indent-level preferred-javascript-indent-level)


(add-to-list 'interpreter-mode-alist (cons "node" preferred-javascript-mode))


;; Javascript nests {} and () a lot, so I find this helpful

(require-package 'rainbow-delimiters)
(dolist (hook '(js2-mode-hook js-mode-hook json-mode-hook))
  (add-hook hook 'rainbow-delimiters-mode))


;; ---------------------------------------------------------------------------
;; Run and interact with an inferior JS via js-comint.el
;; ---------------------------------------------------------------------------

(setq inferior-js-program-command "js")

(defvar inferior-js-minor-mode-map (make-sparse-keymap))
(define-key inferior-js-minor-mode-map "\C-x\C-e" 'js-send-last-sexp)
(define-key inferior-js-minor-mode-map "\C-\M-x" 'js-send-last-sexp-and-go)
(define-key inferior-js-minor-mode-map "\C-cb" 'js-send-buffer)
(define-key inferior-js-minor-mode-map "\C-c\C-b" 'js-send-buffer-and-go)
(define-key inferior-js-minor-mode-map "\C-cl" 'js-load-file-and-go)

(define-minor-mode inferior-js-keys-mode
  "Bindings for communicating with an inferior js interpreter."
  nil " InfJS" inferior-js-minor-mode-map)

(dolist (hook '(js2-mode-hook js-mode-hook))
  (add-hook hook 'inferior-js-keys-mode))

;; ---------------------------------------------------------------------------
;; Alternatively, use skewer-mode
;; ---------------------------------------------------------------------------

(when (maybe-require-package 'skewer-mode)
  (after-load 'skewer-mode
    (add-hook 'skewer-mode-hook
              (lambda () (inferior-js-keys-mode -1)))))


(provide 'init-javascript)
