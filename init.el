;;; -*- lexical-binding: t; -*-
;;
;; Global configuration
;; sane defaults
(setq
 ;; 50 MB, default is 800kb
 gc-cons-threshold 50000000
 ;; backup file settings
 backup-directory-alist `(("." . "~/.emacs.d/backups"))
 backup-by-copying t
 version-control t
 keep-new-version 6
 keep-old-version 2
 delete-old-versions t
 ;; transform backups file name
 auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t))
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
 scroll-conservatively 10000
 initial-scratch-message "Welcome in Emacs")

(setq-default fill-column 80)

;; UTF-8 as default encoding
(set-language-environment "UTF-8")

;; we want a portable python environment
(setenv "PATH" (concat "$HOME/.pyenv/bin:" (getenv "PATH")))
;(getenv "PATH")
;(add-to-list 'exec-path "/opt/miniconda3/bin")

;; line numbers
(if (version<= "26.1" emacs-version)
    (global-display-line-numbers-mode) ; welcome to the 21th century
  (global-linum-mode))

(add-hook 'text-mode-hook 'show-paren-mode)
(add-hook 'prog-mode-hook 'show-paren-mode)

;; narrowing is nice
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-region 'disabled nil)

;; colum numbers
(column-number-mode)

;; change the modeline descriptions to make them shorter
(setq projectile-mode-line '(:eval (format " π[%s]" (projectile-project-name))))
(defvar mode-line-cleaner-alist
  `((auto-revert-mode . " α")
    (undo-tree-mode . "")
    (which-key-mode . "")
    (ivy-mode . "")
    ;(lispyville-mode . " lispyv")
    ; TODO: probably don't need to show this
    (anaconda-mode . " γ")
    ;projectile has its own setting
    ;(projectile-mode . projectile-mode-line)
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
(if (display-graphic-p)
    (progn
      (setq initial-frame-alist
	    '((width . 100) (height . 50)))
      (tool-bar-mode -1)
      (tooltip-mode -1)
      (menu-bar-mode -1)
      (scroll-bar-mode -1)
      (blink-cursor-mode -1)))

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

(add-to-list
 'load-path
 (expand-file-name "evil-collection/" user-emacs-directory))

;;;; All packages

;; temporary patch for dead keys, instead of env XMODIFIERS= emacs
(use-package iso-transl :ensure nil)

(use-package general)
;; just take the override map and increase its precedence to the maximum (for
;; evil)
;; is is already an intercept map
;;(evil-make-intercept-map general-override-mode-map)
;; the mapping has to be introduced as minor mode
(general-override-mode)
(general-define-key
 :states '(normal insert emacs visual motion)
 :keymaps 'override
 :prefix "SPC"
 :non-normal-prefix "M-SPC"
 "?" 'general-describe-keybindings)

(use-package evil
  :init
  (setq evil-want-C-u-scroll t)
  (setq evil-want-integration nil)
  :config
  (evil-mode)
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


;; (use-package evil-matchit :ensure t
;;   :after evil
;;   :config
;;   (global-evil-matchit-mode 1))

;;(use-package evil-search-highlight-persist )

(use-package which-key
  :config
  (which-key-mode))

(use-package winum
  :config
  (winum-mode)
  :general
  (general-define-key
   :states '(normal visual insert emacs motion)
   :keymaps 'override
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
    "1" 'winum-select-window-1
    "2" 'winum-select-window-2
    "3" 'winum-select-window-3
    "4" 'winum-select-window-4
    "5" 'winum-select-window-5))


(use-package winner
  :config
  (winner-mode))

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
   "bo" 'move-buffer-other-window))
(use-package ivy-xref
  :after ivy
  :init (setq xref-show-xrefs-function #'ivy-xref-show-xrefs))

(use-package counsel
  :general
  (general-define-key
   :states '(normal visual insert emacs motion)
   :keymaps 'override
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "ff" 'counsel-find-file
   "fr" 'counsel-recentf
   "fp" 'counsel-git
   "/"  'counsel-projectile-grep
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
   "ss" 'swiper
   "sb" 'swiper-all))

;; Project managment
(use-package projectile
  :general
  (general-define-key
   :states '(normal visual insert emacs motion)
   :keymaps 'override
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "pc" 'counsel-projectile-compile-project
   "pf" 'counsel-projectile-find-file
   "pb" 'counsel-projectile-switch-to-buffer
   "pp" 'counsel-projectile-switch-project
   "pg" 'projectile-find-tag
   "pD" 'projectile-dired
   "pd" 'counsel-projectile-find-dir)
  :config
  (projectile-mode)
  (setq projectile-completion-system 'ivy))

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
  (setq magit-completing-read-function 'ivy-completing-read))

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
 "fj" 'dired-jump
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
 "wu" 'winner-undo
 "wU" 'winner-redo

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

 ;; elisp interaction
 "xe" 'eval-last-sexp
 "xb" 'eval-buffer
 "xr" 'eval-region
 "xj" 'eval-print-last-sexp

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
 (with-eval-after-load 'ediff
   (require 'evil-collection-ediff)
   (evil-collection-ediff-setup))

(with-eval-after-load 'image-mode
  (require 'evil-collection-image)
  (evil-collection-image-setup))

(with-eval-after-load 'doc-view
  (require 'evil-collection-doc-view)
  (evil-collection-doc-view-setup))
(add-hook 'doc-view-mode-hook 'auto-revert-mode)

(with-eval-after-load 'dired
  (require 'evil-collection-dired)
  (evil-collection-dired-setup))

 (with-eval-after-load 'info
   (require 'evil-collection-info)
   (evil-collection-info-setup))

(with-eval-after-load 'comint
  (require 'evil-collection-comint)
  (evil-collection-comint-setup))

(with-eval-after-load 'compile
  (require 'evil-collection-compile)
  (setq compilation-scroll-output t)
  (add-to-list 'compilation-error-regexp-alist
	       '("^\\*\\\* Error: \\(.*?\\)(\\(.*?\\)):" 1 2))
  (evil-collection-compile-setup))
(add-hook 'compilation-mode-hook 'visual-line-mode)

(with-eval-after-load 'package
  (require 'evil-collection-package-menu)
  (evil-collection-package-menu-setup))

(with-eval-after-load 'tramp
  ;(setq projectile-mode-line " Projectile")
  (setq tramp-default-method "ssh")
  ;(setq tramp-verbose 6) ; debugging mode
  (setq tramp-shell-prompt-pattern ; fix parsing bug of fancy remote  prompts
	"\\(?:^\\|\r\\)[^]#$%>\n]*#?[]#$%>].* *\\(^[\\[[0-9;]*[a-zA-Z] *\\)*"))

;; https://emacs.stackexchange.com/
;; questions/27849/how-can-i-setup-eshell-to-use-ivy-for-tab-completion
;; eshell
(with-eval-after-load 'eshell
  (require 'evil-collection-eshell)
  (evil-collection-eshell-setup))
(add-hook 'eshell-mode-hook
	  (lambda ()
	    (define-key eshell-mode-map (kbd "<tab>")
	      'completion-at-point)))
(add-hook 'eshell-mode-hook #'visual-line-mode)

;;;; Custom Layers

;;; Large files
(use-package vlf
  :config
  (require 'vlf-setup)
  (setq vlf-application 'dont-ask))

;;; Tagging
(use-package counsel-etags
  :commands
  counsel-etags-find-tag-at-point
  counsel-etags-virtual-update-tags
  :init
  (setq tags-revert-without-query t)
  (setq large-file-warning-threshold nil))

;;; pdf
(use-package pdf-tools
  :mode ("\\.pdf\\'" . pdf-view-mode)
  :init
  (add-hook 'pdf-view-mode-hook 'auto-revert-mode)
  :config
  (pdf-tools-install)
  (require 'evil-collection-pdf)
  (evil-collection-pdf-setup))

;;; LaTeX
;; (use-package auctex  :defer t)
;; (use-package tex-site )
;; (require 'tex-site)
;; (use-package auctex ; Don't understand how auctext work,
;; it just ignores the :config section... but now acutex won't
;; be installed automatically

(use-package auctex
  :mode ("\\.tex\\'" . TeX-latex-mode)
  :general
  (general-define-key
   :states 'normal
   :keymaps 'LaTeX-mode-map
   :prefix ","
   "\\"  'TeX-insert-macro
   "-"   'TeX-recenter-output-buffer
   "%"   'TeX-comment-or-uncomment-paragraph
   ";"   'TeX-comment-or-uncomment-region
   ;; run compile open
   "a"   'TeX-command-run-all
   "b"   'TeX-command-master
   "k"   'TeX-kill-job
   "l"   'TeX-recenter-output-buffer
   "m"   'TeX-insert-macro
   "v"   'TeX-view
   "hd"  'TeX-doc
   "*"   'LaTeX-mark-section      ;; C-c *
   "."   'LaTeX-mark-environment  ;; C-c .
   "c"   'LaTeX-close-environment ;; C-c ]
   "e"   'LaTeX-environment       ;; C-c C-e
   "ii"  'LaTeX-insert-item       ;; C-c C-j
   "s"   'LaTeX-section           ;; C-c C-s
   "fe"  'LaTeX-fill-environment  ;; C-c C-q C-e
   "fp"  'LaTeX-fill-paragraph    ;; C-c C-q C-p
   "fr"  'LaTeX-fill-region       ;; C-c C-q C-r
   "fs"  'LaTeX-fill-section      ;; C-c C-q C-s
   "fb"  'LaTeX-fill-buffer
   "pb"  'preview-buffer
   "pd"  'preview-document
   "pe"  'preview-environment
   "pf"  'preview-cache-preamble
   "pp"  'preview-at-point
   "ps"  'preview-section
   "pr"  'preview-region
   "rb"  'preview-clearout-buffer
   "rr"  'preview-clearout
   "rd"  'preview-clearout-document
   "rs"  'preview-clearout-section
   "rp"  'preview-clearout-at-point))
(with-eval-after-load "TeX"
  (use-package auctex-latexmk
    :config
    (auctex-latexmk-setup)))

;;; Org
(use-package org
  :mode ("\\.org\\'" . org-mode))
(use-package org-ref
  :after org)

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
  :config
  ;(setq python-shell-interpreter "/opt/miniconda3/bin/python3")
  ;(setq python-shell-interpreter-args "-m IPython --simple-prompt -i")
  ;(setq python-indent-guess-indent-offset nil)
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

;;; C-C++
;; usage:
(use-package lsp-mode
  :hook c-mode)

(use-package cquery
  :commands lsp-cquery-enable
  :init
  (setq cquery-executable "/home/msc18f22/.local/bin/cquery")
  ;;(add-hook 'c-mode-common-hook #'cquery//enable)
  )

(defun cquery//enable ()
  (condition-case nil
      (lsp-cquery-enable)
    (user-error nil)))

(use-package clang-format
  :after c-mode)

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
;   "D"  'disaster
   "mb" 'clang-format-buffer
   "mr" 'clang-format-region)
  (general-define-key
   :states '(normal visual insert emacs motion)
   :keymaps 'c-mode-map
   "M-." 'counsel-etags-find-tag-at-point)
  :config
  ;(use-package disaster )
  ;(use-package cwarn
  ;  :config
  ;  (add-hook 'c-mode-common-hook 'cwarn-mode))
  (setq c-default-style "linux"                 ;GNU style is really shit
	c-basic-offset 4))

;;; Emacs Lisp
(use-package elisp-mode :ensure nil
  :mode ("\\.el\\'" . emacs-lisp-mode)
  :init
  (add-hook 'emacs-lisp-mode-hook (lambda () (electric-pair-local-mode 1))))

;; paredit-like parenthesis editing
;(use-package lispy
;  :defer t)
;;; :init
;;; enable for elisp
;;; (add-hook 'emacs-lisp-mode-hook (lambda () (lispy-mode 1)))
;
;(use-package lispyville
;  :defer t
;  :init
;  ;; always enable too
;  (add-hook 'emacs-lisp-mode-hook (lambda () (lispyville-mode 1)))
;  (add-hook 'emacs-lisp-mode-hook (lambda () (electric-pair-local-mode 1)))
;  :config
;  (lispyville-set-key-theme
;   '(operators
;     slurp/barf-lispy
;     (additional normal visual)
;     (additional-movement normal visual motion))))
;;; (add-hook 'lispy-mode-hook #'lispyville-mode)

;;; Racket
(use-package racket-mode
  :mode ("\\.rkt\\'" . racket-mode))

;;; System Verilog
(use-package verilog-mode :ensure nil
  :mode ("\\.[ds]?vh?\\'" . verilog-mode)
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
  (setq verilog-case-indent 0)
  (setq verilog-cexp-indent 4)
  (setq verilog-auto-lineup 'all)
  (setq verilog-linter "verilator --lint-only")
  :general
  (general-define-key
   :states '(normal visual insert emacs motion)
   :keymaps 'verilog-mode-map
   "M-." 'counsel-etags-find-tag-at-point))

;;; Custom functions
(defun find-dotfile ()
  "Opens the emacs dotfile for quick editing."
  (interactive)
  (find-file-existing "~/.emacs.d/init.el"))

;; esc quits
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
			 (ido-read-file-name "Find file(as root): ")))
    (find-alternate-file (concat "/sudo:root@localhost:" buffer-file-name))))

(defun kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list))))

(defun clean-mode-line ()
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

(defun move-buffer-other-window ()
  "Move current buffer to other window, display previous buffer in
  this window."
  (interactive)
  (save-selected-window
    (switch-to-buffer-other-window (current-buffer)))
  (switch-to-buffer (other-buffer)))

;; do it after definition
;; always apply the changes
(add-hook 'after-change-major-mode-hook 'clean-mode-line)

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
     (output-dvi "Okular")
     (output-pdf "PDF Tools")
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
    (ivy-xref winum which-key use-package rainbow-delimiters
	      racket-mode org-ref general evil-surround evil-matchit
	      evil-magit cquery counsel-projectile clang-format avy
	      auto-virtualenv auctex-latexmk anaconda-mode)))
 '(truncate-lines t))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil
			 :strike-through nil :overline nil :underline nil :slant
			 normal :weight normal :height 140 :width normal
			 :foundry "unknown" :family "Inconsolata LGC")))))
