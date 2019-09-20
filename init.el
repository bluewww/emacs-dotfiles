;;; init.el --- Emacs configuration that uses evil-mode and SPC as leader key
;;; -*- lexical-binding: t; -*-

;;; Commentary:

;; Inspired by spacemacs, but very minimal and lightweight. Startup time was
;; made to sure be kept low, so that non-server workflows are usuable. The main
;; bulk of configuration is done with the help of `use-package' and
;; `general-mode'.

;;; Code:

;; sane defaults for general settings
(setq
 ;; this improves starutp time, default is 800kb
 ;; only set during startup
 gc-cons-threshold 402653184
 gc-cons-percentage 0.6
 ;; backup file settings
 backup-directory-alist `(("." . ,(concat user-emacs-directory "backups")))
 backup-by-copying t
 version-control t
 keep-new-version 6
 keep-old-version 2
 delete-old-versions t
 ;; transform backups file name
 auto-save-file-name-transforms `((".*"
				   ,(concat
				    user-emacs-directory
				    "auto-save-list/")
				   t))
 inhibit-startup-screen t
 ;; silent bell when you make a mistake
 ring-bell-function 'ignore
 ;; sentence SHOULD end with only a point.
 sentence-end-double-space nil
 ;; source path
 source-directory "/usr/src/debug/emacs-26.1-lp150.309.6.x86_64"
 ;; fix bug with maximization
 frame-resize-pixelwise t
 help-window-select t
 tab-width 4
 ;; scroll just one line when hitting bottom of screen
 scroll-conservatively 10000)

(setq-default fill-column 80)

;; save so that we can later restore after startup
(defvar old-file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

;;; Restore hooks
;; measure startup time
(add-hook 'emacs-startup-hook
	  (lambda ()
	    (message "Emacs ready in %s with %d garbage collections."
		     (format "%.2f seconds"
			     (float-time
			      (time-subtract after-init-time before-init-time)))
		     gcs-done)))

;; reset gc to good values after startup
(add-hook 'emacs-startup-hook
	  (lambda()
	    (setq gc-cons-threshold 16777216
		  gc-cons-percentage 0.1)))

;; restore file name handlers
(add-hook 'emacs-startup-hook
	  (lambda()
	    (setq file-name-handler-alist old-file-name-handler-alist)))


;; UTF-8 as default encoding
(set-language-environment "UTF-8")

;; we want a portable python environment
(setenv "PATH" (concat "$HOME/.pyenv/bin:" (getenv "PATH")))
;; (getenv "PATH")
;; (add-to-list 'exec-path "/opt/miniconda3/bin")

;; ctags we like
(setq path-to-ctags "~/.local/bin/ctags")

;; line numbers
(if (version<= "26.1" emacs-version)
    (add-hook 'prog-mode-hook 'display-line-numbers-mode)
  (add-hook 'prog-mode-hook 'linum-mode))


(add-hook 'text-mode-hook 'show-paren-mode)
(add-hook 'prog-mode-hook 'show-paren-mode)

;; narrowing is nice
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-region 'disabled nil)

;; colum numbers
(column-number-mode)

;; disable abbrev saving
(setq save-abbrevs nil)

;; change the modeline descriptions to make them shorter
(defvar mode-line-cleaner-alist
  `((auto-revert-mode . " ρ")
    (auto-fill-function . " φ")
    (undo-tree-mode . "")
    (which-key-mode . "")
    (visual-line-mode . " σ")
    (ivy-mode . "")
    (anaconda-mode . " γ")
    ;; projectile has its own setting
    ;; (projectile-mode . projectile-mode-line)
    (eldoc-mode . " ε")
    ;; Major modes
    (lisp-interaction-mode . "λ")
    (python-mode . "py")
    (emacs-lisp-mode . "elisp"))
  "Alist for `clean-mode-line'.
When you add a new element to the alist, keep in mind that you
 must pass the correct minor/major mode symbol and a string you
 want to use in the modeline *in lieu of* the original.")

;; disable window stuff
(when (display-graphic-p)
  (tool-bar-mode -1)
  (tooltip-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1)
  (blink-cursor-mode -1))

(require 'package)
;; want to use use-package instead
(setq package-enable-at-startup nil)
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
			 ("gnu"       . "http://elpa.gnu.org/packages/")
			 ("melpa"     . "https://melpa.org/packages/")))
(package-initialize)

(setq package-check-signature nil)
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))
;; loading time
(setq use-package-verbose t)
(setq use-package-always-ensure t)
(setq use-package-compute-statistics t)

(add-to-list
 'load-path
 (expand-file-name "evil-collection/" user-emacs-directory))

;;;; All packages

;; temporary patch for dead keys, instead of env XMODIFIERS= emacs
(use-package iso-transl
  :defer t
  :ensure nil)

(use-package general)
;; just take the override map and increase its precedence to the maximum (for
;; evil) is is already an intercept map (evil-make-intercept-map
;; general-override-mode-map) the mapping has to be introduced as minor mode
(general-override-mode)
(general-define-key
 :states '(normal insert emacs visual motion)
 :keymaps 'override
 :prefix "SPC"
 :non-normal-prefix "M-SPC"
 "?" 'general-describe-keybindings)

(use-package evil
  :demand
  :init
  (setq evil-want-C-u-scroll t)
  (setq evil-want-integration nil)
  (when (not (display-graphic-p))
    (setq evil-want-C-i-jump nil))
  ;(setq evil-want-minibuffer t)
  :config
  (evil-mode 1)
  (global-undo-tree-mode 1)
  (evil-set-initial-state 'term-mode 'emacs)
  :general
  (general-define-key                   ; evil-mode seems to use it, so we unmap
					; it to make xref work
   :states 'normal
   "M-." nil)
  (general-define-key
   :states '(normal visual insert emacs motion)
   :keymaps 'override
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
    "wh" 'evil-window-left
    "wj" 'evil-window-down
    "wk" 'evil-window-up
    "wl" 'evil-window-right
    "wR" 'evil-window-rotate-upwards
    "wr" 'evil-window-rotate-downwards
    "w+" 'evil-window-increase-height
    "w-" 'evil-window-decrease-height
    "w;" 'evil-window-increase-width
    "w:" 'evil-window-decrease-width))

(use-package evil-surround
  :after evil
  :config
  (global-evil-surround-mode 1))

(use-package which-key
  :config
  (which-key-mode))

(use-package eyebrowse
  :defer t
  :config
  (eyebrowse-mode)
  :general
  (general-define-key
   :states '(normal visual insert emacs motion)
   :keymaps 'override
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
    "ea" 'eyebrowse-create-window-config
    "ed" 'eyebrowse-close-window-config
    "er" 'eyebrowse-rename-window-config
    "eb" 'eyebrowse-switch-to-window-config
    "1" 'eyebrowse-switch-to-window-config-0
    "2" 'eyebrowse-switch-to-window-config-1
    "3" 'eyebrowse-switch-to-window-config-2
    "4" 'eyebrowse-switch-to-window-config-3
    "5" 'eyebrowse-switch-to-window-config-4
    "6" 'eyebrowse-switch-to-window-config-5))

(use-package winner
  :defer t
  :config
  (winner-mode)
  :general
  (general-define-key
   :states '(normal visual insert emacs motion)
   :keymaps 'override
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "wu" 'winner-undo
   "wU" 'winner-redo))

(use-package rainbow-delimiters
  :defer t
  :config
  (rainbow-delimiters-mode))

;; Completion framework
(use-package ivy
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
   "C-h" (kbd "DEL")                    ; hack
   "C-l" 'ivy-alt-done
   "C-d" 'ivy-scroll-up-command
   "C-u" 'ivy-scroll-down-command
   "C-S-h" help-map
   "<escape>" 'minibuffer-keyboard-quit)
  (general-define-key
   :states '(normal visual insert emacs motion)
   :keymaps 'override
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "bb" 'ivy-switch-buffer
   "bo" 'move-buffer-other-window)
  (general-define-key			; unbind killing of buffers with C-k
   :keymaps 'ivy-switch-buffer-map
   "C-k" 'ivy-previous-line		; we have to set it here again
   "C-b" 'ivy-switch-buffer-kill)
  (general-define-key
   :states '(normal)
   :keymaps 'ivy-occur-mode-map
   [mouse-1] 'ivy-occur-click		; TODO: doesn't work
    "j" 'ivy-occur-next-line
    "k" 'ivy-occur-previous-line
    "h" 'evil-backward-char
    "l" 'evil-forward-char
    "g" nil
    "gg" 'evil-goto-first-line		; TODO: doesn't work
    "gf" 'ivy-occur-press
    "ga" 'ivy-occur-read-action
    "go" 'ivy-occur-dispatch
    "gc" 'ivy-occur-toggle-calling

    ;; refresh
    "gr" 'ivy-occur-revert-buffer

    ;; quit
    "q" 'quit-window)
  (general-define-key
   :keymaps 'ivy-occur-grep-mode-map
   "C-d" 'evil-scroll-down))

(use-package ivy-xref
  :defer t
  :init (setq xref-show-xrefs-function #'ivy-xref-show-xrefs))

(use-package counsel
  :defer t
  :general
  (general-define-key
   :states '(normal visual insert emacs motion)
   :keymaps 'override
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "ff" 'counsel-find-file
   "fj" 'counsel-file-jump
   "fl" 'counsel-locate
   "fr" 'counsel-recentf
   "fp" 'counsel-git
   "hb" 'counsel-descbinds
   "hf" 'counsel-describe-function
   "hv" 'counsel-describe-variable
   "SPC" 'counsel-M-x)
  :general
  (general-define-key
   "M-x" 'counsel-M-x))

;; Searching
(use-package swiper
  :general
  (general-define-key
   :states '(normal visual insert emacs motion)
   :keymaps 'override
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "ss" 'counsel-grep-or-swiper
   "sr" 'counsel-grep-or-swiper-backward
   "sg" 'counsel-git-grep
   "sb" 'swiper-all
   "st" 'swiper-thing-at-poin))

;; Project managment
(use-package projectile
  :general
  (general-define-key
   :states '(normal visual insert emacs motion)
   :keymaps 'override
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "pg"  'counsel-projectile-grep
   "pc" 'counsel-projectile-compile-project
   "pf" 'counsel-projectile-find-file
   "pb" 'counsel-projectile-switch-to-buffer
   "pp" 'counsel-projectile-switch-project
   "pt" 'projectile-find-tag
   "pD" 'projectile-dired
   "pd" 'counsel-projectile-find-dir)
  :config
  (projectile-mode)
  (projectile-update-mode-line)		; sometimes doesn't happen
  (setq projectile-completion-system 'ivy)
  ;; https://github.com/bbatsov/projectile/issues/1270
  (setq projectile-project-compilation-cmd "")
  :init
  (setq projectile-dynamic-mode-line t)
  (setq projectile-mode-line-prefix " π")
  (setq projectile-mode-line-function
      '(lambda () (format " π[%s]" (projectile-project-name)))))

(use-package counsel-projectile
  :after projectile
  :config
  ;; taking only what we need from (counsel-projectile-on)
  (setq projectile-switch-project-action 'counsel-projectile))

;; git intergration
(use-package magit
  :init
  ;; disable built in version control if we use magit
  (setq vc-handled-backends nil)
  :general
  (general-define-key
   :states '(normal visual insert emacs motion)
   :keymaps 'override
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "g" 'magit-status)
  :config
  (setq magit-completing-read-function 'ivy-completing-read)
  (add-hook 'git-commit-mode-hook (lambda () (setq fill-column 72))))

(use-package evil-magit
  :after magit)

(use-package avy
  :general
  (general-define-key
   "C-'" 'avy-goto-word-1)
  (general-define-key
   :states '(normal visual insert emacs motion)
   :keymaps 'override
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "j" 'avy-goto-word-1))

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
 :states '(normal visual insert emacs motion)
 :keymaps 'global-map
 :prefix "SPC"
 :non-normal-prefix "M-SPC"

 ;; elisp interaction
 "xe" 'eval-last-sexp
 "xb" 'eval-buffer
 "xr" 'eval-region
 "xj" 'eval-print-last-sexp)

(general-define-key
 :states '(normal visual insert emacs motion)
 :keymaps 'override
 :prefix "SPC"
 :non-normal-prefix "M-SPC"

 "u" 'universal-argument

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

 ;; file handling
 "fs" 'save-buffer
 "fed" 'find-dotfile
 "fD" 'delete-file
 "fc" 'copy-file
 "fR" 'rename-file
 "fE" 'sudo-edit

 ;; window handling
 "wd" 'delete-window
 "wm" 'maximize-window
 "ws" 'split-window-below
 "wv" 'split-window-right
 "wo" 'other-window

 ;; TODO
 ;; t for toggle
 ;; r for register/killrings

 ;; dired
 "d" 'dired
 ;;compiling
 "cc" 'compile
 "ck" 'kill-compilation
 "cr" 'recompile

 ;;repeat
 "r" 'repeat

 ;; zooming
 "zz" 'text-scale-adjust

 ;; eshell
 "'" 'eshell

 ;; exiting
 "qQ" 'kill-emacs
 "qs" 'save-buffers-kill-emacs

 ;; more help
 "hc" 'describe-char
 "hk" 'describe-key
 "hm" 'describe-mode
 "hp" 'describe-package
 ;; "hf" 'describe-function  using counsel versions to force loading the package
 ;; "hv" 'describe-variable
 "hi" 'info)

;; mousewheel zooming
(general-define-key
 :keymaps 'override
 "<C-mouse-4>" 'text-scale-increase
 "<C-mouse-5>" 'text-scale-decrease)

;;; general settings and lazy evilification of built-in stuff
(use-package ediff
  :defer t
  :config
  (require 'evil-collection-ediff)
  (evil-collection-ediff-setup))

(use-package image-mode :ensure nil
  :defer t
  :config
  (require 'evil-collection-image)
  (evil-collection-image-setup))

(use-package doc-view
  :defer t
  :init
  (add-hook 'doc-view-mode-hook 'auto-revert-mode)
  :config
  (require 'evil-collection-doc-view)
  (evil-collection-doc-view-setup)
  (setq doc-view-resolution 400))

(use-package dired :ensure nil
  :defer t
  :config
  (require 'evil-collection-dired)
  (evil-collection-dired-setup))

(use-package info
  :defer t
  :config
  (require 'evil-collection-info)
  (evil-collection-info-setup))

(use-package comint :ensure nil
  :defer t
  :config
  (require 'evil-collection-comint)
  (evil-collection-comint-setup))

(use-package edebug
  :defer t
  :config
  (require 'evil-collection-edebug)
  (evil-collection-edebug-setup))

(use-package compile
  :defer t
  :no-require
  :init
  (add-hook 'compilation-mode-hook 'visual-line-mode)
  (add-hook 'compilation-filter-hook #'colorize-compilation)
  :config
  (require 'evil-collection-compile)
  (setq compilation-scroll-output t)
  (add-to-list 'compilation-error-regexp-alist
	       '("^# \\*\\\* Error: \\(.*?\\)(\\(.*?\\)):" 1 2))
  (add-to-list 'compilation-error-regexp-alist
	       '("^# \\*\\* \\(Warning: (vsim-[[:digit:]]*)\\)"
		 nil nil nil 1 1 (1 "warning")))
  (add-to-list 'compilation-error-regexp-alist
	       '("^# \\*\\* \\(Warning: (vsim-[[:digit:]]*)\\).*\n#.*File: \\(.*?\\) Line: \\([[:digit:]]*\\)"
		 2 3 nil 1 2 (1 "warning")))
  (evil-collection-compile-setup)
  (require 'ansi-color))

(use-package package
  :defer t
  :config
  (require 'evil-collection-package-menu)
  (evil-collection-package-menu-setup))

(use-package tramp
  :defer t
  :config
  ;; (setq projectile-mode-line " Projectile")
  (setq tramp-default-method "ssh")
  ;; (setq tramp-verbose 6) ; debugging mode
  (setq tramp-shell-prompt-pattern ; fix parsing bug of fancy remote  prompts
	"\\(?:^\\|\r\\)[^]#$%>\n]*#?[]#$%>].* *\\(^[\\[[0-9;]*[a-zA-Z] *\\)*"))

;; eshell
(use-package eshell
  :defer t
  :init
  (add-hook 'eshell-mode-hook
	    (lambda ()
	      (define-key eshell-mode-map (kbd "<tab>")
		'completion-at-point)))
  (add-hook 'eshell-mode-hook #'visual-line-mode)
  :config
  (require 'evil-collection-eshell)
  (evil-collection-eshell-setup))

;; exec path from shell
(use-package exec-path-from-shell
  :defer t
  :config
  (when (memq window-system '(ns x))
    (exec-path-from-shell-initialize)))

;;;; Custom Layers

;;; Large files
(use-package vlf
  :defer t
  :config
  (require 'vlf-setup)
  (setq vlf-application 'dont-ask))

;;; Tagging
;; (use-package counsel-etags
;;   :commands
;;   counsel-etags-find-tag-at-point
;;   counsel-etags-virtual-update-tags
;;   :init
;;   (setq tags-revert-without-query t)
;;   (setq large-file-warning-threshold nil))

;;; pdf
;; (use-package pdf-tools
;;   :mode ("\\.pdf\\'" . pdf-view-mode)
;;   :init
;;   (add-hook 'pdf-view-mode-hook 'auto-revert-mode)
;;   :config
;;   (pdf-tools-install)
;;   (require 'evil-collection-pdf)
;;   (evil-collection-pdf-setup))

;;; LaTeX
(use-package auctex
  :mode ("\\.tex\\'" . TeX-latex-mode)
  :init
  ;; font-lock for custom keywords
  (setq font-latex-match-reference-keywords '(("cref" "{")))
  :config
  (add-to-list 'TeX-command-list '("Make" "make" TeX-run-compile t t))
  ;; :general
  ;; (general-define-key
  ;;  :states 'normal
  ;;  :keymaps 'LaTeX-mode-map
  ;;  :prefix ","
  ;;  "\\"  'TeX-insert-macro
  ;;  "-"   'TeX-recenter-output-buffer
  ;;  "%"   'TeX-comment-or-uncomment-paragraph
  ;;  ";"   'TeX-comment-or-uncomment-region
  ;;  ;; run compile open
  ;;  "a"   'TeX-command-run-all
  ;;  "b"   'TeX-command-master
  ;;  "k"   'TeX-kill-job
  ;;  "l"   'TeX-recenter-output-buffer
  ;;  "m"   'TeX-insert-macro
  ;;  "v"   'TeX-view
  ;;  "hd"  'TeX-doc
  ;;  "*"   'LaTeX-mark-section      ;; C-c *
  ;;  "."   'LaTeX-mark-environment  ;; C-c .
  ;;  "c"   'LaTeX-close-environment ;; C-c ]
  ;;  "e"   'LaTeX-environment       ;; C-c C-e
  ;;  "ii"  'LaTeX-insert-item       ;; C-c C-j
  ;;  "s"   'LaTeX-section           ;; C-c C-s
  ;;  "fe"  'LaTeX-fill-environment  ;; C-c C-q C-e
  ;;  "fp"  'LaTeX-fill-paragraph    ;; C-c C-q C-p
  ;;  "fr"  'LaTeX-fill-region       ;; C-c C-q C-r
  ;;  "fs"  'LaTeX-fill-section      ;; C-c C-q C-s
  ;;  "fb"  'LaTeX-fill-buffer
  ;;  "pb"  'preview-buffer
  ;;  "pd"  'preview-document
  ;;  "pe"  'preview-environment
  ;;  "pf"  'preview-cache-preamble
  ;;  "pp"  'preview-at-point
  ;;  "ps"  'preview-section
  ;;  "pr"  'preview-region
  ;;  "rb"  'preview-clearout-buffer
  ;;  "rr"  'preview-clearout
  ;;  "rd"  'preview-clearout-document
  ;;  "rs"  'preview-clearout-section
  ;;  "rp"  'preview-clearout-at-point)
  )
(with-eval-after-load "TeX"
  (use-package auctex-latexmk
    :config
    (auctex-latexmk-setup)))

;;; Org
(use-package org
  :mode ("\\.org\\'" . org-mode)
  :init
  (add-hook 'org-mode-hook 'auto-fill-mode)
  :config
  (setq org-file-apps
	'((auto-mode . emacs)
	  ("\\.mm\\'" . default)
	  ("\\.x?html?\\'" . default)
	  ("pdf" . "evince %s")
	  ("\\.pdf::\\([0-9]+\\)\\'" . "evince -p %1 %s"))))

(use-package org-ref
  :after org
  :init
  (setq org-ref-completion-library 'org-ref-ivy-cite))

;;; Python
(use-package python
  :mode ("\\.py\\'" . python-mode)
  :general
  (general-define-key
   :states 'normal
   :keymaps 'python-mode-map
   :prefix "SPC"
   "mi" 'run-python
   "mb" 'python-shell-send-buffer
   "md" 'python-shell-send-function
   "mr" 'python-shell-send-region
   "mf" 'python-shell-send-file
   "mc" 'python-check)
  :init
  (add-hook 'python-mode-hook 'flymake-mode)
  :config
  ;; (setq python-shell-interpreter "/opt/miniconda3/bin/python3")
  ;; (setq python-shell-interpreter-args "-m IPython --simple-prompt -i")
  (setq python-flymake-command '("flake8" "-"))
  ;; (setq python-indent-guess-indent-offset nil)
  )
(use-package anaconda-mode
  :after python
  :init
  (add-hook 'python-mode-hook 'anaconda-mode)
  (add-hook 'python-mode-hook 'anaconda-eldoc-mode))

(use-package auto-virtualenv
  :after python
  :init
  (add-hook 'python-mode-hook 'auto-virtualenv-set-virtualenv)
  (add-hook 'window-configuration-change-hook 'auto-virtualenv-set-virtualenv)
  (add-hook 'focus-in-hook 'auto-virtualenv-set-virtualenv))

(use-package yaml-mode
  :mode ("\\.yml\\'" . yaml-mode))
;;; C-C++
;; this is a hack for eglot to use projectile-project-root for finding project
;; roots
(defun aid-projectile-project-find-function (dir)
  (require 'projectile)
  (let ((root (projectile-project-root dir)))
    (and root (cons 'transient root))))

(use-package project
  :defer t
  :config
  (add-to-list 'project-find-functions 'aid-projectile-project-find-function))

(use-package eglot
  :config
  (add-to-list 'eglot-server-programs '((c++-mode c-mode) "clangd"))
  ;; eglot doesn't get to have its own mode-line entry
  ;; TODO: add on-click functionality
  (setq mode-line-misc-info
	(assq-delete-all 'eglot--managed-mode mode-line-misc-info))
  (add-to-list 'minor-mode-alist '(eglot--managed-mode " η"))
  :general
  (general-define-key
   :states '(normal visual insert emacs motion)
   :keymaps 'c-mode-map
   "M-." 'xref-find-definitions))

(use-package realgud
  :defer t
  :commands (realgud:pdb  realgud:gdb))

(use-package clang-format
  :after c-mode
  :init
  (setq clang-format-executable "~/.local/bin/clang-format"))

(use-package cc-mode
  :mode ("\\.c\\'" . c-mode)            ;TODO: add c++ mode
  :init
  (add-hook 'c-mode-common-hook 'electric-pair-local-mode)
  :general
  (general-define-key
   :states 'normal
   :keymaps '(c-mode-map c++-mode-map)
   :prefix "SPC"
   "ma" 'projectile-find-other-file
   "mA" 'projectile-find-other-file-other-window
   "mb" 'clang-format-buffer
   "mr" 'clang-format-region)
  ;; (general-define-key
  ;;  :states '(normal visual insert emacs motion)
  ;;  :keymaps 'c-mode-map
  ;;  "M-." 'counsel-etags-find-tag-at-point)
  :config
  (setq c-default-style "linux"                 ;GNU style is really shit
	c-basic-offset 4))

(use-package bison-mode
  :mode (("\\.y\\'" . bison-mode)
	 ("\\.l\\'" . bison-mode)
	 ("\\.jison\\'" . jison-mode)))

;;; Rust
(use-package rust-mode
  :mode (("\\.rs\\'" . rust-mode)))

;;; Emacs Lisp
(use-package elisp-mode :ensure nil
  :mode ("\\.el\\'" . emacs-lisp-mode)
  :init
  (add-hook 'emacs-lisp-mode-hook 'electric-pair-local-mode))

(use-package package-lint
  :commands package-lint-current-buffer)

;;; Racket
(use-package racket-mode
  :mode ("\\.rkt\\'" . racket-mode))

;;; Scheme
(use-package geiser
  :init
  (add-hook 'geiser-mode-hook 'electric-pair-local-mode)
  :general
  (general-define-key
   :states 'normal
   :keymaps '(geiser-mode-map)
   :prefix "SPC"
   "xe" 'geiser-eval-last-sexp
   "xb" 'geiser-eval-buffer
   "xr" 'geiser-eval-region
   "hd" 'geiser-doc-symbol-at-point))

;;; System Verilog
(use-package verilog-mode :ensure nil
  :mode ("\\.[ds]?vh?\\'" . verilog-mode)
  :load-path "verilog-mode/"
  :init
  (add-hook 'verilog-mode-hook
	    '(lambda () (setq indent-tabs-mode nil)))
  (add-hook 'verilog-mode-hook
	    '(lambda () (clear-abbrev-table verilog-mode-abbrev-table)))
  :config
  (setq verilog-indent-level 4)
  (setq verilog-indent-level-module 4)
  (setq verilog-indent-level-declaration 4)
  (setq verilog-indent-level-behavioral 4)
  (setq verilog-case-indent 4)
  (setq verilog-cexp-indent 4)
  (setq verilog-auto-lineup 'all)
  (setq verilog-indent-lists nil)		; prevent large indents
  (setq verilog-linter "verilator --lint-only")
  (setq verilog-highlight-grouping-keywords t)
  (setq verilog-highlight-includes nil)
  (setq verilog-highlight-modules t)
  (setq verilog-auto-newline nil)
  :general
  ;; (general-define-key
  ;;  :states '(normal visual insert emacs motion)
  ;;  :keymaps 'verilog-mode-map
  ;;  "M-." 'counsel-etags-find-tag-at-point)
  )

;;; Decompiling
(use-package rmsbolt
  :defer t)

;;; Tracing
(use-package trdb-mode
  :commands (trdb-mode trdb-process-trace)
  :mode ("\\.trdb\\'" . trdb-mode)
  :load-path "trdb/")

;;; Dwarf
(use-package dwarf-mode
  :commands (dwarf-mode dwarf-browse)
  :load-path "dwarf/")

;;; Assembly
(use-package riscv-mode
  :commands riscv-mode)

(use-package asm-mode
  :defer t
  :init
  ;; uses ;; as comment delimiter by default, breaks riscv
  (add-hook 'asm-mode-hook
	    (lambda () (setq comment-start "/* " comment-end " */"))))

;;; Custom functions
;; quickly open dotfile
(defun find-dotfile ()
  "Opens the Emacs dotfile for quick editing."
  (interactive)
  (find-file-existing (concat user-emacs-directory "init.el")))

;; esc quits everywhere
(defun minibuffer-keyboard-quit ()
  "Abort recursive edit.
In Delete Selection mode, if the mark is active, just deactivate it;
then it takes a second \\[keyboard-quit] to abort the minibuffer."
  (interactive)
  (if (and delete-selection-mode transient-mark-mode mark-active)
      (setq deactivate-mark  t)
    (when (get-buffer "*Completions*") (delete-windows-on "*Completions*"))
    (abort-recursive-edit)))

(defun sudo-edit (&optional arg)
  "Edit currently visited file as root.
With a prefix ARG prompt for a file to visit.
Will also prompt for a file to visit if current
buffer is not visiting a file."
  (interactive "P")
  (if (or arg (not buffer-file-name))
      (find-file (concat "/sudo:root@localhost:"
			 (read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(defun clean-mode-line ()
  "Clean the mode line.
only allow specific modes to show themselfes there in a
predefined, abbreviated fashion as given in
`mode-line-cleaner-alist'."
  (interactive)
  (cl-loop for cleaner in mode-line-cleaner-alist
	   do (let* ((mode (car cleaner))
		     (mode-str (cdr cleaner))
		     (old-mode-str (cdr (assq mode minor-mode-alist))))
		(when old-mode-str
		  (setcar old-mode-str mode-str))
		;; major mode
		(when (eq mode major-mode)
		  (setq mode-name mode-str)))))

;; do it after definition
(add-hook 'after-change-major-mode-hook 'clean-mode-line)

(defun move-buffer-other-window ()
  "Move current buffer to other window.
Display previous buffer in this window and move pointer to other
window."
  (interactive)
  (save-selected-window
    (switch-to-buffer-other-window (current-buffer)))
  (switch-to-buffer (other-buffer))
  (other-window 1))

(defun colorize-compilation()
  "Colorize from `compilation-filter-start' to `point'."
  (let ((inhibit-read-only t))
    (ansi-color-apply-on-region
     compilation-filter-start (point))))

(defun ansi-colorize-current-buffer ()
  "Colorize ansi escape sequences in the current buffer."
  (interactive)
  (ignore-errors
    (ansi-color-apply-on-region (point-min) (point-max))))

(defun generate-tags ()
  "Generate TAG file for current project."
  (interactive)
  (let ((root (projectile-project-root)))
    (when root
      (shell-command (format "%s -f TAGS -e -R %s"
			     path-to-ctags
			     (directory-file-name root))))))

;;; Stuff from customize
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-view-program-selection
   (quote
    (((output-dvi has-no-display-manager)
      "dvi2tty")
     ((output-dvi style-pstricks)
      "dvips and gv")
     (output-dvi "Evince")
     (output-pdf "Evince")
     (output-html "xdg-open"))))
 '(custom-enabled-themes (quote (wombat)))
 '(custom-safe-themes
   (quote
    ("8bb8a5b27776c39b3c7bf9da1e711ac794e4dc9d43e32a075d8aa72d6b5b3f59"
     "53a9ec5700cf2bb2f7059a584c12a5fdc89f7811530294f9eaf92db526a9fb5f"
     default)))
 '(delete-selection-mode nil)
 '(doc-view-continuous t)
 '(package-selected-packages
   (quote
    (yaml-mode geiser bison-mode eglot package-lint riscv-mode rmsbolt eyebrowse
	       avy which-key vlf use-package rainbow-delimiters racket-mode
	       org-ref ivy-xref general evil-surround evil-matchit evil-magit
	       esup cquery counsel-projectile counsel-etags clang-format
	       auto-virtualenv auctex-latexmk anaconda-mode)))
 '(truncate-lines t)
 '(xterm-mouse-mode t))

(put 'dired-find-alternate-file 'disabled nil)

;; set default font
(add-to-list 'default-frame-alist
	     '(font . "DejaVu Sans Mono-11"))
