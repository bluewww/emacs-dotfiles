;; -*- no-byte-compile: t; lexical-binding: nil -*-
(define-package "realgud" "20260821.933"
  "A modular front-end for interacting with external debuggers."
  '((load-relative "1.3.2")
    (loc-changes   "1.2")
    (test-simple   "1.3.0")
    (emacs         "27"))
  :url "https://github.com/realgud/realgud/"
  :commit "2075721ad093b4525038f746cc4ad5c013f6d0b8"
  :revdesc "2075721ad093"
  :keywords '("debugger" "gdb" "python" "perl" "go" "bash" "zsh" "bashdb" "zshdb" "remake" "trepan" "perldb" "pdb")
  :authors '(("Rocky Bernstein" . "rocky@gnu.org"))
  :maintainers '(("Rocky Bernstein" . "rocky@gnu.org")))
