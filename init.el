;; Global configuration
; sane defaults
(setq
 ; 50 MB, default is 800kb
  gc-cons-threshold 50000000
 ; delete excess backup versions silently
 delete-old-versions -1
 ; make backups file even when in version controlled dir
 vc-make-backup-files t
 ; which directory to put backups file
 backup-directory-alist `(("." . "~/.emacs.d/backups"))
 ; don't ask for confirmation when opening symlinked file
 vc-follow-symlinks t
 ; transform backups file name
 auto-save-file-name-transforms '((".*" "~/.emacs.d/auto-save-list/" t))
 inhibit-startup-screen t
 ; silent bell when you make a mistake
 ring-bell-function 'ignore
 ; sentence SHOULD end with only a point.
 sentence-end-double-space nil
 ; fix bug with maximization
 frame-resize-pixelwise t
 default-fill-column 80
 help-window-select t
 tab-width 4
 initial-scratch-message "Welcome in Emacs")

;; UTF-8 as default encoding
(set-language-environment "UTF-8")

; we want a portable python environment
(setenv "PATH" (concat "/opt/miniconda3/bin:" (getenv "PATH")))
(add-to-list 'exec-path "/opt/miniconda3/bin")

; activate some nice built in modes
(add-hook 'text-mode-hook 'linum-mode)
(add-hook 'prog-mode-hook 'linum-mode)
(add-hook 'text-mode-hook 'show-paren-mode)
(add-hook 'prog-mode-hook 'show-paren-mode)

; convenient auto revert
; TODO:
(add-hook 'doc-view-mode-hook 'auto-revert-mode)

; change the modeline descriptions to make them shorter
(setq projectile-mode-line '(:eval (format " π[%s]" (projectile-project-name))))
(defvar mode-line-cleaner-alist
  `((auto-complete-mode . " α")
    (undo-tree-mode . "")
    (which-key-mode . "")
    (ivy-mode . "")
    (anaconda-mode . " conda")
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

; always apply the changes
(add-hook 'after-change-major-mode-hook 'clean-mode-line)

;; doing this in custom
;;(when window-system
;;  (tool-bar-mode -1)
;;  (tooltip-mode -1)
;;  (menu-bar-mode -1)
;;  (scroll-bar-mode -1)
;;  (blink-cursor-mode -1))

(require 'package)
; want to use use-package instead
(setq package-enable-at-startup nil)
(setq package-archives '(("org"       . "http://orgmode.org/elpa/")
			 ("gnu"       . "http://elpa.gnu.org/packages/")
			 ("melpa"     . "https://melpa.org/packages/")))
(package-initialize)

(setq package-check-signature nil)
(unless (package-installed-p 'use-package)
 (package-refresh-contents)
 (package-install 'use-package))
(require 'use-package)

; loading time
(setq use-package-verbose t)

(add-to-list
  'load-path
  (expand-file-name "evil-collection/" user-emacs-directory))

;; all packages
(use-package general :ensure t)
(general-define-key
 :states '(normal motion visual insert emacs)
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
  (global-evil-matchit-mode 1))
; TODO: bindings
;(use-package evil-search-highlight-persist :ensure t)
(use-package winum :ensure t
 :init
 (winum-mode))
(use-package winner :ensure t
  :init
  (winner-mode))
(use-package rainbow-delimiters :ensure t
  :defer t
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
   :states '(normal motion visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "bb" 'ivy-switch-buffer))

(use-package counsel
  :ensure t
  :general
  (general-define-key
   :states '(normal motion visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "ff" 'counsel-find-file
   "fr" 'counsel-recentf
   "fp" 'counsel-git
   "hb" 'counsel-descbinds
   "hf" 'counsel-describe-function
   "hv" 'counsel-describe-variable
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
   :states '(normal motion visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "ss" 'swiper
   "sb" 'swiper-all))

;; Project managment
(use-package projectile
  :ensure t
  :general
  (general-define-key
   :states '(normal motion visual insert emacs)
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
  (setq projectile-completion-system 'ivy)
  (use-package counsel-projectile :ensure t
    :config
    ; taking only what we need from (counsel-projectile-on)
    (setq projectile-switch-project-action 'counsel-projectile)))

;; git intergration
(use-package magit
  :ensure t
  :general
  (general-define-key
   :states '(normal motion visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "gs" 'magit-status
   "gm" 'magit-dispatch-popup
   "gS" 'magit-stage-file
   "gU" 'magit-unstage-file)
  :config
  (use-package evil-magit :ensure t))

(use-package restart-emacs
  :ensure t
  :general
  (general-define-key
   :states '(normal motion visual insert emacs)
   :prefix "SPC"
   :non-normal-prefix "M-SPC"
   "qR" 'restart-emacs))

; TODO remove (?)
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
 :states '(normal motion visual insert emacs)
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
 "fE" 'sudo-edit

 ;; window handling
 "wd" 'delete-window
 "wm" 'maximize-window
 "wh" 'evil-window-left
 "wj" 'evil-window-down
 "wk" 'evil-window-up
 "wl" 'evil-window-right
 "ws" 'split-window-below
 "wv" 'split-window-right
 "ww" 'other-window
 "wu" 'winner-undo
 "wU" 'winner-redo
 "wR" 'evil-window-rotate-upwards
 "wr" 'evil-window-rotate-downwards
 "w+" 'evil-window-increase-height
 "w-" 'evil-window-decrease-height
 "w;" 'evil-window-increase-width
 "w:" 'evil-window-decrease-width
 "1" 'winum-select-window-1
 "2" 'winum-select-window-2
 "3" 'winum-select-window-3
 "4" 'winum-select-window-4
 "5" 'winum-select-window-5

 ;; eshell
 "'" 'eshell

 ;; elisp interaction
 "xe" 'eval-last-sexp
 "xb" 'eval-buffer
 "xr" 'eval-region

 ;; exiting
 "qQ" 'kill-emacs
 "qs" 'save-buffers-kill-emacs

 ;; more help
 "hc" 'describe-char
 "hk" 'describe-key
 "hm" 'describe-mode
 "hp" 'describe-package
 ;"hf" 'describe-function ; using counsel versions to force loading the package
 ;"hv" 'describe-variable
 "hi" 'info)

;; lazy evilification of built-in stuff
(with-eval-after-load "ediff"
  (use-package evil-ediff :ensure t))

(with-eval-after-load 'image-mode
  (require 'evil-image)
  (evil-image-setup))

(with-eval-after-load 'doc-view
  (require 'evil-doc-view)
  (evil-doc-view-setup))

;(with-eval-after-load 'ivy (require 'evil-ivy) (evil-ivy-setup))

;;; Custom Layers
;; LaTeX
;(use-package auctex :ensure t :defer t)
;(use-package tex-site :ensure t)
;(require 'tex-site)
(use-package auctex
  :ensure t
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
   "b"   'latex-build
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

;; Python
(use-package python
  :ensure t
  :mode ("\\.py\\'" . python-mode)
  :general
  (general-define-key
   :states 'normal
   :keymaps 'python-mode-map
   :prefix ","
   "si" 'run-python
   "sb" 'python-shell-send-buffer
   "sf" 'python-shell-send-function
   "sr" 'python-shell-send-region
   "sf" 'python-shell-send-file
   "gg" 'anaconda-mode-find-definitions
   "ga" 'anaconda-mode-find-assignments
   "gb" 'anaconda-mode-go-back
   "hh" 'anaconda-mode-show-doc
   "cs" 'python-check)
  :config
  (setq python-shell-interpreter "/opt/miniconda3/bin/python3")
  (setq python-shell-interpreter-args "-m IPython --simple-prompt -i")
  (setq python-indent-guess-indent-offset nil)
  (use-package anaconda-mode :ensure t
    :config
    (add-hook 'python-mode-hook 'anaconda-mode)
    (add-hook 'python-mode-hook 'anaconda-eldoc-mode))
  (use-package conda :ensure t
    :config
    (conda-env-initialize-eshell)
    ;;TODO: is activated in any major mode, fix this with hooks?
    (conda-env-autoactivate-mode t)
    (require 'subr-x) ; workaround for missing dependency
    (setq conda-anaconda-home "/opt/miniconda3")))

;; C-C++
;; TODO: flycheck, company?
(use-package cc-mode
  :ensure t
  :mode ("\\.c\\'" . c-mode)
  :general
  (general-define-key
   :states 'normal
   :keymaps 'c-mode-map
   :prefix ","
   "ga" 'projectile-find-other-file
   "gA" 'projectile-find-other-file-other-window
   "D"  'disaster)
  :config
  (use-package disaster :ensure t)
  (use-package cwarn :ensure t
    :config
    (add-hook 'c-mode-common-hook 'cwarn-mode))
  (setq c-default-style "linux" ;GNU style is really shit
	c-basic-offset 4))

(defun find-dotfile ()
  "Opens the emacs dotfile for quick editing"
  (interactive)
  (find-file-existing "~/.emacs.d/init.el"))

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
     (output-pdf "Okular")
     (output-html "xdg-open"))))
 '(blink-cursor-mode nil)
 '(custom-enabled-themes (quote (ujelly)))
 '(custom-safe-themes
   (quote
    ("53a9ec5700cf2bb2f7059a584c12a5fdc89f7811530294f9eaf92db526a9fb5f"
     default)))
 '(delete-selection-mode nil)
 '(doc-view-continuous t)
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (conda anaconda-mode disaster restart-emacs evil-magit ujelly-theme auctex
	   avy magit counsel-projectile counsel ivy rainbow-delimiters winum
	   evil-matchit evil-surround evil which-key general use-package)))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil)
 '(truncate-lines t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil
			 :strike-through nil :overline nil :underline nil :slant
			 normal :weight normal :height 115 :width normal
			 :foundry "unknown" :family "Inconsolata")))))
