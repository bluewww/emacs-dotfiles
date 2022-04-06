;;; zotxt-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "org-zotxt" "org-zotxt.el" (0 0 0 0))
;;; Generated autoloads from org-zotxt.el

(autoload 'org-zotxt-mode "org-zotxt" "\
Toggle org-zotxt-mode.
With no argument, this command toggles the mode.
Non-null prefix argument turns on the mode.
Null prefix argument turns off the mode.

This is a minor mode.  If called interactively, toggle the
`Org-Zotxt mode' mode.  If the prefix argument is positive,
enable the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `org-zotxt-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

This is a minor mode for managing your citations with Zotero in a
org-mode document.

\(fn &optional ARG)" t nil)

(register-definition-prefixes "org-zotxt" '("org-zotxt-"))

;;;***

;;;### (autoloads nil "org-zotxt-noter" "org-zotxt-noter.el" (0 0
;;;;;;  0 0))
;;; Generated autoloads from org-zotxt-noter.el

(register-definition-prefixes "org-zotxt-noter" '("org-zotxt-noter"))

;;;***

;;;### (autoloads nil "zotxt" "zotxt.el" (0 0 0 0))
;;; Generated autoloads from zotxt.el

(autoload 'zotxt-citekey-mode "zotxt" "\
Toggle zotxt-citekey-mode.
With no argument, this command toggles the mode.
Non-null prefix argument turns on the mode.
Null prefix argument turns off the mode.

This is a minor mode.  If called interactively, toggle the
`Zotxt-Citekey mode' mode.  If the prefix argument is positive,
enable the mode, and if it is zero or negative, disable the mode.

If called from Lisp, toggle the mode if ARG is `toggle'.  Enable
the mode if ARG is nil, omitted, or is a positive number.
Disable the mode if ARG is a negative number.

To check whether the minor mode is enabled in the current buffer,
evaluate `zotxt-citekey-mode'.

The mode's hook is called both when the mode is enabled and when
it is disabled.

This is a minor mode for managing your citekey citations,
including completion.

\(fn &optional ARG)" t nil)

(define-obsolete-function-alias 'zotxt-easykey-mode #'zotxt-citekey-mode "6.0")

(register-definition-prefixes "zotxt" '("zotxt-"))

;;;***

;;;### (autoloads nil nil ("zotxt-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; zotxt-autoloads.el ends here
