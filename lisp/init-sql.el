;; Originally from Purcell, modified by me.

;; The SQL buffer must have product "postgres", for example. So, (sql-set-product)

;; TODO: Add auto complete
;; TODO: http://emacs.stackexchange.com/questions/26365/is-there-a-company-backend-for-completion-in-sql-interactive-mode
;; TODO: learn other tricks: http://postgres.cz/wiki/PostgreSQL_SQL_Tricks_III

(require-package 'sql-indent)
(require-package 'edbi)
(after-load 'sql
  (require 'sql-indent))

(defun decoursin/pop-to-sqli-buffer-and-back ()
  "Switch to the corresponding sqli buffer, go to the end, then return back."
  (interactive)
  (let ((current-buffer (window-buffer)))
    (if sql-buffer
        (progn
          (pop-to-buffer sql-buffer)
          (goto-char (point-max))
          (pop-to-buffer current-buffer))
      (sql-set-sqli-buffer)
      (when sql-buffer
        (decoursin/pop-to-sqli-buffer-and-back)))))

(defun decoursin/pop-to-sqli-buffer ()
  "Switch to the corresponding sqli buffer, go to the end."
  (interactive)
    (if sql-buffer
        (progn
          (pop-to-buffer sql-buffer)
          (goto-char (point-max)))
      (sql-set-sqli-buffer)
      (when sql-buffer
        (decoursin/pop-to-sqli-buffer))))

(defun decoursin/sql-send-paragraph ()
  "Send the current paragraph to the SQL process."
  (interactive)
  (let ((start (save-excursion
		 (backward-paragraph)
		 (point)))
	(end (save-excursion
	       (forward-paragraph)
	       (point))))
    (progn
      (decoursin/pop-to-sqli-buffer-and-back)
      (sql-send-region start end))))

(defun decoursin/sql-send-region (start end)
  "Send a region to the SQL process."
  (interactive "r")
  (progn
    (decoursin/pop-to-sqli-buffer-and-back)
    (sql-send-string (buffer-substring-no-properties start end))))

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
  ;; also see init.el for a mapping of ",sql" to decoursin/sql-
  (define-key sql-mode-map (kbd "C-c C-r") 'decoursin/sql-send-region) ;; this one doesn't work!
  (define-key sql-mode-map (kbd "C-c C-c") 'decoursin/sql-send-paragraph)
  ;; (define-key sql-mode-map (kbd "C-c C-z") 'decoursin/pop-to-sqli-buffer)
;;; Nick, do I want this `sanityinc/never-indent?
  ;;  (add-hook 'sql-interactive-mode-hook 'sanityinc/never-indent)
  (when (package-installed-p 'dash-at-point)
    (defun sanityinc/maybe-set-dash-db-docset ()
      (when (eq sql-product 'postgres)
        (set (make-local-variable 'dash-at-point-docset) "psql")))

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


;; directions from: https://truongtx.me/2014/08/23/setup-emacs-as-an-sql-database-client
(setq sql-connection-alist
      '((postgres-default (sql-product 'postgres)
                          (sql-port 5432)
                          (sql-server "localhost")
                          (sql-user "postgres")
                          (sql-password "postgres")
                          (sql-database "postgres"))
        ))

(defun sql-postgres-default-nick ()
;; hmmm...
;; https://stackoverflow.com/questions/26677909/emacs-sql-mode-postgresql-and-inputing-password
;; http://emacsredux.com/blog/2013/06/13/using-emacs-as-a-database-client/
;; https://blog.rackspace.com/an-introduction-to-emacs-sqli-mode
;; http://ergoemacs.org/emacs/emacs_env_var_paths.html
  (interactive)
  (my-sql-connect 'postgres 'postgres-default))

(defun sql-postgres-panono-api-panotech-nick ()
  (interactive)
  (setenv "PGPASSWORD" "rse2eFP7Z8Xk8gu")
  (my-sql-connect 'postgres 'panotech))

(defun sql-set-sqli-buffer-nick ()
  "This is a copy of *sql-set-sqli-buffer* but not interactive."
  (let ((default-buffer (sql-find-sqli-buffer)))
    (if (null default-buffer)
        (sql-product-interactive)
      (let ((new-buffer (read-buffer "New SQLi buffer: " default-buffer t)))
        (if (null (sql-buffer-live-p new-buffer))
            (user-error "Buffer %s is not a working SQLi buffer" new-buffer)
          (when new-buffer
            (setq sql-buffer new-buffer)
            (run-hooks 'sql-set-sqli-hook)))))))

(defun my-sql-connect (product connection)
  ;; remember to set the sql-product, otherwise, it will fail for the first time
  ;; you call the function
  (setq sql-product product)
  (sql-connect connection)
  ;; automatically generate sql buffer
  (let ((buffer (find-file-noselect (concat "/tmp/nick"
                                            (number-to-string (random))
                                            ".sql"))))
    (select-window (previous-window))
    (switch-to-buffer buffer)
    (set (make-local-variable 'window-point-insertion-type) t)
    (sql-set-product "postgres")
    (sql-set-sqli-buffer-nick))
  )


;; PostgreSQL databases with underscores in their names trip up the prompt specified in sql.el. I work around this with the following. Warning, this sets the prompt globally, which is fine by me since I only ever use Postgres.
(add-hook 'sql-interactive-mode-hook
          (lambda ()
            (set (make-local-variable 'window-point-insertion-type) t)
            (setq sql-prompt-regexp "^.*[=][#>] ")
             (setq sql-prompt-cont-regexp "^[_[:alpha:]]*[-][#>] ")))

(provide 'init-sql)
