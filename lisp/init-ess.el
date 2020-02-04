;; nick - WIP

(require-package 'ess)
;; (require-package 'ess-smart-underscore)
;; (require-package 'ess-site)
;; (require-package 'ess-help)
;;; ess-view doesn't work correctly for some reason.
(require-package 'ess-view)

;;;;; Directions
;; 1) Install 'ess`: `apt-get insatll ess'
;; 2) uncomment `(require 'init-ess)` from init.el

;;; To connect to Postgres: https://www.datacareer.de/blog/connect-to-postgresql-with-r-a-step-by-step-example/
;; install.packages('RPostgres')
;; library(DBI)
;; db <- 'api'  #provide the name of your db
;; host_db <- '' #i.e. # i.e. 'ec2-54-83-201-96.compute-1.amazonaws.com'
;; db_port <- '5432'  # or any other port specified by the DBA
;; db_user <- ''
;; db_password <- ''
;; con <- dbConnect(RPostgres::Postgres(), dbname = db, host=host_db, port=db_port, user=db_user, password=db_password)

;; (require 'ess-smart-underscore)

;; The indentation style is from the official R coding standards
;; R-core uses C++ http://www.cran.r-project.org/doc/manuals/R-ints.html#R-coding-standards
;; hadley uses 2 spaces.
;;                                 DEF GNU BSD K&R C++
;; ess-indent-level                  2   2   8   5   4
;; ess-continued-statement-offset    2   2   8   5   4
;; ess-brace-offset                  0   0  -8  -5  -4
;; ess-arg-function-offset           2   4   0   0   0
;; ess-expression-offset             4   2   8   5   4
;; ess-else-offset                   0   0   0   0   0
;; ess-close-brace-offset            0   0   0   0   0

(add-hook 'ess-mode-hook
	  (lambda()
	    (setq ess-indent-level 2
		  tab-width 2)))

(add-to-list 'auto-mode-alist '("\\.Rprofile\\'" . R-mode))

;; No more _ to <-
(ess-toggle-underscore nil)

;; Oh, and if you haven't already, go ahead and set ess-eval-visibly to 'nowait. That way ESS/R doesn't hog Emacs while it's thinking. That really should be the default behavior, I've no idea why it's not. https://www.reddit.com/r/emacs/comments/8gr6jt/looking_for_tips_from_r_coders_who_use_ess/
(setq ess-eval-visibly 'nowait)

;; no more fancy comments
(setq ess-fancy-comments nil)

(add-hook 'inferior-ess-mode-hook
          '(lambda ()
             (local-set-key (kbd "C-w") 'evil-window-map)))

(provide 'init-ess)
