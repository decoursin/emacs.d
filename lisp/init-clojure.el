;; Copied form Purcell
;; Haven't learned yet

;; Basic clojure support, even in Emacs 23
;; See also init-clojure-cider.el

(require-package 'clojure-mode)
(require-package 'cljsbuild-mode)
(require-package 'elein)
(require-package 'clj-refactor)
(require-package 'clojure-cheatsheet)


(require 'clojure-cheatsheet)
;;;;;;;;;;;;;;;;;;;;
;;;; NEW try these
;;;;;;;;;;;;;;;;;;;

;(require 'yasnippet)
;
;(require 'core-async-mode)
;
;(add-hook 'clojure-mode-hook
;          (lambda ()
;            (clj-refactor-mode 1)
;            (core-async-mode 1)))
;
;(define-key clj-refactor-map
;  (cljr--key-pairs-with-modifier "C-s-" "xf") 'my-toggle-expect-focused)
;
;(define-key clj-refactor-map
;  (cljr--key-pairs-with-modifier "C-s-" "xr") 'my-remove-all-focused)
;
;(require 'symbol-focus)
;(define-key clojure-mode-map (kbd "M-s-f") 'sf/focus-at-point)
;
;(defun clj-duplicate-top-level-form ()
;  (interactive)
;  (save-excursion
;    (cljr--goto-toplevel)
;    (insert (cljr--extract-sexp) "\n")
;    (cljr--just-one-blank-line)))
;
;(define-key clojure-mode-map (kbd "C->") 'cljr-thread)
;(define-key clojure-mode-map (kbd "C-<") 'cljr-unwind)
;
;(define-key clojure-mode-map (kbd "s-j") 'clj-jump-to-other-file)
;
;(define-key clojure-mode-map (kbd "C-.") 'clj-hippie-expand-no-case-fold)
;
;(defun clj-hippie-expand-no-case-fold ()
;  (interactive)
;  (let ((old-syntax (char-to-string (char-syntax ?/))))
;    (modify-syntax-entry ?/ " ")
;    (hippie-expand-no-case-fold)
;    (modify-syntax-entry ?/ old-syntax)))
;
;(require-package 'yesql-ghosts)
;
;;; Indent and highlight more commands
;(put-clojure-indent 'match 'defun)
;
;;; try this maybe
;(defun my-toggle-expect-focused ()
;  (interactive)
;  (save-excursion
;    (search-backward "(expect" (cljr--point-after 'cljr--goto-toplevel))
;    (forward-word)
;    (if (looking-at "-focused")
;        (paredit-forward-kill-word)
;      (insert "-focused"))))
;
;(defun my-remove-all-focused ()
;  (interactive)
;  (save-excursion
;    (goto-char (point-min))
;    (while (search-forward "(expect-focused" nil t)
;      (delete-char -8))))
;
;(define-key clj-refactor-map
;  (cljr--key-pairs-with-modifier "C-s-" "xf") 'my-toggle-expect-focused)
;
;(define-key clj-refactor-map
;  (cljr--key-pairs-with-modifier "C-s-" "xr") 'my-remove-all-focused)
;
;;; Cycle between () {} []
;
;(defun live-delete-and-extract-sexp ()
;  "Delete the sexp and return it."
;  (interactive)
;  (let* ((begin (point)))
;    (forward-sexp)
;    (let* ((result (buffer-substring-no-properties begin (point))))
;      (delete-region begin (point))
;      result)))
;
;(defun live-cycle-clj-coll ()
;  "convert the coll at (point) from (x) -> {x} -> [x] -> (x) recur"
;  (interactive)
;  (let* ((original-point (point)))
;    (while (and (> (point) 1)
;                (not (equal "(" (buffer-substring-no-properties (point) (+ 1 (point)))))
;                (not (equal "{" (buffer-substring-no-properties (point) (+ 1 (point)))))
;                (not (equal "[" (buffer-substring-no-properties (point) (+ 1 (point))))))
;      (backward-char))
;    (cond
;     ((equal "(" (buffer-substring-no-properties (point) (+ 1 (point))))
;      (insert "{" (substring (live-delete-and-extract-sexp) 1 -1) "}"))
;     ((equal "{" (buffer-substring-no-properties (point) (+ 1 (point))))
;      (insert "[" (substring (live-delete-and-extract-sexp) 1 -1) "]"))
;     ((equal "[" (buffer-substring-no-properties (point) (+ 1 (point))))
;      (insert "(" (substring (live-delete-and-extract-sexp) 1 -1) ")"))
;     ((equal 1 (point))
;      (message "beginning of file reached, this was probably a mistake.")))
;    (goto-char original-point)))
;
;(define-key clojure-mode-map (kbd "C-`") 'live-cycle-clj-coll)
;
;(setq cljr-magic-require-namespaces
;      '(("io"   . "clojure.java.io")
;        ("set"  . "clojure.set")
;        ("str"  . "clojure.string")
;        ("walk" . "clojure.walk")
;        ("zip"  . "clojure.zip")
;        ("time" . "clj-time.core")
;        ("log"  . "taoensso.timbre")
;        ("json" . "cheshire.core")))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Misc clojure tweaks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(after-load 'clojure-mode
  (clj-refactor-mode 1)
  (add-hook 'clojure-mode-hook 'yas-minor-mode-on); for adding require/use/import statements in clj-refactor
  (add-hook 'clojure-mode-hook 'sanityinc/lisp-setup))

;; (add-auto-mode 'clojurescript-mode "\\.cljs\\'")

(provide 'init-clojure)
