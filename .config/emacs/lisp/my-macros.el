;;; -*- lexical-binding: t; coding: utf-8 -*-

(defmacro require! (&rest features)
  `(progn
     ,@(mapcar (lambda (f)
                 `(require ',f))
               features)))

(defmacro use-package! (&rest packages)
  `(progn
     ,@(mapcar (lambda (pkg)
                 `(use-package ,pkg))
               packages)))

(defmacro defvar! (&rest pairs)
  `(progn
     ,@(mapcar
        (lambda (spec)
          `(defvar ,@spec))
        pairs)))

(defmacro defconst! (&rest pairs)
  `(progn
     ,@(mapcar
        (lambda (spec)
          `(defconst ,@spec))
        pairs)))

(defmacro add-hook! (hook &rest fns)
  `(progn ,@(mapcar (lambda (fn) `(add-hook ',hook ,fn)) fns)))

(defmacro add-to-list! (place &rest entries)
  `(progn ,@(mapcar (lambda (e) `(add-to-list ',place ,e)) entries)))

(defmacro add-advice! (&rest pairs)
  `(progn ,@(mapcar (lambda (p)
                      `(advice-add ,(nth 0 p) ,(nth 1 p) ,(nth 2 p)))
                    pairs)))

(defmacro bind! (keymap &rest bindings)
  `(progn
     (defvar ,keymap (or (and (boundp ',keymap) ,keymap)
                         (make-sparse-keymap)))
     ,@(mapcar
        (lambda (binding)
          `(progn
             ,(let ((cmd (nth 1 binding)))
                (when (symbolp cmd)
                  `(when (and (string-match-p "-\\(key\\)?map\\'" ,(symbol-name cmd))
                              (not (and (boundp ',cmd) (keymapp ,cmd))))
                     (defvar ,cmd (make-sparse-keymap)))))
             (keymap-set ,keymap ,(nth 0 binding) ,(nth 1 binding))
             ,(let ((desc (nth 2 binding)))
                (when desc
                  `(when (featurep 'which-key)
                     (which-key-add-keymap-based-replacements
                       ,keymap ,(nth 0 binding) ,desc))))))
        bindings)))

(defmacro => (&rest body)
  `(lambda () (interactive) ,@body))

(provide 'my-macros)
