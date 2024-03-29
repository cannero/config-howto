;; in case of slow display update: -q -xrm Emacs.FontBackend:gdi
;; C-x C-- or + to zoom

;;; UNCOMMENT THIS TO DEBUG TROUBLE GETTING EMACS UP AND RUNNING.
;;; (setq debug-on-error t)
;;; start without this file '--no-init-file'

;; ----------------------------------------
;; shortcuts
(global-set-key "\M-n" 'revert-buffer)
(global-set-key "\C-c\C-a" 'auto-revert-tail-mode)
(global-set-key "\C-c\C-r" 'recompile)

;;(global-set-key  "\C-w" 'backward-kill-word)
;; ----------------------------------------
(setq exec-path (append exec-path '("C:/tools/Ruby27-x64/msys64/usr/bin" "C:/tools/Ruby27-x64/msys64/mingw64/bin")))
(setq exec-path (append '("C:/Users/nile/anaconda3" "C:/Users/nile/anaconda3/Scripts") exec-path))
;;(setq exec-path (append '("C:/Users/nile/AppData/Local/Programs/Python/Python39" "C:/Users/nile/AppData/Local/Programs/Python/Python39/Scripts") exec-path))

;;(setenv "PATH" (concat (expand-file-name "C:/Users/nile/AppData/Local/Programs/Python/Python39") path-separator (expand-file-name "C:/Users/nile/AppData/Local/Programs/Python/Python39/Scripts") path-separator (expand-file-name "C:/tools/Ruby27-x64/msys64/usr/bin") path-separator (expand-file-name "C:/tools/Ruby27-x64/msys64/mingw64/bin") path-separator (getenv "PATH")))
(setenv "PATH" (concat (expand-file-name "C:/Users/nile/anaconda3") path-separator (expand-file-name "C:/Users/nile/anaconda3/Scripts") path-separator (expand-file-name "C:/tools/Ruby27-x64/msys64/usr/bin") path-separator (expand-file-name "C:/tools/Ruby27-x64/msys64/mingw64/bin") path-separator (getenv "PATH")))

;;(setenv "PYTHONHOME" "C:/Users/nile/AppData/Local/Programs/Python/Python39")
;;(setenv "PYTHONPATH" "C:/Users/nile/AppData/Local/Programs/Python/Python39")
(require 'package)
;; error message when starting package manager: Failed to verify signature archive-contents.sig
;; tries to use msys gpg:
;; gpg: keyblock resource '/c/progra/rust/monkey/interpreter_compiler/c:/Users/nile/AppData/Roaming/.emacs.d/elpa/gnupg/pubring.kbx': No such file or directory
(setq package-check-signature nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)
;;load path
;;(add-to-list 'load-path "D:/tools/emacsInc")
;;(add-to-list 'load-path "D:/tools/emacsInc/HTML5-YASnippet-bundle")

;; place all backup files in one directory https://www.emacswiki.org/emacs/AutoSave
(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups"))))
(setq auto-save-file-name-transforms
          `((".*" ,(concat user-emacs-directory "backups/") t)))
;; turn off lock files https://www.gnu.org/software/emacs/manual/html_node/emacs/Interlocking.html#Interlocking
(setq create-lockfiles nil)

;; columns
(column-number-mode 1)
;; hungry delete
(add-hook 'c++-mode-hook
	  (lambda ()
	    (c-toggle-hungry-state 1)))


;; highlight brackets
(require 'paren)
(show-paren-mode 1)

;; from http://xsteve.at/prg/emacs/power-user-tips.html
(ido-mode 'buffer)
(setq ido-enable-flex-matching t)

;;https://www.emacswiki.org/emacs/IsearchOtherEnd
;;go to beginning after search
(defun my-goto-match-beginning ()
    (when (and isearch-forward (not isearch-mode-end-hook-quit)) (goto-char isearch-other-end)))
(add-hook 'isearch-mode-end-hook 'my-goto-match-beginning)

;;ansi mode
;;show escape sequences in color
;;http://unix.stackexchange.com/questions/19494/how-to-colorize-text-in-emacs
(define-derived-mode fundamental-ansi-mode fundamental-mode "fundamental ansi"
  "Fundamental mode that understands ansi colors."
  (require 'ansi-color)
  (ansi-color-apply-on-region (point-min) (point-max)))

(defun ansi-color-apply-on-region-int (beg end)
  "interactive version of func"
  (interactive "r")
  (ansi-color-apply-on-region beg end))

;;make buffer names unique
;;Run M-x customize-option
;;then customize uniquify-buffer-name-style
(require 'uniquify)
 ;replace y-e-s by y
(fset 'yes-or-no-p 'y-or-n-p)
;open pdf files in fundamental mode
(setq auto-mode-alist
      (append '(("\\.pdf$" . whitespace-mode))
              '(("\\.svg$" . nxml-mode))
              auto-mode-alist))

;;-------------------------------------------
;; set default height
(if (<= 1200 (display-pixel-height))
    (setq default-frame-alist ' (
                                 (user-size . t)
                                 (height . 58)
                                 (width . 95)
                                 ))
  (setq default-frame-alist ' (
                               (user-size . t)
                               (height . 52)
                               (width . 85)
                               )))

(setq initial-frame-alist '(
                            (top . 5)
                            (left . 5)
                            ))
;;(set-background-color "grey97")

(when (display-graphic-p)
  (tool-bar-mode -1)
  (menu-bar-no-scroll-bar))
;; ============================================================
;; prompt before closing
(defun ask-before-closing ()
  "Ask whether or not to close, and then close if y was pressed"
  (interactive)
  (if (y-or-n-p (format "Are you sure you want to exit Emacs? "))
      (if (< emacs-major-version 22)
          (save-buffers-kill-terminal)
        (save-buffers-kill-emacs))
    (message "Canceled exit")))
 
(when (display-graphic-p)
  (global-set-key (kbd "C-x C-c") 'ask-before-closing))

;;==================================================
;; C++ helpers
;;
(defun my-c++-mode-hook ()
  (define-key c++-mode-map "\C-c\C-k" 'compile)
  (setq c-default-style "linux"
  ;;(setq c-default-style "gnu"
        c-basic-offset 4)
  
  (defun Chelp-simple-debug ()
    "insert a CString and a Message Box for best debugging"
    (interactive)
    (insert "
    //TODO remove
    CString out;
    out.Format(\"%d\",i);
    AfxMessageBox(out);
    //TODO end
    "
            )
    )

  (defun Chelp-debug-afx (arg clName)
    "needs class name clName, call from code with Dump(afxDump)"
    (interactive "P\nsClass Name: ")
    (insert "
#ifdef _DEBUG
    virtual void Dump( CDumpContext& dc ) const;
#endif

#ifdef _DEBUG
    Dump( afxDump );
#endif

#ifdef _DEBUG
void "clName"::Dump( CDumpContext& dc ) const
{
    CObject::Dump( dc );

    dc << \"\\n\";
}
#endif
"
)
    )
  (defun Chelp-debug-dumpstring (arg debString)
    "outputs the given chars"
    (interactive "P\nsString name: ")
    (insert "
//TODO sebastian remove
    //char "debString"[50];
    //ltoa(lUniqNr, "debString", 10);
    //strcat(buffer, \"\\n\");
    OutputDebugString("debString");
//TODO till here
"
    )
    )
  )
;;===================================================
;;C# mode
(require 'cc-mode)

(setq lsp-keymap-prefix "s-m")
(require 'lsp-mode)

(autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
(setq auto-mode-alist
      (append '(("\\.cs$" . csharp-mode)) auto-mode-alist))
(defun my-csharp-mode-fn ()
  "my function that runs when csharp-mode is initialized for a buffer."
  (setq-default c-basic-offset 4
                tab-width 4
                indent-tabs-mode nil)
  (c-set-offset 'substatement-open 0)
  ;; if not using lsp mode dumb-jump
  ;; (add-hook 'xref-backend-functions #'dumb-jump-xref-activate)
  ;; lsp-install-server omnisharp
  ;(lsp-deferred)
  )

(add-hook  'csharp-mode-hook 'my-csharp-mode-fn t)
(add-to-list 'auto-mode-alist '("\\.csproj\\'" . nxml-mode))

;;
;;===================================================p
;; org-mode
(require 'org-install)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))
(add-hook 'org-mode-hook
	  (lambda()
		  'turn-on-font-lock ; not needed when global-font-lock-mode is on
		  (define-key org-mode-map "\M-q" 'toggle-truncate-lines)))
(global-set-key "\C-cl" 'org-store-link)
;;(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)

(setq org-log-done t) ;set timestamps
;;;; defined by customize
;;(setq org-agenda-files (list "D:/usr/orgFiles/withoutProject.org")
;;      )

;(org-babel-do-load-languages
;     'org-babel-load-languages
;     '((ditaa . t)
;       (plantuml . t))) ; this line activates ditaa

;(setq org-plantuml-jar-path
;      (expand-file-name
;       "plantuml.jar"
;       (file-name-as-directory
;        (expand-file-name
;         "scripts"
;         (file-name-as-directory
;          (expand-file-name
;           "../contrib"
;           (file-name-directory (org-find-library-dir "org"))
                                        ;           ))))))
(setq org-adapt-indentation nil)
(setq org-startup-folded t)
;;==================================================
;;miscellaneous  helpers
;;
(defun count-region (beginning end)
  "Print number of words and chars in region."
  (interactive "r")
  (message "Counting ...")
  (save-excursion
    (let ((wCnt 0) 
          (charCnt (- end beginning))
          )
      (goto-char beginning)
      (while (and (< (point) end)
                  (re-search-forward "\\w+\\W*" end t))
        (setq wCnt (1+ wCnt))
        )

      (message "Words: %d. Chars: %d." wCnt charCnt)
     )
   )
)

(defun count-chars (point)
  "Print number of chars from beginning to cursor."
  (interactive "d")
  (message "Chars: %d" (- point 1))
  )

(defun move-file (new-location)
  "Write this file to NEW-LOCATION, and delete the old one."
  (interactive (list (expand-file-name
                      (if buffer-file-name
                          (read-file-name "Move file to: ")
                        (read-file-name "Move file to: "
                                        default-directory
                                        (expand-file-name (file-name-nondirectory (buffer-name))
                                                          default-directory))))))
  (when (file-exists-p new-location)
    (delete-file new-location))
  (let ((old-location (expand-file-name (buffer-file-name))))
    (message "old file is %s and new file is %s"
             old-location
             new-location)
    (write-file new-location t)
    (when (and old-location
               (file-exists-p new-location)
               (not (string-equal old-location new-location)))
      (delete-file old-location))))

(defun format-pr-title ()
  (interactive)
  (let ((beg (point)))
    (save-excursion
      (forward-line 1)
      (replace-string-in-region "_" " " beg (point)))))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; hooks
(add-hook 'c++-mode-hook 'my-c++-mode-hook)
(add-hook 'haml-mode-hook
          (lambda ()
            (setq indent-tabs-mode nil)
            (define-key haml-mode-map "\C-m" 'newline-and-indent)))
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; custom menu item for ftp/ip files
(defun open-hosts-file ()
  (interactive)
  (find-file "C:/windows/system32/drivers/etc/hosts")
  )
(defun open-services-file ()
  (interactive)
  (find-file "C:/windows/system32/drivers/etc/services")
  (goto-char (buffer-end 1))
  )
(defun open-functions-file ()
  (interactive)
  (find-file "C:/etc/function")
  (goto-char (buffer-end 1))
  )
(defun open-all-conec-files()
  (interactive)
  (open-functions-file)
  (open-services-file)
  (open-hosts-file)
  )

;;keymaps
(defvar menu-bar-srv-files-menu (make-sparse-keymap "SrvFiles"))
(define-key menu-bar-srv-files-menu [open-function-file]
  '(menu-item "Open functions" open-functions-file))
(define-key menu-bar-srv-files-menu [open-services-file]
  '(menu-item "Open services" open-services-file))
(define-key menu-bar-srv-files-menu [open-hosts-file]
  '(menu-item "Open hosts" open-hosts-file))
(define-key menu-bar-srv-files-menu [separator1]
  '(menu-item "--"))
(define-key menu-bar-srv-files-menu [open-all-files]
  '(menu-item "Open all files" open-all-conec-files))
;;separator
(define-key-after menu-bar-file-menu [separatordel]
  '(menu-item "--")
  'delete-this-frame)
;; add menu
(define-key-after menu-bar-file-menu [srvfiles]
  (list 'menu-item "Connection Files" menu-bar-srv-files-menu)
  'separatordel)

(defun hide-characters-in-buffer (chars)
  "all characters in input string are hidden in buffer"
  (interactive "sChars:")
  ;;buffer-display-table needs integer, string-split returns strings,
  ;;string-to-list integers
  (let ((charlist (string-to-list chars)))
       (setq buffer-display-table (make-display-table))
       (while charlist
         (aset buffer-display-table (car charlist) [])
         (setq charlist (cdr charlist)))
       )
  )

;;for VirtualBox makefiles
(add-to-list 'auto-mode-alist '("\\.kmk\\'" . makefile-mode))

;;xml mode folding
(require 'sgml-mode)
(require 'nxml-mode)
(add-to-list  'hs-special-modes-alist
             '(nxml-mode
               "<!--\\|<[^/>]*[^/]>"
               "-->\\|</[^/>]*[^/]>"

               "<!--"
               sgml-skip-tag-forward
               nil))

(add-hook 'nxml-mode-hook 'hs-minor-mode)
(define-key nxml-mode-map (kbd "C-c h") 'hs-toggle-hiding)

;;snippets
(require 'yasnippet)
(yas-global-mode 1)
;;(require 'html5-snippets)

;;global for source-code browsing
;(add-to-list 'load-path "D:/tools/global/share/gtags")
;(autoload 'gtags-mode "gtags" "" t)

;; semantic does not support ruby or c#!?
;(semantic-mode 1)
;(global-ede-mode 1)

(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.ejs\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.js\\'" . web-mode))
;; does not work with skewer-html-mode
;;(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))
(setq web-mode-content-types-alist
  '(("jsx" . "\\.js[x]?\\'")))

;; skewer does only work with sgml
;;(add-hook 'web-mode-hook 'skewer-html-mode)
(add-hook 'web-mode-hook 'company-mode)
(setq company-dabbrev-downcase nil)
;; sgml mode
(add-hook 'sgml-mode-hook 'skewer-html-mode)

(eval-after-load "hideshow"
  '(add-to-list 'hs-special-modes-alist
                 `(ruby-mode
                   ,(rx (or "def" "class" "module" "{" "[")) ; Block start
                   ,(rx (or "}" "]" "end"))                  ; Block end
                   ,(rx (or "#" "=begin"))                   ; Comment start
                   ruby-forward-sexp nil)))

(add-hook 'ruby-mode-hook #'hs-minor-mode)

;; rust
;;from https://github.com/rksm/emacs-rust-config
(require 'rustic)
(with-eval-after-load 'rustic
  (define-key rustic-mode-map (kbd "C-c C-c q") #'lsp-workspace-restart))

(defun my-rustic-mode-hook ()
  ;;(setq rustic-lsp-client nil)
  ;;rustic-lsp-setup-p
  (setq rustic-format-on-save nil)
  (setq rustic-cargo-bin "~/../../.cargo/bin/cargo")
  (setq rustic-rustfmt-bin "~/../../.cargo/bin/rustfmt")
  (setq-local buffer-save-without-query t)
  (set (make-local-variable 'compile-command)
       (concat "rustc "
               (shell-quote-argument buffer-file-name))))
(add-hook 'rustic-mode-hook #'my-rustic-mode-hook)

(defun my-lsp-ui-mode-hook ()
  (lsp-ui-doc-enable nil))
(add-hook 'lsp-ui-mode-hook #'my-lsp-ui-mode-hook)

;;company
(require 'company)
(setq company-tooltip-align-annotations t)
(setq company-selection-wrap-around t)
;; or make key bindings for company-tab-indent and company-complete minor modes
;; and load those instead of company
;; https://stackoverflow.com/questions/683425/globally-override-key-binding-in-emacs
;; https://stackoverflow.com/questions/9818307/emacs-mode-specific-custom-key-bindings-local-set-key-vs-define-key
(with-eval-after-load 'company
  (define-key company-mode-map (kbd "TAB") #'tab-indent-or-complete)
  (define-key company-mode-map (kbd "<tab>") #'tab-indent-or-complete)
  (define-key company-mode-map (kbd "<backtab>") #'company-indent-or-complete-common)
  (define-key company-active-map (kbd "<tab>") #'company-complete-selection))

(defun check-expansion ()
  (save-excursion
    (if (looking-at "\\_>") t
      (backward-char 1)
      (if (looking-at "\\.") t
        (backward-char 1)
        (if (looking-at "::") t nil)))))

(defun do-yas-expand ()
  (let ((yas-fallback-behavior 'return-nil))
    (yas-expand)))

(defun tab-indent-or-complete ()
  (interactive)
  (if (minibufferp)
      (minibuffer-complete)
    (if (or (not yas-minor-mode)
            (null (do-yas-expand)))
        (if (check-expansion)
            (company-complete-common)
          (indent-for-tab-command)))))

;; javascript
(add-to-list 'auto-mode-alist '("\\.es6\\'" . js-mode))
;;(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(setq ac-js2-evaluate-calls t)
(add-hook 'js2-mode-hook 'ac-js2-mode)
(add-hook 'js2-mode-hook 'skewer-mode)
(add-hook 'js2-mode-hook 'company-mode)
;;skewer mode
;;(add-hook 'css-mode-hook 'skewer-css-mode)
;;(add-hook 'html-mode-hook 'skewer-html-mode)
;; lua
(add-hook 'lua-mode-hook 'company-mode)

;; elixir
(add-hook 'elixir-mode-hook 'company-mode)
(add-hook 'elixir-mode-hook 'alchemist-mode)

;; python
(defun my-python-mode-hook ()
  (company-mode)
  ;; flycheck-verify-setup
  (flycheck-mode)
  ;; pip install pylint --upgrade
  (setq flycheck-python-pylint-executable "python")

  ;; tried also pyvenv-mode and anaconda-mode, conda was working out of the box
  (conda-env-initialize-interactive-shells)
  ;; eshell support
  (conda-env-initialize-eshell)
 
  )
(add-hook 'python-mode-hook 'my-python-mode-hook)

;(defcustom python-shell-interpreter "python"
;  "Default Python interpreter for shell."
;  :type 'string
;  :group 'python)

;; java
(add-hook 'java-mode-hook 'company-mode)

;; go
(defun my-go-mode-hook ()
  (company-mode)
  (add-hook 'before-save-hook 'gofmt-before-save nil t)
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))
  )
(add-hook 'go-mode-hook 'my-go-mode-hook)

;; fsharp
(defun my-fsharp-mode-hook ()
  (company-mode)
  (lsp-deferred)
  ;; todo install dotnet, framework is not supported any more
  ;;(require 'eglot-fsharp)
  ;;(eglot)
  )
(add-hook 'fsharp-mode-hook 'my-fsharp-mode-hook)
(add-to-list 'auto-mode-alist '("\\.fsproj\\'" . nxml-mode))

;;octave and matlab
(add-to-list 'auto-mode-alist '("\\.m$" . octave-mode))

(require 'gn-mode)
(add-to-list 'auto-mode-alist '("\\.gn$" . gn-mode))
(add-to-list 'auto-mode-alist '("\\.gni$" . gn-mode))
;; powershell
(add-hook 'powershell-mode-hook 'company-mode)

;; set default coding system to utf-8
;; from https://www.masteringemacs.org/article/working-coding-systems-unicode-emacs
;; to run a function with a different coding system use
;; M-x universal-coding-system-argument
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
;; backwards compatibility as default-buffer-file-coding-system
;; is deprecated in 23.2.
(if (boundp 'buffer-file-coding-system)
    (setq-default buffer-file-coding-system 'utf-8)
  (setq default-buffer-file-coding-system 'utf-8))

;; Treat clipboard input as UTF-8 string first; compound text next, etc.
(setq x-select-request-type '(UTF8_STRING COMPOUND_TEXT TEXT STRING))

;;ediff
(defun ediff-copy-both-to-C ()
  (interactive)
  (ediff-copy-diff ediff-current-difference nil 'C nil
                   (concat
                    (ediff-get-region-contents ediff-current-difference 'A ediff-control-buffer)
                    (ediff-get-region-contents ediff-current-difference 'B ediff-control-buffer))))
(defun ediff-combine-both-to-A ()
  (interactive)
  (ediff-copy-diff ediff-current-difference nil 'A nil
                   (concat
                    (ediff-get-region-contents ediff-current-difference 'A ediff-control-buffer)
                    (ediff-get-region-contents ediff-current-difference 'B ediff-control-buffer))))

(defun add-d-to-ediff-mode-map () (define-key ediff-mode-map "d" 'ediff-combine-both-to-A))
(add-hook 'ediff-keymap-setup-hook 'add-d-to-ediff-mode-map)

(minions-mode)
;;(add-hook 'after-init-hook #'doom-modeline-mode)
;; show menu at right mouse
(context-menu-mode)

;;==================================================
;; themes
(defun my-disable-all-themes ()
  "disable all active themes."
  (dolist (theme custom-enabled-themes)
    (disable-theme theme)))

(defun my-load-theme (theme)
  (interactive
   (list
    (intern (completing-read "Load custom theme: "
                             (mapcar #'symbol-name
				     (custom-available-themes))))))
  (my-disable-all-themes)
  (load-theme theme))

;; magit
;; use magit-repository-directories for default directories
;;;; magit show date in log
(setq magit-log-margin '(t "%y-%m-%d %H:%M" magit-log-margin-width t 18))

;; set left windows key to super, handle super-m in emacs
;; no need to set w32-pass-lwindow-to-system
(setq w32-lwindow-modifier 'super)
(w32-register-hot-key [s-m])

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(beacon-color "#c82829")
 '(c-default-style '((java-mode . "java") (awk-mode . "awk") (other . "java")))
 '(column-number-mode t)
 '(company-quickhelp-color-background "#4F4F4F")
 '(company-quickhelp-color-foreground "#DCDCCC")
 '(compilation-message-face 'default)
 '(conda-anaconda-home "C:/Users/nile/anaconda3/")
 '(csharp-want-imenu nil)
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#839496")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-enabled-themes nil)
 '(custom-safe-themes
   '("333958c446e920f5c350c4b4016908c130c3b46d590af91e1e7e2a0611f1e8c5" "84b14a0a41bb2728568d40c545280dbe7d6891221e7fbe7c2b1c54a3f5959289" "f149d9986497e8877e0bd1981d1bef8c8a6d35be7d82cba193ad7e46f0989f6a" "90a6f96a4665a6a56e36dec873a15cbedf761c51ec08dd993d6604e32dd45940" "c4063322b5011829f7fdd7509979b5823e8eea2abf1fe5572ec4b7af1dd78519" "745d03d647c4b118f671c49214420639cb3af7152e81f132478ed1c649d4597d" "a6e620c9decbea9cac46ea47541b31b3e20804a4646ca6da4cce105ee03e8d0e" "3d54650e34fa27561eb81fc3ceed504970cc553cfd37f46e8a80ec32254a3ec3" "76ed126dd3c3b653601ec8447f28d8e71a59be07d010cd96c55794c3008df4d7" "0d01e1e300fcafa34ba35d5cf0a21b3b23bc4053d388e352ae6a901994597ab1" "613aedadd3b9e2554f39afe760708fc3285bf594f6447822dd29f947f0775d6c" "97db542a8a1731ef44b60bc97406c1eb7ed4528b0d7296997cbb53969df852d6" "d268b67e0935b9ebc427cad88ded41e875abfcc27abd409726a92e55459e0d01" "db3e80842b48f9decb532a1d74e7575716821ee631f30267e4991f4ba2ddf56e" "a7b20039f50e839626f8d6aa96df62afebb56a5bbd1192f557cb2efb5fcfb662" "1f1b545575c81b967879a5dddc878783e6ebcca764e4916a270f9474215289e5" "5784d048e5a985627520beb8a101561b502a191b52fa401139f4dd20acb07607" "a82ab9f1308b4e10684815b08c9cac6b07d5ccb12491f44a942d845b406b0296" "835868dcd17131ba8b9619d14c67c127aa18b90a82438c8613586331129dda63" "c2aeb1bd4aa80f1e4f95746bda040aafb78b1808de07d340007ba898efa484f5" "7a7b1d475b42c1a0b61f3b1d1225dd249ffa1abb1b7f726aec59ac7ca3bf4dae" "c5ded9320a346146bbc2ead692f0c63be512747963257f18cc8518c5254b7bf5" "1d5e33500bc9548f800f9e248b57d1b2a9ecde79cb40c0b1398dec51ee820daf" "5f19cb23200e0ac301d42b880641128833067d341d22344806cdad48e6ec62f6" "4f1d2476c290eaa5d9ab9d13b60f2c0f1c8fa7703596fa91b235db7f99a9441b" "0466adb5554ea3055d0353d363832446cd8be7b799c39839f387abb631ea0995" "b186688fbec5e00ee8683b9f2588523abdf2db40562839b2c5458fcfb322c8a4" "4b6b6b0a44a40f3586f0f641c25340718c7c626cbf163a78b5a399fbe0226659" "1704976a1797342a1b4ea7a75bdbb3be1569f4619134341bd5a4c1cfb16abad4" "47db50ff66e35d3a440485357fb6acb767c100e135ccdf459060407f8baea7b2" "cf922a7a5c514fad79c483048257c5d8f242b21987af0db813d3f0b138dfaf53" "f6665ce2f7f56c5ed5d91ed5e7f6acb66ce44d0ef4acfaa3a42c7cfe9e9a9013" "246a9596178bb806c5f41e5b571546bb6e0f4bd41a9da0df5dfbca7ec6e2250c" "f7fed1aadf1967523c120c4c82ea48442a51ac65074ba544a5aefc5af490893b" "8146edab0de2007a99a2361041015331af706e7907de9d6a330a3493a541e5a6" "6f4421bf31387397f6710b6f6381c448d1a71944d9e9da4e0057b3fe5d6f2fad" "b0e446b48d03c5053af28908168262c3e5335dcad3317215d9fdeb8bac5bacf9" "4a5aa2ccb3fa837f322276c060ea8a3d10181fecbd1b74cb97df8e191b214313" "4133d2d6553fe5af2ce3f24b7267af475b5e839069ba0e5c80416aa28913e89a" "1278c5f263cdb064b5c86ab7aa0a76552082cf0189acf6df17269219ba496053" "e19ac4ef0f028f503b1ccafa7c337021834ce0d1a2bca03fcebc1ef635776bea" "9b54ba84f245a59af31f90bc78ed1240fca2f5a93f667ed54bbf6c6d71f664ac" "e8df30cd7fb42e56a4efc585540a2e63b0c6eeb9f4dc053373e05d774332fc13" "cbdf8c2e1b2b5c15b34ddb5063f1b21514c7169ff20e081d39cf57ffee89bc1e" "a0be7a38e2de974d1598cf247f607d5c1841dbcef1ccd97cded8bea95a7c7639" "850bb46cc41d8a28669f78b98db04a46053eca663db71a001b40288a9b36796c" "e2c926ced58e48afc87f4415af9b7f7b58e62ec792659fcb626e8cba674d2065" "846b3dc12d774794861d81d7d2dcdb9645f82423565bfb4dad01204fa322dbd5" "fe2539ccf78f28c519541e37dc77115c6c7c2efcec18b970b16e4a4d2cd9891d" "23c806e34594a583ea5bbf5adf9a964afe4f28b4467d28777bcba0d35aa0872e" "d47f868fd34613bd1fc11721fe055f26fd163426a299d45ce69bef1f109e1e71" "1d44ec8ec6ec6e6be32f2f73edf398620bb721afeed50f75df6b12ccff0fbb15" "8d7b028e7b7843ae00498f68fad28f3c6258eda0650fe7e17bfb017d51d0e2a2" "57a29645c35ae5ce1660d5987d3da5869b048477a7801ce7ab57bfb25ce12d3e" "efcecf09905ff85a7c80025551c657299a4d18c5fcfedd3b2f2b6287e4edd659" "e6f3a4a582ffb5de0471c9b640a5f0212ccf258a987ba421ae2659f1eaa39b09" "a9a67b318b7417adbedaab02f05fa679973e9718d9d26075c6235b1f0db703c8" "6c531d6c3dbc344045af7829a3a20a09929e6c41d7a7278963f7d3215139f6a7" "f91395598d4cb3e2ae6a2db8527ceb83fed79dbaf007f435de3e91e5bda485fb" "b5803dfb0e4b6b71f309606587dd88651efe0972a5be16ece6a958b197caeed8" "e79672e00657fb6950f67d1e560ca9b4881282eb0c772e2e7ee7a15ec7bb36a0" "8e7f73e3eb43d785644aaf93da8b222f2596191568afd14c6eb5b07d4ce7f049" "a68e2df30ebbb15ae1e650e743c898f7e52d618230c643522ca60908be4869d3" "e0660eb07fc49f5450614ef36416223f4cfad70c32082485956290723f314cf9" "a41d7d4c20bfa90be5450905a69f65a8ae35d3bcb97f11dfaef47036cf72a372" "a3bdcbd7c991abd07e48ad32f71e6219d55694056c0c15b4144f370175273d16" "0fe24de6d37ea5a7724c56f0bb01efcbb3fe999a6e461ec1392f3c3b105cc5ac" "4bca89c1004e24981c840d3a32755bf859a6910c65b829d9441814000cf6c3d0" "be9645aaa8c11f76a10bcf36aaf83f54f4587ced1b9b679b55639c87404e2499" "e27556a94bd02099248b888555a6458d897e8a7919fd64278d1f1e8784448941" "b5fff23b86b3fd2dd2cc86aa3b27ee91513adaefeaa75adc8af35a45ffb6c499" "d5a878172795c45441efcd84b20a14f553e7e96366a163f742b95d65a3f55d71" "0685ffa6c9f1324721659a9cd5a8931f4bb64efae9ce43a3dba3801e9412b4d8" "01cf34eca93938925143f402c2e6141f03abb341f27d1c2dba3d50af9357ce70" "e074be1c799b509f52870ee596a5977b519f6d269455b84ed998666cf6fc802a" "0a41da554c41c9169bdaba5745468608706c9046231bbbc0d155af1a12f32271" "f94110b35f558e4c015b2c680f150bf8a19799d775f8352c957d9d1054b0a210" "3c2f28c6ba2ad7373ea4c43f28fcf2eed14818ec9f0659b1c97d4e89c99e091e" "2c49d6ac8c0bf19648c9d2eabec9b246d46cb94d83713eaae4f26b49a8183fc4" "cae81b048b8bccb7308cdcb4a91e085b3c959401e74a0f125e7c5b173b916bf9" "7d708f0168f54b90fc91692811263c995bebb9f68b8b7525d0e2200da9bc903c" "fd22c8c803f2dac71db953b93df6560b6b058cb931ac12f688def67f08c10640" "fce3524887a0994f8b9b047aef9cc4cc017c5a93a5fb1f84d300391fba313743" "730a87ed3dc2bf318f3ea3626ce21fb054cd3a1471dcd59c81a4071df02cb601" "c086fe46209696a2d01752c0216ed72fd6faeabaaaa40db9fc1518abebaf700d" "7a994c16aa550678846e82edc8c9d6a7d39cc6564baaaacc305a3fdc0bd8725f" "e1ef2d5b8091f4953fe17b4ca3dd143d476c106e221d92ded38614266cea3c8b" "c4bdbbd52c8e07112d1bfd00fee22bf0f25e727e95623ecb20c4fa098b74c1bd" "f2927d7d87e8207fa9a0a003c0f222d45c948845de162c885bf6ad2a255babfd" "08a27c4cde8fcbb2869d71fdc9fa47ab7e4d31c27d40d59bf05729c4640ce834" "5b809c3eae60da2af8a8cfba4e9e04b4d608cb49584cb5998f6e4a1c87c057c4" "76bfa9318742342233d8b0b42e824130b3a50dcc732866ff8e47366aed69de11" "7546a14373f1f2da6896830e7a73674ef274b3da313f8a2c4a79842e8a93953e" "1623aa627fecd5877246f48199b8e2856647c99c6acdab506173f9bb8b0a41ac" "f4876796ef5ee9c82b125a096a590c9891cec31320569fc6ff602ff99ed73dca" "8f5a7a9a3c510ef9cbb88e600c0b4c53cdcdb502cfe3eb50040b7e13c6f4e78e" "79278310dd6cacf2d2f491063c4ab8b129fee2a498e4c25912ddaa6c3c5b621e" "ca70827910547eb99368db50ac94556bbd194b7e8311cfbdbdcad8da65e803be" "e3c64e88fec56f86b49dcdc5a831e96782baf14b09397d4057156b17062a8848" "93ed23c504b202cf96ee591138b0012c295338f38046a1f3c14522d4a64d7308" "2cdc13ef8c76a22daa0f46370011f54e79bae00d5736340a5ddfe656a767fddf" "aaa4c36ce00e572784d424554dcc9641c82d1155370770e231e10c649b59a074" "4f01c1df1d203787560a67c1b295423174fd49934deb5e6789abd1e61dba9552" "990e24b406787568c592db2b853aa65ecc2dcd08146c0d22293259d400174e37" "6b80b5b0762a814c62ce858e9d72745a05dd5fc66f821a1c5023b4f2a76bc910" "54cf3f8314ce89c4d7e20ae52f7ff0739efb458f4326a2ca075bf34bc0b4f499" "c83c095dd01cde64b631fb0fe5980587deec3834dc55144a6e78ff91ebc80b19" "7b3d184d2955990e4df1162aeff6bfb4e1c3e822368f0359e15e2974235d9fa8" "6c3b5f4391572c4176908bb30eddc1718344b8eaff50e162e36f271f6de015ca" "3df5335c36b40e417fec0392532c1b82b79114a05d5ade62cfe3de63a59bc5c6" "e6df46d5085fde0ad56a46ef69ebb388193080cc9819e2d6024c9c6e27388ba9" "c5692610c00c749e3cbcea09d61f3ed5dac7a01e0a340f0ec07f35061a716436" "039c01abb72985a21f4423dd480ddb998c57d665687786abd4e16c71128ef6ad" "f2c35f8562f6a1e5b3f4c543d5ff8f24100fae1da29aeb1864bbc17758f52b70" "75db7af5f17d4ba11559cfe7bd53ef453287b053d07f72dec716ce321def865d" "ef6d1a893cf61449dc12a86dc700a15b00eafb85954ec34c524dbca3deeacf17" "bf46e1924750ebb13e606423ddd214d470d788a29ec819dbe1bf3313ed31783f" "309338f23d97c2b056bdc19944f5d616e00fb46fa6c42b0fbe302cbaa0331b56" "a8255b88c031afb6f6983772f3aa6f75741bd6b22ae6296062d0bfe4c22ede93" "378d52c38b53af751b50c0eba301718a479d7feea5f5ba912d66d7fe9ed64c8f" "890a1a44aff08a726439b03c69ff210fe929f0eff846ccb85f78ee0e27c7b2ea" "06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "51ec7bfa54adf5fff5d466248ea6431097f5a18224788d0bd7eb1257a4f7b773" "7f1d414afda803f3244c6fb4c2c64bea44dac040ed3731ec9d75275b9e831fe5" "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "830877f4aab227556548dc0a28bf395d0abe0e3a0ab95455731c9ea5ab5fe4e1" "285d1bf306091644fb49993341e0ad8bafe57130d9981b680c1dbd974475c5c7" "00445e6f15d31e9afaa23ed0d765850e9cd5e929be5e8e63b114a3346236c44c" "13a8eaddb003fd0d561096e11e1a91b029d3c9d64554f8e897b2513dbf14b277" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "0fffa9669425ff140ff2ae8568c7719705ef33b7a927a0ba7c5e2ffcfac09b75" "f56eb33cd9f1e49c5df0080a3e8a292e83890a61a89bceeaa481a5f183e8e3ef" "b12be36f77442e77dba317814d8ca99acb7613bb9262df5737031bd4c0a6f88c" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default))
 '(ecb-options-version "2.40")
 '(flycheck-color-mode-line-face-to-color 'mode-line-buffer-id)
 '(frame-background-mode 'light)
 '(highlight-changes-colors '("#d33682" "#6c71c4"))
 '(highlight-symbol-colors
   '("#3b6b40f432d6" "#07b9463c4d36" "#47a3341e358a" "#1d873c3f56d5" "#2d86441c3361" "#43b7362d3199" "#061d417f59d7"))
 '(highlight-symbol-foreground-color "#93a1a1")
 '(hl-bg-colors
   '("#866300" "#992700" "#a7020a" "#a00559" "#243e9b" "#0061a8" "#007d76" "#5b7300"))
 '(hl-fg-colors
   '("#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36"))
 '(hl-paren-colors '("#2aa198" "#b58900" "#268bd2" "#6c71c4" "#859900"))
 '(hl-sexp-background-color "#33323e")
 '(hl-todo-keyword-faces
   '(("TODO" . "#dc752f")
     ("NEXT" . "#dc752f")
     ("THEM" . "#2d9574")
     ("PROG" . "#4f97d7")
     ("OKAY" . "#4f97d7")
     ("DONT" . "#f2241f")
     ("FAIL" . "#f2241f")
     ("DONE" . "#86dc2f")
     ("NOTE" . "#b1951d")
     ("KLUDGE" . "#b1951d")
     ("HACK" . "#b1951d")
     ("TEMP" . "#b1951d")
     ("FIXME" . "#dc752f")
     ("XXX+" . "#dc752f")
     ("\\?\\?\\?+" . "#dc752f")))
 '(ido-default-buffer-method 'selected-window)
 '(ignored-local-variable-values '((eval add-hook 'before-save-hook 'time-stamp)))
 '(indent-tabs-mode nil)
 '(initial-buffer-choice t)
 '(initial-scratch-message nil)
 '(lsp-ui-doc-border "#282828")
 '(nrepl-message-colors
   '("#dc322f" "#cb4b16" "#b58900" "#5b7300" "#b3c34d" "#0061a8" "#2aa198" "#d33682" "#6c71c4"))
 '(package-selected-packages
   '(material-theme conda csharp-mode all-the-icons clang-format gn-mode rustic lsp-ui lsp-mode flycheck doom-themes cmake-mode jinja2-mode editorconfig leuven-theme dockerfile-mode color-theme-sanityinc-tomorrow solarized-theme zenburn-theme kotlin-mode fsharp-mode yaml-mode fish-mode neotree magit yasnippet-snippets blacken spacemacs-theme minions inf-ruby typescript-mode go-snippets go-mode java-snippets yasnippet-classic-snippets python company-jedi typing-game markdown-mode clojure-mode alchemist elixir-mode powershell company-lua erlang ac-js2 web-mode scss-mode ecb color-theme coffee-mode))
 '(pos-tip-background-color "#073642")
 '(pos-tip-foreground-color "#93a1a1")
 '(python-shell-interpreter "python")
 '(rustic-cargo-bin "~/../../.cargo/bin/cargo")
 '(scroll-bar-mode nil)
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
 '(term-default-bg-color "#002b36")
 '(term-default-fg-color "#839496")
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style 'post-forward nil (uniquify))
 '(vc-annotate-background-mode nil)
 '(weechat-color-list
   '(unspecified "#002b36" "#073642" "#a7020a" "#dc322f" "#5b7300" "#859900" "#866300" "#b58900" "#0061a8" "#268bd2" "#a00559" "#d33682" "#007d76" "#2aa198" "#839496" "#657b83"))
 '(window-divider-mode nil)
 '(xterm-color-names
   ["#ebebeb" "#d6000c" "#1d9700" "#c49700" "#0064e4" "#dd0f9d" "#00ad9c" "#b9b9b9"])
 '(xterm-color-names-bright
   ["#ffffff" "#d04a00" "#878787" "#ffffff" "#474747" "#7f51d6" "#282828" "#dedede"]))
;;(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
;; '(default ((t (:inherit nil :stipple nil :background "#EDEDED" :foreground "#2E3436" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "outline" :family "Source Code Pro")))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "JetBrains Mono" :foundry "outline" :slant normal :weight regular :height 113 :width normal)))))
