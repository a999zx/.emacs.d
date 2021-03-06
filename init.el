;; Basic .emacs with a good set of defaults, to be used as template for usage
;; with OCaml and OPAM
;;
;; Author: Louis Gesbert <louis.gesbert@ocamlpro.com>
;; Released under CC0

;; Generic, recommended configuration options

;; ANSI color in compilation buffer

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(require 'ansi-color)
(defun colorize-compilation-buffer ()
  (toggle-read-only)
  (ansi-color-apply-on-region (point-min) (point-max))
  (toggle-read-only))
(add-hook 'compilation-filter-hook 'colorize-compilation-buffer)

;; Some key bindings

(global-set-key [f3] 'next-match)
(defun prev-match () (interactive nil) (next-match -1))
(global-set-key [(shift f3)] 'prev-match)
(global-set-key [backtab] 'auto-complete)
;; -- Tweaks for OS X -------------------------------------
;; Tweak for problem on OS X where Emacs.app doesn't run the right
;; init scripts when invoking a sub-shell
(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH environment variable to
  match that used by the user's shell.

This is particularly useful under Mac OSX, where GUI apps are not
started from a shell."
  (interactive)
  (let ((path-from-shell
         (replace-regexp-in-string
          "[ \t\n]*$" ""
          (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))
         ))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator)))
  )

(set-exec-path-from-shell-PATH)
;; OCaml configuration
;;  - better error and backtrace matching

(defun set-ocaml-error-regexp ()
  (set
   'compilation-error-regexp-alist
   (list '("[Ff]ile \\(\"\\(.*?\\)\", line \\(-?[0-9]+\\)\\(, characters \\(-?[0-9]+\\)-\\([0-9]+\\)\\)?\\)\\(:\n\\(\\(Warning .*?\\)\\|\\(Error\\)\\):\\)?"
    2 3 (5 . 6) (9 . 11) 1 (8 compilation-message-face)))))

(add-hook 'tuareg-mode-hook 'set-ocaml-error-regexp)
(add-hook 'caml-mode-hook 'set-ocaml-error-regexp)
;; ## added by OPAM user-setup for emacs / base ## 56ab50dc8996d2bb95e7856a6eddb17b ## you can edit, but keep this line
(require 'opam-user-setup "~/.emacs.d/opam-user-setup.el")
;; ## end of OPAM user-setup addition for emacs / base ## keep this line



;; my configuration

(setq load-path (cons "~/.emacs.d/elisp" load-path))

;; install-elisp
(require 'install-elisp)
(setq install-elisp-repository-directory "~/.emacs.d/elisp/")

;; hi-line+
(when (require 'hl-line+ nil t)  ; hl-line is also loaded
  (global-hl-line-mode 1)
  (defface my-hl-line-face
    '((((class color) (background dark))  ; カラーかつ, 背景が dark ならば,
       (:background "gray10" t))
      (((class color) (background light)) ; カラーかつ, 背景が light ならば,
       (:background "gray90" t))
      (t (:bold t)))
    "hl-line's my face")
  (setq hl-line-face 'my-hl-line-face)
  )

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#2d3743" "#ff4242" "#74af68" "#dbdb95" "#34cae2" "#008b8b" "#00ede1" "#e1e1e0"])
 '(custom-enabled-themes (quote (misterioso-modified)))
 '(custom-safe-themes
   (quote
    ("03c3cb3fde58b957fb40bc3a7dbb7e900d3ba266ac17159f7d1a1457ff5d8e72" default)))
 '(custom-theme-directory "~/.emacs.d/themes")
 '(default-frame-alist (quote ((alpha . 90)))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(cursor ((t (:background "pink")))))

;; GUIのときのみデスクトップの使用
(when window-system
  (custom-set-variables
   '(desktop-path (quote ("~/.emacs.d/")))
   '(desktop-save (quote ask))
   '(desktop-save-mode t)))

;; 選択行に色をつける
(global-hl-line-mode 1)

;; フォントサイズ
(set-face-attribute 'default nil :height 140)

;; ウィンドウの遷移の設定
(defun other-window-or-split (val)
  (interactive)
  (when (one-window-p)
    (split-window-horizontally) ;split horizontally
;    (split-window-vertically) ;split vertically
  )
  (other-window val))

(global-set-key (kbd "<C-tab>") (lambda () (interactive) (other-window-or-split 1)))
(global-set-key (kbd "<C-S-tab>") (lambda () (interactive) (other-window-or-split -1)))

(global-set-key (kbd "<C-s-268632070>") 'toggle-frame-fullscreen)

;; backup の保存先
(setq backup-directory-alist
  (cons (cons ".*" (expand-file-name "~/.emacs.d/backup"))
        backup-directory-alist))

(setq auto-save-file-name-transforms
  `((".*", (expand-file-name "~/.emacs.d/backup/") t)))
