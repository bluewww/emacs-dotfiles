;;; riscv-mode-autoloads.el --- automatically extracted autoloads  -*- lexical-binding: t -*-
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "riscv-mode" "riscv-mode.el" (0 0 0 0))
;;; Generated autoloads from riscv-mode.el

(autoload 'riscv-mode "riscv-mode" "\
Major mode for editing RISC V assembly.

\(fn)" t nil)

(add-to-list 'auto-mode-alist '("\\.riscv\\'" . riscv-mode))

(register-definition-prefixes "riscv-mode" '("riscv-"))

;;;***

;;;### (autoloads nil nil ("riscv-mode-pkg.el") (0 0 0 0))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; riscv-mode-autoloads.el ends here
