;; sane defaults
(setq
 ; delete excess backup versions silently
 delete-old-versions -1
 ; make backups file even when in version controlled dir
 vc-make-backup-files t
 ; which directory to put backups file
 backup-directory-alist `(("." . "~/.emacs.dev/backups"))
 ; don't ask for confirmation when opening symlinked file
 vc-follow-symlinks t
 ; transform backups file name
 auto-save-file-name-transforms '((".*" "~/.emacs.dev/auto-save-list/" t))
 inhibit-startup-screen t
 ; silent bell when you make a mistake
 ring-bell-function 'ignore
 ; use utf-8 by default
 coding-system-for-read 'utf-8
 coding-system-for-write 'utf-8
 ; sentence SHOULD end with only a point.
 sentence-end-double-space nil
 default-fill-column 80
 help-window-select t
 tab-width 4
 initial-scratch-message "Welcome in Emacs")

(when window-system
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (blink-cursor-mode -1))

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
(add-hook 'text-mode-hook 'linum-mode)
(add-hook 'prog-mode-hook 'linum-mode)
(add-hook 'text-mode-hook 'show-paren-mode)
(add-hook 'prog-mode-hook 'show-paren-mode)

;; all packages
(use-package general :ensure t)
(general-define-key
 :states '(normal visual insert emacs)
 :prefix "SPC"
 :non-normal-prefix "M-SPC"
 "?" 'general-describe-keybindings)

(use-package which-key :ensure t
 :init
 (which-key-mode))
(use-package evil :ensure t
 :init
 (setq evil-want-C-u-scroll t)
 (evil-mode))
(use-package evil-surround
  :ensure t
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

;; completion framework
(use-package ivy
  :ensure t
  :config
  (ivy-mode 1)
  (setq ivy-wrap t)
  (setq ivy-count-format "(%d/%d) ")
  (setq ivy-use-virtual-buffers t)
  :general
  (general-define-key
   :keymaps 'ivy-minibuffer-map
   "C-j" 'ivy-next-line
   "C-k" 'ivy-previous-line
   "C-h" (kbd "DEL") ; hack
   "C-l" 'ivy-alt-done
   "C-d" 'ivy-scroll-up-command
   "C-u" 'ivy-scroll-down-command
   "C-S-h" help-map
   "<escape>" 'minibuffer-keyboard-quit)
  :general
  (general-define-key
  :states '(normal visual insert emacs)
  :prefix "SPC"
  :non-normal-prefix "M-SPC"
  "bb" 'ivy-switch-buffer))

(use-package counsel
  :ensure t
  :general
  (general-define-key
    :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "ff" 'counsel-find-file
   "fr" 'counsel-recentf
   "fp" 'counsel-git
   "hb" 'counse-descbinds
   ; TODO: explore more counsel functionality
   ; spacemacs syle
   "SPC" 'counsel-M-x)
  :general
  (general-define-key
   "M-x" 'counsel-M-x))

;; Searching
(use-package swiper
  :ensure t
  :general
  (general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "ss" 'swiper
   "sb" 'swiper-all))

;; Project managment
(use-package counsel-projectile :ensure t)

(use-package projectile
  :ensure t
  :general
  (general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "pc" 'counsel-projectile-compile-project
   "pf" 'counsel-projectile-find-file
   "pb" 'counsel-projectile-switch-to-buffer
   "pp" 'counsel-projectile-switch-project
   "pg" 'projectile-find-tag
   "pD" 'projectile-dired
   "pd" 'counsel-projectile-find-dir))

;; git intergration
(use-package magit
  :ensure t
  :general
  (general-define-key
   :states '(normal visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "gs" 'magit-status
   "gm" 'magit-dispatch-popup
   "gS" 'magit-stage-file
   "gU" 'magit-unstage-file)
  :config
  (use-package evil-magit :ensure t))

(use-package avy
  :ensure t
  :general
  (general-define-key
   "C-'" 'avy-goto-word-1))

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

(general-define-key
 :states '(normal visual insert emacs)
 :prefix "SPC"
 :non-normal-prefix "M-SPC"

 ;; buffer handling
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

 ;; eshell
 "'" 'eshell

 ;; exiting
 "qQ" 'kill-emacs
 "qR" 'restart-emacs ;TODO this is package
 "qs" 'save-buffers-kill-emacs

 ;; more help
 "hc" 'describe-char
 "hk" 'describe-key
 "hm" 'describe-mode
 "hp" 'describe-package
 "hf" 'describe-function ; those
 "hv" 'describe-variable ; are remapped to counsel
 "hi" 'info)

;; Layers
;; lazy evilification of built-in stuff
(with-eval-after-load "ediff"
  (use-package evil-ediff :ensure t))

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
