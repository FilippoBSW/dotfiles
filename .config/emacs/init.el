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
       (font-size "9")
       (font-weight "semibold")
       (font-spec (format "%s-%s:%s" font-name font-size font-weight)))
  (set-frame-font font-spec nil t)
  (add-to-list 'default-frame-alist `(font . ,font-spec)))

;;; Side window
(defconst my--side-window-buffer-names
  '("Help"
    "Messages"
    "Warnings"
    "Embark Export"
    "Embark Collect"
    "Embark Actions"
    "compilation"
    "Flymake"
    "Async Shell Command"
    "Occur"
    "grep"
    "xref"))

(defconst my--side-window-buffer-pattern
  (mapconcat (lambda (name) (concat "*" name)) my--side-window-buffer-names "\\|"))

(setq display-buffer-alist
      `((,my--side-window-buffer-pattern
         (display-buffer-reuse-window
          display-buffer-in-side-window)
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

(use-package ibuffer)
(use-package meow)
(use-package vertico)
(use-package orderless)
(use-package marginalia)
(use-package consult)
(use-package consult-eglot)
(use-package embark)
(use-package embark-consult)
(use-package company)
(use-package multiple-cursors)
(use-package visual-regexp)
(use-package visual-regexp-steroids)
(use-package perspective)
(use-package embrace)
(use-package wgrep)
(use-package avy)
(use-package vundo)
(use-package savehist)
(use-package recentf)
(use-package windower)
(use-package ido)
(use-package ido-select-window)
(use-package zoxide)
(use-package magit)
(use-package magit-delta)
(use-package which-key)
(use-package snap-indent)
(use-package yasnippet)
(use-package yasnippet-snippets)
(use-package ediff)
(use-package sudo-edit)
(use-package rainbow-mode)
(use-package gruvbox-theme)
(use-package all-the-icons)
(use-package diredfl)
(use-package dired-subtree)
(use-package org-superstar)
(use-package toc-org)
(use-package eglot)
(use-package treesit-auto)
(use-package winner)
(use-package clang-format)
(use-package cargo)
(use-package rust-mode)
(use-package zig-mode)
(use-package cargo-mode)
(use-package haskell-mode)
(use-package glsl-mode)
(use-package c-ts-mode)
(use-package go-ts-mode)
(use-package cmake-ts-mode)

(defconst my--consult-fd-args "~/.cargo/bin/fd --sort-by-depth --full-path --hidden --no-ignore --color=never --exclude .git")
(consult-customize consult--source-buffer :hidden t :default nil)

(setq buffer-default-sorting-mode 'filename/process
      isearch-lazy-count t
      search-upper-case t
      isearch-case-fold-search t
      search-whitespace-regexp ".*?"
      meow-keypad-describe-keymap-function nil
      meow-expand-hint-remove-delay 0
      vertico-count 15
      completion-styles '(orderless)
      consult-preview-key "C-o"
      consult-buffer-filter "\\*"
      consult-fd-args (concat my--consult-fd-args " -t file")
      consult-ripgrep-args (concat consult-ripgrep-args " -P --hidden --no-ignore -g !.git -g !TAGS")
      embark-mixed-indicator-delay 1.0
      company-tooltip-maximum-width 10000
      mc/always-run-for-all t
      vr/default-regexp-modifiers '(:I t :M t :S nil)
      persp-sort 'access
      persp-initial-frame-name "dev"
      persp-mode-prefix-key (kbd "C-c M-p")
      persp-state-default-file (locate-user-emacs-file "state.persp")
      persp-modestring-dividers '("(" ")" " ")
      embrace-show-help-p nil
      wgrep-auto-save-buffer t
      avy-background t
      avy-keys '(?n ?r ?t ?s ?g ?y ?h ?a ?e ?i ?l ?d ?c ?f ?o ?u)
      recentf-max-menu-items 50
      recentf-max-saved-items 100
      vundo-glyph-alist vundo-unicode-symbols
      recentf-exclude '("/tmp")
      magit-log-margin '(t "%Y-%m-%d %H:%M" magit-log-margin-width t 18)
      magit-delta-default-dark-theme "gruvbox-dark"
      ediff-split-window-function 'split-window-horizontally
      ediff-window-setup-function 'ediff-setup-windows-plain
      rainbow-x-colors nil
      dired-listing-switches "-alh --group-directories-first --sort=version"
      dired-kill-when-opening-new-dired-buffer t
      dired-dwim-target t
      dired-subtree-use-backgrounds nil
      wdired-create-parent-directories t
      wdired-allow-to-change-permissions t
      org-src-fontify-natively t
      org-indent-indentation-per-level 4
      org-superstar-leading-bullet ""
      org-superstar-headline-bullets-list '("◉" "○" "◎")
      eglot-stay-out-of '(flymake)
      treesit-font-lock-level 4
      treesit-auto-install t
      c-ts-mode-indent-offset 4
      go-ts-mode-indent-offset 4
      whitespace-line-column 150
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
        tab-mark
        missing-newline-at-eof))

;;; Other
(setq-default tab-width 4
              indent-tabs-mode nil
              case-fold-search t)

(setq compile-command ""
      history-length 1000
      electric-pair-inhibit-predicate (lambda (c) (or (char-equal c ?\') (char-equal c ?\")))
      completion-category-overrides '((file (styles . (partial-completion))))
      completion-ignore-case t
      icon-title-format frame-title-format
      display-line-numbers-type 'relative
      tab-bar-show nil
      tab-bar-new-button-show nil
      tab-bar-close-button-show nil
      use-short-answers t
      scroll-error-top-bottom t
      enable-recursive-minibuffers t
      revert-without-query '(".*")
      auto-revert-verbose nil
      auto-revert-check-vc-info t
      window-min-width 1
      window-min-height 1
      split-height-threshold nil
      split-width-threshold 200
      column-number-mode t
      visible-bell nil
      ring-bell-function 'ignore
      read-buffer-completion-ignore-case t
      lazy-count-prefix-format "(%s/%s) "
      lazy-count-suffix-format nil
      register-preview-delay 0.0
      register-preview-function #'consult-register-format
      inhibit-startup-screen t
      initial-scratch-message nil)

;;; Modes
(global-display-line-numbers-mode 1)
(global-hl-line-mode 1)
(global-font-lock-mode 1)
(global-company-mode 1)
(global-treesit-auto-mode 1)
(global-eldoc-mode 1)
(diredfl-global-mode 1)
(meow-global-mode 1)

(global-whitespace-mode 0)
(global-visual-line-mode 0)
(global-auto-revert-mode 0)
(yas-global-mode 0)

(electric-pair-mode 1)
(electric-indent-mode 1)
(file-name-shadow-mode 1)
(minibuffer-depth-indicate-mode 1)
(delete-selection-mode 1)
(vertico-mode 1)
(vertico-flat-mode 1)
(marginalia-mode 1)
(persp-mode 1)
(savehist-mode 1)
(recentf-mode 1)
(winner-mode 1)

(which-key-mode 0)
(tab-bar-mode 0)
(menu-bar-mode 0)
(tool-bar-mode 0)
(blink-cursor-mode 0)
(desktop-save-mode 0)
(scroll-bar-mode 0)

;;; Functions
(defun my--rename-buffer-to-star (mode str)
  (when (derived-mode-p mode)
    (let ((current-name (buffer-name)))
      (unless (string-prefix-p "*" current-name)
        (rename-buffer (concat "*" str current-name) t)))))

(defun my--rename-dired-buffer ()
  (let* ((git-root (vc-root-dir))
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

(defun vr--isearch-case-insensitive-advice (orig-fun forward string &rest args)
  (let ((modified-string string))
    (when (and (eq vr/engine 'python)
               case-fold-search
               (not (string-match-p "^\\(\\?i\\)" modified-string)))
      (setq modified-string (concat "(?im)" modified-string)))
    (apply orig-fun forward modified-string args)))

(defun my--add-to-zoxide-find-file-advice (orig-fun &rest args)
  (when-let* ((filename (car args))
              (directory (file-name-directory (expand-file-name filename))))
    (zoxide-add directory))
  (apply orig-fun args))

(defun my--magit-bury-advice (fn &optional kill-buffer)
  (funcall fn
           (cond ((not kill-buffer)
                  16)
                 ((>= (prefix-numeric-value kill-buffer) 16)
                  nil)
                 (t
                  kill-buffer))))

(defun my--isearch-with-region (forward)
  (if (use-region-p)
      (let ((search-string (buffer-substring-no-properties (region-beginning) (region-end))))
        (deactivate-mark)
        (isearch-mode forward)
        (isearch-yank-string search-string))
    (if forward
        (isearch-forward)
      (isearch-backward))))

(defun my--consult-fd-with-region (&optional i)
  (if (use-region-p)
      (consult-fd i (buffer-substring-no-properties (region-beginning) (region-end)))
    (consult-fd i)))

(defun my--consult-ripgrep-with-region (&optional i)
  (if (use-region-p)
      (consult-ripgrep i (buffer-substring-no-properties (region-beginning) (region-end)))
    (consult-ripgrep i)))

(defun my--consult-line-with-region ()
  (if (use-region-p)
      (let ((input (buffer-substring-no-properties (region-beginning) (region-end))))
        (consult-line input))
    (consult-line)))

(defun my--consult-minibuffer-history ()
  (delete-minibuffer-contents)
  (consult-history))

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

(defun my--call-with-vertico (fn &rest arg)
  (let ((vertico-flat-mode nil))
    (apply fn arg)))

(defun my--eglot-format-on-save ()
  (when (and (eglot-managed-p)
             (eglot--server-capable :documentFormattingProvider))
    (eglot-format-buffer)))

(defun my--half-window-height ()
  (max 1 (/ (window-body-height) 2)))

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

(defun my-copy-full-path ()
  (interactive)
  (let ((file-path (or (buffer-file-name) default-directory)))
    (kill-new file-path)
    (message "Copied '%s'" file-path)))

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
    (message "Buffer is not visiting a file!")))

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

(defun my-kill-all-side-windows ()
  (interactive)
  (let ((windows (window-list)))
    (dolist (window windows)
      (when (window-parameter window 'window-side)
        (delete-window window)))))

(defun my-delete-other-windows ()
  (interactive)
  (let ((buffer-name (buffer-name)))
    (while (window-parameter (selected-window) 'window-side)
      (other-window 1))
    (delete-other-windows)
    (switch-to-buffer buffer-name)))

(defun my-persp-kill-other-buffers ()
  (interactive)
  (cl-loop for buf in (persp-current-buffers)
           unless (or (eq buf (current-buffer))
                      (eq buf (get-buffer (persp-scratch-buffer))))
           do (kill-buffer buf))
  (message nil))

(defun my-kill-region-or-line ()
  (interactive)
  (if (use-region-p)
      (kill-region (region-beginning) (region-end))
    (kill-line)))

(defun my-toggle-meow-normal-mode ()
  (interactive)
  (if (meow-motion-mode-p)
      (meow-normal-mode)
    (meow-motion-mode)))

(defun my-toggle-vertico-flat-mode ()
  (interactive)
  (vertico-flat-mode 'toggle))

(defun my-set-vertico-count-half-screen ()
  (interactive)
  (let* ((frame-height (frame-height))
         (half-height (/ frame-height 2))
         (new-count (- half-height 3)))
    (setq-local vertico-count new-count)))

(defun my-toggle-magit-blame ()
  (interactive)
  (if (bound-and-true-p magit-blame-mode)
      (magit-blame-quit)
    (call-interactively 'magit-blame-addition)))

(defun my-isearch-forward-with-region ()
  (interactive)
  (my--isearch-with-region t))

(defun my-isearch-backward-with-region ()
  (interactive)
  (my--isearch-with-region nil))

(defun my-move-lines-up (&optional n)
  (interactive "p")
  (my--move-lines (- (or n 1))))

(defun my-move-lines-down (&optional n)
  (interactive "p")
  (my--move-lines (or n 1)))

(defun my-insert-replace ()
  (interactive)
  (when (use-region-p)
    (kill-region (region-beginning) (region-end)))
  (meow-insert))

(defun my-tmux-to-emacs-buffer ()
  (interactive)
  (let ((output (shell-command-to-string "tmux capture-pane -pS -1000")))
    (with-current-buffer (get-buffer-create "*ex-tx*")
      (erase-buffer)
      (insert output)
      (meow-motion-mode)
      (meow-normal-mode)
      (goto-char (point-max))
      (skip-chars-backward " \t\n")
      (switch-to-buffer-other-window "*ex-tx*"))))

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

(defun my-enable-eglot-format-on-save ()
  (interactive)
  (add-hook 'before-save-hook #'my--eglot-format-on-save))

(defun my-disable-eglot-format-on-save ()
  (interactive)
  (remove-hook 'before-save-hook #'my--eglot-format-on-save))

(defun my-consult-fd-directories (&optional arg)
  (interactive)
  (let ((consult-fd-args (concat my--consult-fd-args " -t directory --prune")))
    (my--call-with-vertico #'consult-fd arg)))

;;; Hooks
(add-hook 'text-mode-hook #'visual-line-mode)
(add-hook 'before-save-hook #'delete-trailing-whitespace)
(add-hook 'after-change-major-mode-hook (lambda () (when auto-revert-mode (auto-revert-mode 0))))
(add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy)
(add-hook 'embark-collect-mode-hook #'consult-preview-at-point-mode)
(add-hook 'embark-after-export-hook #'my--rename-embark-buffer)
(add-hook 'kill-emacs-hook #'persp-state-save)
(add-hook 'find-file-hook #'zoxide-add)
(add-hook 'magit-mode-hook #'magit-auto-revert-mode)
(add-hook 'magit-blame-mode-hook #'my-toggle-meow-normal-mode)
(add-hook 'magit-mode-hook #'my--rename-magit-buffer)
(add-hook 'dired-mode-hook (lambda () (my--rename-buffer-to-star 'dired-mode "d: ")))
(add-hook 'dired-mode-hook #'my--rename-dired-buffer)
(add-hook 'dired-mode-hook #'zoxide-add)
(add-hook 'org-mode-hook #'org-indent-mode)
(add-hook 'org-mode-hook #'org-superstar-mode)
(add-hook 'org-mode-hook #'toc-org-enable)
(add-hook 'text-mode-hook #'snap-indent-mode)
(add-hook 'prog-mode-hook #'snap-indent-mode)
(add-hook 'eglot-managed-mode-hook (lambda () (eglot-inlay-hints-mode -1)))
(add-hook 'ido-setup-hook (lambda ()
                            (keymap-set ido-completion-map "C-n" #'ido-next-match)
                            (keymap-set ido-completion-map "C-p" #'ido-prev-match)))
(add-hook 'ediff-startup-hook (lambda ()
                                (meow-insert-mode)
                                (keymap-set ediff-mode-map "," #'ediff-next-difference)
                                (keymap-set ediff-mode-map "." #'ediff-previous-difference)))

;;; Other
(unless (member "all-the-icons" (font-family-list)) (all-the-icons-install-fonts t))
(unless (eq system-type 'windows-nt) (add-to-list 'default-frame-alist '(undecorated . t)))
(add-to-list 'consult-buffer-sources persp-consult-source)
(add-to-list 'auto-mode-alist '("CMakeLists\\.txt\\'" . cmake-ts-mode))
(add-to-list 'auto-mode-alist '("\\.cmake\\'" . cmake-ts-mode))
(add-to-list 'auto-mode-alist '("\\.lua\\'" . lua-ts-mode))
(advice-add 'vr--isearch :around #'vr--isearch-case-insensitive-advice)
(advice-add 'find-file :around #'my--add-to-zoxide-find-file-advice)
(advice-add #'register-preview :override #'consult-register-window)
(fset 'yes-or-no-p 'y-or-n-p)

(with-eval-after-load 'treesit
  (when (>= emacs-major-version 30)
    (advice-add 'treesit-forward-sexp :override #'forward-sexp-default-function)))

(with-eval-after-load 'perspective
  (persp-switch "dev")
  (find-file "~/")
  (persp-switch "dev"))

(with-eval-after-load 'magit
  (advice-add 'magit-mode-bury-buffer :around #'my--magit-bury-advice '((name . "magit-mode-bury-buffer--tweak-arg"))))

;;; Keybindings
(defun add-keymap (map func key desc)
  (keymap-set map key func)
  (which-key-add-keymap-based-replacements map key desc))

(defvar-keymap my-normal-map)
(add-keymap global-map my-normal-map "C-x a" "normal map")

(meow-define-keys 'normal (cons "SPC" my-normal-map))
(meow-define-keys 'motion (cons "SPC" my-normal-map))

(meow-normal-define-key
 '("<escape>" . (lambda () (interactive) (ignore) (my-keyboard-quit-dwim)))
 '("7" . mc/unmark-next-like-this)
 '("8" . mc/mark-next-like-this)
 '("9" . mc/mark-previous-like-this)
 '("0" . mc/unmark-previous-like-this)
 '("j" . beginning-of-visual-line)
 '("f" . back-to-indentation)
 '("o" . end-of-visual-line)
 '("u" . clipboard-yank)
 '("U" . (lambda () (interactive) (my--call-with-vertico 'consult-yank-pop)))
 '("y" . repeat)
 '("h" . backward-char)
 '("a" . next-line)
 '("e" . previous-line)
 '("i" . forward-char)
 '("H" . join-line)
 '("A" . (lambda () (interactive) (meow-open-below) (meow-normal-mode)))
 '("E" . (lambda () (interactive) (meow-open-above) (meow-normal-mode)))
 '("I" . (lambda () (interactive) (join-line -1)))
 '("k" . meow-line)
 '("p" . mark-word)
 '("." . (lambda () (interactive) (backward-paragraph) (recenter)))
 '("," . (lambda () (interactive) (forward-paragraph) (recenter)))
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
 '("t" . (lambda () (interactive) (let ((inhibit-message t)) (call-interactively #'set-mark-command)) (meow-append)))
 '("s" . my-insert-replace)
 '("g" . avy-goto-line)
 '("G" . consult-goto-line)
 '("z" . kill-word)
 '("x" . kill-whole-line)
 '("m" . kill-sexp)
 '("w" . my-kill-region-or-line)
 '("v" . rectangle-mark-mode)
 '("@" . my-select-inside)
 '("#" . mark-sexp)
 '("$" . jump-to-register)
 '("!" . set-mark-command)
 '("+" . beginning-of-buffer)
 '("-" . end-of-buffer)
 '("?" . meow-change)
 '("*" . embrace-add)
 '(";" . mark-sexp)
 '(")" . my-scroll-up-half)
 '("(" . my-scroll-down-half)
 '("^" . pop-to-mark-command)
 '("=" . backward-up-list)
 '(">" . backward-sexp)
 '("<" . forward-sexp)
 '("_" . down-list)
 '(":" . comment-line)
 '("[" . (lambda () (interactive) (end-of-defun) (recenter)))
 '("]" . (lambda () (interactive) (beginning-of-defun) (recenter)))
 '("\\" . mark-defun))

(meow-motion-overwrite-define-key
 '("<escape>" . (lambda () (interactive) (ignore) (my-keyboard-quit-dwim)))
 '("a" . next-line)
 '("e" . previous-line)
 '("(" . my-scroll-down-half)
 '(")" . my-scroll-up-half))

(add-keymap meow-insert-state-keymap #'meow-insert-exit "C-g" "meow-insert-exit")

(defvar-keymap my-find-keymap)
(add-keymap my-find-keymap (lambda () (interactive) (my--call-with-vertico 'my--consult-fd-with-region)) "h" "consult-fd")
(add-keymap my-find-keymap (lambda () (interactive) (my--call-with-vertico 'my--consult-fd-with-region 1)) "a" "consult-fd-1")
(add-keymap my-find-keymap #'my-consult-fd-directories "f" "my-consult-fd-directories")
(add-keymap my-find-keymap (lambda () (interactive) (my-consult-fd-directories 1)) "o" "my-consult-fd-directories 1")
(add-keymap my-normal-map my-find-keymap "s" "my-find-keymap")

(defvar-keymap my-search-keymap)
(add-keymap my-search-keymap (lambda () (interactive) (my--call-with-vertico 'my--consult-ripgrep-with-region)) "h" "consult-ripgrep")
(add-keymap my-search-keymap (lambda () (interactive) (my--call-with-vertico 'my--consult-ripgrep-with-region 1)) "a" "consult-ripgrep-1")
(add-keymap my-search-keymap (lambda () (interactive) (my--call-with-vertico 'my--consult-line-with-region)) "f" "consult-line")
(add-keymap my-search-keymap (lambda () (interactive) (my--call-with-vertico 'consult-imenu)) "o" "consult-imenu")
(add-keymap my-normal-map my-search-keymap "t" "my-search-keymap")

(defvar-keymap my-replace-keymap)
(add-keymap my-replace-keymap #'query-replace "f" "query-replace")
(add-keymap my-replace-keymap #'vr/query-replace "h" "vr/query-replace")
(add-keymap my-replace-keymap #'vr/replace "a" "vr/replace")
(add-keymap my-replace-keymap #'vr/mc-mark "e" "vr/mc-mark")
(add-keymap my-normal-map my-replace-keymap "r" "my-replace-keymap")

(defvar-keymap my-compile-keymap)
(add-keymap my-compile-keymap #'project-compile "f" "project-compile")
(add-keymap my-compile-keymap #'project-async-shell-command "o" "project-async-shell-command")
(add-keymap my-compile-keymap #'compile "h" "compile")
(add-keymap my-compile-keymap #'async-shell-command "a" "async-shell-command")
(add-keymap my-compile-keymap #'recompile "e" "recompile")
(add-keymap my-normal-map my-compile-keymap "n" "my-compile-keymap")

(defvar-keymap my-magit-keymap)
(add-keymap my-magit-keymap #'magit-dispatch "y" "magit-dispatch")
(add-keymap my-magit-keymap #'magit-status "h" "magit-status")
(add-keymap my-magit-keymap #'magit-log-current "a" "magit-log-current")
(add-keymap my-magit-keymap #'magit-checkout "e" "magit-checkout")
(add-keymap my-magit-keymap #'magit-file-dispatch "j" "magit-file-dispatch")
(add-keymap my-magit-keymap #'my-toggle-magit-blame "f" "magit-blame")
(add-keymap my-magit-keymap #'magit-log-buffer-file "o" "magit-log-buffer-file")
(add-keymap my-magit-keymap #'magit-ediff-show-commit "u" "magit-ediff-show-commit")
(add-keymap my-normal-map my-magit-keymap "m" "my-magit-keymap")

(defvar-keymap my-window-keymap)
(add-keymap my-window-keymap #'kill-buffer-and-window "l" "kill-buffer-and-window")
(add-keymap my-window-keymap #'my-delete-other-windows "d" "my-delete-other-windows")
(add-keymap my-window-keymap #'delete-window "c" "delete-window")
(add-keymap my-window-keymap (lambda () (interactive) (delete-other-windows-vertically) (my-kill-all-side-windows)) "b" "delete-side-and-vertical")
(add-keymap my-window-keymap #'balance-windows "n" "balance-windows")
(add-keymap my-window-keymap #'windower-toggle-split "r" "windower-toggle-split")
(add-keymap my-window-keymap #'split-window-vertically "t" "split-window-vertically")
(add-keymap my-window-keymap #'split-window-horizontally "s" "split-window-horizontally")
(add-keymap my-window-keymap #'windower-toggle-single "w" "windower-toggle-single")
(add-keymap my-window-keymap (lambda () (interactive) (windower-swap-left) (select-window (old-selected-window))) "h" "windower-swap-left")
(add-keymap my-window-keymap (lambda () (interactive) (windower-swap-below) (select-window (old-selected-window))) "a" "windower-swap-below")
(add-keymap my-window-keymap (lambda () (interactive) (windower-swap-above) (select-window (old-selected-window))) "e" "windower-swap-above")
(add-keymap my-window-keymap (lambda () (interactive) (windower-swap-right) (select-window (old-selected-window))) "i" "windower-swap-right")
(add-keymap my-normal-map my-window-keymap "h" "my-window-keymap")

(defvar-keymap my-file-keymap)
(add-keymap my-file-keymap #'rename-file "d" "rename-file")
(add-keymap my-file-keymap #'write-file "c" "write-file")
(add-keymap my-file-keymap #'my-copy-full-path "s" "copy full path")
(add-keymap my-file-keymap #'my-copy-path "t" "copy path")
(add-keymap my-file-keymap #'my-copy-file-name "r" "copy buffer name")
(add-keymap my-file-keymap #'ediff-files "x" "ediff-files")
(add-keymap my-normal-map my-file-keymap "f" "my-file-keymap")

(defvar-keymap my-buffer-keymap)
(add-keymap my-buffer-keymap #'my-persp-kill-other-buffers "l" "my-persp-kill-other-buffers")
(add-keymap my-buffer-keymap #'persp-kill-buffer* "d" "persp-kill-buffer")
(add-keymap my-buffer-keymap #'kill-current-buffer "c" "kill-current-buffer")
(add-keymap my-buffer-keymap #'align-regexp "n" "align-regexp")
(add-keymap my-buffer-keymap #'rename-buffer "r" "rename-buffer")
(add-keymap my-buffer-keymap #'previous-buffer "t" "prev-buffer")
(add-keymap my-buffer-keymap #'next-buffer "s" "next-buffer")
(add-keymap my-buffer-keymap #'revert-buffer "g" "revert-buffer")
(add-keymap my-buffer-keymap #'ediff-buffers "x" "ediff-buffers")
(add-keymap my-buffer-keymap (lambda () (interactive) (my--call-with-vertico 'consult-mark)) "w" "consult-mark")
(add-keymap my-buffer-keymap (lambda () (interactive) (my--call-with-vertico 'consult-global-mark)) "m" "consult-global-mark")
(add-keymap my-buffer-keymap #'ibuffer "h" "ibuffer")
(add-keymap my-buffer-keymap #'persp-ibuffer "a" "persp-ibuffer")
(add-keymap my-normal-map my-buffer-keymap "a" "my-buffer-keymap")

(defvar-keymap my-persp-keymap)
(add-keymap my-persp-keymap #'persp-switch-to-scratch-buffer "l" "persp-switch-to-scratch-buffer")
(add-keymap my-persp-keymap #'persp-kill-others "d" "persp-kill-others")
(add-keymap my-persp-keymap #'persp-kill "c" "persp-kill")
(add-keymap my-persp-keymap #'persp-rename "r" "persp-rename")
(add-keymap my-persp-keymap #'persp-prev "t" "persp-prev")
(add-keymap my-persp-keymap #'persp-next "s" "persp-next")
(add-keymap my-persp-keymap #'persp-merge "w" "persp-merge")
(add-keymap my-persp-keymap #'persp-unmerge "m" "persp-unmerge")
(add-keymap my-normal-map my-persp-keymap "e" "my-persp-keymap")

(defvar-keymap my-bookmark-keymap)
(add-keymap my-bookmark-keymap #'bookmark-delete "c" "bookmark-delete")
(add-keymap my-bookmark-keymap #'bookmark-rename "r" "bookmark-rename")
(add-keymap my-bookmark-keymap #'point-to-register "t" "point-to-register")
(add-keymap my-bookmark-keymap #'bookmark-set "s" "bookmark-set")
(add-keymap my-normal-map my-bookmark-keymap "i" "my-bookmark-keymap")

(defvar-keymap my-eglot-keymap)
(add-keymap my-eglot-keymap #'eglot "e" "eglot")
(add-keymap my-eglot-keymap #'eglot-shutdown-all "d" "eglot-shutdown-all")
(add-keymap my-eglot-keymap #'eglot-shutdown "c" "eglot-shutdown")
(add-keymap my-eglot-keymap #'eglot-format "f" "eglot-format")
(add-keymap my-eglot-keymap #'my-enable-eglot-format-on-save "s" "my-enable-eglot-format-on-save")
(add-keymap my-eglot-keymap #'my-disable-eglot-format-on-save "t" "my-disable-eglot-format-on-save")
(add-keymap global-map my-eglot-keymap "C-c e" "my-eglot-keymap")

(add-keymap my-normal-map #'persp-switch "l" "persp-switch")
(add-keymap my-normal-map #'my-ido-select-window "d" "my-ido-select-window")
(add-keymap my-normal-map #'my-select-side-window "o" "my-select-side-window")
(add-keymap my-normal-map #'consult-buffer "c" "consult-buffer")
(add-keymap my-normal-map #'consult-bookmark "b" "consult-bookmark")
(add-keymap my-normal-map #'my-toggle-meow-normal-mode "x" "toggle-normal-mode")
(add-keymap my-normal-map #'my-dired-or-file "w" "my-dired-or-file")
(add-keymap my-normal-map #'find-file "DEL" "find-file")

(keymap-set global-map "M-j" #'beginning-of-visual-line)
(keymap-set global-map "M-f" #'back-to-indentation)
(keymap-set global-map "M-o" #'end-of-visual-line)
(keymap-set global-map "M-u" #'upcase-dwim)
(keymap-set global-map "M-h" #'backward-char)
(keymap-set global-map "M-a" #'my-move-lines-down)
(keymap-set global-map "M-e" #'my-move-lines-up)
(keymap-set global-map "M-i" #'forward-char)
(keymap-set global-map "M-l" #'clipboard-kill-ring-save)
(keymap-set global-map "M-d" #'backward-word)
(keymap-set global-map "M-c" #'forward-word)
(keymap-set global-map "M-b" #'undo)
(keymap-set global-map "M-B" #'undo-redo)
(keymap-set global-map "M-n" #'set-mark-command)
(keymap-set global-map "M-r" #'exchange-point-and-mark)
(keymap-set global-map "M-s" #'kill-word)
(keymap-set global-map "M-t" #'backward-kill-word)
(keymap-set global-map "M-m" #'capitalize-dwim)
(keymap-set global-map "M-w" #'downcase-dwim)
(keymap-set global-map "M-," #'xref-go-back)
(keymap-set global-map "M-." #'xref-find-definitions)
(keymap-set global-map "M-/" #'xref-find-references)
(keymap-set global-map "M-<delete>" #'kill-word)

(keymap-set global-map "C-f" #'mark-sexp)
(keymap-set global-map "C-o" (lambda () (interactive) (my--call-with-vertico 'zoxide-find-file)))
(keymap-set global-map "C-u" #'clipboard-yank)
(keymap-set global-map "C-h" #'mark-word)
(keymap-set global-map "C-d" #'other-window)
(keymap-set global-map "C-s" #'my-isearch-forward-with-region)
(keymap-set global-map "C-r" #'my-isearch-backward-with-region)
(keymap-set global-map "C-z" #'(lambda () (interactive) (my--call-with-vertico 'consult-isearch-history)))
(keymap-set global-map "C-g" #'my-keyboard-quit-dwim)
(keymap-set global-map "C-w" #'my-kill-region-or-line)
(keymap-set global-map "C-+" #'global-text-scale-adjust)
(keymap-set global-map "C-," (lambda () (interactive) (duplicate-dwim) (next-line)))
(keymap-set global-map "C-." #'embark-act)

(keymap-set global-map "C-c u" #'vundo)
(keymap-set global-map "C-c h" #'help-command)
(keymap-set global-map "C-c i" #'indent-region)
(keymap-set global-map "C-c n" #'my-toggle-meow-normal-mode)
(keymap-set global-map "C-c v" #'my-toggle-vertico-flat-mode)
(keymap-set global-map "C-c C-u" #'universal-argument)

(keymap-set isearch-mode-map "C-u" #'isearch-yank-x-selection)

(keymap-set minibuffer-local-shell-command-map "M-e" #'previous-history-element)
(keymap-set minibuffer-local-shell-command-map "M-a" #'next-history-element)

(keymap-set minibuffer-local-map "M-a" #'embark-export)
(keymap-set minibuffer-local-map "C-u" #'clipboard-yank)
(keymap-set minibuffer-local-map "C-v" #'my-set-vertico-count-half-screen)
(keymap-set minibuffer-local-map "C-r" (lambda () (interactive) (my--call-with-vertico 'my--consult-minibuffer-history)))
(keymap-set minibuffer-local-map "M-j" #'beginning-of-visual-line)
(keymap-set minibuffer-local-map "M-f" #'back-to-indentation)
(keymap-set minibuffer-local-map "M-o" #'end-of-visual-line)
(keymap-set minibuffer-local-map "M-h" #'backward-char)
(keymap-set minibuffer-local-map "M-i" #'forward-char)
(keymap-set minibuffer-local-map "M-l" #'clipboard-kill-ring-save)
(keymap-set minibuffer-local-map "M-d" #'backward-word)
(keymap-set minibuffer-local-map "M-c" #'forward-word)
(keymap-set minibuffer-local-map "M-b" #'undo)
(keymap-set minibuffer-local-map "M-B" #'undo-redo)
(keymap-set minibuffer-local-map "M-n" #'set-mark-command)
(keymap-set minibuffer-local-map "M-r" #'exchange-point-and-mark)
(keymap-set minibuffer-local-map "M-s" #'kill-word)
(keymap-set minibuffer-local-map "M-t" #'backward-kill-word)

(keymap-set xref--xref-buffer-mode-map "o" #'xref-show-location-at-point)
(keymap-set xref--xref-buffer-mode-map "<backspace>" #'xref-show-location-at-point)

(keymap-set compilation-mode-map "." #'previous-error-no-select)
(keymap-set compilation-mode-map "," #'next-error-no-select)
(keymap-set compilation-button-map "o" (lambda () (interactive) (compile-goto-error) (select-window (old-selected-window))))
(keymap-set compilation-button-map "<backspace>" (lambda () (interactive) (compile-goto-error) (select-window (old-selected-window))))

(with-eval-after-load 'wgrep
  (keymap-set wgrep-mode-map "M-a" #'wgrep-abort-changes))
(keymap-set grep-mode-map "M-a" #'wgrep-change-to-wgrep-mode)
(keymap-set grep-mode-map "." #'previous-error-no-select)
(keymap-set grep-mode-map "," #'next-error-no-select)

(keymap-set occur-edit-mode-map "M-a" #'occur-cease-edit)
(keymap-set occur-mode-map "M-a" #'occur-edit-mode)
(keymap-set occur-mode-map "." #'previous-error-no-select)
(keymap-set occur-mode-map "," #'next-error-no-select)
(keymap-set occur-mode-map "o" (lambda () (interactive) (occur-mode-goto-occurrence) (select-window (old-selected-window))))
(keymap-set occur-mode-map "<backspace>" (lambda () (interactive) (occur-mode-goto-occurrence) (select-window (old-selected-window))))

(keymap-set magit-mode-map "n" (lambda () (interactive) (magit-section-forward) (recenter)))
(keymap-set magit-mode-map "p" (lambda () (interactive) (magit-section-backward) (recenter)))
(keymap-set magit-mode-map "," (lambda () (interactive) (magit-section-forward) (recenter)))
(keymap-set magit-mode-map "." (lambda () (interactive) (magit-section-backward) (recenter)))
(keymap-set magit-mode-map "C-<tab>" #'magit-section-cycle-diffs)

(keymap-set magit-blame-mode-map "n" (lambda () (interactive) (magit-blame-next-chunk) (recenter)))
(keymap-set magit-blame-mode-map "p" (lambda () (interactive) (magit-blame-previous-chunk) (recenter)))
(keymap-set magit-blame-mode-map "," (lambda () (interactive) (magit-blame-next-chunk) (recenter)))
(keymap-set magit-blame-mode-map "." (lambda () (interactive) (magit-blame-previous-chunk) (recenter)))
(keymap-set magit-blame-mode-map "w" 'magit-blame-copy-hash)

(with-eval-after-load 'wdired
  (keymap-set wdired-mode-map "M-a" #'wdired-abort-changes))
(keymap-set dired-mode-map "M-a" #'dired-toggle-read-only)
(keymap-set dired-mode-map "h" #'dired-up-directory)
(keymap-set dired-mode-map "i" #'dired-find-alternate-file)
(keymap-set dired-mode-map "<backspace>" #'dired-display-file)
(keymap-set dired-mode-map "<return>" #'dired-find-file-other-window)
(keymap-set dired-mode-map "<tab>" #'dired-subtree-toggle)
(keymap-set dired-mode-map "C-o" (lambda () (interactive) (my--call-with-vertico 'zoxide-find-file)))
(keymap-set dired-mode-map "$" #'jump-to-register)
(keymap-set dired-mode-map "l" #'clipboard-kill-ring-save)

(keymap-set vertico-flat-map "<left>" #'backward-char)
(keymap-set vertico-flat-map "<right>" #'forward-char)

(keymap-set mc/keymap "<return>" nil)
(keymap-set transient-map "<escape>" #'transient-quit-one)
(keymap-set org-mode-map "C-," (lambda () (interactive) (duplicate-dwim) (next-line)))

(keyboard-translate ?\C-a ?\C-n)
(keyboard-translate ?\C-e ?\C-p)
(keyboard-translate ?\C-t ?\C-g)

;;; Color
(defconst gruvbox-material-colors
  '((bg-dim . "#181818")
    (bg-dim1 . "#1b1b1b")
    (bg-dim2 . "#1d2021")
    (bg0 . "#282828")
    (bg1 . "#32302f")
    (bg2 . "#45403d")
    (bg3 . "#5a524c")
    (bg-diff-green . "#34381b")
    (bg-visual-green . "#3b4439")
    (bg-diff-red . "#402120")
    (bg-visual-red . "#4c3432")
    (bg-diff-blue . "#0e363e")
    (bg-visual-blue . "#374141")
    (bg-visual-yellow . "#4f422e")
    (bg-visual-yellow2 . "#8a734f")
    (bg-current-word . "#3c3836")
    (fg0 . "#d4be98")
    (fg1 . "#ddc7a1")
    (fg2 . "#e6d0aa")
    (red . "#ea6962")
    (orange . "#e78a4e")
    (yellow . "#d8a657")
    (green . "#a9b665")
    (aqua . "#89b482")
    (dark_aqua . "#445450")
    (blue . "#73a499")
    (purple . "#d3869b")
    (grey0 . "#7c6f64")
    (grey1 . "#928374")
    (grey2 . "#a89984")))

(defun my--gmc (color)
  (assoc-default color gruvbox-material-colors))

(defun my--set-faces ()
  (set-cursor-color (my--gmc 'fg0))
  (custom-set-faces
   '(org-document-title ((t (:inherit outline-1 :height 1.1))))
   '(org-level-1 ((t (:inherit outline-1 :height 1.1))))
   '(org-level-2 ((t (:inherit outline-2 :height 1.0))))
   '(org-level-3 ((t (:inherit outline-3 :height 1.0))))
   '(org-level-4 ((t (:inherit outline-4 :height 1.0))))
   '(org-level-5 ((t (:inherit outline-5 :height 1.0)))))
  (let ((faces `((default :background ,(my--gmc 'bg0))
                 (compilation-info :foreground ,(my--gmc 'bg-visual-blue))
                 (avy-background-face :foreground ,(my--gmc 'grey0))
                 (avy-lead-face :background ,(my--gmc 'bg-dim) :foreground ,(my--gmc 'yellow))
                 (avy-lead-face-0 :background ,(my--gmc 'bg-dim) :foreground ,(my--gmc 'green))
                 (avy-lead-face-1 :background ,(my--gmc 'bg-dim) :foreground ,(my--gmc 'orange))
                 (avy-lead-face-2 :background ,(my--gmc 'bg-dim) :foreground ,(my--gmc 'orange))
                 (line-number :background ,(my--gmc 'bg0) :foreground ,(my--gmc 'grey1))
                 (line-number-current-line :background ,(my--gmc 'bg1) :foreground ,(my--gmc 'fg0))
                 (match :background ,(my--gmc 'bg3) :foreground ,(my--gmc 'fg0))
                 (company-preview :background ,(my--gmc 'blue) :foreground ,(my--gmc 'bg0))
                 (company-preview-search :background ,(my--gmc 'blue) :foreground ,(my--gmc 'bg0))
                 (consult-preview-match :background ,(my--gmc 'blue) :foreground ,(my--gmc 'bg0))
                 (completions-highlight :background ,(my--gmc 'bg2))
                 (minibuffer-depth-indicator :background ,(my--gmc 'bg2))
                 (wgrep-file-face :background ,(my--gmc 'bg2))
                 (vertico-current :background ,(my--gmc 'bg2))
                 (isearch :background ,(my--gmc 'blue) :foreground ,(my--gmc 'bg0))
                 (isearch-fail :background ,(my--gmc 'red) :foreground ,(my--gmc 'bg0))
                 (isearch-group-1 :background ,(my--gmc 'blue) :foreground ,(my--gmc 'bg0))
                 (isearch-group-2 :background ,(my--gmc 'green) :foreground ,(my--gmc 'bg0))
                 (lazy-highlight :background ,(my--gmc 'bg3) :foreground ,(my--gmc 'fg0))
                 (vr/group-0 :background ,(my--gmc 'blue) :foreground ,(my--gmc 'bg0))
                 (vr/group-1 :background ,(my--gmc 'green) :foreground ,(my--gmc 'bg0))
                 (vr/group-2 :background ,(my--gmc 'yellow) :foreground ,(my--gmc 'bg0))
                 (vr/match-0 :background ,(my--gmc 'blue) :foreground ,(my--gmc 'bg0))
                 (vr/match-1 :background ,(my--gmc 'blue) :foreground ,(my--gmc 'bg0))
                 (orderless-match-face-0 :foreground ,(my--gmc 'yellow))
                 (orderless-match-face-1 :foreground ,(my--gmc 'yellow))
                 (orderless-match-face-2 :foreground ,(my--gmc 'yellow))
                 (orderless-match-face-3 :foreground ,(my--gmc 'yellow))
                 (diredfl-symlink :foreground ,(my--gmc 'grey2))
                 (diredfl-dir-name :foreground ,(my--gmc 'blue))
                 (diredfl-dir-heading :foreground ,(my--gmc 'blue))
                 (diredfl-deletion :foreground ,(my--gmc 'red))
                 (diredfl-deletion-file-name :foreground ,(my--gmc 'red))
                 (diredfl-number :foreground ,(my--gmc 'yellow))
                 (diredfl-date-time :foreground ,(my--gmc 'aqua))
                 (diredfl-flag-mark :foreground ,(my--gmc 'yellow) :background ,(my--gmc 'bg1))
                 (diredfl-flag-mark-line :foreground ,(my--gmc 'yellow) :background ,(my--gmc 'bg1))
                 (diredfl-dir-priv :foreground ,(my--gmc 'fg0))
                 (diredfl-read-priv :foreground ,(my--gmc 'green))
                 (diredfl-write-priv :foreground ,(my--gmc 'yellow))
                 (diredfl-exec-priv :foreground ,(my--gmc 'red))
                 (persp-selected-face :foreground ,(my--gmc 'green))
                 (magit-header-line :foreground ,(my--gmc 'yellow))
                 (magit-section-heading :foreground ,(my--gmc 'yellow))
                 (magit-branch-remote :foreground ,(my--gmc 'green))
                 (magit-diff-added :foreground ,(my--gmc 'green))
                 (magit-diff-added-highlight :foreground ,(my--gmc 'green))
                 (magit-process-ok :foreground ,(my--gmc 'green))
                 (magit-reflog-cherry-pick :foreground ,(my--gmc 'green))
                 (magit-reflog-commit :foreground ,(my--gmc 'green))
                 (magit-reflog-merge :foreground ,(my--gmc 'green))
                 (magit-sequence-stop :foreground ,(my--gmc 'green))
                 (magit-signature-good :foreground ,(my--gmc 'green))
                 (magit-diff-removed :foreground ,(my--gmc 'red))
                 (magit-diff-removed-highlight :foreground ,(my--gmc 'red))
                 (magit-bisect-bad :foreground ,(my--gmc 'red))
                 (magit-diffstat-removed :foreground ,(my--gmc 'red))
                 (magit-mode-line-process-error :foreground ,(my--gmc 'red))
                 (magit-process-ng :foreground ,(my--gmc 'red))
                 (magit-reflog-reset :foreground ,(my--gmc 'red))
                 (magit-signature-bad :foreground ,(my--gmc 'red))
                 (magit-signature-error :foreground ,(my--gmc 'red))
                 (magit-branch-local :foreground ,(my--gmc 'blue))
                 (error :foreground ,(my--gmc 'red))
                 (font-lock-bracket-face :foreground ,(my--gmc 'grey2))
                 (font-lock-builtin-face :foreground ,(my--gmc 'orange))
                 (font-lock-comment-face :foreground ,(my--gmc 'bg-visual-yellow2))
                 (font-lock-comment-delimiter-face :foreground ,(my--gmc 'bg-visual-yellow2))
                 (font-lock-constant-face :foreground ,(my--gmc 'orange))
                 (font-lock-delimiter-face :foreground ,(my--gmc 'fg1))
                 (font-lock-doc-face :foreground ,(my--gmc 'green))
                 (font-lock-doc-markup-face :foreground ,(my--gmc 'green))
                 (font-lock-escape-face :foreground ,(my--gmc 'red))
                 (font-lock-function-name-face :foreground ,(my--gmc 'orange))
                 (font-lock-function-call-face :foreground ,(my--gmc 'orange))
                 (font-lock-keyword-face :foreground ,(my--gmc 'red))
                 (font-lock-misc-punctuation-face :foreground ,(my--gmc 'fg1))
                 (font-lock-negation-char-face :foreground ,(my--gmc 'red))
                 (font-lock-number-face :foreground ,(my--gmc 'green))
                 (font-lock-operator-face :foreground ,(my--gmc 'fg1))
                 (font-lock-preprocessor-face :foreground ,(my--gmc 'yellow))
                 (font-lock-property-name-face :foreground ,(my--gmc 'fg1))
                 (font-lock-property-use-face :foreground ,(my--gmc 'fg1))
                 (font-lock-punctuation-face :foreground ,(my--gmc 'fg1))
                 (font-lock-regexp-face :foreground ,(my--gmc 'orange))
                 (font-lock-regexp-grouping-backslash :foreground ,(my--gmc 'orange))
                 (font-lock-regexp-grouping-construct :foreground ,(my--gmc 'orange))
                 (font-lock-string-face :foreground ,(my--gmc 'green))
                 (font-lock-type-face :foreground ,(my--gmc 'yellow))
                 (font-lock-variable-name-face :foreground ,(my--gmc 'fg0))
                 (font-lock-variable-use-face :foreground ,(my--gmc 'fg0))
                 (font-lock-warning-face :foreground ,(my--gmc 'red))
                 (vundo-highlight :foreground ,(my--gmc 'green))
                 (vundo-saved :foreground ,(my--gmc 'aqua))
                 (vundo-last-saved :foreground ,(my--gmc 'aqua))
                 (compilation-info :foreground ,(my--gmc 'green))
                 (compilation-mode-line-exit :foreground ,(my--gmc 'green))
                 (compilation-warning :foreground ,(my--gmc 'yellow))
                 (compilation-mode-line-run :foreground ,(my--gmc 'yellow))
                 (compilation-error :foreground ,(my--gmc 'red))
                 (compilation-mode-line-fail :foreground ,(my--gmc 'red))
                 (company-template-field :foreground ,(my--gmc 'bg0) :background ,(my--gmc 'yellow))
                 (eglot-mode-line :foreground ,(my--gmc 'green) :weight medium)
                 (ediff-current-diff-A :foreground ,(my--gmc 'fg2) :background ,(my--gmc 'bg-diff-red))
                 (ediff-current-diff-Ancestor :foreground ,(my--gmc 'fg2) :background ,(my--gmc 'bg-diff-blue))
                 (ediff-current-diff-B :foreground ,(my--gmc 'fg2) :background ,(my--gmc 'bg-diff-green))
                 (ediff-current-diff-C :foreground ,(my--gmc 'fg2)  :background ,(my--gmc 'bg-visual-yellow))
                 (ediff-even-diff-A :foreground ,(my--gmc 'fg2) :background ,(my--gmc 'bg-diff-red))
                 (ediff-even-diff-Ancestor :foreground ,(my--gmc 'fg2) :background ,(my--gmc 'bg-diff-blue))
                 (ediff-even-diff-B :foreground ,(my--gmc 'fg2) :background ,(my--gmc 'bg-diff-green))
                 (ediff-even-diff-C :foreground ,(my--gmc 'fg2)  :background ,(my--gmc 'bg-visual-yellow))
                 (ediff-fine-diff-A :foreground ,(my--gmc 'fg2) :background ,(my--gmc 'bg-diff-red))
                 (ediff-fine-diff-Ancestor :foreground ,(my--gmc 'fg2) :background ,(my--gmc 'bg-diff-blue))
                 (ediff-fine-diff-B :foreground ,(my--gmc 'fg2) :background ,(my--gmc 'bg-diff-green))
                 (ediff-fine-diff-C :foreground ,(my--gmc 'fg2)  :background ,(my--gmc 'bg-visual-yellow))
                 (ediff-odd-diff-A :foreground ,(my--gmc 'fg2) :background ,(my--gmc 'bg-diff-red))
                 (ediff-odd-diff-Ancestor :foreground ,(my--gmc 'fg2) :background ,(my--gmc 'bg-diff-blue))
                 (ediff-odd-diff-B :foreground ,(my--gmc 'fg2) :background ,(my--gmc 'bg-diff-green))
                 (ediff-odd-diff-C :foreground ,(my--gmc 'fg2)  :background ,(my--gmc 'bg-visual-yellow))
                 (org-link :foreground ,(my--gmc 'grey2))
                 (org-level-1 :foreground ,(my--gmc 'orange))
                 (org-level-2 :foreground ,(my--gmc 'yellow))
                 (org-level-3 :foreground ,(my--gmc 'blue))
                 (org-level-4 :foreground ,(my--gmc 'green))
                 (org-level-5 :foreground ,(my--gmc 'aqua))
                 (whitespace-hspace :foreground ,(my--gmc 'bg2))
                 (whitespace-indentation :foreground ,(my--gmc 'bg2))
                 (whitespace-newline :foreground ,(my--gmc 'bg2))
                 (whitespace-space :foreground ,(my--gmc 'bg2))
                 (whitespace-space-after-tab :foreground ,(my--gmc 'bg2))
                 (whitespace-space-before-tab :foreground ,(my--gmc 'bg2))
                 (whitespace-missing-newline-at-eof :foreground ,(my--gmc 'bg0) :background ,(my--gmc 'blue))
                 (whitespace-tab :foreground ,(my--gmc 'bg2))
                 (mode-line-active :background ,(my--gmc 'bg1)  :box (:line-width 1 :color ,(my--gmc 'dark_aqua) :style nil))
                 (mode-line-inactive :background ,(my--gmc 'bg0) :box (:line-width 1 :color ,(my--gmc 'bg1) :style nil))
                 (mode-line-buffer-id :foreground ,(my--gmc 'green)))))
    (dolist (face faces)
      (apply #'set-face-attribute (car face) nil (cdr face)))))

(load-theme 'gruvbox-dark-medium :no-confirm)
(my--set-faces)

;;; Modeline
(defvar my--segment-modal-state-alist
  '((normal . ("N" . font-lock-variable-name-face))
    (insert . ("I" . font-lock-string-face))
    (motion . ("M" . diredfl-symlink))))

(dolist (mode '(meow-normal-mode
                meow-insert-mode
                meow-motion-mode))
  (setq minor-mode-alist (assq-delete-all mode minor-mode-alist)))

(defun my--segment-modal-fn ()
  (when (boundp 'meow--current-state)
    (let ((mode-cons (alist-get meow--current-state
                                my--segment-modal-state-alist)))
      (concat (propertize (car mode-cons)
                          'face (cdr mode-cons))))))

(defface mode-line-buffer-id-inactive
  `((t (:inherit mode-line-buffer-id :foreground ,(my--gmc 'grey2))))
  "Face for buffer name in inactive windows.")

(defun my--mode-line-buffer-id ()
  (let ((face (if (mode-line-window-selected-p)
                  'mode-line-buffer-id
                'mode-line-buffer-id-inactive)))
    (propertize "%b"
                'face face
                'mouse-face 'mode-line-highlight
                'help-echo "Buffer name\nmouse-1: Previous buffer\nmouse-3: Next buffer"
                'local-map mode-line-buffer-identification-keymap)))

(setq-default mode-line-position
              '((line-number-mode ("(%l"))
                (column-number-mode (", %c)"))))

(setq-default mode-line-format
              '("%e"
                mode-line-front-space
                (:propertize
                 (""
                  mode-line-mule-info
                  mode-line-client
                  mode-line-modified
                  mode-line-remote)
                 display (min-width (6.0)))
                " "
                (:eval (my--mode-line-buffer-id))
                "  "
                (:eval (when (mode-line-window-selected-p)
                         (list
                          mode-line-position
                          "  "
                          (format "(%s)" (my--segment-modal-fn))
                          " "
                          mode-line-modes
                          (persp-mode-line)
                          (when (eglot-managed-p)
                            (list " (" eglot--mode-line-format ")"))
                          vc-mode
                          )))))

;;; Server
(server-start)
