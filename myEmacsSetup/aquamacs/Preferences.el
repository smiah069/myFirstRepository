;; This is the Aquamacs Preferences file.
;; Add Emacs-Lisp code here that should be executed whenever
;; you start Aquamacs Emacs. If errors occur, Aquamacs will stop
;; evaluating this file and print errors in the *Messages* buffer.
;; Use this file in place of ~/.emacs (which is loaded as well.)

;;;;;;;;;;;;;;;;;;;;; Suruz's customization

; start package.el with emacs
(require 'package)
; add MELPA repository list
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/"))
; initialize package.el
(package-initialize)


;; Directory editor: Group directories and sort files
(setq insert-directory-program "gls" dired-use-ls-dired t)
(setq dired-listing-switches "-aBhl  --group-directories-first")

(require 'dired-x) ;; useful to jump (or info) to the directory of the file your are editing kbd shortcut C-x C-j; I for info 

(setq-default delete-by-moving-to-trash t) ;; delete files/folder to trash (instead of  deleting them permenently)

;;; Explore folder with TAB, C-TAB keys
(use-package dired-subtree
  :ensure
  :after dired
  :config
  (setq dired-subtree-use-backgrounds nil)
  :bind (:map dired-mode-map
              ("<tab>" . dired-subtree-toggle)   ;; TAB
              ("<C-tab>" . dired-subtree-cycle)  ;; C-TAB
              ("<S-iso-lefttab>" . dired-subtree-remove))) ;; Shift-TAB


;; Type 'a' (or use command 'dired-find-alternate-file'), instead of RET key to reuse current buffer (i.e., instead of opening a child directory in a new buffer)
;; Note that the reuse buffer using 'dired-find-alternate-file' does not work when you use '^' to move up to the parent directory. If you want to reuse current buffer (i.e., buffer containing child directory) to move up to the parent directory by pressing '^' key, then add the following lines in the .emacs (Preferences.el) file

(add-hook 'dired-mode-hook
          (lambda ()
            (define-key dired-mode-map (kbd "^")
                        (lambda () (interactive) (find-alternate-file "..")))))


;;;;;;;; start auto-complete with emacs
(require 'auto-complete)
; do default config for auto-complete
(require 'auto-complete-config)
(ac-config-default)
(require 'auto-complete-auctex)

; start yasnippet with emacs
(require 'yasnippet)
(yas-global-mode 1)


(global-visual-line-mode 1)  ; 1 for on, 0 for off.



(setq-default TeX-master nil)   ; working with Master file


(setq ediff-split-window-function 'split-window-horizontally)

(setq-default cursor-type 'box)

;; (require 'magit)

;;; Install epdfinfo via 'brew install pdf-tools' and then install the
;;; pdf-tools elisp via the use-package below. To upgrade the epdfinfo
;;; server, just do 'brew upgrade pdf-tools' prior to upgrading to newest
;;; pdf-tools package using Emacs package system. If things get messed
;;; up, just do 'brew uninstall pdf-tools', wipe out the elpa
;;; pdf-tools package and reinstall both as at the start.

;;; Install epdfinfo via 'brew install pdf-tools' and then install the
;;; pdf-tools elisp via the use-package below. To upgrade the epdfinfo
;;; server, just do 'brew upgrade pdf-tools' prior to upgrading to newest
;;; pdf-tools package using Emacs package system. If things get messed
;;; up, just do 'brew uninstall pdf-tools', wipe out the elpa
;;; pdf-tools package and reinstall both as at the start.


(add-hook 'pdf-view-mode-hook (lambda() (linum-mode -1)))

(require 'use-package)

(use-package pdf-tools
  :ensure t
  :config
  (custom-set-variables
    '(pdf-tools-handle-upgrades nil)) ; Use brew upgrade pdf-tools instead.
  (setq pdf-info-epdfinfo-program "/usr/local/bin/epdfinfo"))
(pdf-tools-install)


(add-hook 'TeX-after-compilation-finished-functions #'TeX-revert-document-buffer)

;; view generated PDF with `pdf-tools'.
(unless (assoc "PDF Tools" TeX-view-program-list-builtin)
  (add-to-list 'TeX-view-program-list-builtin
               '("PDF Tools" TeX-pdf-tools-sync-view)))
(add-to-list 'TeX-view-program-selection
             '(output-pdf "PDF Tools"))


;;;;;; Ido-mode enable

(require 'ido)

(ido-mode 1); enable ido-mode
(setq ido-enable-flex-matching t); flexibly match names via fuzzy matching
(ido-everywhere 1); use ido-mode everywhere, in buffers and for finding files
(setq ido-use-filename-at-point 'guess); for find-file-at-point
(setq ido-use-url-at-point t); look for URLs at point
(setq ffap-require-prefix t); get find-file-at-point with C-u C-x C-f

;;; In directory editor (dired) when a file is to be copied/renamed/moved to a different directory
;;; with key C/R then all directory choice will automatically appear in the minibuffer using
;;; ido-mode (rather than conventional way of changing directory). For that, first install
;;; ido-completing-read+ from melpha (M-x package-list-packages => search for ido-completing-read+,
;;; type i then x).
;;; After that, activate the following two lines. Now simply use C or R key to navigate to the directory
;;; you want and pres C-j to stop at a path and paste the file

;;(require 'ido-completing-read+)  ;; no need to activate this line if ido-completing-read+ is installed from melpha 
(ido-ubiquitous-mode 1)
(eval-after-load 'dired '(progn (mapatoms (lambda (symbol) (if (s-starts-with? "dired-do-" (symbol-name symbol))  (put symbol 'ido 'find-file))))))

;;(put 'dired-do-rename 'ido 'find-file);; No need works with key R (rename/move) only => this is not what we want


(require 'ido-vertical-mode)
(ido-mode 1)
(ido-vertical-mode 1)
(setq ido-vertical-define-keys 'C-n-and-C-p-only)


;;;; Autocomplete for minibuffer's M-x commands (similar to ido-mode but it is M-x only)
(require 'smex) ; Not needed if you use package.el
  (smex-initialize) ; Can be omitted. This might cause a (minimal) delay
                    ; when Smex is auto-initialized on its first run.
(global-set-key (kbd "M-x") 'smex)
  (global-set-key (kbd "M-X") 'smex-major-mode-commands)
  ;; This is your old M-x.
  ;;(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

(require 'recentf)  ;; To access recently opened files
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

(require 'amx)  ;; Newer version of smex 
(amx-mode 1)
