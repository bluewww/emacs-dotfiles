;;; trdb-mode.el --- A basic trace disassebler and viewer

;;; Commentary:
;;

;;; Code:
(defvar trdb-disas-line (rx bol
			    (group "/" (1+ (not (any ":"))))
			    ":"
			    (group (1+ num))
			    (0+ any))
  "Regexp to find line number information in disassembled code.")

(defvar trdb-dumper "objdump"
  "Command to run to decompress and disassemble traces.")

(defvar trdb-dumper-args "-dl"
  "Arguments to pass when calling `trdb-dumper'.")

(defvar trdb-overlays nil
  "List of overlays to display.")

(defvar trdb-buffer "trdb-output"
  "Default buffername used by trdb.")

(defface trdb-current-line-face
  '((t (:weight bold :inherit highlight)))
  "Face to fontify the current line for showing matches."
  :group 'trdb)

;;;###autoload
(defun trdb-process-trace (trace-file)
  "TODO.
Argument TRACE-FILE Captured, compressed traces to view."
  (interactive "ftrace file: ")
  (let ((asmbuf (get-buffer-create trdb-buffer)))
    (shell-command
     (mapconcat #'identity
		(list trdb-dumper trdb-dumper-args trace-file)
		" ")
     asmbuf)
    (with-current-buffer asmbuf
      (asm-mode)
      (trdb--shadow-non-assembly-code)
      (compilation-minor-mode))))

;; use this for rmsbolt style overlays
;; (let ((o (make-overlay 0 1000 asmbuf)))
;;       (overlay-put o 'face 'trdb-current-line-face)
;;       o)
;; (defun trdb--process-lines (asm-buffer)
;;   ())

;; this function is taken verbatim from disaster-mode
(defun trdb--shadow-non-assembly-code ()
  "Scans current buffer and shadows non-asm lines.
Assumed to be in `asm-mode' beforehand. Uses the standard
`shadow' face for lines that don't appear to contain assembly
code."
  (remove-overlays)
  (save-excursion
    (goto-char 0)
    (while (not (eobp))
      (beginning-of-line)
      (if (not (looking-at "[ \t]+[a-f0-9]+:[ \t]+"))
	  (let ((eol (save-excursion (end-of-line) (point))))
	    (overlay-put (make-overlay (point) eol)
			 'face 'shadow)))
(forward-line))))

;;;###autoload
(define-minor-mode trdb-mode
  "Toggle trdb-mode.
This mode is enabled in the output buffer."
  :global nil
  ;; init
  (add-to-list 'compilation-error-regexp-alist
	       `(,trdb-disas-line 1 2)))

(provide 'trdb-mode)

;;; trdb-mode.el ends here
