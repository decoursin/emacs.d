;; Copied from Purcel
;; IDK this file

(ignore-errors
  (require-package 'erlang))

(when (package-installed-p 'erlang)
  (require 'erlang-start))

(provide 'init-erlang)
