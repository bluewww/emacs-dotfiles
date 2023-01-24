;;; early init stuff

;; disable window stuff
(blink-cursor-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)

;; we do that here because it prevents a "flashing" frame size adjustment during
;; emacs startup
;; initial frame size
(add-to-list 'default-frame-alist
	     '(width . 120))
(add-to-list 'default-frame-alist
	     '(height . 80))
;; set default font
(add-to-list 'default-frame-alist
	     '(font . "DejaVu Sans Mono-10"))
