;;; disaster-autoloads.el --- automatically extracted autoloads
;;
;;; Code:

(add-to-list 'load-path (directory-file-name
                         (or (file-name-directory #$) (car load-path))))


;;;### (autoloads nil "disaster" "disaster.el" (0 0 0 0))
;;; Generated autoloads from disaster.el

(defvar disaster-find-build-root-functions nil "\
Functions to call to get the build root directory from the project directory.
If nil is returned, the next function will be tried.  If all
functions return nil, the project root directory will be used as
the build directory.")

(autoload 'disaster "disaster" "\
Shows assembly code for current line of C/C++ file.

Here's the logic path it follows:

- Is there a Makefile in this directory? Run `make bufname.o`.
- Or is there a Makefile in a parent directory? Run `make -C .. bufname.o`.
- Or is this a C file? Run `cc -g -O3 -c -o bufname.o bufname.c`
- Or is this a C++ file? Run `c++ -g -O3 -c -o bufname.o bufname.c`
- If build failed, display errors in compile-mode.
- Run objdump inside a new window while maintaining focus.
- Jump to line matching current line.

If FILE and LINE are not specified, the current editing location
is used.

\(fn &optional FILE LINE)" t nil)

(if (fboundp 'register-definition-prefixes) (register-definition-prefixes "disaster" '("disaster-")))

;;;***

;; Local Variables:
;; version-control: never
;; no-byte-compile: t
;; no-update-autoloads: t
;; coding: utf-8
;; End:
;;; disaster-autoloads.el ends here
