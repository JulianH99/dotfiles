
;; Turn off startup screen
(setq inhibit-startup-message t)

;; Basic UI cleanup
(scroll-bar-mode -1)
(tool-bar-mode -1)
(menu-bar-mode -1)

;; Highlight current line
(global-hl-line-mode 1)

;; Line numbers
(setq display-line-numbers-type 'relative)
(global-display-line-numbers-mode 1)

;; Package system initialization
(require 'package)

(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
        ("gnu"   . "https://elpa.gnu.org/packages/")))

(package-initialize)

;; Install use-package automatically if not installed
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)



;; configure custom packages

;; configure evil mode
(use-package evil
  :ensure t
  :init
  (setq evil-want-C-i-jump nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-search-module 'isearch)
  :config
  (evil-mode 1)
)

;; bind c-c to escape
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages '(evil)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
