; delete excess backup versions silently
(setq delete-old-versions -1)
; use version control
(setq version-control t)
; make backups file even when in version controlled dir
(setq vc-make-backup-files t)
 ; which directory to put backups file
(setq backup-directory-alist `(("." . "~/.emacs.dev/backups")))
; don't ask for confirmation when opening symlinked file
(setq vc-follow-symlinks t)
 ;transform backups file name
(setq auto-save-file-name-transforms '((".*" "~/.emacs.dev/auto-save-list/" t)))
; inhibit useless and old-school startup screen
(setq inhibit-startup-screen t)
; silent bell when you make a mistake
(setq ring-bell-function 'ignore)
; use utf-8 by default
(setq coding-system-for-read 'utf-8 )
(setq coding-system-for-write 'utf-8 )
; sentence SHOULD end with only a point.
(setq sentence-end-double-space nil)
; toggle wrapping text at the 80th character
(setq default-fill-column 80)
; print a default message in the empty scratch buffer opened at startup
(setq initial-scratch-message "Welcome in Emacs")



(require 'package)
(setq package-enable-at-startup nil)
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
			 ("gnu"       . "http://elpa.gnu.org/packages/")
			 ("melpa"     . "https://melpa.org/packages/")
			 ("marmalade" . "http://marmalade-repo.org/packages/")))
(package-initialize)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
;(add-to-list
;  'load-path
;  (expand-file-name "evil-collection/" user-emacs-directory))
(add-to-list
  'load-path
  (expand-file-name "evil-collection/" "~/.emacs.dev/"))

(with-eval-after-load 'ivy (require 'evil-ivy) (evil-ivy-setup))
(setq evil-want-C-u-scroll t)
(use-package which-key :ensure t
  :init
  (which-key-mode))
(use-package ivy :ensure t)
(use-package counsel :ensure t)
(use-package swiper :ensure t)
;(use-package magit :ensure t)
(use-package evil :ensure t
  :init
  (evil-mode))
(use-package avy :ensure t
  :commands (avy-goto-word-1))
(use-package general :ensure t)

(general-define-key
  ;; replace default keybindings
  "C-'" 'avy-goto-word-1
  "M-x" 'counsel-M-x)

(defun find-dotfile ()
  (interactive)
  (find-file-existing "~/.emacs.dev/init.el"))

;; ivy navigation
(general-define-key
  "C-j" 'ivy-next-line ; bugged
  "C-k" 'ivy-previous-line
  "C-h" (kbd "DEL") ; hack
  "C-l" 'ivy-alt-done
  "C-S-h" help-map
  "<escape>" 'minibuffer-keyboard-quit)

(general-define-key
 :states '(normal visual insert emacs)
 :prefix "SPC
 ;; TODO fix this
 :non-normal-prefix "M-SPC"

  ;; buffer handling
  "bb" 'ivy-switch-buffer
  "bd" 'kill-this-buffer
  "bm" 'kill-other-buffers
  "bs" 'switch-to-scratch-buffer
  "bn" 'next-buffer
  "bp" 'previous-buffer
  "bw" 'read-only-mode
  "bN" 'new-empty-buffer

  "/"   'counsel-git-grep

  ;; file handling
  "fs"  'save-buffer
  "fed" 'find-dotfile
  "ff"  'counsel-find-file
  "fr"	'counsel-recentf
  "pf"  'counsel-git


  ;; swiper
  "ss" 'swiper
  "ss" 'swiper-all
  ;; magit
  "gs" 'magit-status

  "SPC" 'counsel-M-x

  ;; exiting
  "qQ" 'kill-emacs
  "qR" 'restart-emacs
  "qs" 'save-buffers-kill-emacs

  ;; help
  "hb" 'describe-bindings
  "hc" 'describe-char
  "hf" 'describe-function
  "hv" 'describe-variable
  "hk" 'describe-key
  "hm" 'describe-mode
  "hp" 'describe-package
  "hi" 'info)
