;;; -*- lexical-binding: t; coding: utf-8 -*-

(defvar my--segment-modal-state-alist
  '((normal . ("N" . font-lock-variable-name-face))
    (insert . ("I" . font-lock-string-face))
    (motion . ("M" . diredfl-symlink))))

(defun my--segment-modal-fn ()
  (when (boundp 'meow--current-state)
    (let ((mode-cons (alist-get meow--current-state
                                my--segment-modal-state-alist)))
      (concat (propertize (car mode-cons)
                          'face (cdr mode-cons))))))

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

(setq-default mode-line-mule-info
              '((:eval
                 (let ((eol (coding-system-eol-type buffer-file-coding-system))
                       (encoding (format-mode-line " %z")))
                   (concat encoding
                           (cond
                            ((eq eol 0) ":")
                            ((eq eol 1) "\\")
                            ((eq eol 2) "/")
                            (t "")))))))

(setq-default mode-line-format
              `("%e"
                mode-line-front-space
                (:propertize
                 (""
                  mode-line-mule-info
                  mode-line-modified
                  mode-line-remote))
                "  "
                (:eval (my--mode-line-buffer-id))
                "  "
                (:eval
                 (when (mode-line-window-selected-p)
                   (list
                    mode-line-position
                    "  "
                    (format "(%s)" (my--segment-modal-fn))
                    " "
                    mode-line-modes
                    (persp-mode-line)
                    ,(if (eq system-type 'darwin)
                         '(when (eglot-managed-p)
                            (list
                             '(" ("
                               (:eval
                                (cl-loop for e in eglot-mode-line-format
                                         for render = (format-mode-line e)
                                         unless (string-empty-p render)
                                         collect (cons render (eq e 'eglot-mode-line-menu)) into rendered
                                         finally return
                                         (cl-loop for (rspec . rest) on rendered
                                                  for (r . titlep) = rspec
                                                  concat r
                                                  when rest concat (if titlep ":" "/"))))
                               ") ")))
                       '(when (eglot-managed-p)
                          (list " (" eglot--mode-line-format ")"))))))))
