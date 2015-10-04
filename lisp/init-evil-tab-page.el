;; Initally copied from tarao but I removed alot of it
;; https://gist.githubusercontent.com/tarao/5019545/raw/a45a2675e283c92724790b394910b6f80fad3c76/evil-tab-page.el

;; Nick todo:
;; 1) remap:
;;	  - elscreen-create to evil-tab-new
;;	  - elscreen-next to evil-tab-next
;;	  - elscreen-previous to evil-tab-previous
;; 2) evil-tab-edit to find-file in new window.
;; 3) 

;; Nick what does this do?
;(setq elscreen-tab-display-control nil
;      elscreen-tab-display-kill-screen nil)

(evil-define-command evil-tab-find-file-at-point (&optional count)
  :repeat nil
  (let ((buffer (current-buffer)))
    (evil-tab-new)
    (switch-to-buffer buffer))
  (find-file-at-point))

(evil-define-command evil-tab-find-file-at-point-with-line (&optional count)
  :repeat nil
  (let ((buffer (current-buffer)))
    (evil-tab-new)
    (switch-to-buffer buffer))
  (evil-find-file-at-point-with-line))

;(evil-define-command evil-tab-next (&optional count)
;  :repeat nil
;  (interactive "P")
;  (if count
;      (elscreen-goto count)
;    (elscreen-next)))
;
;(evil-define-command evil-tab-previous (&optional count)
;  :repeat nil
;  (interactive "P")
;  (if count
;      (let* ((screens (length (elscreen-get-screen-list)))
;             (screen (- screens count 1)))
;        (when (>= screen 0)
;          (elscreen-goto screen)))
;    (elscreen-previous)))

;(evil-define-command evil-tab-first ()
;  :repeat nil
;  (elscreen-goto 0))
;
;(evil-define-command evil-tab-last ()
;  :repeat nil
;  (elscreen-goto (1- (length (elscreen-get-screen-list)))))

;(defadvice evil-quit (around tabclose-or-quit activate)
;  (if (> (length (elscreen-get-screen-list)) 1)
;      (condition-case nil
;          (delete-window)
;        (error (evil-tab-close)))
;    ad-do-it))

;(evil-ex-define-cmd "tabnew" #'evil-tab-new)
;(evil-ex-define-cmd "tabe[dit]" #'evil-tab-edit)
;(evil-ex-define-cmd "tabc[lose]" #'evil-tab-close)
;(evil-ex-define-cmd "tabo[nly]" #'evil-tab-only)
;(evil-ex-define-cmd "tabn[ext]" #'evil-tab-next)
;(evil-ex-define-cmd "tabp[revious]" #'evil-tab-previous)
;(evil-ex-define-cmd "tabN[ext]" #'evil-tab-previous)
;(evil-ex-define-cmd "tabfir[st]" #'evil-tab-first)
;(evil-ex-define-cmd "tabl[ast]" #'evil-tab-last)
;(evil-ex-define-cmd "tabs" #'elscreen-display-screen-name-list)

;(define-key evil-motion-state-map (kbd "gt") #'evil-tab-next)
;(define-key evil-motion-state-map (kbd "gT") #'evil-tab-previous)
(define-key evil-window-map (kbd "gf") #'evil-tab-find-file-at-point)
(define-key evil-window-map (kbd "gF") #'evil-tab-find-file-at-point-with-line)

; A function that behaves like Vim's ':tabe' commnad for creating a new tab and
; buffer (the name "[No Name]" is also taken from Vim).
(defun vimlike-:tabe ()
  "Vimlike ':tabe' behavior for creating a new tab and buffer."
  (interactive)
  (let ((buffer (generate-new-buffer "[No Name]")))
      ; create new tab
      (elscreen-create)
      ; set window's buffer to the newly-created buffer
      (set-window-buffer (selected-window) buffer)
      ; set state to normal state
      (with-current-buffer buffer
        (evil-normal-state))
    )
  )

(provide 'init-tab-page)
