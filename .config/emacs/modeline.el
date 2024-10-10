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

(defface mode-line-buffer-id-inactive
  `((t (:inherit mode-line-buffer-id :foreground ,(gmc 'grey1) :background ,(gmc 'bg0))))
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
