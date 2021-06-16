;;; colorscheme.el -*- lexical-binding: t; -*-


;; TODO: go through and make this fit more with the other thing
(ch/pkg colorscheme ()
  (set-face-attribute 'default nil :height 140)
  
  ;; unfortunately i can't have the actual theme here
  ;; because it needs to be discoverable by emacs
  ;; so it's in ~/.emacs.d/ and i just load it here :(
  (load "~/.emacs.d/hawaii-theme")
  (require 'hawaii-theme)
  (load-theme 'hawaii t))
