;;; evil.el -*- lexical-binding: t; -*-


(ch/pkg evil ()
  (defmacro ch/evil/define-key-all (states &rest body)
    (declare (indent defun))
    `(progn
       ,@(mapcar
	  (lambda (state)
	    `(evil-define-key nil ,state
	       ,@body))
	  states)))
  
  (defun ch/evil/start-of-line ()
    (interactive)
    (evil-first-non-blank))
  
  (defun ch/evil/end-of-line ()
    (interactive)
    (evil-end-of-line)
    (unless (or (eq evil-state 'visual)
		(equal "" (buffer-substring (line-beginning-position) (line-end-position))))
      (forward-char)))

  (defun ch/evil/last-file-buffer ()
    (interactive)
    (let* ((file-buffers (seq-filter #'buffer-file-name (buffer-list)))
	   (last-file-buffer (when (> (length file-buffers) 1)
			       (cadr file-buffers))))
      (switch-to-buffer last-file-buffer)))
  
  (use-package undo-fu)
  
  (use-package evil
    :init (evil-mode 1)
    :config
    (ch/evil/define-key-all (evil-insert-state-map evil-normal-state-map evil-visual-state-map)
      "\C-a" 'ch/evil/start-of-line
      "\C-e" 'ch/evil/end-of-line)

    (evil-define-key nil evil-insert-state-map
      "\C-f" 'evil-normal-state)
    
    (evil-define-key nil evil-normal-state-map
      ";" 'ch/evil/last-file-buffer
      "u" 'undo-fu-only-undo
      (kbd "C-c c") 'evilnc-comment-or-uncomment-lines
      "\C-r" 'undo-fu-only-redo))

  (use-package evil-nerd-commenter))