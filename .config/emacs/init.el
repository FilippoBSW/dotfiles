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
       (font-size 8)
       (font-weight "semibold")
       (font-spec (format "%s-%s:%s" font-name font-size font-weight)))
  (set-frame-font font-spec nil t)
  (add-to-list 'default-frame-alist `(font . ,font-spec)))

;;; Frame
(add-to-list 'default-frame-alist '(undecorated . t))
(setq frame-title-format
      '(:eval (if buffer-file-name
                  (concat (file-name-nondirectory buffer-file-name)
                          (when (buffer-modified-p) "*")
                          " — GNU Emacs")
                (concat "%b — GNU Emacs"))))

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

;;; Side window
(setq display-buffer-alist
      (let ((names '(".*Shell Command.*"
                     ".*compilation.*"
                     ".*tmux.*"
                     "Cargo"
                     "Embark"
                     "Flymake"
                     "Help"
                     "Messages"
                     "Occur"
                     "Org Select"
                     "Warnings"
                     "grep"
                     "m-process:"
                     "xref")))
        `((,(mapconcat (lambda (name) (concat "*" name)) names "\\|")
           (display-buffer-reuse-window
            display-buffer-in-side-window)
           (side . bottom)
           (window-height . 25)
           (window-parameters . ((no-other-window . t)))
           (body-function . select-window)))))

;;; Macros
(add-to-list 'load-path (locate-user-emacs-file "lisp"))
(require 'my-macros)

;; Packages
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(require 'use-package)
(setq use-package-always-ensure t)
(setq native-comp-async-report-warnings-errors 'silent)

(setq use-package-always-demand t)
(use-package! avy
              cape
              consult
              corfu
              embark
              embark-consult
              magit
              marginalia
              meow
              multiple-cursors
              orderless
              perspective
              rainbow-mode
              snap-indent
              sudo-edit
              treesit-auto
              vertico
              visual-regexp
              visual-regexp-steroids
              vundo
              wgrep
              windower
              yasnippet
              yasnippet-snippets
              zoxide)

(setq use-package-always-demand nil)
(use-package! cargo-mode
              clang-format
              cmake-mode
              go-mode
              haskell-mode
              rust-mode
              swift-mode
              zig-mode)

(require! c-ts-mode
          ediff
          eglot
          eldoc
          git-rebase
          go-ts-mode
          ibuffer
          recentf
          rust-ts-mode
          savehist
          treesit
          wdired
          which-key
          winner
          ibuffer)

(require! my-modeline)

(defconst! (my--fd-executable-path  "~/.cargo/bin/fd")
           (my--consult-fd-args (concat my--fd-executable-path " --sort-by-depth --full-path --hidden --no-ignore --color=never --exclude .git"))
           (my--consult-narrow-key "l")
           (my--consult-narrow-delim "%s"))

(defvar! (my--vc-enabled nil)
         (my--eglot-global-enabled nil)
         (my--eglot-format-on-save-enabled nil)
         (my--corfu-auto-mode-line-string " corfu"))

(consult-customize consult--source-buffer :name "λ" :hidden t :narrow ?\l
                   consult--source-recent-file :name "λ" :hidden t :narrow ?\l
                   consult--source-hidden-buffer :name "◆" :hidden t :default nil :narrow ?\s
                   persp-consult-source :name "λ" :narrow nil
                   consult--source-bookmark :hidden t :default nil :narrow nil)

(setq auto-revert-check-vc-info nil
      auto-revert-remote-files nil
      auto-revert-verbose nil
      avy-background t
      avy-keys '(?n ?r ?t ?s ?g ?y ?h ?a ?e ?i ?l ?d ?c ?f ?o ?u)
      c-basic-offset 4
      c-default-style "bsd"
      c-ts-mode-indent-offset 4
      c-ts-mode-indent-style 'bsd
      cape--dabbrev-properties (plist-put cape--dabbrev-properties :annotation-function (lambda (_) ""))
      column-number-mode t
      compile-command ""
      completion-category-overrides '((file (styles . (partial-completion))))
      completion-ignore-case t
      completion-styles '(orderless)
      consult-buffer-filter "\\*"
      consult-fd-args (concat my--consult-fd-args " -t file")
      consult-line-start-from-top t
      consult-narrow-key "C-,"
      consult-preview-key "C-SPC"
      consult-ripgrep-args (concat consult-ripgrep-args " -P --hidden --no-ignore -g !.git -g !TAGS")
      corfu-popupinfo-delay nil
      corfu-popupinfo-max-height 500
      corfu-popupinfo-max-width 500
      dired-dwim-target t
      dired-kill-when-opening-new-dired-buffer t
      dired-listing-switches "-alh --group-directories-first --sort=version"
      display-line-numbers-type 'relative
      ediff-split-window-function #'split-window-horizontally
      ediff-window-setup-function #'ediff-setup-windows-plain
      eglot-stay-out-of '(flymake)
      electric-pair-inhibit-predicate (lambda (c) (or (char-equal c ?\') (char-equal c ?\")))
      embark-mixed-indicator-delay 1.0
      enable-recursive-minibuffers t
      flymake-mode-line-counter-format '("(" flymake-mode-line-error-counter flymake-mode-line-warning-counter flymake-mode-line-note-counter ")")
      flymake-mode-line-format '(" " flymake-mode-line-exception flymake-mode-line-counters)
      go-ts-mode-indent-offset 4
      history-length 1000000
      icon-title-format frame-title-format
      imenu-flatten nil
      imenu-max-item-length 1000
      imenu-max-items 100
      inhibit-startup-screen t
      initial-scratch-message nil 
      isearch-case-fold-search t
      isearch-lazy-count t
      large-file-warning-threshold (* 5 1024 1024)
      lazy-count-prefix-format "(%s/%s) "
      lazy-count-suffix-format nil
      magit-auto-revert-mode nil
      magit-commit-show-diff nil
      magit-diff-refine-hunk 'all
      magit-log-margin '(t "%Y-%m-%d %H:%M" magit-log-margin-width t 18)
      magit-section-initial-visibility-alist '((staged . hide) (unstaged . hide) (untracked . hide) (stashes . hide) (unpushed . hide) (unpulled . hide))
      mc/always-run-for-all t
      meow-expand-hint-remove-delay 0
      meow-keypad-describe-keymap-function nil
      org-indent-indentation-per-level 4
      org-src-fontify-natively t
      org-startup-folded 'fold
      persp-initial-frame-name "dev"
      persp-mode-prefix-key (kbd "C-c M-p")
      persp-modestring-dividers '("(" ")" " ")
      persp-sort 'access
      persp-state-default-file (locate-user-emacs-file "state.persp")
      rainbow-x-colors nil
      read-buffer-completion-ignore-case t
      read-file-name-completion-ignore-case t
      recentf-exclude '("/tmp")
      recentf-max-menu-items 10
      recentf-max-saved-items 1000000
      revert-without-query '(".*")
      ring-bell-function 'ignore
      rust-ts-mode--font-lock-settings (cl-remove-if (lambda (entry) (eq (nth 2 entry) 'error)) rust-ts-mode--font-lock-settings)
      scroll-error-top-bottom t
      search-upper-case t
      search-whitespace-regexp ".*?"
      split-height-threshold nil
      split-width-threshold 220
      tab-bar-close-button-show nil
      tab-bar-new-button-show nil
      tab-bar-show nil
      treesit-auto-install t
      treesit-font-lock-level 4
      use-short-answers t
      vc-handled-backends nil
      vertico-buffer-display-action '(display-buffer-same-window (inhibit-same-window . nil) (body-function . (lambda (win) (delete-other-windows win))))
      vertico-count 15
      vertico-flat-max-lines 3
      vertico-multiform-categories '((t flat))
      vertico-multiform-commands '()
      visible-bell nil
      vr/default-regexp-modifiers '(:I t :M t :S nil)
      vundo-glyph-alist vundo-unicode-symbols
      wdired-allow-to-change-permissions t
      wdired-create-parent-directories t
      wgrep-auto-save-buffer t
      whitespace-line-column 10000
      whitespace-style '(face tabs spaces trailing lines-tail space-before-tab indentation newline empty space-after-tab space-mark tab-mark)
      window-min-height 1
      window-min-width 1)

(setq-default case-fold-search t
              indent-tabs-mode nil
              tab-width 4)

;; Set magit default log args
(put 'magit-log-mode 'magit-log-default-arguments '("-n256"))

;; Add a dispatcher to make `$` patterns ignore Consult’s hidden tofu chars
(with-eval-after-load 'orderless
  (with-eval-after-load 'consult
    (defun my-orderless-dollar-tofu-dispatcher (pattern _index _total)
      (when (and (string-suffix-p "$" pattern)
                 (> (length pattern) 1))
        (let* ((tofu (format "[%c-%c]" consult--tofu-char
                             (+ consult--tofu-char consult--tofu-range -1)))
               (core (substring pattern 0 -1)))
          `(orderless-regexp . ,(concat core tofu "*$")))))
    (add-to-list 'orderless-style-dispatchers #'my-orderless-dollar-tofu-dispatcher)))

;;; Modes
(global-corfu-mode 1)
(global-display-line-numbers-mode 1)
(global-eldoc-mode 1)
(global-font-lock-mode 1)
(global-hl-line-mode 1)
(global-treesit-auto-mode 1)
(global-whitespace-mode 1)
(meow-global-mode 1)
(yas-global-mode 1)

(global-auto-revert-mode 0)
(global-visual-line-mode 0)

(corfu-echo-mode 1)
(corfu-history-mode 1)
(corfu-popupinfo-mode 1)
(delete-selection-mode 1)
(electric-indent-mode 1)
(file-name-shadow-mode 1)
(marginalia-mode 1)
(minibuffer-depth-indicate-mode 1)
(persp-mode 1)
(recentf-mode 1)
(savehist-mode 1)
(vertico-mode 1)
(vertico-multiform-mode 1)
(winner-mode 1)

(blink-cursor-mode 0)
(desktop-save-mode 0)
(electric-pair-mode 0)
(menu-bar-mode 0)
(scroll-bar-mode 0)
(tab-bar-mode 0)
(tool-bar-mode 0)
(which-key-mode 0)

;;; Functions
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

(defun my--rename-buffer-to-star (mode str)
  (when (if (listp mode) (apply #'derived-mode-p mode) (derived-mode-p mode))
    (let ((current-name (buffer-name)))
      (unless (string-prefix-p "*" current-name)
        (rename-buffer (concat "*" str current-name) t)))))

(defun my--rename-dired-buffer ()
  (let* ((git-root (locate-dominating-file default-directory ".git"))
         (repo-name (and git-root (file-name-nondirectory (directory-file-name git-root))))
         (relative-dir (if git-root
                           (directory-file-name (file-relative-name default-directory git-root))
                         (abbreviate-file-name (directory-file-name default-directory))))
         (final-name (cond
                      ((not git-root) relative-dir)
                      ((or (string= relative-dir ".") (string= relative-dir "./")) repo-name)
                      (t (format "%s/%s" repo-name relative-dir)))))
    (rename-buffer final-name t)))

(defun my--rename-magit-buffer ()
  (let ((bn (buffer-name)))
    (when (string-match "^magit\\(.*\\): \\(.*\\)" bn)
      (rename-buffer (format "*m%s: %s" (match-string 1 bn) (match-string 2 bn)) t))))

(defun my--rename-embark-buffer ()
  (let ((bn (buffer-name)))
    (when (string-match "\\*Embark Export: .* - \\(.*\\)\\*" bn)
      (let ((search-input (match-string 1 bn)))
        (rename-buffer (format "*e: %s: %s"
                               (replace-regexp-in-string "-mode$" "" (symbol-name major-mode))
                               search-input) t)))))

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

(defun my--consult-narrow-advice (orig-fun &rest args)
  (prog1 (apply orig-fun args)
    (when consult--narrow-overlay
      (let* ((label (alist-get consult--narrow
                               (plist-get consult--narrow-config :keys)))
             (text  (format my--consult-narrow-delim label))
             (prop  (propertize (concat " " text)
                                'face 'consult-narrow-indicator)))
        (overlay-put consult--narrow-overlay 'before-string prop)))))

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

(defun my--insert-pair-around-region (open close)
  (when (use-region-p)
    (let ((beg (region-beginning))
          (end (region-end)))
      (save-excursion
        (goto-char end)
        (insert close)
        (goto-char beg)
        (insert open)))))

(defun my--eglot-ensure-if-supported ()
  (condition-case nil
      (when (and (derived-mode-p 'prog-mode)
                 (eglot--guess-contact))
        (eglot-ensure))
    (error nil)))

(defun my--eglot-global-disable ()
  (setq eglot-stay-out-of '(flymake))
  (flymake-mode 0)
  (setq my--eglot-format-on-save-enabled nil)
  (remove-hook 'before-save-hook #'my-eglot-format-buffer)
  (my-disable-vc)
  (my-disable-corfu-auto)
  (setq my--eglot-global-enabled nil)
  (eglot-shutdown-all)
  (remove-hook 'prog-mode-hook #'my--eglot-ensure-if-supported)
  (message "Eglot disabled."))

(defun my--eglot-global-enable ()
  (setq my--eglot-global-enabled t)
  (my--eglot-ensure-if-supported)
  (add-hook 'prog-mode-hook #'my--eglot-ensure-if-supported)
  (message "Eglot enabled."))

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

(defun my--rename-mode (pairs)
  (dolist (pair pairs)
    (let ((mode (car pair))
          (name (cadr pair)))
      (when-let ((entry (assq mode minor-mode-alist)))
        (setcdr entry (list name))))))

(defun my--half-window-height ()
  (max 1 (/ (window-body-height) 2)))

(defun my--get-project-dir ()
  (locate-dominating-file default-directory ".git"))

(defun my--tmux-command ()
  (if (eq system-type 'windows-nt)
      "wsl tmux"
    "tmux"))

;;; Interactive functions
(defun my-isearch-forward-with-region ()
  (interactive)
  (my--isearch-with-region t))

(defun my-isearch-backward-with-region ()
  (interactive)
  (my--isearch-with-region nil))

(defun my-consult-fd-directories (&optional arg)
  (interactive)
  (let ((consult-fd-args (concat my--consult-fd-args " -t directory --prune")))
    (consult-fd arg)))

(defun my-consult-global-mark ()
  (interactive)
  (let ((consult-preview-key 'any))
    (consult-global-mark)))

(defun my-consult-line-with-region ()
  (interactive)
  (let ((consult-preview-key 'any))
    (if (use-region-p)
        (let ((input (buffer-substring-no-properties (region-beginning) (region-end))))
          (deactivate-mark)
          (consult-line input))
      (consult-line))))

(defun my-consult-select-window ()
  (interactive)
  (require 'consult)
  (let* ((all-wins (cdr (window-list)))
         (wins (seq-remove (lambda (w)
                             (window-parameter w 'no-other-window))
                           all-wins)))
    (cond
     ((= (length wins) 0)
      (call-interactively #'other-window))
     ((= (length wins) 1)
      (select-window (car wins)))
     (t
      (let* ((cands (mapcar (lambda (w)
                              (cons (buffer-name (window-buffer w)) w))
                            wins))
             (choice (consult--read (mapcar #'car cands)
                                    :prompt "Window: "
                                    :require-match t
                                    :sort nil)))
        (when choice
          (select-window (cdr (assoc choice cands)))))))))

(defun my-consult-narrow-to-space ()
  (interactive)
  (setq unread-command-events
        (append (listify-key-sequence
                 (kbd (concat consult-narrow-key " " my--consult-narrow-key)))
                unread-command-events)))

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

(defun my-mark-line (&optional n)
  (interactive "p")
  (let* ((n (or n 1))
         (steps (max 1 (abs n))))
    (if (not (region-active-p))
        (progn
          (beginning-of-line)
          (set-mark (line-end-position))
          (activate-mark))
      (let* ((p (point))
             (m (mark t))
             (forward (if (> m p) t (if (< m p) nil t)))
             target)
        (save-excursion
          (goto-char m)
          (if forward
              (progn
                (forward-line steps)
                (setq target (line-end-position)))
            (forward-line (- steps))
            (setq target (line-beginning-position))))
        (set-mark target)
        (activate-mark)))))

(defun my-select-inside ()
  (interactive)
  (mark-sexp)
  (forward-char)
  (exchange-point-and-mark)
  (backward-char)
  (exchange-point-and-mark))

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
  (cl-letf (((symbol-function 'y-or-n-p) (lambda (&rest _) t)))
    (persp-kill-other-buffers)))

(defun my-kill-matching-buffers-no-ask-except-current (regexp &optional internal-too)
  (interactive
   (list (read-regexp "Kill buffers matching regexp: ")
         current-prefix-arg))
  (dolist (buf (buffer-list))
    (let ((name (buffer-name buf)))
      (when (and (not (eq buf (current-buffer)))
                 (or internal-too
                     (not (string-prefix-p " " name)))
                 (string-match-p regexp name))
        (kill-buffer buf)))))

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
      (magit-status-quick))))

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
        my--corfu-auto-mode-line-string " corfu-auto")
  (global-corfu-mode 0)
  (global-corfu-mode 1))

(defun my-disable-corfu-auto ()
  (interactive)
  (setq corfu-auto nil
        my--corfu-auto-mode-line-string " corfu")
  (setq corfu-auto nil)
  (global-corfu-mode 0)
  (global-corfu-mode 1))

(defun my-enable-eglot-format-on-save ()
  (interactive)
  (setq my--eglot-format-on-save-enabled t)
  (add-hook 'before-save-hook #'my-eglot-format-buffer)
  (message "eglot format-on-save enabled"))

(defun my-disable-eglot-format-on-save ()
  (interactive)
  (setq my--eglot-format-on-save-enabled nil)
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
  (setq my--vc-enabled t)
  (setq vc-handled-backends '(RCS CVS SVN SCCS SRC Bzr Git Hg)))

(defun my-disable-vc ()
  (interactive)
  (message "vc disabled")
  (setq my--vc-enabled nil)
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
  (if my--vc-enabled
      (my-disable-vc)
    (my-enable-vc)))

(defun my-toggle-corfu-auto ()
  (interactive)
  (if corfu-auto
      (my-disable-corfu-auto)
    (my-enable-corfu-auto)))

(defun my-toggle-eglot-format-on-save ()
  (interactive)
  (if my--eglot-format-on-save-enabled
      (my-disable-eglot-format-on-save)
    (my-enable-eglot-format-on-save)))

(defun my-toggle-eglot-flymake ()
  (interactive)
  (if (member 'flymake eglot-stay-out-of)
      (my-enable-eglot-flymake)
    (my-disable-eglot-flymake)))

(defun my-toggle-eglot-global ()
  (interactive)
  (if my--eglot-global-enabled
      (my--eglot-global-disable)
    (my--eglot-global-enable)))

(defun my-show-buffer-file-encoding ()
  (interactive)
  (message "Buffer encoding: %s" buffer-file-coding-system))

(defun my-minibuffer-next-history-or-clear (n)
  (interactive "p")
  (condition-case nil
      (next-history-element n)
    (error (delete-minibuffer-contents))))

(defun my-corfu-move-to-minibuffer ()
  (interactive)
  (pcase completion-in-region--data
    (`(,beg ,end ,table ,pred ,extras)
     (let ((completion-extra-properties extras)
           completion-cycle-threshold completion-cycling)
       (consult-completion-in-region beg end table pred)))))

(defun my-insert-replace ()
  (interactive)
  (when (use-region-p)
    (kill-region (region-beginning) (region-end)))
  (meow-insert))

(defun my-insert-line-above ()
  (interactive)
  (beginning-of-line)
  (open-line 1)
  (indent-for-tab-command))

(defun my-insert-line-below ()
  (interactive)
  (end-of-line)
  (newline)
  (indent-for-tab-command))

(defun my-join-line-above ()
  (interactive)
  (join-line -1))

(defun my-dired-or-file ()
  (interactive)
  (if (derived-mode-p 'dired-mode)
      (call-interactively 'find-file)
    (dired-jump)))

(defun my-dired-duplicate-file ()
  (interactive)
  (let* ((file (dired-get-file-for-visit))
         (dir  (file-name-directory file))
         (name (file-name-nondirectory file))
         (base (file-name-sans-extension name))
         (ext  (file-name-extension name t))
         new)
    (if (string-match "\\(.*?\\)_copy\\([0-9]*\\)$" base)
        (setq base (match-string 1 base)))
    (setq new (expand-file-name (concat base "_copy" ext) dir))
    (let ((i 1))
      (while (file-exists-p new)
        (setq new (expand-file-name (format "%s_copy%d%s" base i ext) dir))
        (setq i (1+ i))))
    (copy-file file new)
    (dired-add-file new)
    (message "Copied %s -> %s" name (file-name-nondirectory new))))

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

(defun my-backward-delete-char-dwim ()
  (interactive)
  (if (use-region-p)
      (delete-region (region-beginning) (region-end))
    (delete-char -1)))

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

(defun my-down-list (&optional n)
  (interactive "p")
  (let ((count (or n 1)))
    (dotimes (_ count)
      (let (done)
        (while (not done)
          (let ((pt (point)))
            (or (ignore-errors (down-list 1) (setq done t))
                (progn
                  (ignore-errors
                    (backward-up-list 1)
                    (forward-sexp 1)
                    (skip-syntax-forward " >"))
                  (when (= (point) pt) (setq done t))))))))))

;;; Hooks
(add-hook! after-init-hook
           (lambda () (my--rename-mode
                       '((meow-normal-mode "")
                         (meow-insert-mode "")
                         (meow-motion-mode "")
                         (meow-beacon-mode "")
                         (meow-keypad-mode "")
                         (flymake-mode "")
                         (eldoc-mode " eldoc")
                         (snap-indent-mode " snap")))))
(add-hook! text-mode-hook
           #'visual-line-mode
           #'snap-indent-mode)
(add-hook! prog-mode-hook
           #'snap-indent-mode)
(add-hook! before-save-hook
           #'delete-trailing-whitespace)
(add-hook! rfn-eshadow-update-overlay-hook
           #'vertico-directory-tidy)
(add-hook! embark-collect-mode-hook
           #'consult-preview-at-point-mode)
(add-hook! find-file-hook
           #'zoxide-add)
(add-hook! magit-blame-mode-hook
           #'my-toggle-meow-normal-mode)
(add-hook! magit-mode-hook
           #'my--rename-magit-buffer)
(add-hook! embark-after-export-hook
           #'my--rename-embark-buffer)
(add-hook! dired-mode-hook
           (lambda () (my--rename-buffer-to-star '(dired-mode) "d: "))
           #'my--rename-dired-buffer
           #'zoxide-add)
(add-hook! org-mode-hook
           #'org-indent-mode)
(add-hook! eglot-managed-mode-hook
           (lambda () (eglot-inlay-hints-mode -1)))
(add-hook! ediff-startup-hook
           (lambda ()
             (global-whitespace-mode 0)
             (meow-insert-mode)
             (bind! ediff-mode-map
                    ("," #'ediff-next-difference "ediff-next-difference")
                    ("." #'ediff-previous-difference "ediff-previous-difference"))))
(add-hook! ediff-quit-hook
           (lambda () (global-whitespace-mode 1)))

(dolist (hook '(shell-mode-hook
                eshell-mode-hook
                minibuffer-setup-hook
                term-mode-hook
                comint-mode-hook
                compilation-mode-hook))
  (add-hook hook (lambda ()
                   (setq-local corfu-auto nil)
                   (corfu-mode 1))))

;;; Add to list
(add-to-list! major-mode-remap-alist
              '(cmake-ts-mode . cmake-mode))
(add-to-list! consult-buffer-sources
              persp-consult-source)
(add-to-list! corfu-continue-commands
              #'my-corfu-move-to-minibuffer)
(add-to-list! minor-mode-alist
              '(global-corfu-mode my--corfu-auto-mode-line-string))
(add-to-list! completion-at-point-functions
              #'cape-history
              #'cape-dabbrev
              #'cape-abbrev
              #'cape-file
              #'cape-keyword
              #'cape-elisp-block)
(add-to-list! eglot-ignored-server-capabilities
              :documentOnTypeFormattingProvider)

;;; Advice add
(add-advice!
 (#'vr--isearch :around #'my--isearch-case-insensitive-advice)
 (#'find-file :before #'my--make-dir-find-file-advice)
 (#'find-file :around #'my--add-to-zoxide-find-file-advice)
 (#'consult-narrow :around #'my--consult-narrow-advice)
 (#'magit-show-commit :around #'my--magit--show-commit-current-file)
 (#'treesit-forward-sexp :override #'forward-sexp-default-function)
 (#'eglot-completion-at-point :around #'cape-wrap-buster)
 (#'auto-revert-mode :override (lambda (&optional _) nil))
 (#'global-auto-revert-mode :override (lambda (&optional _) nil)))

;;; Keybindings
(bind! global-map
       ("C-x a" my-leader-map "leader-map")
       ("C-x t" meow-normal-state-keymap "normal-map"))

(meow-define-keys 'insert
  '("C-g" . meow-insert-exit))

(meow-define-keys 'normal
 (cons "SPC" my-leader-map)
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
 '("A" . my-insert-line-below)
 '("E" . my-insert-line-above)
 '("I" . my-join-line-above)
 '("k" . my-mark-line)
 '("p" . mark-word)
 '("." . backward-paragraph)
 '("," . forward-paragraph)
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
 '("g" . nil)
 '("g g" . consult-goto-line)
 (cons "g h" (=> (avy-goto-line) (back-to-indentation)))
 '("g a" . avy-goto-char-timer)
 '("g e" . my-consult-global-mark)
 '("z" . kill-word)
 '("x" . kill-whole-line)
 '("X" . my-kill-line-above)
 '("m" . kill-sexp)
 '("M" . kill-rectangle)
 '("w" . my-kill-region-or-line)
 '("v" . rectangle-mark-mode)
 '("V" . string-insert-rectangle)
 '("#" . my-select-inside)
 '("$" . mark-sexp)
 '("!" . set-mark-command)
 '("+" . beginning-of-buffer)
 '("-" . end-of-buffer)
 '("?" . my-insert-replace)
 '(";" . mark-sexp)
 '(")" . my-scroll-up-half)
 '("(" . my-scroll-down-half)
 '("{" . pop-to-mark-command)
 '("=" . backward-up-list)
 '(">" . backward-sexp)
 '("<" . forward-sexp)
 '("_" . my-down-list)
 '(":" . comment-line)
 (cons "[" (=> (end-of-defun) (recenter)))
 (cons "]" (=> (beginning-of-defun) (recenter)))
 '("\\" . mark-defun))

(meow-define-keys 'motion
 (cons "SPC" my-leader-map)
 (cons "<escape>" (=> (ignore) (my-keyboard-quit-dwim)))
 '("a" . next-line)
 '("e" . previous-line)
 '("(" . my-scroll-down-half)
 '(")" . my-scroll-up-half))

(bind! my-find-keymap
       ("f" (=> (my--consult-fd-with-region default-directory)) "consult-fd-1")
       ("o" (=> (my-consult-fd-directories default-directory)) "my-consult-fd-directories-1")
       ("h" (=> (my--consult-fd-with-region (my--get-project-dir))) "consult-fd")
       ("a" (=> (my-consult-fd-directories (my--get-project-dir))) "my-consult-fd-directories")
       ("e" (=> (my--consult-fd-with-region 1)) "consult-fd-2"))

(bind! my-search-keymap
       ("f" (=> (my--consult-ripgrep-with-region default-directory)) "consult-ripgrep-1")
       ("o" #'consult-imenu "consult-imenu")
       ("h" (=> (my--consult-ripgrep-with-region (my--get-project-dir))) "consult-ripgrep")
       ("a" #'my-consult-line-with-region "consult-line")
       ("e" (=> (my--consult-ripgrep-with-region 1)) "consult-ripgrep-2"))

(bind! my-replace-keymap
       ("f" #'query-replace "query-replace")
       ("h" #'vr/query-replace "vr/query-replace")
       ("a" #'vr/replace "vr/replace")
       ("e" #'vr/mc-mark "vr/mc-mark"))

(bind! my-compile-keymap
       ("f" #'compile "compile")
       ("o" #'async-shell-command "async-shell-command")
       ("u" #'my-compile-region "my-compile-region")
       ("h" #'my-project-compile "my-project-compile")
       ("a" #'my-project-async-shell-command "my-project-async-shell-command")
       ("e" #'recompile "recompile")
       ("." #'my-project-compile-region "my-project-compile-region"))

(bind! my-magit-keymap
       ("j" #'magit-file-dispatch "magit-file-dispatch")
       ("f" #'my-toggle-magit-blame "magit-blame")
       ("o" #'magit-log-buffer-file "magit-log-buffer-file")
       ("u" #'magit-ediff-show-commit "magit-ediff-show-commit")
       ("y" #'magit-dispatch "magit-dispatch")
       ("h" #'my-magit-switch-or-status "my-magit-switch-or-status")
       ("a" #'magit-log-current "magit-log-current")
       ("e" #'magit-checkout "magit-checkout")
       ("." #'magit-status-quick "magit-status-quick")
       ("," #'magit-git-command-topdir "magit-git-command-topdir")
       ("/" #'my-magit-restore-current "my-magit-restore-current"))

(bind! my-window-keymap
       ("l" #'kill-buffer-and-window "kill-buffer-and-window")
       ("d" #'my-delete-other-windows "my-delete-other-windows")
       ("c" #'delete-window "delete-window")
       ("b" #'delete-other-windows-vertically "delete-side-and-vertical")
       ("n" #'balance-windows "balance-windows")
       ("r" #'windower-toggle-split "windower-toggle-split")
       ("t" #'split-window-vertically "split-window-vertically")
       ("s" #'split-window-horizontally "split-window-horizontally")
       ("w" #'windower-swap "windower-swap")
       ("m" #'window-toggle-side-windows "window-toggle-side-windows"))

(bind! my-file-keymap
       ("d" #'rename-file "rename-file")
       ("c" #'write-file "write-file")
       ("s" #'my-copy-full-path "copy full path")
       ("t" #'my-copy-path "copy path")
       ("r" #'my-copy-file-name "copy buffer name")
       ("x" #'ediff-files "ediff-files"))

(bind! my-toggle-keymap
       ("l" #'my-toggle-vc-mode "my-toggle-vc-mode")
       ("d" #'flymake-show-buffer-diagnostics "flymake-show-buffer-diagnostics")
       ("c" #'my-toggle-corfu-auto "my-toggle-corfu-auto")
       ("r" #'my-toggle-eglot-flymake "my-toggle-eglot-flymake")
       ("t" #'my-toggle-eglot-global "my-toggle-eglot-global")
       ("s" #'my-toggle-eglot-format-on-save "my-toggle-eglot-format-on-save"))

(bind! my-buffer-keymap
       ("l" #'persp-kill-buffer* "persp-kill-buffer")
       ("d" #'my-kill-persp-other-buffers "my-kill-persp-other-buffers")
       ("c" #'kill-current-buffer "kill-current-buffer")
       ("b" #'my-kill-matching-buffers-no-ask-except-current "kill-matching-buffers-no-ask")
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

(bind! my-persp-keymap
       ("l" #'persp-switch-to-scratch-buffer "persp-switch-to-scratch-buffer")
       ("d" #'persp-kill-others "persp-kill-others")
       ("c" #'persp-kill "persp-kill")
       ("r" #'persp-rename "persp-rename")
       ("t" #'persp-prev "persp-prev")
       ("s" #'persp-next "persp-next")
       ("x" (=> (persp-forget-buffer (buffer-name)) (delete-window)) "persp-forget-buffer")
       ("w" #'persp-merge "persp-merge")
       ("m" #'persp-unmerge "persp-unmerge"))

(bind! my-bookmark-keymap
       ("c" #'bookmark-delete "bookmark-delete")
       ("r" #'bookmark-rename "bookmark-rename")
       ("s" #'bookmark-set "bookmark-set"))

(bind! my-leader-map
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
       ("d" #'my-consult-select-window "my-consult-select-window")
       ("c" #'consult-buffer "consult-buffer")
       ("b" #'consult-bookmark "consult-bookmark")
       ("x" #'my-toggle-meow-normal-mode "toggle-normal-mode")
       ("w" #'my-dired-or-file "my-dired-or-file")
       ("o" #'my-select-side-window "my-select-side-window")
       ("DEL" #'find-file "find-file"))

(bind! global-map
       ("<backspace>" #'my-backward-delete-char-dwim "my-backward-delete-char-dwim")
       ("M-j" #'beginning-of-visual-line "beginning-of-visual-line")
       ("M-f" #'back-to-indentation "back-to-indentation")
       ("M-o" #'end-of-visual-line "end-of-visual-line")
       ("M-u" #'clipboard-yank "clipboard-yank")
       ("M-h" #'backward-char "backward-char")
       ("M-i" #'forward-char "forward-char")
       ("M-l" #'clipboard-kill-ring-save "clipboard-kill-ring-save")
       ("M-d" #'backward-word "backward-word")
       ("M-c" #'forward-word "forward-word")
       ("M-b" #'undo "undo")
       ("M-B" #'undo-redo "undo-redo")
       ("M-n" #'set-mark-command "set-mark-command")
       ("M-r" #'exchange-point-and-mark "exchange-point-and-mark")
       ("M-w" #'my-kill-region-or-line "my-kill-region-or-line")
       ("M-a" #'my-move-lines-down "my-move-lines-down")
       ("M-e" #'my-move-lines-up "my-move-lines-up")
       ("M-s" #'kill-word "kill-word")
       ("M-t" #'backward-kill-word "backward-kill-word")
       ("M-S" #'upcase-dwim "upcase-dwim")
       ("M-T" #'capitalize-dwim "capitalize-dwim")
       ("M-R" #'downcase-dwim "downcase-dwim")
       ("M-," #'xref-go-back "xref-go-back")
       ("M-." #'xref-find-definitions "xref-find-definitions")
       ("M-/" #'xref-find-references "xref-find-references")
       ("C-f" #'completion-at-point "completion-at-point")
       ("C-o" #'zoxide-travel "zoxide-travel")
       ("C-S-u" #'consult-yank-pop "consult-yank-pop")
       ("C-u" #'clipboard-yank "clipboard-yank")
       ("C-h" #'mark-word "mark-word")
       ("C-d" #'other-window "other-window")
       ("C-S-d" #'my-select-side-window "my-select-side-window")
       ("C-s" #'my-isearch-forward-with-region "my-isearch-forward-with-region")
       ("C-r" #'my-isearch-backward-with-region "my-isearch-backward-with-region")
       ("C-z" #'consult-isearch-history "consult-isearch-history")
       ("C-w" #'my-kill-region-or-line "my-kill-region-or-line")
       ("C-g" #'my-keyboard-quit-dwim "my-keyboard-quit-dwim")
       ("C-t" #'my-keyboard-quit-dwim "my-keyboard-quit-dwim")
       ("C-T" #'my-keyboard-quit-dwim "my-keyboard-quit-dwim")
       ("C-+" #'global-text-scale-adjust "global-text-scale-adjust")
       ("C-," (=> (duplicate-dwim) (next-line)) "duplicate-dwim")
       ("C-." #'embark-act "embark-act")
       ("C-<tab>" #'tab-to-tab-stop "tab-to-tab-stop")
       ("C-c f" #'mc/edit-beginnings-of-lines "mc/edit-beginnings-of-lines")
       ("C-c o" #'mc/insert-numbers "mc/insert-numbers")
       ("C-c u" #'vundo "vundo")
       ("C-c ." #'help-command "help-command")
       ("C-c a" #'my-tmux-cd "my-tmux-cd")
       ("C-c i" #'indent-region "indent-region")
       ("C-c w" #'my-wrap-region-with-pair "my-wrap-region-with-pair")
       ("C-c C-u" #'universal-argument "universal-argument")
       ("C-x j" #'dired-jump "dired-jump")
       ("C-x RET o" #'my-show-buffer-file-encoding "my-show-buffer-file-encoding")
       ("C-x f" #'find-file "find-file")
       ("C-x C-f" #'find-file-at-point "find-file-at-point")
       ("C-x C-j" (=> (find-file (my--get-project-dir))) "dired-project-dir"))

(bind! minibuffer-local-shell-command-map
       ("C-p" #'previous-history-element "previous-history-element") ; C-e
       ("C-n" #'my-minibuffer-next-history-or-clear "my-minibuffer-next-history-or-clear")) ; C-a

(bind! minibuffer-local-map
       ("M-j" #'beginning-of-visual-line "beginning-of-visual-line")
       ("M-f" #'back-to-indentation "back-to-indentation")
       ("M-o" #'end-of-visual-line "end-of-visual-line")
       ("M-u" #'clipboard-yank "clipboard-yank")
       ("M-h" #'backward-char "backward-char")
       ("M-i" #'forward-char "forward-char")
       ("M-l" #'clipboard-kill-ring-save "clipboard-kill-ring-save")
       ("M-d" #'backward-word "backward-word")
       ("M-c" #'forward-word "forward-word")
       ("M-b" #'undo "undo")
       ("M-B" #'undo-redo "undo-redo")
       ("M-n" #'set-mark-command "set-mark-command")
       ("M-r" #'exchange-point-and-mark "exchange-point-and-mark")
       ("M-w" #'my-kill-region-or-line "my-kill-region-or-line")
       ("M-a" #'embark-export "embark-export")
       ("M-s" #'kill-word "kill-word")
       ("M-t" #'backward-kill-word "backward-kill-word")
       ("C-u" #'clipboard-yank "clipboard-yank")
       ("C-h" #'mark-word "mark-word")
       ("C-r" #'consult-history "consult-history"))

(bind! isearch-mode-map
       ("C-d" #'avy-isearch "avy-isearch")
       ("C-u" #'isearch-yank-x-selection "isearch-yank-x-selection")
       ("M-u" #'isearch-yank-x-selection "isearch-yank-x-selection"))

(bind! xref--xref-buffer-mode-map
       ("<backspace>" #'xref-show-location-at-point "xref-show-location-at-point"))

(bind! compilation-mode-map
       ("." #'previous-error-no-select "previous-error-no-select")
       ("," #'next-error-no-select "next-error-no-select"))

(bind! compilation-button-map
       ("<backspace>" (=> (compile-goto-error) (select-window (old-selected-window))) "compile-goto-error"))

(bind! grep-mode-map
       ("M-a" #'wgrep-change-to-wgrep-mode "wgrep-change-to-wgrep-mode")
       ("." #'previous-error-no-select "previous-error-no-select")
       ("," #'next-error-no-select "next-error-no-select"))

(bind! wgrep-mode-map
       ("M-a" #'wgrep-abort-changes "wgrep-abort-changes"))

(bind! occur-edit-mode-map
       ("M-a" #'occur-cease-edit "occur-cease-edit"))

(bind! occur-mode-map
       ("M-a" #'occur-edit-mode "occur-edit-mode")
       ("." #'previous-error-no-select "previous-error-no-select")
       ("," #'next-error-no-select "next-error-no-select")
       ("<backspace>" (=> (occur-mode-goto-occurrence) (select-window (old-selected-window))) "occur-mode-goto-occurrence"))

(bind! flymake-diagnostics-buffer-mode-map
       ("<backspace>" (=> (call-interactively #'flymake-goto-diagnostic) (select-window (old-selected-window))) "flymake-goto-diagnostic"))

(bind! magit-mode-map
       ("n" (=> (magit-section-forward) (recenter)) "magit-section-forward")
       ("p" (=> (magit-section-backward) (recenter)) "magit-section-backward")
       ("," (=> (magit-section-forward) (recenter)) "magit-section-forward")
       ("." (=> (magit-section-backward) (recenter)) "magit-section-backward")
       ("q" (=> (magit-kill-this-buffer) (when (> (count-windows) 1) (delete-window))) "magit-kill-this-buffer")
       ("<enter>" #'magit-diff-visit-file-other-window "magit-diff-visit-file-other-window")
       ("<backspace>" (=> (call-interactively #'magit-diff-visit-file-other-window) (select-window (old-selected-window))) "magit-diff-other-window")
       ("C-c m u" #'magit-smerge-keep-upper "magit-smerge-keep-upper")
       ("C-c m l" #'magit-smerge-keep-lower "magit-smerge-keep-lower")
       ("C-c m b" #'magit-smerge-keep-base "magit-smerge-keep-base")
       ("C-c m a" #'magit-smerge-keep-all "magit-smerge-keep-all")
       ("C-c m c" #'magit-smerge-keep-current "magit-smerge-keep-current"))

(bind! magit-blame-mode-map
       ("n" (=> (magit-blame-next-chunk) (recenter)) "magit-blame-next-chunk")
       ("p" (=> (magit-blame-previous-chunk) (recenter)) "magit-blame-previous-chunk")
       ("," (=> (magit-blame-next-chunk) (recenter)) "magit-blame-next-chunk")
       ("." (=> (magit-blame-previous-chunk) (recenter)) "magit-blame-previous-chunk")
       ("w" #'magit-blame-copy-hash "magit-blame-copy-hash")
       ("M-<return>" #'my-magit-show-commit-original "my-magit-show-commit-original"))

(bind! git-rebase-mode-map
       ("M-a" #'git-rebase-move-line-down "git-rebase-move-line-down")
       ("M-e" #'git-rebase-move-line-up "git-rebase-move-line-up"))

(bind! dired-mode-map
       ("M-a" #'dired-toggle-read-only "dired-toggle-read-only")
       ("h" #'dired-up-directory "dired-up-directory")
       ("i" #'dired-find-file "dired-find-file")
       ("<backspace>" #'dired-display-file "dired-display-file")
       ("<return>" #'dired-find-file-other-window "dired-find-file-other-window")
       ("C-o" #'zoxide-travel "zoxide-travel")
       ("C-," #'my-dired-duplicate-file "my-dired-duplicate-file")
       ("l" #'clipboard-kill-ring-save "clipboard-kill-ring-save"))

(bind! wdired-mode-map
       ("M-a" #'wdired-abort-changes "wdired-abort-changes"))

(bind! vertico-multiform-map
       ("C-f" #'vertico-multiform-grid "vertico-multiform-grid")
       ("C-M-f" #'vertico-multiform-vertical "vertico-multiform-vertical")
       ("C-S-f" #'vertico-multiform-buffer "vertico-multiform-buffer")
       ("C-S-a" #'vertico-grid-right "vertico-grid-right")
       ("C-S-e" #'vertico-grid-left "vertico-grid-left")
       ("C-<return>" #'vertico-exit "vertico-exit")
       ("<left>" #'backward-char "backward-char")
       ("<right>" #'forward-char "forward-char"))

(bind! consult-narrow-map
       ("C-o" #'my-consult-narrow-to-space "my-consult-narrow-to-space"))

(bind! mc/keymap
       ("C-t" #'mc/keyboard-quit "mc/keyboard-quit")
       ("C-T" #'mc/keyboard-quit "mc/keyboard-quit")
       ("<return>" nil "nil"))

(bind! transient-map
       ("<escape>" #'transient-quit-one "transient-quit-one"))

(bind! org-mode-map
       ("C-," (=> (duplicate-dwim) (next-line)) "duplicate-dwim"))

(bind! corfu-map
       ("C-SPC" #'corfu-insert-separator "corfu-insert-separator")
       ("C-h" #'corfu-info-documentation "corfu-info-documentation")
       ("C-o" #'my-corfu-move-to-minibuffer "my-corfu-move-to-minibuffer"))

(keyboard-translate ?\C-a ?\C-n)
(keyboard-translate ?\C-e ?\C-p)
(keyboard-translate ?\C-t ?\C-g)

;;; Server
(server-start)
