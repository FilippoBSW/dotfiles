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

;;; Theme
(load-theme 'gruber-material-dark :no-confirm)

;;; Modeline
(load-file (locate-user-emacs-file "modeline.el"))

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
(setq native-comp-async-report-warnings-errors 'silent)

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
(use-package all-the-icons)
(use-package diredfl)
(use-package org-superstar)
(use-package toc-org)
(use-package treesit-auto)
(use-package clang-format)
(use-package haskell-mode)
(use-package zig-mode)
(use-package cmake-mode)
(use-package glsl-mode)

(defconst my--fd-executable-path  "~/.cargo/bin/fd")
(defconst my--consult-fd-args (concat my--fd-executable-path " --sort-by-depth --full-path --hidden --no-ignore --color=never --exclude .git"))
(consult-customize consult--source-buffer :hidden t :default nil)

(setq isearch-lazy-count t
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
      org-src-fontify-natively t
      org-indent-indentation-per-level 4
      eglot-stay-out-of '(flymake)
      treesit-font-lock-level 4
      c-ts-mode-indent-offset 4
      go-ts-mode-indent-offset 4
      whitespace-line-column 250
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

(setq meow-keypad-describe-keymap-function nil
      meow-expand-hint-remove-delay 0
      vertico-count 15
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
      corfu-cycle t
      corfu-auto nil
      corfu-auto-delay 0.2
      corfu-auto-prefix 2
      corfu-separator ?\s
      corfu-quit-at-boundary nil
      corfu-preview-current t
      corfu-preselect 'prompt
      corfu-quit-no-match t
      corfu-on-exact-match nil
      corfu-scroll-margin 5
      corfu-max-width 100
      corfu-min-width 15
      corfu-count 10
      corfu-popupinfo-max-width 300
      corfu-popupinfo-max-height 300
      corfu-popupinfo-delay 1
      corfu-separator 32
      global-corfu-minibuffer (lambda ()
                                (not (or (bound-and-true-p mct--active)
                                         (bound-and-true-p vertico--input)
                                         (eq (current-local-map) read-passwd-map)))))

(setq-default tab-width 4
              indent-tabs-mode nil
              case-fold-search t)

(setq compile-command ""
      history-length 1000000
      completion-ignore-case t
      completion-category-overrides '((file (styles . (partial-completion))))
      read-buffer-completion-ignore-case t
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
      split-width-threshold 200
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
(global-treesit-auto-mode 1)
(global-eldoc-mode 1)
(diredfl-global-mode 1)
(meow-global-mode 1)
(global-whitespace-mode 1)
(global-corfu-mode 1)
(yas-global-mode 1)

(global-visual-line-mode 0)
(global-auto-revert-mode 0)

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
(corfu-history-mode 1)
(corfu-popupinfo-mode 1)
(corfu-echo-mode 1)

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
  (let ((consult-preview-key 'any))
    (if (use-region-p)
        (let ((input (buffer-substring-no-properties (region-beginning) (region-end))))
          (consult-line input))
      (consult-line))))

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

(defun my--eglot-ensure-if-supported ()
  (condition-case nil
      (when (and (derived-mode-p 'prog-mode)
                 (eglot--guess-contact))
        (eglot-ensure))
    (error nil)))

(defun my--half-window-height ()
  (max 1 (/ (window-body-height) 2)))

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

;;; Interactive functions
(defun my-consult-fd-directories (&optional arg)
  (interactive)
  (let ((consult-fd-args (concat my--consult-fd-args " -t directory --prune")))
    (my--call-with-vertico #'consult-fd arg)))

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

(defun my-kill-all-side-windows ()
  (interactive)
  (let ((windows (window-list)))
    (dolist (window windows)
      (when (window-parameter window 'window-side)
        (delete-window window)))))

(defun my-kill-persp-other-buffers ()
  (interactive)
  (dolist (buffer (persp-current-buffers))
    (unless (or (eq buffer (current-buffer))
                (eq buffer (get-buffer (persp-scratch-buffer))))
      (kill-buffer buffer))))

(defun my-kill-star-buffers ()
  (interactive)
  (dolist (buffer (buffer-list))
    (let ((name (buffer-name buffer)))
      (when (and name
                 (string-match "^\\*" name)
                 (not (eq buffer (current-buffer))))
        (kill-buffer buffer)))))

(defun my-kill-region-or-line ()
  (interactive)
  (if (use-region-p)
      (kill-region (region-beginning) (region-end))
    (kill-line)))

(defun my-kill-line-above ()
  (interactive)
  (forward-line -1)
  (kill-whole-line))

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

(defun my-magit-switch-or-status ()
  (interactive)
  (let ((magit-buffers (magit-mode-get-buffers)))
    (if magit-buffers
        (call-interactively #'magit-switch-to-repository-buffer-other-window)
      (magit-status))))

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

(defun my-eglot-enable-global ()
  (interactive)
  (add-hook 'prog-mode-hook 'my--eglot-ensure-if-supported)
  (my--eglot-ensure-if-supported))

(defun my-eglot-disable-global ()
  (interactive)
  (remove-hook 'prog-mode-hook 'my--eglot-ensure-if-supported)
  (eglot-shutdown-all))

(defun my-project-compile ()
  (interactive)
  (if-let ((proj-dir (my--get-project-dir)))
      (let ((default-directory proj-dir))
        (call-interactively #'compile))
    (call-interactively #'compile)))

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

(defun my-consult-mark ()
  (interactive)
  (let ((consult-preview-key 'any))
    (my--call-with-vertico #'consult-mark)))

(defun my-corfu-move-to-minibuffer ()
  (interactive)
  (pcase completion-in-region--data
    (`(,beg ,end ,table ,pred ,extras)
     (let ((completion-extra-properties extras)
           completion-cycle-threshold completion-cycling)
       (consult-completion-in-region beg end table pred)))))

(defun my-toggle-corfu-auto ()
  (interactive)
  (if corfu-auto
      (progn
        (setq corfu-auto nil)
        (message "Corfu auto-completion disabled"))
    (progn
      (setq corfu-auto t)
      (message "Corfu auto-completion enabled")))
  (global-corfu-mode 0)
  (global-corfu-mode 1))

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
         (unix-path (if (and (eq system-type 'windows-nt)
                             (string-match "^\\([a-zA-Z]\\):" dir-path))
                        (concat "/" (downcase (match-string 1 dir-path))
                                (substring dir-path 2))
                      dir-path))
         (expanded-path (expand-file-name unix-path)))
    (shell-command (format "%s send-keys 'cd %s' C-m"
                           (my--tmux-command)
                           (shell-quote-argument (directory-file-name expanded-path))))
    (message "Changed tmux directory to '%s'" expanded-path)))

;;; Hooks
(add-hook 'text-mode-hook #'visual-line-mode)
(add-hook 'before-save-hook #'delete-trailing-whitespace)
(add-hook 'rfn-eshadow-update-overlay-hook #'vertico-directory-tidy)
(add-hook 'embark-collect-mode-hook #'consult-preview-at-point-mode)
(add-hook 'embark-after-export-hook #'my--rename-embark-buffer)
(add-hook 'find-file-hook #'zoxide-add)
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
(add-hook 'window-setup-hook (lambda() (add-to-list 'default-frame-alist '(undecorated . nil))))
(add-hook 'after-init-hook #'my--remove-meow-from-modeline)
(add-hook 'eglot-managed-mode-hook (lambda () (eglot-inlay-hints-mode -1)))
(add-hook 'ido-setup-hook (lambda ()
                            (keymap-set ido-completion-map "C-n" #'ido-next-match)
                            (keymap-set ido-completion-map "C-p" #'ido-prev-match)))
(add-hook 'ediff-startup-hook (lambda ()
                                (meow-insert-mode)
                                (keymap-set ediff-mode-map "," #'ediff-next-difference)
                                (keymap-set ediff-mode-map "." #'ediff-previous-difference)))

;;; Add to list
(add-to-list 'default-frame-alist '(undecorated . t))
(add-to-list 'consult-buffer-sources persp-consult-source)
(add-to-list 'major-mode-remap-alist '(glsl-ts-mode . glsl-mode))
(add-to-list 'major-mode-remap-alist '(cmake-ts-mode . cmake-mode))
(add-to-list 'auto-mode-alist '("CMakeLists\\.txt\\'" . cmake-ts-mode))
(add-to-list 'auto-mode-alist '("\\.cmake\\'" . cmake-ts-mode))
(add-to-list 'auto-mode-alist '("\\.lua\\'" . lua-ts-mode))
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-ts-mode))
(add-to-list 'corfu-continue-commands #'my-corfu-move-to-minibuffer)
(add-to-list 'completion-at-point-functions #'cape-history)
(add-to-list 'completion-at-point-functions #'cape-dabbrev)
(add-to-list 'completion-at-point-functions #'cape-abbrev)
(add-to-list 'completion-at-point-functions #'cape-file)
(add-to-list 'completion-at-point-functions #'cape-keyword)
(add-to-list 'completion-at-point-functions #'cape-elisp-block)
(add-to-list 'eglot-ignored-server-capabilities :documentOnTypeFormattingProvider)

;;; Advice add
(advice-add 'vr--isearch :around #'my--isearch-case-insensitive-advice)
(advice-add 'find-file :before #'my--make-dir-find-file-advice)
(advice-add 'find-file :around #'my--add-to-zoxide-find-file-advice)
(advice-add #'register-preview :override #'consult-register-window)
(advice-add 'eglot-completion-at-point :around #'cape-wrap-buster)
(advice-add 'auto-revert-mode :override (lambda (&optional _) nil))
(advice-add 'global-auto-revert-mode :override (lambda (&optional _) nil))

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

(with-eval-after-load 'cape
  (setq cape--keyword-properties
        (list :annotation-function (lambda (_) " ")
              :company-kind (lambda (_) 'keyword)
              :exclusive 'no
              :category 'cape-keyword))
  (setq cape--dabbrev-properties
        (list :annotation-function (lambda (_) " ")
              :company-kind (lambda (_) 'text)
              :exclusive 'no
              :category 'cape-dabbrev))
  (setq cape--dict-properties
        (list :annotation-function (lambda (_) "")
              :company-kind (lambda (_) 'text)
              :display-sort-function #'identity
              :cycle-sort-function #'identity
              :exclusive 'no
              :category 'cape-dict)))

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
(add-keymap my-find-keymap (lambda () (interactive) (my--call-with-vertico 'my--consult-fd-with-region default-directory)) "f" "consult-fd-1")
(add-keymap my-find-keymap (lambda () (interactive) (my-consult-fd-directories default-directory)) "o" "my-consult-fd-directories 1")
(add-keymap my-find-keymap (lambda () (interactive) (my--call-with-vertico 'my--consult-fd-with-region (my--get-project-dir))) "h" "consult-fd")
(add-keymap my-find-keymap (lambda () (interactive) (my-consult-fd-directories (my--get-project-dir))) "a" "my-consult-fd-directories")
(add-keymap my-normal-map my-find-keymap "s" "my-find-keymap")

(defvar-keymap my-search-keymap)
(add-keymap my-search-keymap (lambda () (interactive) (my--call-with-vertico 'my--consult-ripgrep-with-region default-directory)) "f" "consult-ripgrep-1")
(add-keymap my-search-keymap (lambda () (interactive) (my--call-with-vertico 'consult-imenu)) "o" "consult-imenu")
(add-keymap my-search-keymap (lambda () (interactive) (my--call-with-vertico 'my--consult-ripgrep-with-region (my--get-project-dir))) "h" "consult-ripgrep")
(add-keymap my-search-keymap (lambda () (interactive) (my--call-with-vertico 'my--consult-line-with-region)) "a" "consult-line")
(add-keymap my-normal-map my-search-keymap "t" "my-search-keymap")

(defvar-keymap my-replace-keymap)
(add-keymap my-replace-keymap #'query-replace "f" "query-replace")
(add-keymap my-replace-keymap #'vr/query-replace "h" "vr/query-replace")
(add-keymap my-replace-keymap #'vr/replace "a" "vr/replace")
(add-keymap my-replace-keymap #'vr/mc-mark "e" "vr/mc-mark")
(add-keymap my-normal-map my-replace-keymap "r" "my-replace-keymap")

(defvar-keymap my-compile-keymap)
(add-keymap my-compile-keymap #'my-project-compile "h" "my-project-compile")
(add-keymap my-compile-keymap #'my-project-async-shell-command "a" "my-project-async-shell-command")
(add-keymap my-compile-keymap #'recompile "e" "recompile")
(add-keymap my-compile-keymap #'compile "f" "compile")
(add-keymap my-compile-keymap #'async-shell-command "o" "async-shell-command")
(add-keymap my-normal-map my-compile-keymap "n" "my-compile-keymap")

(defvar-keymap my-magit-keymap)
(add-keymap my-magit-keymap #'magit-dispatch "y" "magit-dispatch")
(add-keymap my-magit-keymap #'my-magit-switch-or-status "h" "my-magit-switch-or-status")
(add-keymap my-magit-keymap #'magit-log-current "a" "magit-log-current")
(add-keymap my-magit-keymap #'magit-checkout "e" "magit-checkout")
(add-keymap my-magit-keymap #'magit-status "." "magit-status")
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
(add-keymap my-window-keymap #'windower-swap "w" "windower-swap")
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
(add-keymap my-buffer-keymap #'persp-kill-buffer* "l" "persp-kill-buffer")
(add-keymap my-buffer-keymap #'my-kill-persp-other-buffers "d" "my-kill-persp-other-buffers")
(add-keymap my-buffer-keymap #'kill-current-buffer "c" "kill-current-buffer")
(add-keymap my-buffer-keymap #'my-kill-star-buffers "b" "my-kill-star-buffers")
(add-keymap my-buffer-keymap #'align-regexp "n" "align-regexp")
(add-keymap my-buffer-keymap #'rename-buffer "r" "rename-buffer")
(add-keymap my-buffer-keymap #'previous-buffer "t" "prev-buffer")
(add-keymap my-buffer-keymap #'next-buffer "s" "next-buffer")
(add-keymap my-buffer-keymap #'revert-buffer "g" "revert-buffer")
(add-keymap my-buffer-keymap #'ediff-buffers "x" "ediff-buffers")
(add-keymap my-buffer-keymap #'eval-buffer "m" "eval-buffer")
(add-keymap my-buffer-keymap #'eval-region "w" "eval-region")
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
(add-keymap my-eglot-keymap #'my-eglot-enable-global "e" "my-eglot-enable-global")
(add-keymap my-eglot-keymap #'my-eglot-disable-global "d" "my-eglot-disable-global")
(add-keymap my-eglot-keymap #'eglot-format "f" "eglot-format")
(add-keymap my-eglot-keymap #'my-enable-eglot-format-on-save "s" "my-enable-eglot-format-on-save")
(add-keymap my-eglot-keymap #'my-disable-eglot-format-on-save "t" "my-disable-eglot-format-on-save")
(add-keymap global-map my-eglot-keymap "C-c e" "my-eglot-keymap")

(add-keymap my-normal-map #'persp-switch "l" "persp-switch")
(add-keymap my-normal-map #'my-ido-select-window "d" "my-ido-select-window")
(add-keymap my-normal-map #'consult-buffer "c" "consult-buffer")
(add-keymap my-normal-map #'consult-bookmark "b" "consult-bookmark")
(add-keymap my-normal-map #'my-toggle-meow-normal-mode "x" "toggle-normal-mode")
(add-keymap my-normal-map #'my-dired-or-file "w" "my-dired-or-file")
(add-keymap my-normal-map #'my-select-side-window "o" "my-select-side-window")
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

(keymap-set global-map "C-f" #'completion-at-point)
(keymap-set global-map "C-o" (lambda () (interactive) (my--call-with-vertico 'zoxide-travel)))
(keymap-set global-map "C-u" #'clipboard-yank)
(keymap-set global-map "C-h" #'mark-word)
(keymap-set global-map "C-d" #'other-window)
(keymap-set global-map "C-S-d" #'persp-next)
(keymap-set global-map "C-s" #'my-isearch-forward-with-region)
(keymap-set global-map "C-r" #'my-isearch-backward-with-region)
(keymap-set global-map "C-S-s" #'vr/isearch-forward)
(keymap-set global-map "C-S-r" #'vr/isearch-backward)
(keymap-set global-map "C-z" #'(lambda () (interactive) (my--call-with-vertico 'consult-isearch-history)))
(keymap-set global-map "C-g" #'my-keyboard-quit-dwim)
(keymap-set global-map "C-w" #'my-kill-region-or-line)
(keymap-set global-map "C-+" #'global-text-scale-adjust)
(keymap-set global-map "C-," (lambda () (interactive) (duplicate-dwim) (next-line)))
(keymap-set global-map "C-." #'embark-act)

(keymap-set global-map "C-c f" #'mc/edit-beginnings-of-lines)
(keymap-set global-map "C-c o" #'mc/insert-numbers)
(keymap-set global-map "C-c u" #'vundo)
(keymap-set global-map "C-c h" #'help-command)
(keymap-set global-map "C-c a" #'my-tmux-cd)
(keymap-set global-map "C-c i" #'indent-region)
(keymap-set global-map "C-c n" #'my-toggle-meow-normal-mode)
(keymap-set global-map "C-c w" #'my-wrap-region-with-pair)
(keymap-set global-map "C-c v" #'my-toggle-vertico-flat-mode)
(keymap-set global-map "C-c z" #'my-toggle-corfu-auto)
(keymap-set global-map "C-c C-u" #'universal-argument)
(keymap-set global-map "C-c p" #'consult-buffer-other-frame)
(keymap-set global-map "C-c x" #'delete-frame)

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
(keymap-set dired-mode-map "C-o" (lambda () (interactive) (my--call-with-vertico 'zoxide-travel)))
(keymap-set dired-mode-map "$" #'jump-to-register)
(keymap-set dired-mode-map "l" #'clipboard-kill-ring-save)

(keymap-set vertico-flat-map "<left>" #'backward-char)
(keymap-set vertico-flat-map "<right>" #'forward-char)

(with-eval-after-load 'smerge-mode
  (keymap-set smerge-mode-map "<down>" #'smerge-next)
  (keymap-set smerge-mode-map "<up>" #'smerge-prev)
  (keymap-set smerge-mode-map "C-l" #'smerge-keep-lower)
  (keymap-set smerge-mode-map "C-u" #'smerge-keep-upper)
  (keymap-set smerge-mode-map "C-b" #'smerge-keep-base)
  (keymap-set smerge-mode-map "C-s" #'smerge-keep-all)
  (keymap-set smerge-mode-map "C-x" #'smerge-ediff))

(keymap-set mc/keymap "<return>" nil)
(keymap-set transient-map "<escape>" #'transient-quit-one)
(keymap-set org-mode-map "C-," (lambda () (interactive) (duplicate-dwim) (next-line)))

(keymap-set corfu-map "M-a" (lambda () (interactive) (my--call-with-vertico 'my-corfu-move-to-minibuffer)))
(keymap-set corfu-map "SPC"
            (lambda ()
              (interactive)
              (if current-prefix-arg
                  (progn
                    (corfu-quit)
                    (insert " "))
                (if (and (= (char-before) corfu-separator)
                         (or
                          (not (char-after))
                          (= (char-after) ?\s)
                          (= (char-after) ?\n)))
                    (progn
                      (corfu-insert)
                      (insert " "))
                  (corfu-insert-separator)))))

(keyboard-translate ?\C-a ?\C-n)
(keyboard-translate ?\C-e ?\C-p)
(keyboard-translate ?\C-t ?\C-g)

;;; Server
(server-start)
