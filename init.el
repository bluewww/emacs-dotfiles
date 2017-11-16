; delete excess backup versions silently
(setq delete-old-versions -1)
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
			 ("melpa"     . "https://melpa.org/packages/")))
(package-initialize)

(unless (package-installed-p 'use-package)
 (package-refresh-contents)
 (package-install 'use-package))
(require 'use-package)
;(add-to-list
;  'load-path
;  (expand-file-name "evil-collection/" user-emacs-directory))

;(add-to-list
;  'load-path
;  (expand-file-name "evil-collection/" "~/.emacs.dev/"))

;(with-eval-after-load 'ivy (require 'evil-ivy) (evil-ivy-setup))

;; nice built in modes
(linum-mode)
(show-paren-mode)

(use-package which-key :ensure t
 :init
 (which-key-mode))
(use-package evil :ensure t
 :init
 (setq evil-want-C-u-scroll t)
 (evil-mode))
(use-package evil-surround :ensure t
  :config
  (global-evil-surround-mode 1))
(use-package evil-matchit :ensure t
  :config
  (evil-matchit-mode))
; TODO: bindings
;(use-package evil-search-highlight-persist :ensure t)
(use-package winum :ensure t
 :init
 (winum-mode))
(use-package rainbow-delimiters :ensure t
  :init
  (rainbow-delimiters-mode))
(use-package ivy :ensure t)
(use-package counsel :ensure t)
(use-package swiper :ensure t)
(use-package magit :ensure t)
(use-package avy :ensure t
  :commands (avy-goto-word-1))
(use-package general
  :ensure t
  :config
  ; replace default keybindings
  (general-define-key
   "C-'" 'avy-goto-word-1
   "M-x" 'counsel-M-x)
  ;; proper vim style escape

  (general-define-key
   :states '(normal visual)
   "<escape>" 'keyboard-quit)
  (general-define-key
   :keymaps '(minibuffer-local-map
	      minibuffer-local-ns-map
	      minibuffer-local-completion-map
	      minibuffer-local-must-match-map
	      minibuffer-local-isearch-map)
   "<escape>" 'minibuffer-keyboard-quit)

  ;; ivy navigation
  (general-define-key
   :keymaps 'ivy-minibuffer-map
   "C-j" 'ivy-next-line ; bugged
   "C-k" 'ivy-previous-line
   "C-h" (kbd "DEL") ; hack
   "C-l" 'ivy-alt-done
   "C-S-h" help-map
   "<escape>" 'minibuffer-keyboard-quit)

  (general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
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
   "bR" 'revert-buffer
   "bE" 'erase-buffer

   "/"   'counsel-git-grep

   ;; file handling
   "fs" 'save-buffer
   "fed" 'find-dotfile
   "ff" 'counsel-find-file
   "fr" 'counsel-recentf
   "pf" 'counsel-git
   "fj" 'dired-jump
   "fD" 'delete-file
   "fc" 'copy-file
   "fR" 'rename-file
   ;; TODO: sudo edit

   ;; window handling
   "wd" 'delete-window
   "wm" 'maximize-buffer
   "wh" 'evil-window-left
   "wj" 'evil-window-down
   "wk" 'evil-window-up
   "wl" 'evil-window-right
   "ws" 'split-window-below
   "wv" 'split-window-right
   "ww" 'other-window
   "1" 'winum-select-window-1
   "2" 'winum-select-window-2
   "3" 'winum-select-window-3
   "4" 'winum-select-window-4
   "5" 'winum-select-window-5

   ;; swiper
   "ss" 'swiper
   "sb" 'swiper-all

   ;; eshell
   "'" 'eshell

   ;; magit
   "gs" 'magit-status
   "gm" 'magit-dispatch-popup
   "gS" 'magit-stage-file
   "gU" 'magit-unstage-file

   ;; projectile
   "pc" 'projectile-compile-project
   "pf" 'projectile-find-file-dwim
   "pg" 'projectile-find-tag
   "pD" 'projectile-dired
   "pd" 'counsel-projectile-find-dir

   ;; spacemacs syle
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
   "hi" 'info))

;; Layers
(use-package evil-ediff :ensure t)

;(define-key evil-normal-state-map [escape] 'keyboard-quit)
;(define-key evil-visual-state-map [escape] 'keyboard-quit)
;(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
;(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
;(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
;(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
;(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)

(defun find-dotfile ()
  "Opens the emacs dotfile for quick editing"
  (interactive)
  (find-file-existing "~/.emacs.dev/init.el"))

;;; esc quits
(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))
