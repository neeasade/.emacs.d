(ch/pkg builtin
  (add-hook 'before-save-hook #'delete-trailing-whitespace)

  (set-face-attribute 'default nil
		      :font "Fira Mono"
		      :height 140)

  (setq backup-directory-alist `(("." . ,(concat user-emacs-directory "backups")))
	inhibit-startup-screen t
	read-process-output-max (* 1024 1024 4) ;; 2MB
	ring-bell-function 'ignore)

  (setq exec-path
	`("/Library/Apple/usr/bin"
	  ,(expand-file-name "~/bin")
	  ,(expand-file-name "~/go/bin")
	  "/bin"
	  "/opt/local/bin"
	  "/opt/local/sbin"
	  "/sbin"
	  "/usr/bin"
	  "/usr/local/bin"
	  "/usr/sbin"))

  (run-with-idle-timer
   1 t
   (lambda ()
     (garbage-collect-maybe 3)))

  (global-auto-revert-mode 1)
  (global-display-line-numbers-mode 1)
  (global-eldoc-mode -1)
  (setq eldoc-documentation-function #'ignore))
