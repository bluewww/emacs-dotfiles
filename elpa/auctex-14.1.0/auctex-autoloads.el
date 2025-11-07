;;; auctex-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "auctex" "auctex.el" (0 0 0 0))
;;; Generated autoloads from auctex.el

(register-definition-prefixes "auctex" '("AUCTeX-version"))

;;;***

;;;### (autoloads nil "bib-cite" "bib-cite.el" (0 0 0 0))
;;; Generated autoloads from bib-cite.el

(autoload 'bib-cite-minor-mode "bib-cite" "\
Toggle bib-cite mode.
When bib-cite mode is enabled, citations, labels and refs are highlighted
when the mouse is over them.  Clicking on these highlights with [mouse-2]
runs `bib-find', and [mouse-3] runs `bib-display'.

\(fn ARG)" t nil)

(autoload 'turn-on-bib-cite "bib-cite" "\
Unconditionally turn on Bib Cite mode." nil nil)

(register-definition-prefixes "bib-cite" '("LaTeX-find-label-hist-alist" "bib-" "create-alist-from-list" "member-cis" "psg-" "search-directory-tree"))

;;;***

;;;### (autoloads nil "context" "context.el" (0 0 0 0))
;;; Generated autoloads from context.el

(defalias 'context-mode #'ConTeXt-mode)

(autoload 'ConTeXt-mode "context" "\
Major mode in AUCTeX for editing ConTeXt files.

Entering `ConTeXt-mode' calls the value of `text-mode-hook',
then the value of `TeX-mode-hook', and then the value
of `ConTeXt-mode-hook'.

\(fn)" t nil)

(register-definition-prefixes "context" '("ConTeXt-" "TeX-ConTeXt-sentinel" "context-guess-current-interface"))

;;;***

;;;### (autoloads nil "context-en" "context-en.el" (0 0 0 0))
;;; Generated autoloads from context-en.el

(register-definition-prefixes "context-en" '("ConTeXt-"))

;;;***

;;;### (autoloads nil "context-nl" "context-nl.el" (0 0 0 0))
;;; Generated autoloads from context-nl.el

(register-definition-prefixes "context-nl" '("ConTeXt-"))

;;;***

;;;### (autoloads nil "font-latex" "font-latex.el" (0 0 0 0))
;;; Generated autoloads from font-latex.el

(autoload 'font-latex-setup "font-latex" "\
Setup this buffer for LaTeX font-lock.  Usually called from a hook." nil nil)

(register-definition-prefixes "font-latex" '("font-latex-"))

;;;***

;;;### (autoloads nil "latex" "latex.el" (0 0 0 0))
;;; Generated autoloads from latex.el

(autoload 'BibTeX-auto-store "latex" "\
This function should be called from `bibtex-mode-hook'.
It will setup BibTeX to store keys in an auto file." nil nil)

(add-to-list 'auto-mode-alist '("\\.drv\\'" . LaTeX-mode) t)

(add-to-list 'auto-mode-alist '("\\.hva\\'" . LaTeX-mode))
 (if (eq (symbol-function 'LaTeX-mode) 'latex-mode)
    (defalias 'LaTeX-mode nil))

(autoload 'LaTeX-mode "latex" "\
Major mode in AUCTeX for editing LaTeX files.
See info under AUCTeX for full documentation.

Entering LaTeX mode calls the value of `text-mode-hook',
then the value of `TeX-mode-hook', and then the value
of `LaTeX-mode-hook'.

\(fn)" t nil)

(put 'LaTeX-mode 'auctex-function-definition (symbol-function 'LaTeX-mode))

(autoload 'docTeX-mode "latex" "\
Major mode in AUCTeX for editing .dtx files derived from `LaTeX-mode'.
Runs `LaTeX-mode', sets a few variables and
runs the hooks in `docTeX-mode-hook'.

\(fn)" t nil)

(register-definition-prefixes "latex" '("Bib" "LaTeX-" "TeX-" "docTeX-" "latex-math-mode"))

;;;***

;;;### (autoloads nil "latex-flymake" "latex-flymake.el" (0 0 0 0))
;;; Generated autoloads from latex-flymake.el

(register-definition-prefixes "latex-flymake" '("LaTeX-"))

;;;***

;;;### (autoloads nil "multi-prompt" "multi-prompt.el" (0 0 0 0))
;;; Generated autoloads from multi-prompt.el

(autoload 'multi-prompt "multi-prompt" "\
Completing prompt for a list of strings.
The first argument SEPARATOR should be the string (of length 1) to
separate the elements in the list.  The second argument UNIQUE should
be non-nil, if each element must be unique.  The remaining elements
are the arguments to `completing-read'.  See that.

\(fn SEPARATOR UNIQUE PROMPT TABLE &optional MP-PREDICATE REQUIRE-MATCH INITIAL HISTORY)" nil nil)

(autoload 'multi-prompt-key-value "multi-prompt" "\
Read multiple strings, with completion and key=value support.
PROMPT is a string to prompt with, usually ending with a colon
and a space.

TABLE is an alist where each entry is a list.  The first element
of each list is a string representing a key and the optional
second element is a list with strings to be used as values for
the key.  The second element can also be a variable returning a
list of strings.

See the documentation for `completing-read' for details on the
other arguments: PREDICATE, REQUIRE-MATCH, INITIAL-INPUT, HIST,
DEF, and INHERIT-INPUT-METHOD.

The return value is the string as entered in the minibuffer.

\(fn PROMPT TABLE &optional PREDICATE REQUIRE-MATCH INITIAL-INPUT HIST DEF INHERIT-INPUT-METHOD)" nil nil)

(register-definition-prefixes "multi-prompt" '("multi-prompt-"))

;;;***

;;;### (autoloads nil "plain-tex" "plain-tex.el" (0 0 0 0))
;;; Generated autoloads from plain-tex.el
 (if (eq (symbol-function 'plain-TeX-mode) 'plain-tex-mode)
    (defalias 'plain-TeX-mode nil))

(autoload 'plain-TeX-mode "plain-tex" "\
Major mode in AUCTeX for editing plain TeX files.
See info under AUCTeX for documentation.

Entering `plain-TeX-mode' calls the value of `text-mode-hook',
then the value of `TeX-mode-hook', and then the value
of `plain-TeX-mode-hook'.

\(fn)" t nil)

(put 'plain-TeX-mode 'auctex-function-definition (symbol-function 'plain-TeX-mode))

(autoload 'AmSTeX-mode "plain-tex" "\
Major mode in AUCTeX for editing AmSTeX files.
See info under AUCTeX for documentation.

Entering `AmSTeX-mode' calls the value of `text-mode-hook', then
the value of `TeX-mode-hook', `plain-TeX-mode-hook' and then the
value of `AmSTeX-mode-hook'.

\(fn)" t nil)

(defalias 'ams-tex-mode #'AmSTeX-mode)

(register-definition-prefixes "plain-tex" '("AmSTeX-" "plain-TeX-"))

;;;***

;;;### (autoloads nil "preview" "preview.el" (0 0 0 0))
;;; Generated autoloads from preview.el

(put 'preview-scale-function 'safe-local-variable (lambda (x) (and (numberp x) (<= 0.1 x 10))))

(autoload 'desktop-buffer-preview "preview" "\
Hook function for restoring persistent previews into a buffer.

\(fn FILE-NAME BUFFER-NAME MISC)" nil nil)

(add-to-list 'desktop-buffer-mode-handlers '(LaTeX-mode . desktop-buffer-preview))

(autoload 'preview-install-styles "preview" "\
Install the TeX style files into a permanent location DIR.
This must be in the TeX search path.  If FORCE-OVERWRITE is greater
than 1, files will get overwritten without query, if it is less
than 1 or nil, the operation will fail.  The default of 1 for interactive
use will query.

Similarly FORCE-SAVE can be used for saving
`preview-TeX-style-dir' to record the fact that the uninstalled
files are no longer needed in the search path.

\(fn DIR &optional FORCE-OVERWRITE FORCE-SAVE)" t nil)

(autoload 'LaTeX-preview-setup "preview" "\
Hook function for embedding the preview package into AUCTeX.
This is called by `LaTeX-mode-hook' and changes AUCTeX variables
to add the preview functionality." nil nil)

(autoload 'preview-report-bug "preview" "\
Report a bug in the preview-latex package." t nil)

(register-definition-prefixes "preview" '("TeX-" "desktop-buffer-preview-misc-data" "preview-"))

;;;***

;;;### (autoloads nil "tex" "tex.el" (0 0 0 0))
;;; Generated autoloads from tex.el

(autoload 'TeX-tex-mode "tex" "\
Call suitable AUCTeX major mode for editing TeX or LaTeX files.
Tries to guess whether this file is for plain TeX or LaTeX.

The algorithm is as follows:

   1) If the file is empty or `TeX-force-default-mode' is not set to nil,
      `TeX-default-mode' is chosen.
   2) If non-commented out content matches with regular expression in
      `TeX-format-list', use the associated major mode.  For example,
      if \\documentclass or \\begin{, \\section{, \\part{ or \\chapter{ is
      found, `LaTeX-mode' is selected.
   3) Otherwise, use `TeX-default-mode'.

By default, `TeX-format-list' has a fallback entry for
`plain-TeX-mode', thus non-empty file which didn't match any
other entries will enter `plain-TeX-mode'." t nil)
 (if (eq (symbol-function 'TeX-mode) 'tex-mode)
    (defalias 'TeX-mode nil))

(put 'TeX-mode 'auctex-function-definition (symbol-function 'TeX-mode))

(autoload 'TeX-auto-generate "tex" "\
Generate style file for TEX and store it in AUTO.
If TEX is a directory, generate style files for all files in the directory.

\(fn TEX AUTO)" t nil)

(autoload 'TeX-auto-generate-global "tex" "\
Create global auto directory for global TeX macro definitions." t nil)

(autoload 'TeX-submit-bug-report "tex" "\
Submit a bug report on AUCTeX via mail.

Don't hesitate to report any problems or inaccurate documentation.

If you don't have setup sending mail from Emacs, please copy the
output buffer into your mail program, as it gives us important
information about your AUCTeX version and AUCTeX configuration." t nil)

(register-definition-prefixes "tex" '("Bib" "ConTeXt-" "LaTeX-" "TeX-" "docTeX-default-extension" "plain-TeX-auto-regexp-list" "tex-"))

;;;***

;;;### (autoloads nil "tex-bar" "tex-bar.el" (0 0 0 0))
;;; Generated autoloads from tex-bar.el

(autoload 'TeX-install-toolbar "tex-bar" "\
Install toolbar buttons for TeX mode." t nil)

(autoload 'LaTeX-install-toolbar "tex-bar" "\
Install toolbar buttons for LaTeX mode." t nil)

(register-definition-prefixes "tex-bar" '("TeX-bar-"))

;;;***

;;;### (autoloads nil "tex-fold" "tex-fold.el" (0 0 0 0))
;;; Generated autoloads from tex-fold.el

(autoload 'TeX-fold-mode "tex-fold" "\
Minor mode for hiding and revealing macros and environments.

Called interactively, with no prefix argument, toggle the mode.
With universal prefix ARG (or if ARG is nil) turn mode on.
With zero or negative ARG turn mode off.

\(fn &optional ARG)" t nil)

(defalias 'tex-fold-mode #'TeX-fold-mode)

(register-definition-prefixes "tex-fold" '("TeX-fold-"))

;;;***

;;;### (autoloads nil "tex-font" "tex-font.el" (0 0 0 0))
;;; Generated autoloads from tex-font.el

(autoload 'tex-font-setup "tex-font" "\
Setup font lock support for TeX." nil nil)

(register-definition-prefixes "tex-font" '("tex-font-lock-"))

;;;***

;;;### (autoloads nil "tex-info" "tex-info.el" (0 0 0 0))
;;; Generated autoloads from tex-info.el

(autoload 'Texinfo-mode "tex-info" "\
Major mode in AUCTeX for editing Texinfo files.

Entering Texinfo mode calls the value of `text-mode-hook' and then the
value of `Texinfo-mode-hook'.

\(fn)" t nil)

(register-definition-prefixes "tex-info" '("Texinfo-" "texinfo-environment-regexp"))

;;;***

;;;### (autoloads nil "tex-ispell" "tex-ispell.el" (0 0 0 0))
;;; Generated autoloads from tex-ispell.el

(register-definition-prefixes "tex-ispell" '("TeX-ispell-"))

;;;***

;;;### (autoloads nil "tex-jp" "tex-jp.el" (0 0 0 0))
;;; Generated autoloads from tex-jp.el

(autoload 'japanese-plain-TeX-mode "tex-jp" "\
Major mode in AUCTeX for editing Japanese plain TeX files.

\(fn)" t nil)

(defalias 'japanese-plain-tex-mode #'japanese-plain-TeX-mode)

(autoload 'japanese-LaTeX-mode "tex-jp" "\
Major mode in AUCTeX for editing Japanese LaTeX files.

\(fn)" t nil)

(defalias 'japanese-latex-mode #'japanese-LaTeX-mode)

(register-definition-prefixes "tex-jp" '("TeX-japanese-process-" "japanese-"))

;;;***

;;;### (autoloads nil "tex-site" "tex-site.el" (0 0 0 0))
;;; Generated autoloads from tex-site.el
 (require 'tex-site)

(register-definition-prefixes "tex-site" '("TeX-" "preview-TeX-style-dir" "tex-site-unload-function"))

;;;***

;;;### (autoloads nil "tex-style" "tex-style.el" (0 0 0 0))
;;; Generated autoloads from tex-style.el

(register-definition-prefixes "tex-style" '("LaTeX-" "TeX-TikZ-point-name-regexp"))

;;;***

;;;### (autoloads nil "tex-wizard" "tex-wizard.el" (0 0 0 0))
;;; Generated autoloads from tex-wizard.el

(register-definition-prefixes "tex-wizard" '("TeX-wizard"))

;;;***

;;;### (autoloads nil "texmathp" "texmathp.el" (0 0 0 0))
;;; Generated autoloads from texmathp.el

(autoload 'texmathp "texmathp" "\
Determine if point is inside (La)TeX math mode.
Returns t or nil.  Additional info is placed into `texmathp-why'.
The functions assumes that you have (almost) syntactically correct (La)TeX in
the buffer.
See the variable `texmathp-tex-commands' about which commands are checked." t nil)

(autoload 'texmathp-match-switch "texmathp" "\
Search backward for any of the math switches.
Limit searched to BOUND.

\(fn BOUND)" nil nil)

(register-definition-prefixes "texmathp" '("texmathp-"))

;;;***

;;;### (autoloads nil "toolbar-x" "toolbar-x.el" (0 0 0 0))
;;; Generated autoloads from toolbar-x.el
 (autoload 'toolbarx-install-toolbar "toolbar-x")

(register-definition-prefixes "toolbar-x" '("toolbarx-"))

;;;***

;;;### (autoloads nil nil ("auctex-pkg.el" "tex-mik.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; auctex-autoloads.el ends here
