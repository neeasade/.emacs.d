(require 'helm-projectile)

;; Defining the crockeo-mode keymap.
;;
;; Divided up hotkeys into individual sections. Note that certain hotkeys, which
;; are not global across emacs, are stored in individual files according to
;; their (major|minor)-mode.
(defun make-crockeo-mode-keymap ()
  (let ((crockeo-mode-map (make-sparse-keymap)))
    ;; evil-mode
    (define-key crockeo-mode-map (kbd "C-c C-c") 'evilnc-comment-or-uncomment-lines)

    ;; dired-sidebar
    (define-key crockeo-mode-map (kbd "C-c C-d") 'dired-sidebar-toggle-sidebar)

    ;; helm-projectile
    (define-key crockeo-mode-map (kbd "C-c C-a") 'helm-projectile-ag)
    (define-key crockeo-mode-map (kbd "C-c C-f") 'helm-projectile-find-file)
    (define-key crockeo-mode-map (kbd "C-c C-p") 'helm-projectile-switch-project)

    ;; misc
    (define-key crockeo-mode-map (kbd "RET") 'newline-and-indent)
    (define-key crockeo-mode-map (kbd "C-c C-i") 'ibuffer)

    crockeo-mode-map))

;; Defining crockeo-mode.
(define-minor-mode crockeo-mode
  "Personal minor-mode"
  :lighter " crockeo"
  :keymap (make-crockeo-mode-keymap))

;; Ensuring we don't use crockeo-mode when trying to enter a command.
(defun disable-crockeo-mode ()
  (crockeo-mode 0))

(add-hook 'minibuffer-setup-hook 'disable-crockeo-mode)

;; Globalizing crockeo-mode, so it works across buffers. Namely useful for when
;; I open dired-sidebar.
(define-globalized-minor-mode global-crockeo-mode
  crockeo-mode
  (lambda ()
    (crockeo-mode 1)))

(provide 'crockeo-mode)
(provide 'global-crockeo-mode)
