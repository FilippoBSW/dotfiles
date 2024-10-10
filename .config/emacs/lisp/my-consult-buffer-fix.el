;;; -*- lexical-binding: t; coding: utf-8 -*-

;; Workaround: make `el$` style regexps work in `consult-buffer`
;;
;; Problem:
;;   `consult-buffer` appends invisible “tofu” characters to candidates
;;   (for disambiguation across sources). This breaks regexps that end
;;   with `$`, since `$` lands *before* the hidden suffix and matches
;;   nothing.
;;
;; Fix:
;;   Add an Orderless dispatcher that rewrites patterns ending in `$`
;;   into a regexp that allows trailing tofu chars, e.g.:
;;
;;       "el$"  →  "el[TOFU_RANGE]*$"
;;
;; Notes:
;;   - Relies on Consult internals (`consult--tofu-char`, `consult--tofu-range`).
;;   - May break if Consult changes how disambiguation is implemented.
;;   - Only triggers when a pattern ends with `$`.
;;   - Safe to remove once Consult upstream addresses the issue.

(use-package orderless
  :init
  (setq completion-styles '(orderless)
        completion-category-defaults nil
        completion-category-overrides '((file (styles . (partial-completion)))))
  :config
  (let ((tofu (format "[%c-%c]"
                      consult--tofu-char
                      (+ consult--tofu-char consult--tofu-range -1))))
    (defun my/orderless-dispatch-skip-consult-tofu (pattern index _total)
      (when (string-suffix-p "$" pattern)
        `(orderless-regexp . ,(concat (substring pattern 0 -1) tofu "*$"))))
    (setq orderless-style-dispatchers
          (cons #'my/orderless-dispatch-skip-consult-tofu
                orderless-style-dispatchers))))

(provide 'my-consult-buffer-fix)
