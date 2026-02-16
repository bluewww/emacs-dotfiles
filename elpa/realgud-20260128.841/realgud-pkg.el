;; -*- no-byte-compile: t; lexical-binding: nil -*-
(define-package "realgud" "20260128.841"
  "A modular front-end for interacting with external debuggers."
  '((load-relative "1.3.2")
    (loc-changes   "1.2")
    (test-simple   "1.3.0")
    (emacs         "27"))
  :url "https://github.com/realgud/realgud/"
  :commit "fe1d6eab69375c704c6861125fa1f4d0d758a5e8"
  :revdesc "fe1d6eab6937"
  :keywords '("debugger" "gdb" "python" "perl" "go" "bash" "zsh" "bashdb" "zshdb" "remake" "trepan" "perldb" "pdb")
  :authors '(("Rocky Bernstein" . "rocky@gnu.org"))
  :maintainers '(("Rocky Bernstein" . "rocky@gnu.org")))
