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
 ;; silent bell when you make a mistake
 ring-bell-function 'ignore
 ;; sentence SHOULD end with only a point.
 sentence-end-double-space nil
 ;; fix bug with maximization
 frame-resize-pixelwise t
 help-window-select t
 tab-width 4
 ;; scroll just one line when hitting bottom of screen
 scroll-conservatively 10000
 ;; better copy/paste behavior
 select-enable-clipboard t
 ;; don't split windows horizontally
 split-height-threshold 160)

(setq-default fill-column 80)

;; only show startup screen when opening no files
(defun bwww-inhibit-startup-screen-always ()
  "Startup screen inhibitor for `command-line-functions`.
Inhibits startup screen on the first unrecognised option."
  (ignore (setq inhibit-startup-screen t)))

(add-hook 'command-line-functions #'bwww-inhibit-startup-screen-always)

;; fix bad answer default
(defalias 'yes-or-no-p 'y-or-n-p)

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

;; set up PATH to also consider other commonly used directories
(defun bwww-extend-path (path)
  "Extend `PATH' and variable `exec-path' by PATH."
  (setenv "PATH" (concat (expand-file-name path) ":" (getenv "PATH")))
  (setq exec-path (append (list (expand-file-name path)) exec-path)))

(when (memq window-system '(ns x))
  (bwww-extend-path "~/.scripts")
  (bwww-extend-path "~/.cargo/bin")
  (bwww-extend-path "~/.local/bin"))

;; ctags we like
(setq path-to-ctags "~/.local/bin/ctags")

;; line numbers
(if (version<= "26.1" emacs-version)
    (add-hook 'prog-mode-hook 'display-line-numbers-mode)
  (add-hook 'prog-mode-hook 'linum-mode))

;; if we running on older emacs make sure we load early-init.el anyways
(when (version< emacs-version "27")
  (load (concat user-emacs-directory "early-init.el")))

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

(require 'package)
;; want to use use-package instead
(setq package-archives '(("org"       . "https://orgmode.org/elpa/")
			 ("gnu"       . "https://elpa.gnu.org/packages/")
			 ("melpa"     . "https://melpa.org/packages/")))

;; starting from emacs 27, package-initialize is automatically called before
;; init.el is evaluated
(if (version<  emacs-version "27")
    (package-initialize))

;; (setq package-check-signature t)
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
  (setq evil-want-keybinding nil)
  (setq evil-want-integration t)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-fine-undo nil)
  (when (not (display-graphic-p))
    (setq evil-want-C-i-jump nil))
  (setq evil-search-module 'evil-search)
  :config
  (evil-mode 1)
  (global-undo-tree-mode 1)
  (setq evil-undo-system 'undo-tree)
  (evil-set-undo-system 'undo-tree)
  (evil-set-initial-state 'term-mode 'emacs)
  (setq evil-ex-search-vim-style-regexp t)
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

(use-package undo-tree
  :after evil
  :config
  (setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo"))))

(use-package which-key
  :config
  (which-key-mode))


;; (use-package fido
;;   :ensure nil
;;   :init
;;   (fido-mode)
;;   :general
;;   (general-define-key
;;    :states '(normal visual insert emacs motion)
;;    :keymaps 'override
;;    :prefix "SPC"
;;    :non-normal-prefix "M-SPC"
;;    "bb" 'switch-to-buffer
;;    "ff" 'find-file
;;    ;; "fj" 'counsel-file-jump
;;    ;; "fl" 'counsel-locate
;;    ;; "fr" 'counsel-recentf
;;    ;; "fp" 'counsel-git
;;    "hb" 'describe-bindings
;;    "hf" 'describe-function
;;    "hv" 'describe-variable
;;    "SPC" 'execute-extended-command))

;; Enable vertico
(use-package vertico
  :init
  (vertico-mode)
  (setq vertico-count 20)
  :general
  (general-define-key
   :states '(normal visual insert emacs motion)
   :keymaps 'override
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "bb" 'switch-to-buffer
   "ff" 'find-file
   ;; "fj" 'counsel-file-jump
   ;; "fl" 'counsel-locate
   ;; "fr" 'counsel-recentf
   ;; "fp" 'counsel-git
   "hb" 'describe-bindings
   "hf" 'describe-function
   "hv" 'describe-variable
   "SPC" 'execute-extended-command)
  ;; instead of
  ;; (keymap-set vertico-map "?" #'minibuffer-completion-help)
  :general
  (general-define-key
   :keymaps 'vertico-map
   "?" 'minibuffer-completion-help
   "C-j" 'vertico-next
   "C-k" 'vertico-previous
   "C-d" 'vertico-scroll-up
   "C-u" 'vertico-scroll-down
   "C-l" 'vertico-exit
   "C-w" 'backward-kill-word
   "S-SPC" '+vertico-restrict-to-matches))

;; Enable vertico mouse support
(use-package vertico-mouse
  :after vertico
  :ensure nil
  :init
  (vertico-mouse-mode))

;; ivy like S-SPC restrict
(defun +vertico-restrict-to-matches ()
  (interactive)
  (let ((inhibit-read-only t))
    (goto-char (point-max))
    (insert " ")
    (add-text-properties (minibuffer-prompt-end) (point-max)
                         '(invisible t cursor-intangible t rear-nonsticky t))))

;; Optionally use the `orderless' completion style.
(use-package orderless
  :init
  ;; Configure a custom style dispatcher (see the Consult wiki)
  ;; (setq orderless-style-dispatchers '(+orderless-dispatch)
  ;;       orderless-component-separator #'orderless-escapable-split-on-space)
  (setq completion-styles '(substring orderless basic)
        completion-category-defaults nil
        completion-category-overrides '((file (styles partial-completion)))))

(use-package consult
  :init
  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  ;; Use `consult-completion-in-region' if Vertico is enabled.
  ;; Otherwise use the default `completion--in-region' function.
  (setq completion-in-region-function
	(lambda (&rest args)
          (apply (if vertico-mode
                     #'consult-completion-in-region
                   #'completion--in-region)
		 args)))

  :general
  (general-define-key
   :states '(normal visual insert emacs motion)
   :keymaps 'override
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "ss" 'consult-line
   "sg" 'consult-grep
   "sv" 'consult-git-grep
   "sg" 'consult-grep
   "sr" 'consult-ripgrep
   "sb" 'consult-line-multi
   "fj" 'consult-find
   "fr" 'consult-recent-file))

;; Enable rich annotations using the Marginalia package
(use-package marginalia
  :bind (:map minibuffer-local-map
         ("M-A" . marginalia-cycle))
  :init
  (marginalia-mode))

(use-package embark
  :bind
  (("C-c C-." . embark-act)         ;; pick some comfortable binding
   ("C-c C-," . embark-dwim)        ;; good alternative: M-.
   ;; ("C-h B" . embark-bindings)  ;; alternative for `describe-bindings'
   ))

(use-package embark-consult
  :ensure t ; only need to install it, embark loads it after consult if found
  :hook
  (embark-collect-mode . consult-preview-at-point-mode))

;; Project managment
(use-package project
  :ensure nil
  :general
  (general-define-key
   :states '(normal visual insert emacs motion)
   :keymaps 'override
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "pg" 'project-find-regexp
   "pc" 'project-compile
   "pf" 'project-find-file
   "pb" 'project-switch-to-buffer
   "pp" 'project-switch-project
   ;;"pt" 'projectile-find-tag
   "pD" 'project-dired
   "pd" 'project-find-dir))

;; editing grep
(use-package wgrep
  :defer t)

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
;;  (setq magit-completing-read-function 'ivy-completing-read)
  (add-hook 'git-commit-mode-hook (lambda () (setq fill-column 72))))

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
 "bo" 'move-buffer-other-window
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
 "z" 'text-scale-adjust

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
(use-package evil-collection
  :ensure nil
  :after evil)

(with-eval-after-load 'magit
  (evil-collection-magit-setup)
  (evil-collection-define-key 'normal 'magit-blame-mode-map
    (kbd "RET") 'magit-show-commit)
  (evil-collection-define-key 'normal 'magit-blame-mode-map
    "c" 'magit-blame-cycle-style)
  (evil-collection-define-key 'normal 'magit-blame-mode-map
    "n" 'magit-blame-next-chunk)
  (evil-collection-define-key 'normal 'magit-blame-mode-map
    "p" 'magit-blame-previous-chunk)
  (evil-collection-define-key 'normal 'magit-blame-mode-map
    "\M-w" 'magit-blame-copy-hash))

(with-eval-after-load 'ediff
  (setq ediff-split-window-function (quote split-window-horizontally))
  (evil-collection-ediff-setup)
  (setq ediff-window-setup-function 'ediff-setup-windows-plain))

(with-eval-after-load 'arc-mode
  (evil-collection-arc-mode-setup))

(with-eval-after-load 'image-mode
  (evil-collection-image-setup))

(with-eval-after-load 'doc-view
  (evil-collection-doc-view-setup)
  (add-hook 'doc-view-mode-hook 'auto-revert-mode)
  (setq doc-view-resolution 400))

(with-eval-after-load 'dired
  (setq dired-dwim-target t)
  (setq dired-listing-switches "-alh --group-directories-first")
  (evil-collection-dired-setup))

(with-eval-after-load 'info
  (evil-collection-info-setup))

(with-eval-after-load 'comint
  (evil-collection-comint-setup))

(with-eval-after-load 'edebug
  (evil-collection-edebug-setup))

(use-package compile
  :ensure nil
  :defer t
  :no-require
  :init
  (add-hook 'compilation-mode-hook 'visual-line-mode)
  (add-hook 'compilation-filter-hook #'colorize-compilation)
  :config
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

(with-eval-after-load 'package
  (evil-collection-package-menu-setup))

(use-package tramp
  :ensure nil
  :defer t
  :config
  ;; (setq projectile-mode-line " Projectile")
  (setq tramp-default-method "rsync")
  ;; (setq tramp-verbose 6) ; debugging mode
  (setq tramp-shell-prompt-pattern ; fix parsing bug of fancy remote  prompts
	"\\(?:^\\|\r\\)[^]#$%>\n]*#?[]#$%>].* *\\(^[\\[[0-9;]*[a-zA-Z] *\\)*"))

;; eshell
(use-package eshell
  :ensure nil
  :defer t
  :init
  (add-hook 'eshell-mode-hook
	    (lambda ()
	      (define-key eshell-mode-map (kbd "<tab>")
		'completion-at-point)))
  (add-hook 'eshell-mode-hook #'visual-line-mode))

(with-eval-after-load 'eshell
  (evil-collection-eshell-setup))

;; we should do this manually
;; ;; exec path from shell
;; (use-package exec-path-from-shell
;;   :config
;;   (when (memq window-system '(ns x))
;;     (exec-path-from-shell-initialize)))

;; Esup bug workaround
(setq esup-depth 0)

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

;; (use-package zotxt
;;   :after org
;;   :init
;;   (add-hook 'org-mode-hook 'org-zotxt-mode))


;; (defun bwww-org-ref-open-pdf-at-point ()
;;   "Open the pdf for bibtex key under point if it exists."
;;   (interactive)
;;   (let* ((results (org-ref-get-bibtex-key-and-file))
;; 	 (key (car results))
;; 	 (pdf-file (car (bibtex-completion-find-pdf key))))
;;     (if (file-exists-p pdf-file)
;; 	(org-open-file pdf-file)
;;       (message "No PDF found for %s" key))))
;; (use-package org-ref
;;   :after org
;;   :init
;;   (setq org-ref-completion-library 'org-ref-ivy-cite)
;;   (setq reftex-default-bibliography '("~/documents/biblio/refs.bib"))

;;   ;; see org-ref for use of these variables
;;   (setq org-ref-bibliography-notes "~/documents/biblio/notes.org"
;; 	org-ref-default-bibliography '("~/documents/biblio/refs.bib")
;; 	org-ref-pdf-directory "~/documents/biblio/bibtex-pdfs/")
;;   :config
;;   (setq bibtex-completion-pdf-field "file") ; make it work with zotero

;;   (setq org-ref-open-pdf-function 'bwww-org-ref-open-pdf-at-point))

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
  (add-hook 'python-mode-hook (lambda () (setq fill-column 79)))
  :config
  (setq python-interpreter "python3")
  (setq python-shell-interpreter "python3")
  ;; (setq python-shell-interpreter-args "-m IPython --simple-prompt -i")
  (setq python-flymake-command '("flake8" "-")))
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
  :after cc-mode
  :init
  (setq clang-format-executable "/usr/bin/clang-format")
  (when (string= user-login-name "balasr")
    (setq clang-format-executable "~/.local/bin/clang-format")))

(use-package cc-mode
  :ensure nil
  :mode ("\\.c\\'" . c-mode)            ;TODO: add c++ mode
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

(use-package disaster
  :config
  (setq disaster-cflags "-O2 -g3")
  (setq disaster-cxxflags "-O2 -g3")
  :general
  (general-define-key
   :states 'normal
   :keymaps '(c-mode-map c++-mode-map)
   :prefix "SPC"
   "o" 'disaster))

;;; Rust
(use-package rust-mode
  :mode (("\\.rs\\'" . rust-mode)))

;;; Ocaml
(use-package tuareg
  :mode (("\\.ml[ily]?$" . tuareg-mode)
	 ("\\.topml$" . tuareg-mode))
  :init
  ;;(add-hook 'tuareg-mode-hook 'tuarget-imenu-set-imenu)
  ;; (autoload 'utop "utop" "Toplevel for OCaml" t)
  ;; (add-hook 'tuareg-mode-hook 'utop-minor-mode)
  (add-hook 'tuareg-mode-hook 'merlin-mode)
  :config
  (dolist (var (car (read-from-string (shell-command-to-string "opam config env --sexp"))))
    (setenv (car var) (cadr var)))

  ;; Update the emacs path
  (setq exec-path (append (parse-colon-path (getenv "PATH"))
			  (list exec-directory)))

  ;; Update the emacs load path
  (add-to-list 'load-path (expand-file-name "../../share/emacs/site-lisp"
					    (getenv "OCAML_TOPLEVEL_PATH"))))

(use-package merlin
  :after tuareg
  :config
  (setq merlin-use-auto-complete-mode t)
  (setq merlin-error-after-save nil)
  (setq merlin-command "ocamlmerlin")
  ;; use auto-complete
  (setq merlin-ac-setup 'easy)
  :general
  (general-define-key
   :states '(normal visual insert emacs motion)
   :keymaps 'merlin-mode-map
   "M-." 'merlin-locate
   "M-," 'merlin-pop-stack))

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

;;; Tcl
;; Stop braindead tab/space mixture asap
(use-package tcl-mode
  :ensure nil
  :mode ("\\.sdc\\'")
  :init
  (add-hook 'tcl-mode-hook #'(lambda () (setq indent-tabs-mode nil))))


;;; System Verilog
(use-package verilog-mode :ensure nil
  :mode ("\\.[ds]?vh?\\'" . verilog-mode)
  :load-path "verilog-mode/"
  :init
  (add-hook 'verilog-mode-hook
	    #'(lambda () (setq indent-tabs-mode nil)))
  (add-hook 'verilog-mode-hook
	    #'(lambda () (clear-abbrev-table verilog-mode-abbrev-table)))
  :config
  (setq verilog-indent-level 2)
  (setq verilog-indent-level-module 2)
  (setq verilog-indent-level-declaration 2)
  (setq verilog-indent-level-behavioral 2)
  (setq verilog-case-indent 2)
  (setq verilog-cexp-indent 2)
  (setq verilog-auto-lineup 'all)
  (setq verilog-indent-lists nil)		; prevent large indents
  (setq verilog-linter "verilator --lint-only")
  (setq verilog-highlight-grouping-keywords t)
  (setq verilog-highlight-includes nil)
  (setq verilog-highlight-modules t)
  (setq verilog-auto-newline nil)
  (setq verilog-auto-arg-sort nil)
  (setq verilog-auto-endcomments t)
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
  :ensure nil
  :defer t
  :init
  ;; uses ;; as comment delimiter by default, breaks riscv
  (add-hook 'asm-mode-hook
	    (lambda () (setq comment-start "/* " comment-end " */"))))

;;; llvm
(use-package llvm-mode
  :mode ("\\.ll\\'" . llvm-mode)
  :load-path "llvm/")

;;; tablegen
(use-package tablegen-mode
  :mode ("\\.td\\'" . tablegen-mode)
  :load-path "tablegen/")

;;; mlir
(use-package mlir-mode
  :mode ("\\.mlir\\'" . mlir-mode)
  :load-path "mlir/")


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
  (previous-buffer)
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

(defun asm-2-space-style ()
  "Enable asm 2 space style. Useful shorthand."
  (interactive)
  (progn
    (setq-default indent-tabs-mode nil)
    (setq-default tab-width 2)
    (setq asm-comment-char ?#)))

(defun c-gnu-style ()
  "Enable gnu c style. Useful shorthand."
  (interactive)
  (progn
    (setq-default c-default-style "gnu")
    (setq-default c-basic-offset 2)))

(defun c-sane-style ()
  "Enable gnu c style. Useful shorthand."
  (interactive)
  (progn
    (setq-default c-default-style "linux")
    (setq-default indent-tabs-mode nil)
    (setq-default c-basic-offset 4)))

;; Add a cc-mode style for editing LLVM C and C++ code
(c-add-style "llvm.org"
             '("gnu"
	       (fill-column . 80)
	       (c++-indent-level . 2)
	       (c-basic-offset . 2)
	       (indent-tabs-mode . nil)
	       (c-offsets-alist . ((arglist-intro . ++)
				   (innamespace . 0)
				   (member-init-intro . ++)
				   (statement-cont . llvm-lineup-statement)))))

;; Add a cc-mode style for editing generic 4 spaces C and C++ code
(c-add-style "generic-4"
             '("linux"
	       (fill-column . 80)
	       (c-basic-offset . 4)
	       (indent-tabs-mode . nil)))

;;; Stuff from customize
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(TeX-view-program-selection
   '(((output-dvi has-no-display-manager)
      "dvi2tty")
     ((output-dvi style-pstricks)
      "dvips and gv")
     (output-dvi "Evince")
     (output-pdf "Evince")
     (output-html "xdg-open")))
 '(auth-source-save-behavior nil)
 '(custom-enabled-themes '(wombat))
 '(custom-safe-themes
   '("8bb8a5b27776c39b3c7bf9da1e711ac794e4dc9d43e32a075d8aa72d6b5b3f59" "53a9ec5700cf2bb2f7059a584c12a5fdc89f7811530294f9eaf92db526a9fb5f" default))
 '(delete-selection-mode nil)
 '(doc-view-continuous t)
 '(enable-remote-dir-locals t)
 '(grep-find-ignored-files
   '(".#*" "*.cmti" "*.cmt" "*.annot" "*.cmi" "*.cmxa" "*.cma" "*.cmx" "*.cmo" "*.o" "*~" "*.bin" "*.lbin" "*.so" "*.a" "*.ln" "*.blg" "*.bbl" "*.elc" "*.lof" "*.glo" "*.idx" "*.lot" "*.fmt" "*.tfm" "*.class" "*.fas" "*.lib" "*.mem" "*.x86f" "*.sparcf" "*.dfsl" "*.pfsl" "*.d64fsl" "*.p64fsl" "*.lx64fsl" "*.lx32fsl" "*.dx64fsl" "*.dx32fsl" "*.fx64fsl" "*.fx32fsl" "*.sx64fsl" "*.sx32fsl" "*.wx64fsl" "*.wx32fsl" "*.fasl" "*.ufsl" "*.fsl" "*.dxl" "*.lo" "*.la" "*.gmo" "*.mo" "*.toc" "*.aux" "*.cp" "*.fn" "*.ky" "*.pg" "*.tp" "*.vr" "*.cps" "*.fns" "*.kys" "*.pgs" "*.tps" "*.vrs" "*.pyc" "*.pyo" "*.d"))
 '(merlin-completion-with-doc t)
 '(package-selected-packages
   '(embark-consult embark bind-key eldoc flymake jsonrpc project marginalia zotxt yaml-mode which-key wgrep vlf vertico use-package undo-tree tuareg rust-mode rmsbolt realgud rainbow-delimiters racket-mode package-lint org-noter orderless merlin magit ivy-xref ivy-bibtex general geiser exec-path-from-shell evil-surround esup eglot disaster cquery counsel-projectile counsel-etags consult clang-format bison-mode avy auto-virtualenv auctex-latexmk annalist anaconda-mode))
 '(safe-local-variable-values '((rmsbolt-asm-format) (rmsbolt-disassemble)))
 '(truncate-lines nil))
(put 'dired-find-alternate-file 'disabled nil)

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
