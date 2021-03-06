;;
;; 1. global custom
;;

(setq-default make-backup-files nil)
(setq create-lockfiles nil)
(setq-default indent-tabs-mode nil)
; newline at end of file
(setq require-final-newline t)
; scroll
(setq scroll-step 1)
; tab
(setq default-tab-width 2)
(setq tab-width 2)
(setq-default tab-width 2)
(setq tab-stop-list (number-sequence 0 100 2))
(setq c-basic-offset 2)
; menu bar mode
(menu-bar-mode -1)
(if tool-bar-mode
  (tool-bar-mode -1))
; column number mode
(setq column-number-mode t)
; another key of goto-line
(global-set-key (kbd "M-s") 'goto-line)
; default font
(set-face-attribute 'default nil :font "Monaco 14")
; Chinese Font
(if (fboundp 'set-fontset-font)
  (dolist (charset '(kana han symbol cjk-misc bopomofo))
    (set-fontset-font (frame-parameter nil 'font)
                      charset (font-spec :family "STHeiti"
                                         :size 14))))

;;
;; 2. plugins
;;

; load path
;; compare with `normal-top-level-add-subdirs-to-load-path`
;; this function:
;;     1. no recursion find subdirs
;;     2. no check on name of subdir
;;         for example: a subdir named `xxx.el`
(defun add-subdirs-to-load-path (base-path)
  "add dirs in `base-path` to load-path"
  (dolist (file (directory-files base-path))
    ; exclude . and ..
    (unless (member file '("." ".."))
      (let ((file-abs-path (expand-file-name file base-path)))
        (if (file-directory-p file-abs-path)
          (add-to-list 'load-path file-abs-path))))))
(add-subdirs-to-load-path "~/.emacs.d/lisp")

; insert-datetime
(defun insert-datetime ()
  "Insert date at point."
  (interactive)
  (insert (format-time-string "%Y-%m-%d %H:%M:%S")))
(global-set-key [f6] 'insert-datetime)

; linum mode
(require 'linum)
(global-linum-mode 1)

; auto complete
; apt-get install emacs-goodies-el
; apt-get install auto-complete-el
(require 'auto-complete-config)
; case sensitive matching
(setq ac-ignore-case nil)
(global-auto-complete-mode t)
(ac-config-default)

;; disable electric indent mode
(setq-default electric-indent-mode nil)
(electric-indent-mode -1)

; coffee-mode
; cd ~/.emacs.d
; git clone https://github.com/lexdene/coffee-mode.git
(if (require 'coffee-mode nil t)
  (progn
    (add-hook 'coffee-mode-hook
      (lambda()
        (setq coffee-tab-width 2)
        (setq tab-width 2)))
    (add-to-list 'ac-modes 'coffee-mode)))

; refresh file
(defun refresh-file ()
  (interactive)
  (revert-buffer t t t)
  (message "refresh-file ...")
)
(global-set-key [f5] 'refresh-file)

;;启用时间显示
(setq display-time-format " %Y-%m-%d %A %H:%M ")
(setq display-time-interval 10)
(display-time-mode 1)

; white space
;(global-whitespace-mode 1)
(global-set-key [f8] 'whitespace-mode)

; js indent
(setq js-indent-level 4)
(setq js-auto-indent-flag nil)

; vline
; download from http://www.emacswiki.org/emacs/download/vline.el
(if (require 'vline nil t)
  (global-set-key [f7] 'vline-mode))

; windmove
(global-set-key [M-down] 'windmove-down)
(global-set-key [M-up] 'windmove-up)
(global-set-key (kbd "C-c n") 'windmove-down)
(global-set-key (kbd "C-c p") 'windmove-up)
(global-set-key (kbd "C-c b") 'windmove-left)
(global-set-key (kbd "C-c f") 'windmove-right)

; compile make
(if (require 'compile-make nil t)
  (progn
    (global-set-key [f9] 'compile-make)
    (global-set-key (kbd "M-g c") 'compile-make-ex)
    (setq compilation-scroll-output t)))

; grep at point
(if (require 'grep-at-point nil t)
  (progn
    (global-set-key [f3] 'nopromp-grep-at-point)
    (global-set-key (kbd "M-g M-r 1") 'nopromp-grep-at-point)
    (global-set-key (kbd "M-g M-r 2") 'grep-at-point)))

; show file name
(defun show-file-name ()
  "Show the full path file name in the minibuffer."
  (interactive)
  (message (buffer-file-name)))

(global-set-key [f10] 'show-file-name)

; show paren mode
(show-paren-mode t)

(if (require 'python nil t)
  (progn
    (add-hook 'python-mode-hook
      (lambda()
        (setq tab-width 4)))
    (add-to-list 'auto-mode-alist
      '("\\.tac\\'" . python-mode))))

(require 'ruby-mode)
(add-to-list 'auto-mode-alist
  '("\\.\\(?:gemspec\\|irbrc\\|gemrc\\|rake\\|rb\\|ru\\|thor\\)\\'" . ruby-mode))
(add-to-list 'auto-mode-alist
  '("\\(Capfile\\|Gemfile\\(?:\\.[a-zA-Z0-9._-]+\\)?\\|[rR]akefile\\)\\'" . ruby-mode))
(add-hook 'ruby-mode-hook
  (lambda ()
    (setq tab-width 2)))

(if (require 'haml-mode nil t)
  (progn
    (add-to-list 'ac-modes 'haml-mode)
    (modify-syntax-entry ?_ "_" haml-mode-syntax-table)
    (add-hook 'haml-mode-hook
      (lambda ()
        (setq tab-width 2)))))

(if (require 'gedit-mode nil t)
  (global-gedit-mode t))

(if (require 'column-marker nil t)
  (column-marker-1 80))

(if (require 'scss-mode nil t)
  (progn
    (setq scss-compile-at-save nil)
    (add-to-list 'auto-mode-alist '("\\.scss\\'" . scss-mode))))

(if (require 'markdown-mode nil t)
  (progn
    (add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))))

(add-to-list 'auto-mode-alist '("\\.hbs\\'". html-mode))
