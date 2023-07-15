(define-derived-mode my-logfile-mode text-mode "My Logfile Mode"
  "Syntax highlighting for logfiles based on text-mode.
Load with (require 'my-logfile-mode)."

  ;; Add font-lock rules
  (setq font-lock-defaults
        '((("\\<\\(FIXME\\|TODO\\|BUG\\):" 1 font-lock-warning-face t)
           ("\\<\\(function\\|if\\|else\\|while\\|for\\|return\\)\\>" . font-lock-keyword-face)
           ("\\<\\(true\\|false\\|huls\\)\\>" . font-lock-constant-face)
           ("^<\\([0-9]+\\)/\\([0-9]+\\)>"
            (1 font-lock-constant-face)
            (2 font-lock-warning-face))
           ))
        )
  ;; add other custom behavior here
  )

(provide 'my-logfile-mode)
