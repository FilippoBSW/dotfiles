;;; -*- lexical-binding: t; coding: utf-8 -*-

;;; Custom file
(setq custom-file (locate-user-emacs-file "custom.el")
      create-lockfiles nil
      disabled-command-function nil)
(load custom-file :no-error-if-file-is-missing)

;;; Backup
(setq backup-directory-alist `(("." . ,(locate-user-emacs-file "backup")))
      auto-save-default nil
      auto-save-file-name-transforms `((".*" ,(locate-user-emacs-file "backup/autosaves")))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)

;;; Font
(let* ((font-name (if (eq system-type 'windows-nt)
                      "JetBrainsMono NFM Medium"
                    "JetBrainsMono Nerd Font Mono"))
       (font-size "8")
       (font-weight "semibold")
       (font-spec (format "%s-%s:%s" font-name font-size font-weight)))
  (set-frame-font font-spec nil t)
  (add-to-list 'default-frame-alist `(font . ,font-spec)))

;;; Coding system
(set-language-environment "UTF-8")
(prefer-coding-system 'utf-8-unix)
(set-default-coding-systems 'utf-8-unix)

(setq-default buffer-file-coding-system 'utf-8-unix)

(unless (display-graphic-p)
  (set-terminal-coding-system 'utf-8-unix)
  (set-keyboard-coding-system 'utf-8-unix))
(when (eq system-type 'windows-nt)
  (set-clipboard-coding-system 'utf-16-le)
  (set-selection-coding-system 'utf-16-le)
  (setq default-process-coding-system '(utf-8-unix . utf-8-unix)))

;;; Modeline
(load-file (locate-user-emacs-file "modeline.el"))

;;; Side window
(defconst my--side-window-buffer-names
  '(".*compilation.*"
    "Async Shell Command"
    "Cargo"
    "Embark Actions"
    "Embark Collect"
    "Embark Export"
    "Flymake"
    "Help"
    "Messages"
    "Occur"
    "Warnings"
    "grep"
    "m-process:"
    "vterm"
    "xref"))

(defconst my--side-window-buffer-pattern
  (mapconcat (lambda (name) (concat "*" name)) my--side-window-buffer-names "\\|"))

(setq display-buffer-alist
      `((,my--side-window-buffer-pattern
         (display-buffer-reuse-window
          display-buffer-in-side-window)
         (side . bottom)
         (window-height . 25)
         (window-parameters . ((no-other-window . t)))
         (body-function . select-window))))

;;; Frame name
(setq frame-title-format
      '(:eval (if (buffer-file-name)
                  (concat "" (abbreviate-file-name (buffer-file-name)))
                (concat "" "%b"))))

;;; Packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(require 'use-package)
(setq use-package-always-ensure t)
(package-initialize)
(unless package-archive-contents (package-refresh-contents))
(setq native-comp-async-report-warnings-errors 'silent)

(use-package meow)
(use-package vertico)
(use-package corfu)
(use-package cape)
(use-package orderless)
(use-package marginalia)
(use-package consult)
(use-package consult-eglot)
(use-package wgrep)
(use-package embark)
(use-package embark-consult)
(use-package perspective)
(use-package multiple-cursors)
(use-package visual-regexp)
(use-package visual-regexp-steroids)
(use-package avy)
(use-package vundo)
(use-package windower)
(use-package ido-select-window)
(use-package zoxide)
(use-package magit)
(use-package snap-indent)
(use-package yasnippet)
(use-package yasnippet-snippets)
(use-package sudo-edit)
(use-package rainbow-mode)
(use-package kind-icon)
(use-package all-the-icons)
(use-package diredfl)
(use-package org-superstar)
(use-package toc-org)
(use-package treesit-auto)
(use-package clang-format)
(use-package flycheck-clang-tidy)
(use-package cmake-mode)
(use-package haskell-mode)
(use-package rust-mode)
(use-package cargo-mode)
(use-package zig-mode)
(use-package go-mode)
(use-package swift-mode)
(use-package vlf)

(require 'ibuffer)
(require 'savehist)
(require 'recentf)
(require 'ido)
(require 'ediff)
(require 'eglot)
(require 'winner)
(require 'which-key)
(require 'c-ts-mode)
(require 'go-ts-mode)
(require 'vlf-setup)

(defconst my--fd-executable-path  "~/.cargo/bin/fd")
(defconst my--consult-fd-args (concat my--fd-executable-path " --sort-by-depth --full-path --hidden --no-ignore --color=never --exclude .git"))

(defvar my-vc-enabled nil)
(defvar my-eglot-global-enabled nil)
(defvar my-eglot-format-on-save-enabled nil)
(defvar corfu-auto-mode-line-string "")

(consult-customize consult--source-buffer :hidden t :default nil)

(setq
 isearch-lazy-count t
 isearch-case-fold-search t
 search-upper-case t
 search-whitespace-regexp ".*?"
 recentf-max-menu-items 10
 recentf-max-saved-items 1000000
 recentf-exclude '("/tmp")
 ediff-split-window-function 'split-window-horizontally
 ediff-window-setup-function 'ediff-setup-windows-plain
 dired-listing-switches "-alh --group-directories-first --sort=version"
 dired-kill-when-opening-new-dired-buffer t
 dired-dwim-target t
 wdired-create-parent-directories t
 wdired-allow-to-change-permissions t
 eglot-stay-out-of '(flymake)
 flymake-mode-line-counter-format '("(" flymake-mode-line-error-counter flymake-mode-line-warning-counter flymake-mode-line-note-counter ")")
 flymake-mode-line-format '(" " flymake-mode-line-exception flymake-mode-line-counters)
 org-src-fontify-natively t
 org-indent-indentation-per-level 4
 treesit-font-lock-level 4
 c-default-style "bsd"
 c-basic-offset 4
 c-ts-mode-indent-style 'bsd
 c-ts-mode-indent-offset 4
 go-ts-mode-indent-offset 4
 whitespace-line-column 10000
 whitespace-style
 '(face
   tabs
   spaces
   trailing
   lines-tail
   space-before-tab
   indentation
   newline
   empty
   space-after-tab
   space-mark
   tab-mark))

(setq
 meow-keypad-describe-keymap-function nil
 meow-expand-hint-remove-delay 0
 vertico-count 15
 vertico-multiform-categories '((t flat))
 vertico-multiform-commands '()
 completion-styles '(orderless)
 consult-preview-key "C-o"
 consult-buffer-filter "\\*"
 consult-fd-args (concat my--consult-fd-args " -t file")
 consult-ripgrep-args (concat consult-ripgrep-args " -P --hidden --no-ignore -g !.git -g !TAGS")
 embark-mixed-indicator-delay 1.0
 mc/always-run-for-all t
 vr/default-regexp-modifiers '(:I t :M t :S nil)
 persp-sort 'created
 persp-initial-frame-name "dev"
 persp-mode-prefix-key (kbd "C-c M-p")
 persp-state-default-file (locate-user-emacs-file "state.persp")
 persp-modestring-dividers '("(" ")" " ")
 wgrep-auto-save-buffer t
 avy-background t
 avy-keys '(?n ?r ?t ?s ?g ?y ?h ?a ?e ?i ?l ?d ?c ?f ?o ?u)
 vundo-glyph-alist vundo-unicode-symbols
 magit-log-margin '(t "%Y-%m-%d %H:%M" magit-log-margin-width t 18)
 magit-diff-refine-hunk 'all
 rainbow-x-colors nil
 dired-subtree-use-backgrounds nil
 org-superstar-leading-bullet ""
 org-superstar-headline-bullets-list '("◉" "○" "◎")
 treesit-auto-install t
 corfu-popupinfo-max-width 500
 corfu-popupinfo-max-height 500
 corfu-popupinfo-delay nil)

(setq-default
 tab-width 4
 indent-tabs-mode nil
 case-fold-search t)

(setq
 compile-command ""
 history-length 1000000
 completion-ignore-case t
 completion-category-overrides '((file (styles . (partial-completion))))
 read-buffer-completion-ignore-case t
 read-file-name-completion-ignore-case t
 electric-pair-inhibit-predicate (lambda (c) (or (char-equal c ?\') (char-equal c ?\")))
 icon-title-format frame-title-format
 display-line-numbers-type 'relative
 column-number-mode t
 visible-bell nil
 ring-bell-function 'ignore
 tab-bar-show nil
 tab-bar-new-button-show nil
 tab-bar-close-button-show nil
 use-short-answers t
 scroll-error-top-bottom t
 enable-recursive-minibuffers t
 revert-without-query '(".*")
 auto-revert-remote-files nil
 auto-revert-verbose nil
 vc-handled-backends nil
 auto-revert-check-vc-info nil
 window-min-width 1
 window-min-height 1
 split-height-threshold nil
 split-width-threshold 220
 lazy-count-prefix-format "(%s/%s) "
 lazy-count-suffix-format nil
 register-preview-delay 0.0
 register-preview-function #'consult-register-format
 inhibit-startup-screen t
 initial-scratch-message nil)

;;; Load file
(load-file (locate-user-emacs-file "kind-icon-mapping.el"))

;;; Modes
(global-display-line-numbers-mode 1)
(global-hl-line-mode 1)
(global-font-lock-mode 1)
(global-treesit-auto-mode 1)
(global-eldoc-mode 1)
(global-corfu-mode 1)
(global-whitespace-mode 1)
(meow-global-mode 1)
(diredfl-global-mode 1)
(yas-global-mode 1)

(global-visual-line-mode 0)
(global-auto-revert-mode 0)

(electric-indent-mode 1)
(file-name-shadow-mode 1)
(minibuffer-depth-indicate-mode 1)
(delete-selection-mode 1)
(vertico-mode 1)
(vertico-multiform-mode 1)
(marginalia-mode 1)
(persp-mode 1)
(savehist-mode 1)
(recentf-mode 1)
(winner-mode 1)
(corfu-history-mode 1)
(corfu-echo-mode 1)
(corfu-popupinfo-mode 1)

(electric-pair-mode 0)
(which-key-mode 0)
(tab-bar-mode 0)
(menu-bar-mode 0)
(tool-bar-mode 0)
(blink-cursor-mode 0)
(desktop-save-mode 0)
(scroll-bar-mode 0)

;;; Pkgs
;; Vertico: fix vertico-group-title face bening ignored
(defun vertico--format-group-title (title cand)
  "Format group TITLE given the current CAND."
  ;; Copy candidate highlighting if title is a prefix of the candidate.
  (when (string-prefix-p title cand)
    (setq cand (propertize cand 'face 'vertico-group-title)) ; added this from 000a415630c4be0fb6be5c5a8fc31b6caaa7a76e
    (setq title (substring cand 0 (length title)))
    (vertico--remove-face 0 (length title) 'completions-first-difference title))
  (setq title (substring title))
  (add-face-text-property 0 (length title) 'vertico-group-title t title)
  (format (concat vertico-group-format "\n") title))

;; Cape: remove Dabbrev annotation string
(setq cape--dabbrev-properties
  (list :annotation-function (lambda (_) "")
        :company-kind (lambda (_) 'text)
        :exclusive 'no
        :category 'cape-dabbrev))

;;; Functions
(defun my--rename-buffer-to-star (mode str)
  (when (derived-mode-p mode)
    (let ((current-name (buffer-name)))
      (unless (string-prefix-p "*" current-name)
        (rename-buffer (concat "*" str current-name) t)))))

(defun my--rename-dired-buffer ()
  (let* ((git-root (locate-dominating-file default-directory ".git"))
         (repo-name (and git-root (file-name-nondirectory (directory-file-name git-root))))
         (relative-dir (if git-root
                           (file-relative-name default-directory git-root)
                         default-directory))
         (final-name (cond
                      ((not git-root) (abbreviate-file-name relative-dir))
                      ((string= relative-dir "./") (format "%s" repo-name))
                      (t (format "%s/%s" repo-name relative-dir)))))
    (rename-buffer final-name t)))

(defun my--rename-magit-buffer ()
  (when (string-match "^magit\\(.*\\): \\(.*\\)" (buffer-name))
    (let ((new-name (concat "*m" (match-string 1 (buffer-name)) ": " (match-string 2 (buffer-name)))))
      (rename-buffer new-name))))

(defun my--rename-embark-buffer ()
  (when (string-match "\\*Embark Export: .* - \\(.*\\)\\*" (buffer-name))
    (let ((search-input (match-string 1 (buffer-name))))
      (rename-buffer (format "*e: %s: %s"
                             (replace-regexp-in-string "-mode$" "" (symbol-name major-mode))
                             search-input) t))))

(defun my--isearch-case-insensitive-advice (orig-fun forward string &rest args)
  (let ((modified-string string))
    (when (and (eq vr/engine 'python)
               case-fold-search
               (not (string-match-p "^\\(\\?i\\)" modified-string)))
      (setq modified-string (concat "(?im)" modified-string)))
    (apply orig-fun forward modified-string args)))

(defun my--isearch-with-region (forward)
  (if (use-region-p)
      (let ((search-string (buffer-substring-no-properties (region-beginning) (region-end))))
        (deactivate-mark)
        (isearch-mode forward)
        (isearch-yank-string search-string))
    (if forward
        (isearch-forward)
      (isearch-backward))))

(defun my--add-to-zoxide-find-file-advice (orig-fun &rest args)
  (when-let* ((filename (car args))
              (directory (file-name-directory (expand-file-name filename))))
    (zoxide-add directory))
  (apply orig-fun args))

(defun my--make-dir-find-file-advice (filename &optional wildcards)
  (unless (file-exists-p filename)
    (let ((dir (file-name-directory filename)))
      (unless (file-exists-p dir)
        (make-directory dir t)))))

(defun my--consult-fd-with-region (&optional i)
  (if (use-region-p)
      (consult-fd i (buffer-substring-no-properties (region-beginning) (region-end)))
    (consult-fd i)))

(defun my--consult-ripgrep-with-region (&optional i)
  (if (use-region-p)
      (consult-ripgrep i (buffer-substring-no-properties (region-beginning) (region-end)))
    (consult-ripgrep i)))

(defun my--consult-line-with-region ()
  (let ((consult-preview-key 'any))
    (if (use-region-p)
        (let ((input (buffer-substring-no-properties (region-beginning) (region-end))))
          (deactivate-mark)
          (consult-line input))
      (consult-line))))

(defun my--move-lines (n)
  (let* (text-start
         text-end
         (region-start (point))
         (region-end region-start)
         swap-point-mark
         delete-latest-newline)
    (when (region-active-p)
      (if (> (point) (mark))
          (setq region-start (mark))
        (exchange-point-and-mark)
        (setq swap-point-mark t
              region-end (point))))
    (end-of-line)
    (if (< (point) (point-max))
        (forward-char 1)
      (setq delete-latest-newline t)
      (insert-char ?\n))
    (setq text-end (point)
          region-end (- region-end text-end))
    (goto-char region-start)
    (beginning-of-line)
    (setq text-start (point)
          region-start (- region-start text-end))
    (let ((text (delete-and-extract-region text-start text-end)))
      (forward-line n)
      (when (not (= (current-column) 0))
        (insert-char ?\n)
        (setq delete-latest-newline t))
      (insert text))
    (forward-char region-end)
    (when delete-latest-newline
      (save-excursion
        (goto-char (point-max))
        (delete-char -1)))
    (when (region-active-p)
      (setq deactivate-mark nil)
      (set-mark (+ (point) (- region-start region-end)))
      (if swap-point-mark
          (exchange-point-and-mark)))))

(defun my--half-window-height ()
  (max 1 (/ (window-body-height) 2)))

(defun my--eglot-ensure-if-supported ()
  (condition-case nil
      (when (and (derived-mode-p 'prog-mode)
                 (eglot--guess-contact))
        (eglot-ensure))
    (error nil)))

(defun my--remove-meow-from-modeline ()
  (dolist (mode '(meow-normal-mode
                  meow-insert-mode
                  meow-motion-mode))
    (setq minor-mode-alist (assq-delete-all mode minor-mode-alist))))

(defun my--get-project-dir ()
  (locate-dominating-file default-directory ".git"))

(defun my--tmux-command ()
  (if (eq system-type 'windows-nt)
      "wsl tmux"
    "tmux"))

(defun my--insert-pair-around-region (open close)
  (when (use-region-p)
    (let ((beg (region-beginning))
          (end (region-end)))
      (save-excursion
        (goto-char end)
        (insert close)
        (goto-char beg)
        (insert open)))))

(defun my--eglot-global-disable ()
  (setq eglot-stay-out-of '(flymake))
  (flymake-mode 0)
  (setq my-eglot-format-on-save-enabled nil)
  (remove-hook 'before-save-hook #'my-eglot-format-buffer)
  (my-disable-vc)
  (my-disable-corfu-auto)
  (setq my-eglot-global-enabled nil)
  (eglot-shutdown-all)
  (remove-hook 'prog-mode-hook #'my--eglot-ensure-if-supported)
  (message "Eglot disabled."))

(defun my--eglot-global-enable ()
  (setq my-eglot-global-enabled t)
  (my--eglot-ensure-if-supported)
  (add-hook 'prog-mode-hook #'my--eglot-ensure-if-supported)
  (message "Eglot enabled."))

(defun my--rename-mode (mode new-name)
  (let ((entry (assq mode minor-mode-alist)))
    (when entry
      (setcdr entry (list new-name)))))

(defun my--magit--show-commit-current-file (orig-fun &rest args)
  (if (and (null (nth 2 args))
           (or (bound-and-true-p magit-blame-mode)
               (bound-and-true-p magit-blame-read-only-mode))
           (buffer-file-name))
      (let* ((rel (magit-file-relative-name (buffer-file-name)))
             (rev    (nth 0 args))
             (cmdargs (nth 1 args))
             (module (nth 3 args)))
        (funcall orig-fun rev cmdargs (list rel) module))
    (apply orig-fun args)))

(defun my--objdump-base (cmd)
  (let* ((src (shell-quote-argument buffer-file-name))
         (out (concat (file-name-sans-extension buffer-file-name) ".o"))
         (cmp-cmd (format cmd src (file-name-nondirectory out)))
         (objdump-cmd (format "objdump -d -M intel -S %s" out))
         (buf (get-buffer-create
               (format "*objdump: %s [%s]*"
                       (file-name-nondirectory buffer-file-name)
                       (format-time-string "%Y%m%d-%H%M%S")))))
    (shell-command cmp-cmd)
    (split-window-horizontally)
    (other-window 1)
    (with-current-buffer buf
      (erase-buffer)
      (insert (shell-command-to-string objdump-cmd))
      (asm-mode))
    (switch-to-buffer buf)))

;;; Interactive functions
(defun my-show-buffer-file-encoding ()
  (interactive)
  (message "Buffer encoding: %s" buffer-file-coding-system))

(defun my-consult-fd-directories (&optional arg)
  (interactive)
  (let ((consult-fd-args (concat my--consult-fd-args " -t directory --prune")))
    (consult-fd arg)))

(defun my-consult-mark ()
  (interactive)
  (let ((consult-preview-key 'any))
    (consult-mark)))

(defun my-keyboard-quit-dwim ()
  (interactive)
  (cond
   ((region-active-p)
    (keyboard-quit))
   ((derived-mode-p 'completion-list-mode)
    (delete-completion-window))
   ((> (minibuffer-depth) 0)
    (abort-recursive-edit))
   (t
    (keyboard-quit))))

(defun my-scroll-up-half ()
  (interactive)
  (previous-line (my--half-window-height))
  (recenter))

(defun my-scroll-down-half ()
  (interactive)
  (next-line (my--half-window-height))
  (recenter))

(defun my-move-lines-up (&optional n)
  (interactive "p")
  (my--move-lines (- (or n 1))))

(defun my-move-lines-down (&optional n)
  (interactive "p")
  (my--move-lines (or n 1)))

(defun my-copy-full-path ()
  (interactive)
  (let ((file-path (or (buffer-file-name) default-directory)))
    (kill-new file-path)
    (when (called-interactively-p 'interactive)
      (message "Copied '%s'" file-path))
    file-path))

(defun my-copy-path ()
  (interactive)
  (let ((dir-path (or (and (buffer-file-name)
                           (file-name-directory (buffer-file-name)))
                      default-directory)))
    (kill-new (directory-file-name dir-path))
    (message "Copied '%s'" dir-path)))

(defun my-copy-file-name ()
  (interactive)
  (if-let ((file-name (buffer-file-name)))
      (progn
        (kill-new (file-name-nondirectory file-name))
        (message "Copied '%s'" (file-name-nondirectory file-name)))
    (let ((name (buffer-name)))
      (kill-new name)
      (message "Copied buffer name '%s'" name))))

(defun my-ido-select-window ()
  (interactive)
  (let* ((all-wins (cdr (window-list)))
         (wins (seq-filter (lambda (w)
                             (not (window-parameter w 'no-other-window)))
                           all-wins))
         (mapping (mapcar
                   (lambda (w) (cons (buffer-name (window-buffer w)) w))
                   wins))
         (names (mapcar 'car mapping)))
    (if (= (length wins) 1)
        (select-window (car wins))
      (if (> (length wins) 1)
          (select-window
           (cdr (assoc
                 (ido-completing-read ido-select-window-prompt names)
                 mapping)))
        (call-interactively 'other-window)))))

(defun my-select-side-window ()
  (interactive)
  (let ((side-windows
         (seq-filter
          (lambda (window)
            (window-parameter window 'window-side))
          (window-list))))
    (when side-windows
      (select-window (car side-windows)))))

(defun my-delete-other-windows ()
  (interactive)
  (let ((buffer-name (buffer-name)))
    (while (window-parameter (selected-window) 'window-side)
      (other-window 1))
    (delete-other-windows)
    (switch-to-buffer buffer-name)))

(defun my-kill-persp-other-buffers ()
  (interactive)
  (dolist (buffer (persp-current-buffers))
    (unless (or (eq buffer (current-buffer))
                (eq buffer (get-buffer (persp-scratch-buffer))))
      (kill-buffer buffer))))

(defun my-kill-region-or-line ()
  (interactive)
  (if (use-region-p)
      (kill-region (region-beginning) (region-end))
    (kill-line)))

(defun my-kill-line-above ()
  (interactive)
  (forward-line -1)
  (kill-whole-line))

(defun my-magit-switch-or-status ()
  (interactive)
  (let ((magit-buffers (magit-mode-get-buffers)))
    (if magit-buffers
        (call-interactively #'magit-switch-to-repository-buffer-other-window)
      (magit-status))))

(defun my-magit-show-commit-original ()
  (interactive)
  (let ((had (advice-member-p #'my--magit--show-commit-current-file
                              'magit-show-commit)))
    (unwind-protect
        (progn
          (when had
            (advice-remove 'magit-show-commit #'my--magit--show-commit-current-file))
          (call-interactively #'magit-show-commit))
      (when had
        (advice-add 'magit-show-commit :around #'my--magit--show-commit-current-file)))))

(defun my-magit-restore-current ()
  (interactive)
  (let ((path (my-copy-full-path)))
    (when (y-or-n-p (format "Restore changes in %s? " path))
      (magit-call-git "restore" path)
      (when (get-file-buffer path)
        (with-current-buffer (get-file-buffer path)
          (revert-buffer :ignore-auto :noconfirm))))))

(defun my-isearch-forward-with-region ()
  (interactive)
  (my--isearch-with-region t))

(defun my-isearch-backward-with-region ()
  (interactive)
  (my--isearch-with-region nil))

(defun my-insert-replace ()
  (interactive)
  (when (use-region-p)
    (kill-region (region-beginning) (region-end)))
  (meow-insert))

(defun my-dired-or-file ()
  (interactive)
  (if (derived-mode-p 'dired-mode)
      (call-interactively 'find-file)
    (dired-jump)))

(defun my-select-inside ()
  (interactive)
  (mark-sexp)
  (forward-char)
  (exchange-point-and-mark)
  (backward-char)
  (exchange-point-and-mark))

(defun my-eglot-format-buffer ()
  (interactive)
  (when (and (eglot-managed-p)
             (eglot--server-capable :documentFormattingProvider))
    (eglot-format-buffer)
    (when (eq system-type 'windows-nt)
      (save-excursion
        (goto-char (point-min))
        (while (search-forward "\r" nil t)
          (replace-match ""))))))

(defun my-project-compile ()
  (interactive)
  (if-let ((proj-dir (my--get-project-dir)))
      (let ((default-directory proj-dir))
        (call-interactively #'compile))
    (call-interactively #'compile)))

(defun my-project-compile-region (start end)
  (interactive "r")
  (if-let ((proj-dir (my--get-project-dir)))
      (let ((default-directory proj-dir))
        (compile (buffer-substring-no-properties start end)))
    (compile (buffer-substring-no-properties start end))))

(defun my-compile-region (start end)
  (interactive "r")
  (let ((command (buffer-substring-no-properties start end)))
    (compile command)))

(defun my-project-async-shell-command ()
  (interactive)
  (if-let ((proj-dir (my--get-project-dir)))
      (let ((default-directory proj-dir))
        (call-interactively #'async-shell-command))
    (call-interactively #'async-shell-command)))

(defun my-sort-u ()
  (interactive)
  (let ((beg (if (region-active-p)
                 (region-beginning)
               (point-min)))
        (end (if (region-active-p)
                 (region-end)
               (point-max))))
    (sort-lines nil beg end)
    (delete-duplicate-lines beg end)))

(defun my-wrap-region-with-pair ()
  (interactive)
  (when (use-region-p)
    (let ((char (read-char "Wrap with: ")))
      (cond
       ((eq char ?\() (my--insert-pair-around-region "(" ")"))
       ((eq char ?\[) (my--insert-pair-around-region "[" "]"))
       ((eq char ?\{) (my--insert-pair-around-region "{" "}"))
       ((eq char ?<) (my--insert-pair-around-region "<" ">"))
       (t (let ((char-str (char-to-string char)))
            (my--insert-pair-around-region char-str char-str)))))))

(defun my-tmux-to-emacs-buffer ()
  (interactive)
  (let ((content (shell-command-to-string (format "%s capture-pane -p" (my--tmux-command)))))
    (with-current-buffer (get-buffer-create "*tmux*")
      (erase-buffer)
      (insert content))
    (switch-to-buffer "*tmux*")))

(defun my-tmux-to-emacs-buffer-all ()
  (interactive)
  (let ((content (shell-command-to-string (format "%s capture-pane -p -S -" (my--tmux-command)))))
    (with-current-buffer (get-buffer-create "*tmux-all*")
      (erase-buffer)
      (insert content))
    (switch-to-buffer "*tmux-all*")))

(defun my-tmux-cd ()
  (interactive)
  (let* ((dir-path (or (and (buffer-file-name)
                            (file-name-directory (buffer-file-name)))
                       default-directory))
         (is-windows (eq system-type 'windows-nt))
         (abs-path (if is-windows
                       dir-path
                     (expand-file-name dir-path)))
         (unix-path (if (and is-windows
                             (string-match "^\\([a-zA-Z]\\):" abs-path))
                        (concat "/" (downcase (match-string 1 abs-path))
                                (substring abs-path 2))
                      abs-path)))
    (shell-command (format "%s send-keys 'cd %s' C-m"
                           (my--tmux-command)
                           (shell-quote-argument (directory-file-name unix-path))))
    (message "Changed tmux directory to '%s'" unix-path)))

(defun my-enable-corfu-auto ()
  (interactive)
  (setq corfu-auto t
        corfu-auto-mode-line-string " auto")
  (global-corfu-mode 0)
  (global-corfu-mode 1))

(defun my-disable-corfu-auto ()
  (interactive)
  (setq corfu-auto nil
        corfu-auto-mode-line-string "")
  (setq corfu-auto nil)
  (global-corfu-mode 0)
  (global-corfu-mode 1))

(defun my-corfu-move-to-minibuffer ()
  (interactive)
  (pcase completion-in-region--data
    (`(,beg ,end ,table ,pred ,extras)
     (let ((completion-extra-properties extras)
           completion-cycle-threshold completion-cycling)
       (consult-completion-in-region beg end table pred)))))

(defun my-enable-eglot-format-on-save ()
  (interactive)
  (setq my-eglot-format-on-save-enabled t)
  (add-hook 'before-save-hook #'my-eglot-format-buffer)
  (message "eglot format-on-save enabled"))

(defun my-disable-eglot-format-on-save ()
  (interactive)
  (setq my-eglot-format-on-save-enabled nil)
  (remove-hook 'before-save-hook #'my-eglot-format-buffer)
  (message "eglot format-on-save disabled"))

(defun my-enable-eglot-flymake ()
  (interactive)
  (setq eglot-stay-out-of nil)
  (call-interactively #'eglot-reconnect)
  (flymake-mode 1)
  (message "Eglot flymake enabled"))

(defun my-disable-eglot-flymake ()
  (interactive)
  (setq eglot-stay-out-of '(flymake))
  (call-interactively #'eglot-reconnect)
  (flymake-mode 0)
  (message "Eglot flymake disabled"))

(defun my-enable-vc ()
  (interactive)
  (message "vc enabled")
  (setq my-vc-enabled t)
  (setq vc-handled-backends '(RCS CVS SVN SCCS SRC Bzr Git Hg)))

(defun my-disable-vc ()
  (interactive)
  (message "vc disabled")
  (setq my-vc-enabled nil)
  (setq vc-handled-backends nil))

(defun my-toggle-magit-blame ()
  (interactive)
  (if (bound-and-true-p magit-blame-mode)
      (magit-blame-quit)
    (call-interactively 'magit-blame-addition)))

(defun my-toggle-meow-normal-mode ()
  (interactive)
  (if (meow-motion-mode-p)
      (meow-normal-mode)
    (meow-motion-mode)))

(defun my-toggle-vc-mode ()
  (interactive)
  (if my-vc-enabled
      (my-disable-vc)
    (my-enable-vc)))

(defun my-toggle-corfu-auto ()
  (interactive)
  (if corfu-auto
      (my-disable-corfu-auto)
    (my-enable-corfu-auto)))

(defun my-toggle-eglot-format-on-save ()
  (interactive)
  (if my-eglot-format-on-save-enabled
      (my-disable-eglot-format-on-save)
    (my-enable-eglot-format-on-save)))

(defun my-toggle-eglot-flymake ()
  (interactive)
  (if (member 'flymake eglot-stay-out-of)
      (my-enable-eglot-flymake)
    (my-disable-eglot-flymake)))

(defun my-toggle-eglot-global ()
  (interactive)
  (if my-eglot-global-enabled
      (my--eglot-global-disable)
    (my--eglot-global-enable)))

;;; Hooks
(defmacro add-hooks (hook &rest fns)
  `(progn ,@(mapcar (lambda (fn) `(add-hook ',hook ,fn)) fns)))

(add-hooks text-mode-hook
           #'visual-line-mode
           #'snap-indent-mode)
(add-hooks before-save-hook
           #'delete-trailing-whitespace)
(add-hooks rfn-eshadow-update-overlay-hook
           #'vertico-directory-tidy)
(add-hooks embark-collect-mode-hook
           #'consult-preview-at-point-mode)
(add-hooks embark-after-export-hook
           #'my--rename-embark-buffer)
(add-hooks find-file-hook
           #'zoxide-add)
(add-hooks magit-blame-mode-hook
           #'my-toggle-meow-normal-mode)
(add-hooks magit-mode-hook
           #'my--rename-magit-buffer)
(add-hooks dired-mode-hook
           (lambda () (my--rename-buffer-to-star 'dired-mode "d: "))
           #'my--rename-dired-buffer
           #'zoxide-add)
(add-hooks org-mode-hook
           #'org-indent-mode
           #'org-superstar-mode
           #'toc-org-enable)
(add-hooks prog-mode-hook
           #'snap-indent-mode)
(add-hooks eglot-managed-mode-hook
           (lambda () (eglot-inlay-hints-mode -1)))
(add-hooks ido-setup-hook
           (lambda ()
             (keymap-set ido-completion-map "C-n" #'ido-next-match)
             (keymap-set ido-completion-map "C-p" #'ido-prev-match)))
(add-hooks ediff-startup-hook
           (lambda ()
             (meow-insert-mode)
             (keymap-set ediff-mode-map "," #'ediff-next-difference)
             (keymap-set ediff-mode-map "." #'ediff-previous-difference)))
(add-hooks window-setup-hook
           (lambda () (add-to-list 'default-frame-alist '(undecorated . nil))))
(add-hooks after-init-hook
           #'my--remove-meow-from-modeline)
(add-hooks emacs-startup-hook
           (lambda () (load-theme 'gruber-material-dark :no-confirm))
           (lambda () (unless (member "" compile-history)
                        (add-to-history 'compile-history ""))))

(dolist (hook '(shell-mode-hook
                eshell-mode-hook
                minibuffer-setup-hook
                term-mode-hook
                comint-mode-hook
                compilation-mode-hook))
  (add-hook hook (lambda ()
                   (setq-local corfu-auto nil)
                   (corfu-mode 1))))

;;; Modes
(define-derived-mode slang-ts-mode c++-ts-mode "slang")
(define-derived-mode my-glsl-ts-mode c++-ts-mode "my-glsl")

;;; Add to list
(defmacro add-to-lists (place &rest entries)
  `(progn ,@(mapcar (lambda (e) `(add-to-list ',place ,e)) entries)))

(add-to-lists default-frame-alist
              '(undecorated . t))
(add-to-lists custom-theme-load-path
              (locate-user-emacs-file "themes/gruber-material-dark"))
(add-to-lists consult-buffer-sources
              persp-consult-source)
(add-to-lists major-mode-remap-alist
              '(cmake-ts-mode . cmake-mode))
(add-to-lists auto-mode-alist
              '("CMakeLists\\.txt\\'" . cmake-ts-mode)
              '("\\.cmake\\'"         . cmake-ts-mode)
              '("\\.lua\\'"           . lua-ts-mode)
              '("\\.yml\\'"           . yaml-ts-mode)
              '("\\.slang\\'"         . slang-ts-mode)
              '("\\.glsl\\'"          . my-glsl-ts-mode)
              '("\\.hlsl\\'"          . c++-ts-mode))
(add-to-lists corfu-continue-commands
              #'corfu-move-to-minibuffer)
(add-to-lists corfu-margin-formatters
              #'kind-icon-margin-formatter)
(add-to-lists completion-at-point-functions
              #'cape-history
              #'cape-dabbrev
              #'cape-abbrev
              #'cape-file
              #'cape-keyword
              #'cape-elisp-block)
(add-to-lists eglot-server-programs
              '(my-glsl-ts-mode . ("glsl_analyzer"))
              '(slang-ts-mode . ("~/dev/slang/build/Release/bin/slangd")))
(add-to-lists eglot-ignored-server-capabilities
              :documentOnTypeFormattingProvider)
(add-to-lists minor-mode-alist
              '(global-corfu-mode corfu-auto-mode-line-string))

;;; Advice add
(defmacro add-advices (&rest pairs)
  `(progn ,@(mapcar (lambda (p)
                      `(advice-add ,(nth 0 p) ,(nth 1 p) ,(nth 2 p)))
                    pairs)))
(add-advices
 (#'vr--isearch :around #'my--isearch-case-insensitive-advice)
 (#'find-file :before #'my--make-dir-find-file-advice)
 (#'find-file :around #'my--add-to-zoxide-find-file-advice)
 (#'register-preview :override #'consult-register-window)
 (#'eglot-completion-at-point :around #'cape-wrap-buster)
 (#'auto-revert-mode :override (lambda (&optional _) nil))
 (#'global-auto-revert-mode :override (lambda (&optional _) nil)))

;;; Other
(unless (member "all-the-icons" (font-family-list)) (all-the-icons-install-fonts t))
(fset 'yes-or-no-p 'y-or-n-p)

;;; After load
(with-eval-after-load 'treesit
  (when (>= emacs-major-version 30)
    (advice-add 'treesit-forward-sexp :override #'forward-sexp-default-function)))
(with-eval-after-load 'perspective
  (defun persp-names ()
    (let ((persps (hash-table-values (perspectives-hash))))
      (cond ((eq persp-sort 'created)
             (mapcar 'persp-name
                     (sort persps (lambda (a b)
                                    (time-less-p (persp-created-time a)
                                                 (persp-created-time b))))))))))
(with-eval-after-load 'rust-ts-mode
  (setq rust-ts-mode--font-lock-settings
        (cl-remove-if (lambda (entry)
                        (eq (nth 2 entry) 'error))
                      rust-ts-mode--font-lock-settings)))
(with-eval-after-load 'snap-indent
  (my--rename-mode 'snap-indent-mode " snap"))
(with-eval-after-load 'eldoc
  (my--rename-mode 'eldoc-mode " eldoc"))
(with-eval-after-load 'magit
  (advice-add 'magit-show-commit :around #'my--magit--show-commit-current-file))

;;; Keybindings
(defun add-keymap (map key func desc)
  (keymap-set map key func)
  (which-key-add-keymap-based-replacements map key desc))

(defmacro add-keymaps (keymap &rest bindings)
  `(progn
     ,@(mapcar (lambda (binding)
                 `(progn
                    (keymap-set ,keymap ,(nth 0 binding) ,(nth 1 binding))
                    (which-key-add-keymap-based-replacements ,keymap ,(nth 0 binding) ,(nth 2 binding))))
               bindings)))

(defmacro define-keys (keymap &rest bindings)
  `(progn
     ,@(mapcar
        (lambda (binding)
          `(keymap-set ,keymap ,(nth 0 binding) ,(nth 1 binding)))
        bindings)))

(defmacro => (&rest body)
  `(lambda () (interactive) ,@body))

(defvar-keymap my-normal-map)
(add-keymap global-map "C-x a" my-normal-map "normal map")

(meow-define-keys 'normal (cons "SPC" my-normal-map))
(meow-define-keys 'motion (cons "SPC" my-normal-map))

(meow-normal-define-key
 (cons "<escape>" (=> (ignore) (my-keyboard-quit-dwim)))
 '("7" . mc/unmark-next-like-this)
 '("8" . mc/mark-next-like-this)
 '("9" . mc/mark-previous-like-this)
 '("0" . mc/unmark-previous-like-this)
 '("j" . beginning-of-visual-line)
 '("f" . back-to-indentation)
 '("o" . end-of-visual-line)
 '("u" . clipboard-yank)
 '("U" . consult-yank-pop)
 '("y" . repeat)
 '("h" . backward-char)
 '("a" . next-line)
 '("e" . previous-line)
 '("i" . forward-char)
 '("H" . join-line)
 (cons "A" (=> (meow-open-below) (meow-normal-mode)))
 (cons "E" (=> (meow-open-above) (meow-normal-mode)))
 (cons "I" (=> (join-line -1)))
 '("k" . meow-line)
 '("p" . mark-word)
 (cons "." (=> (backward-paragraph) (recenter)))
 (cons "," (=> (forward-paragraph) (recenter)))
 '("/" . mark-paragraph)
 '("2" . mc/skip-to-previous-like-this)
 '("3" . mc/skip-to-next-like-this)
 '("l" . clipboard-kill-ring-save)
 '("d" . backward-word)
 '("c" . forward-word)
 '("b" . undo)
 '("B" . undo-redo)
 '("n" . set-mark-command)
 '("r" . exchange-point-and-mark)
 (cons "t" (=> (let ((inhibit-message t)) (call-interactively #'set-mark-command)) (meow-append)))
 '("s" . my-insert-replace)
 '("g" . avy-goto-line)
 '("G" . consult-goto-line)
 '("z" . kill-word)
 '("x" . kill-whole-line)
 '("X" . my-kill-line-above)
 '("m" . kill-sexp)
 '("M" . kill-rectangle)
 '("w" . my-kill-region-or-line)
 '("v" . rectangle-mark-mode)
 '("V" . string-insert-rectangle)
 '("@" . my-select-inside)
 '("#" . mark-sexp)
 '("$" . jump-to-register)
 '("!" . set-mark-command)
 '("+" . beginning-of-buffer)
 '("-" . end-of-buffer)
 '("?" . meow-change)
 '(";" . mark-sexp)
 '(")" . my-scroll-up-half)
 '("(" . my-scroll-down-half)
 '("{" . pop-to-mark-command)
 '("}" . my-consult-mark)
 '("=" . backward-up-list)
 '(">" . backward-sexp)
 '("<" . forward-sexp)
 '("_" . down-list)
 '(":" . comment-line)
 (cons "[" (=> (end-of-defun) (recenter)))
 (cons "]" (=> (beginning-of-defun) (recenter)))
 '("\\" . mark-defun))

(meow-motion-overwrite-define-key
 (cons "<escape>" (=> (ignore) (my-keyboard-quit-dwim)))
 '("a" . next-line)
 '("e" . previous-line)
 '("(" . my-scroll-down-half)
 '(")" . my-scroll-up-half))

(add-keymaps meow-insert-state-keymap
             ("C-g" #'meow-insert-exit "C-g" "meow-insert-exit"))

(defvar-keymap my-find-keymap)
(add-keymaps my-find-keymap
             ("f" (=> (my--consult-fd-with-region default-directory)) "consult-fd-1")
             ("o" (=> (my-consult-fd-directories default-directory)) "my-consult-fd-directories-1")
             ("h" (=> (my--consult-fd-with-region (my--get-project-dir))) "consult-fd")
             ("a" (=> (my-consult-fd-directories (my--get-project-dir))) "my-consult-fd-directories"))

(defvar-keymap my-search-keymap)
(add-keymaps my-search-keymap
             ("f" (=> (my--consult-ripgrep-with-region default-directory)) "consult-ripgrep-1")
             ("o" #'consult-imenu "consult-imenu")
             ("h" (=> (my--consult-ripgrep-with-region (my--get-project-dir))) "consult-ripgrep")
             ("a" #'my--consult-line-with-region "consult-line"))

(defvar-keymap my-replace-keymap)
(add-keymaps my-replace-keymap
             ("f" #'query-replace "query-replace")
             ("h" #'vr/query-replace "vr/query-replace")
             ("a" #'vr/replace "vr/replace")
             ("e" #'vr/mc-mark "vr/mc-mark"))

(defvar-keymap my-compile-keymap)
(add-keymaps my-compile-keymap
             ("h" #'my-project-compile "my-project-compile")
             ("a" #'my-project-async-shell-command "my-project-async-shell-command")
             ("e" #'recompile "recompile")
             ("f" #'compile "compile")
             ("o" #'async-shell-command "async-shell-command")
             ("u" #'my-compile-region "my-compile-region")
             ("." #'my-project-compile-region "my-project-compile-region"))

(defvar-keymap my-magit-keymap)
(add-keymaps my-magit-keymap
             ("y" #'magit-dispatch "magit-dispatch")
             ("h" #'my-magit-switch-or-status "my-magit-switch-or-status")
             ("a" #'magit-log-current "magit-log-current")
             ("e" #'magit-checkout "magit-checkout")
             ("." #'magit-status "magit-status")
             ("," #'magit-git-command-topdir "magit-git-command-topdir")
             ("/" #'my-magit-restore-current "my-magit-restore-current")
             ("j" #'magit-file-dispatch "magit-file-dispatch")
             ("f" #'my-toggle-magit-blame "magit-blame")
             ("o" #'magit-log-buffer-file "magit-log-buffer-file")
             ("u" #'magit-ediff-show-commit "magit-ediff-show-commit"))

(defvar-keymap my-window-keymap)
(add-keymaps my-window-keymap
             ("l" #'kill-buffer-and-window "kill-buffer-and-window")
             ("d" #'my-delete-other-windows "my-delete-other-windows")
             ("c" #'delete-window "delete-window")
             ("C" #'delete-frame "delete-frame")
             ("b" #'delete-other-windows-vertically "delete-side-and-vertical")
             ("n" #'balance-windows "balance-windows")
             ("r" #'windower-toggle-split "windower-toggle-split")
             ("t" #'split-window-vertically "split-window-vertically")
             ("s" #'split-window-horizontally "split-window-horizontally")
             ("w" #'windower-swap "windower-swap")
             ("m" #'window-toggle-side-windows "window-toggle-side-windows"))

(defvar-keymap my-file-keymap)
(add-keymaps my-file-keymap
             ("d" #'rename-file "rename-file")
             ("c" #'write-file "write-file")
             ("s" #'my-copy-full-path "copy full path")
             ("t" #'my-copy-path "copy path")
             ("r" #'my-copy-file-name "copy buffer name")
             ("x" #'ediff-files "ediff-files"))

(defvar-keymap my-toggle-keymap)
(add-keymaps my-toggle-keymap
             ("l" #'my-toggle-vc-mode "my-toggle-vc-mode")
             ("d" #'flymake-show-buffer-diagnostics "flymake-show-buffer-diagnostics")
             ("c" #'my-toggle-corfu-auto "my-toggle-corfu-auto")
             ("r" #'my-toggle-eglot-flymake "my-toggle-eglot-flymake")
             ("t" #'my-toggle-eglot-global "my-toggle-eglot-global")
             ("s" #'my-toggle-eglot-format-on-save "my-toggle-eglot-format-on-save"))

(defvar-keymap my-buffer-keymap)
(add-keymaps my-buffer-keymap
             ("l" #'persp-kill-buffer* "persp-kill-buffer")
             ("d" #'my-kill-persp-other-buffers "my-kill-persp-other-buffers")
             ("c" #'kill-current-buffer "kill-current-buffer")
             ("b" #'kill-matching-buffers-no-ask "kill-matching-buffers-no-ask")
             ("n" #'align-regexp "align-regexp")
             ("r" #'rename-buffer "rename-buffer")
             ("t" #'previous-buffer "prev-buffer")
             ("s" #'next-buffer "next-buffer")
             ("g" #'revert-buffer "revert-buffer")
             ("x" #'ediff-buffers "ediff-buffers")
             ("m" #'eval-buffer "eval-buffer")
             ("w" #'eval-region "eval-region")
             ("h" #'ibuffer "ibuffer")
             ("a" #'persp-ibuffer "persp-ibuffer"))

(defvar-keymap my-persp-keymap)
(add-keymaps my-persp-keymap
             ("l" #'persp-switch-to-scratch-buffer "persp-switch-to-scratch-buffer")
             ("d" #'persp-kill-others "persp-kill-others")
             ("c" #'persp-kill "persp-kill")
             ("r" #'persp-rename "persp-rename")
             ("t" #'persp-prev "persp-prev")
             ("s" #'persp-next "persp-next")
             ("w" #'persp-merge "persp-merge")
             ("x" (=> (persp-forget-buffer (buffer-name)) (delete-window)) "persp-forget-buffer")
             ("m" #'persp-unmerge "persp-unmerge"))

(defvar-keymap my-bookmark-keymap)
(add-keymaps my-bookmark-keymap
             ("c" #'bookmark-delete "bookmark-delete")
             ("r" #'bookmark-rename "bookmark-rename")
             ("t" #'point-to-register "point-to-register")
             ("s" #'bookmark-set "bookmark-set"))

(add-keymaps my-normal-map
             ("n" my-compile-keymap "my-compile-keymap")
             ("r" my-replace-keymap "my-replace-keymap")
             ("t" my-search-keymap "my-search-keymap")
             ("s" my-find-keymap "my-find-keymap")
             ("m" my-magit-keymap "my-magit-keymap")
             ("f" my-file-keymap "my-file-keymap")
             ("u" my-toggle-keymap "my-toggle-keymap")
             ("h" my-window-keymap "my-window-keymap")
             ("a" my-buffer-keymap "my-buffer-keymap")
             ("e" my-persp-keymap "my-persp-keymap")
             ("i" my-bookmark-keymap "my-bookmark-keymap")
             ("l" #'persp-switch "persp-switch")
             ("d" #'my-ido-select-window "my-ido-select-window")
             ("c" #'consult-buffer "consult-buffer")
             ("C" #'switch-to-buffer-other-frame "switch-to-buffer-other-frame")
             ("b" #'consult-bookmark "consult-bookmark")
             ("x" #'my-toggle-meow-normal-mode "toggle-normal-mode")
             ("w" #'my-dired-or-file "my-dired-or-file")
             ("o" #'my-select-side-window "my-select-side-window")
             ("DEL" #'find-file "find-file"))

(define-keys global-map
             ("M-j" #'beginning-of-visual-line)
             ("M-f" #'back-to-indentation)
             ("M-o" #'end-of-visual-line)
             ("M-u" #'upcase-dwim)
             ("M-h" #'backward-char)
             ("M-a" #'my-move-lines-down)
             ("M-e" #'my-move-lines-up)
             ("M-A" #'persp-next)
             ("M-E" #'persp-prev)
             ("M-i" #'forward-char)
             ("M-l" #'clipboard-kill-ring-save)
             ("M-d" #'backward-word)
             ("M-c" #'forward-word)
             ("M-b" #'undo)
             ("M-B" #'undo-redo)
             ("M-n" #'set-mark-command)
             ("M-r" #'exchange-point-and-mark)
             ("M-s" #'kill-word)
             ("M-t" #'backward-kill-word)
             ("M-m" #'capitalize-dwim)
             ("M-w" #'downcase-dwim)
             ("M-," #'xref-go-back)
             ("M-." #'xref-find-definitions)
             ("M-/" #'xref-find-references)
             ("M-<delete>" #'kill-word)

             ("C-f" #'completion-at-point)
             ("C-o" #'zoxide-travel)
             ("C-u" #'clipboard-yank)
             ("C-h" #'mark-word)
             ("C-d" #'other-window)
             ("C-S-d" #'persp-next)
             ("C-s" #'my-isearch-forward-with-region)
             ("C-r" #'my-isearch-backward-with-region)
             ("C-S-s" #'vr/isearch-forward)
             ("C-S-r" #'vr/isearch-backward)
             ("C-z" #'consult-isearch-history)
             ("C-g" #'my-keyboard-quit-dwim)
             ("C-w" #'my-kill-region-or-line)
             ("C-+" #'global-text-scale-adjust)
             ("C-," (=> (duplicate-dwim) (next-line)))
             ("C-." #'embark-act)
             ("C-<tab>" #'tab-to-tab-stop)

             ("C-c f" #'mc/edit-beginnings-of-lines)
             ("C-c o" #'mc/insert-numbers)
             ("C-c u" #'vundo)
             ("C-c h" #'help-command)
             ("C-c a" #'my-tmux-cd)
             ("C-c i" #'indent-region)
             ("C-c w" #'my-wrap-region-with-pair)

             ("C-c C-u" #'universal-argument)

             ("C-x j" #'dired-jump)

             ("C-x RET o" #'my-show-buffer-file-encoding)

             ("C-x C-f" #'find-file-at-point)
             ("C-x C-j" (=> (find-file (my--get-project-dir)))))

(define-keys isearch-mode-map
             ("C-u" #'isearch-yank-x-selection))

(define-keys minibuffer-local-shell-command-map
             ("M-e" #'previous-history-element)
             ("M-a" #'next-history-element))

(define-keys minibuffer-local-map
             ("M-a" #'embark-export)
             ("C-u" #'clipboard-yank)
             ("C-r" #'consult-history)
             ("M-j" #'beginning-of-visual-line)
             ("M-f" #'back-to-indentation)
             ("M-o" #'end-of-visual-line)
             ("M-h" #'backward-char)
             ("M-i" #'forward-char)
             ("M-l" #'clipboard-kill-ring-save)
             ("M-d" #'backward-word)
             ("M-c" #'forward-word)
             ("M-b" #'undo)
             ("M-B" #'undo-redo)
             ("M-n" #'set-mark-command)
             ("M-r" #'exchange-point-and-mark)
             ("M-s" #'kill-word)
             ("M-t" #'backward-kill-word))

(define-keys xref--xref-buffer-mode-map
             ("<backspace>" #'xref-show-location-at-point))

(define-keys compilation-mode-map
             ("." #'previous-error-no-select)
             ("," #'next-error-no-select))

(define-keys compilation-button-map
             ("<backspace>" (=> (compile-goto-error) (select-window (old-selected-window)))))

(define-keys grep-mode-map
             ("M-a" #'wgrep-change-to-wgrep-mode)
             ("." #'previous-error-no-select)
             ("," #'next-error-no-select))

(with-eval-after-load 'wgrep
  (define-keys wgrep-mode-map
               ("M-a" #'wgrep-abort-changes)))

(define-keys occur-edit-mode-map
             ("M-a" #'occur-cease-edit))

(define-keys occur-mode-map
             ("M-a" #'occur-edit-mode)
             ("." #'previous-error-no-select)
             ("," #'next-error-no-select)
             ("<backspace>" (=> (occur-mode-goto-occurrence) (select-window (old-selected-window)))))

(define-keys flymake-diagnostics-buffer-mode-map
             ("<backspace>" (=> (call-interactively #'flymake-goto-diagnostic)
                                (select-window (old-selected-window)))))

(define-keys magit-mode-map
             ("n" (=> (magit-section-forward) (recenter)))
             ("p" (=> (magit-section-backward) (recenter)))
             ("," (=> (magit-section-forward) (recenter)))
             ("." (=> (magit-section-backward) (recenter)))
             ("q" (=> (magit-kill-this-buffer) (delete-window)))
             ("<enter>" #'magit-diff-visit-file-other-window)
             ("<backspace>" (=> (call-interactively #'magit-diff-visit-file-other-window) (select-window (old-selected-window))))
             ("C-<tab>" #'magit-section-cycle-diffs))

(define-keys magit-blame-mode-map
             ("n" (=> (magit-blame-next-chunk) (recenter)))
             ("p" (=> (magit-blame-previous-chunk) (recenter)))
             ("," (=> (magit-blame-next-chunk) (recenter)))
             ("." (=> (magit-blame-previous-chunk) (recenter)))
             ("w" #'magit-blame-copy-hash)
             ("M-<return>" #'my-magit-show-commit-original))

(with-eval-after-load 'git-rebase
  (define-keys git-rebase-mode-map
               ("M-a" #'git-rebase-move-line-down)
               ("M-e" #'git-rebase-move-line-up)))

(define-keys dired-mode-map
             ("M-a" #'dired-toggle-read-only)
             ("h" #'dired-up-directory)
             ("i" #'dired-find-alternate-file)
             ("<backspace>" #'dired-display-file)
             ("<return>" #'dired-find-file-other-window)
             ("C-o" #'zoxide-travel)
             ("$" #'jump-to-register)
             ("l" #'clipboard-kill-ring-save))

(with-eval-after-load 'wdired
  (define-keys wdired-mode-map
               ("M-a" #'wdired-abort-changes)))

(define-keys vertico-multiform-map
             ("C-f" #'vertico-multiform-vertical)
             ("C-S-f" #'vertico-multiform-buffer)
             ("C-S-a" #'vertico-next-group)
             ("C-S-e" #'vertico-previous-group)
             ("<left>" #'backward-char)
             ("<right>" #'forward-char))

(define-keys mc/keymap
             ("<return>" nil))

(define-keys transient-map
             ("<escape>" #'transient-quit-one))

(define-keys org-mode-map
             ("C-," (=> (duplicate-dwim) (next-line))))

(define-keys corfu-map
             ("C-SPC" #'corfu-insert-separator)
             ("C-h" #'corfu-info-documentation)
             ("C-o" #'my-corfu-move-to-minibuffer)
             ("C-SPC" #'corfu-insert-separator))

(keyboard-translate ?\C-a ?\C-n)
(keyboard-translate ?\C-e ?\C-p)
(keyboard-translate ?\C-t ?\C-g)

;;; Server
(server-start)
