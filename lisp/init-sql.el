;; Copied from Purcell
;; Untested

;; TODO: Add auto complete
;; TODO: http://emacs.stackexchange.com/questions/26365/is-there-a-company-backend-for-completion-in-sql-interactive-mode
;; TODO: learn other tricks: http://postgres.cz/wiki/PostgreSQL_SQL_Tricks_III

(require-package 'sql-indent)
(after-load 'sql
  (require 'sql-indent))

(defun sanityinc/pop-to-sqli-buffer ()
  "Switch to the corresponding sqli buffer."
  (interactive)
  (if sql-buffer
      (progn
        (pop-to-buffer sql-buffer)
        (goto-char (point-max)))
    (sql-set-sqli-buffer)
    (when sql-buffer
      (sanityinc/pop-to-sqli-buffer))))

(setq sql-port 5432)

(setq-default sql-postgres-options)

;; don't use pager; empty title; expanded for column oriented output
(setq sql-postgres-options '("-P" "pager=off" "-P" "title= " "--expanded")) 

(defun toggle-expanded-postgres-nick ()
  (interactive)
  (if sql-buffer
      (progn
        (pop-to-buffer sql-buffer)
        (goto-char (point-max))
        (insert "\\x"))
    (sql-set-sqli-buffer)))


;; hooks
(add-hook 'sql-interactive-mode-hook
          (lambda ()
            (toggle-truncate-lines t)
            (local-unset-key (kbd "C-d"))
	    (local-set-key (kbd "<up>") 'comint-previous-input)
	    (local-set-key (kbd "<down>") 'comint-next-input)
            (setq word-wrap t)
            ;; (toggle-horizontal-scroll-bar t)
            (setq-local show-trailing-whitespace nil)))

;; hooks
(add-hook 'sql-mode-hook
          (lambda ()
            (setq word-wrap t)
            (local-unset-key (kbd "C-d"))
            (setq-local ac-ignore-case t)))

(after-load 'sql
  (define-key sql-mode-map (kbd "C-c C-z") 'sanityinc/pop-to-sqli-buffer)
  ;; (define-key sql-mode-map (kbd "C-c C-z") 'sanityinc/pop-to-sqli-buffer)
;;; Nick, do I want this `sanityinc/never-indent?
  ;;  (add-hook 'sql-interactive-mode-hook 'sanityinc/never-indent)
  (when (package-installed-p 'dash-at-point)
    (defun sanityinc/maybe-set-dash-db-docset ()
      (when (eq sql-product 'postgres)
        (set (make-local-variable 'dash-at-point-docset) "psql")))

    ;; Nick, this doesn't seem to do anything?
    (add-hook 'sql-interactive-mode-hook (lambda () (auto-complete-mode t)))
    (add-hook 'sql-mode-hook (lambda () (auto-complete-mode)))


    ;; (setq sql-postgres-options (list "--port 5432"))
    (add-hook 'sql-mode-hook 'sanityinc/maybe-set-dash-db-docset)
    (add-hook 'sql-interactive-mode-hook 'sanityinc/maybe-set-dash-db-docset)
    (defadvice sql-set-product (after set-dash-docset activate)
      (sanityinc/maybe-set-dash-db-docset))))

(setq-default sql-input-ring-file-name
              (expand-file-name ".sqli_history" user-emacs-directory))

;; See my answer to https://emacs.stackexchange.com/questions/657/why-do-sql-mode-and-sql-interactive-mode-not-highlight-strings-the-same-way/673
(defun sanityinc/font-lock-everything-in-sql-interactive-mode ()
  (unless (eq 'oracle sql-product)
    (sql-product-font-lock nil nil)))
(add-hook 'sql-interactive-mode-hook 'sanityinc/font-lock-everything-in-sql-interactive-mode)


(after-load 'page-break-lines
  (push 'sql-mode page-break-lines-modes))

;;;; Connect


(provide 'init-sql)
