(deftheme My-Basic
  "Created 2019-08-13.")

(custom-theme-set-variables
 'My-Basic
 '(ansi-color-names-vector ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(c-default-style '((java-mode . "java") (awk-mode . "awk") (other . "java")))
 '(ido-default-buffer-method 'selected-window)
 '(indent-tabs-mode nil)
 '(initial-buffer-choice t)
 '(initial-scratch-message nil)
 '(package-selected-packages '(inf-ruby typescript-mode go-snippets go-mode java-snippets yasnippet-classic-snippets python company-jedi cargo typing-game markdown-mode clojure-mode alchemist elixir-mode powershell company-lua erlang ac-js2 company-racer web-mode scss-mode ecb color-theme coffee-mode))
 '(column-number-mode t)
 '(show-paren-mode t)
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style 'post-forward)
 '(scroll-bar-mode nil))

(custom-theme-set-faces
 'My-Basic
 '(default ((t (:inherit nil :stipple nil :background "#EDEDED" :foreground "#2E3436" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "outline" :family "Source Code Pro")))))

(provide-theme 'My-Basic)
