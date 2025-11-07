;; -*- no-byte-compile: t; lexical-binding: nil -*-
(define-package "realgud" "20251024.2145"
  "A modular front-end for interacting with external debuggers."
  '((load-relative "1.3.1")
    (loc-changes   "1.2")
    (test-simple   "1.3.0")
    (emacs         "25"))
  :url "https://github.com/realgud/realgud/"
  :commit "56a8d82830ad65c9cbb9c694617f078f007281ac"
  :revdesc "56a8d82830ad"
  :keywords '("debugger" "gdb" "python" "perl" "go" "bash" "zsh" "bashdb" "zshdb" "remake" "trepan" "perldb" "pdb")
  :authors '(("Rocky Bernstein" . "rocky@gnu.org"))
  :maintainers '(("Rocky Bernstein" . "rocky@gnu.org")))
