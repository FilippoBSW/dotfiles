;; Misc

(when (eq system-type 'windows-nt)
  (use-package powershell)
  (setq magit-git-executable "..."))

(setq url-proxy-services
      '(("http" . "...")
        ("https" . "...")))

(with-eval-after-load 'perspective
  (find-file "...")
  (persp-switch "..."))

(add-to-list 'exec-path "...")
(add-to-list 'eglot-server-programs '(...-mode . ("...")))
