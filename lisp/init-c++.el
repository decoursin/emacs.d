;;
;; this file is a WIP, mostly copied from here:
;; https://github.com/syl20bnr/spacemacs/blob/master/layers/%2Blang/c-c%2B%2B/packages.el
;;

(require-package 'cmake-mode)

;; (require 'cc-mode)
(require-package 'cc-mode)

;;
;; you'll have to install gtags for this to work
;; which is under the *global* package for some reason.
;; sudo apt install global
;;
;; Then, 1) open up a c++ file anywhere in the source directory.
;; 2) M-x ggtags-mode
;; 3) M-x ggtags-create-tags (choose directory to index)
;; 4) optionally choose ctags as backend (I believe it's faster for large projects)
;;
;; Installing ctags:
;; 1) clone https://github.com/universal-ctags/ctags
;; 2) follow directions here: https://github.com/universal-ctags/ctags/blob/master/docs/autotools.rst
;;    - NOTE: before running `./autogen.sh` you'll need to sudo apt install autotools-dev automake
;;

(require-package 'ggtags)
(require-package 'helm-cscope)
(require-package 'helm-gtags)
(require-package 'xcscope)
(require-package 'disaster) ;; disassemble c code
(require-package 'ycmd)

(require-package 'modern-cpp-font-lock)

(defun spacemacs/ggtags-mode-enable ()
  "Enable ggtags and eldoc mode.

For eldoc, ggtags advises the eldoc function at the lowest priority
so that if the major mode has better support it will use it first."
  (when gtags-enable-by-default
    (ggtags-mode 1)
    (eldoc-mode 1)))

(add-hook 'c-mode-local-vars-hook #'spacemacs/ggtags-mode-enable)
(add-hook 'c++-mode-local-vars-hook #'spacemacs/ggtags-mode-enable)

;; (add-to-list 'auto-mode-alist `("\\.h\\'" . ,c-c++-default-mode-for-headers))

(add-hook 'c++-mode-hook 'ycmd-mode)
(add-hook 'c-mode-hook 'ycmd-mode)

(modern-c++-font-lock-global-mode t)

;;; cmake-ide stuff
;;;; (require 'rtags) ;; optional, must have rtags installed
;; (cmake-ide-setup)

(provide 'init-c++)
