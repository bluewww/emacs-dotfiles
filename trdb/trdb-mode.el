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

(defvar trdb-dumper "trdb"
  "Command to run to decompress and disassemble traces.")

(defvar trdb-dumper-args "-dls"
  "Arguments to pass when calling `trdb-dumper'.")

(defvar trdb-overlays nil
  "List of overlays to display.")

(defvar trdb-buffer "*trdb-output*"
  "Default buffername used by trdb.")

(defface trdb-current-line-face
  '((t (:weight bold :inherit highlight)))
  "Face to fontify the current line for showing matches."
  :group 'trdb)


(defconst trdb-riscv-registers (rx (or "zero" "ra" (and (any "sgtf") "p")
				       (and "t" (any "0-6"))
				       (and "s" digit digit) ; 0-11
				       (and "a" (any "0-7"))
				       (and "f" digit digit) ; 0-31
				       (and "ft" digit digit) ; 0-11
				       (and "fs" digit digit) ; 0-11
				       (and "fa" (any "0-8"))
				       (and "x" digit digit)))) ; 0-31

(defconst trdb-hex-const (rx "0x" (1+ (any digit "a-f" "A-F"))))

(defconst trdb-resolved-symbol (rx (and (1+ (any digit "a-f" "A-F")) " <"
					(1+ (any "_" alnum ))
					(or
					 (and "+" "0x"
					      (1+ (any digit "a-f" "A-F")) ">")
					 ">"))))

;; this is form risc-v mode
(defconst trdb-riscv-keywords
  '("lui" "auipc"
    "jal" "jalr"
    "beq" "bne" "blt" "bge" "bltu" "bgeu"
    "lh" "lb" "lw" "lbu" "lhu"
    "sb" "sh" "sw"
    "add" "sub"
    "addi"
    "sll" "slt" "sltu" "xor" "srl" "sra" "or" "and"
    "slti" "sltiu" "xori" "ori" "andi" "slli" "srli" "srai"
    "fence" "fence.i"
    "scall" "sbreak" "ecall" "ebreak"
    "rdcycle" "rdcycleh" "rdtime" "rdtimeh" "rdinstret" "rdinstreth"
    "lwu" "ld" "sd"
    "addiw" "slliw" "srliw" "sraiw" "adw" "subw" "sllw" "srlw" "sraw"
    "mul" "mulh" "mulhsu" "mulhu" "div" "divu" "rem" "remu"
    "mulw" "divw" "divuw" "remw" "remuw"
    ;; Atomics
    "lr.w" "sc.w" "amoswapw" "amoadd.w" "amoxor.w" "amoand.w" "amoor.w"
    "amomin.w" "amomax.w" "amominu.w" "amomaxu.w"
    "lr.d" "sc.d" "amosdapd" "amoadd.d" "amoxor.d" "amoand.d" "amoor.d"
    "amomin.d" "amomax.d" "amominu.d" "amomaxu.d"
    ;; Floating point
    "flw" "fsw" "fmadd.s" "fmsub.s" "fnmsub.s" "fnmadd.s"
    "fadd.s" "fsub.s" "fmul.s" "fdiv.s" "fsqrt.s"
    "fsgnj.s" "fsnjn.s" "fsnjx.s"
    "fmin.s" "fmax.s" "fcvt.w.s" "fcvt.wu.s" "fmv.x.s"
    "feq.s" "flt.s" "fle.s"
    "fclass.s" "fcvt.s.w" "fcvt.s.wu" "fmv.s.x"
    "frcsr" "frrm" "frflags" "fscsr" "fsrm" "fsflags" "fsrmi" "fsflagsi"
    "fcvt.l.s" "fcvt.l.u.s" "fcvt.s.l" "fcvt.s.lu"
    ;; Double Precision
    "fld" "fsd" "fmadd.d" "fmsub.d" "fnmsub.d" "fnmadd.d"
    "fadd.d" "fsub.d" "fmul.d" "fdiv.d" "fsqrt.d"
    "fsgnj.d" "fsnjn.d" "fsnjx.d"
    "fmin.d" "fmax.d" "fcvt.w.d" "fcvt.wu.d" "fmv.x.d"
    "feq.d" "flt.d" "fle.d"
    "fclass.d" "fcvt.d.w" "fcvt.d.wu" "fmv.d.x"
    "frcsr" "frrm" "frflags" "fscsr" "fsrm" "fsflags" "fsrmi" "fsflagsi"
    "fcvt.l.d" "fcvt.l.u.d" "fcvt.d.l" "fcvt.d.lu"
    "fmv.d.x"
    ;; Pseudoinstructions
    "nop"
    "la" "li"
    "lb" "lh" "lw" "ld"
    "sb" "sh" "sw" "sd"
    "flw" "fld"
    "fsw" "fsd"
    "mv"
    "not" "neg" "negw"
    "sext"
    "seqz" "snez" "sltz" "sgtz"
    "fmv.s" "fmv.d"
    "fabs.s" "fabs.d"
    "fneg.s" "fneg.d"
    "beqz" "bnez" "blez" "bgez" "btlz" "bgtz"
    "j" "jal" "jr" "jalr" "ret" "call" "tail"))

(defconst trdb-font-lock-keywords
  `(("\\<-?[0-9]+\\>" . font-lock-constant-face)
    ("\"\\.\\*\\?" . font-lock-string-face)
    (,trdb-resolved-symbol . font-lock-constant-face)
    (,(regexp-opt trdb-riscv-keywords) . font-lock-keyword-face)
    (,trdb-hex-const . font-lock-constant-face)
    (,trdb-riscv-registers . font-lock-type-face)))

;;;###autoload
(defun trdb-decompress-disassemble-trace (executable &optional trace-file)
  "TODO.
Argument EXECUTABLE is the original binary that was executed to produce TRACE-FILE.
Argument TRACE-FILE is the aptured, compressed traces to view."
  (interactive "fexecutable:")
  (let ((asmbuf (get-buffer-create trdb-buffer))
	(file (or trace-file (buffer-file-name))))
    (shell-command
     (mapconcat
      #'identity
      (list trdb-dumper "--bfd" executable trdb-dumper-args file)
      " ")
     asmbuf)
    (with-current-buffer asmbuf
      (trdb-mode)
      ;; (trdb--shadow-non-assembly-code)
      (compilation-minor-mode))))

;; this function is taken verbatim from disaster-mode
;;;###autoload
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
(define-derived-mode trdb-mode asm-mode "trdb"
  "Toggle trdb-mode.
This mode is enabled in the output buffer."
  :global nil
  ;; init
  (add-to-list 'compilation-error-regexp-alist
	       `(,trdb-disas-line 1 2))
  (font-lock-add-keywords nil trdb-font-lock-keywords)
  (font-lock-add-keywords nil asm-font-lock-keywords)
  (font-lock-add-keywords nil '(("#.+" . font-lock-comment-face)))
  (set (make-local-variable 'comment-start) "# ")
  (set (make-local-variable 'comment-start-skip) "#+\\s-*")
  (set (make-local-variable 'compilation-error-face) 'font-lock-comment-face))

;;;###autoload
(add-to-list 'auto-mode-alist '("\\.trdb\\'" . trdb-mode))

(provide 'trdb-mode)
;;; trdb-mode.el ends here
