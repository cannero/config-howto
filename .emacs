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
(setq exec-path (append exec-path '("C:/tools/Ruby27-x64/msys64/usr/bin" "C:/tools/Ruby27-x64/msys64/mingw64/bin" "C:/Users/nile/AppData/Local/Programs/Python/Python37/Scripts")))
(setenv "PATH" (concat (expand-file-name "C:/tools/Ruby27-x64/msys64/usr/bin") path-separator (expand-file-name "C:/tools/Ruby27-x64/msys64/mingw64/bin") path-separator (expand-file-name "C:/Users/nile/AppData/Local/Programs/Python/Python37/Scripts") path-separator (getenv "PATH")))
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
(autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
(setq auto-mode-alist
      (append '(("\\.cs$" . csharp-mode)) auto-mode-alist))
(defun my-csharp-mode-fn ()
  "my function that runs when csharp-mode is initialized for a buffer."
  (setq-default c-basic-offset 4
				tab-width 4
				indent-tabs-mode nil)
  (c-set-offset 'substatement-open 0))

(add-hook  'csharp-mode-hook 'my-csharp-mode-fn t)

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
;;(setq org-agenda-files (list "D:/usr/orgFiles/Yazaki.org"
;;                             "D:/usr/orgFiles/withoutProject.org")
;;      )

(org-babel-do-load-languages
     'org-babel-load-languages
     '((ditaa . t)
       (plantuml . t))) ; this line activates ditaa

(setq org-plantuml-jar-path
      (expand-file-name
       "plantuml.jar"
       (file-name-as-directory
        (expand-file-name
         "scripts"
         (file-name-as-directory
          (expand-file-name
           "../contrib"
           (file-name-directory (org-find-library-dir "org"))
           ))))))
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
;;also the environment variable RUST_SRC_PATH has to be set
;;todo use rustup for src
;;(setq racer-rust-src-path "d:/progra/rust/rust/src/")
(require 'company-racer)
(with-eval-after-load 'company
  (add-to-list 'company-backends 'company-racer))
(defun my-rust-mode-hook ()
  (racer-mode)
  (cargo-minor-mode)
  ;;buffer local
  (add-hook 'before-save-hook 'rust-format-buffer nil t)
  (set (make-local-variable 'compile-command)
       (concat "rustc "
               (shell-quote-argument buffer-file-name))))

(add-hook 'rust-mode-hook #'my-rust-mode-hook)
(add-hook 'racer-mode-hook #'eldoc-mode)

(add-hook 'racer-mode-hook #'company-mode)
(global-set-key (kbd "TAB") #'company-indent-or-complete-common)
(setq company-tooltip-align-annotations t)
(setq company-selection-wrap-around t)

;; javascript
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
  (local-set-key (kbd "TAB") #'company-complete-common)
  (local-set-key (kbd "<backtab>") #'company-indent-or-complete-common)
  ;;not working with msys python
  ;;(blacken-mode)
  )
(add-hook 'python-mode-hook 'my-python-mode-hook)

(defcustom python-shell-interpreter "python3"
  "Default Python interpreter for shell."
  :type 'string
  :group 'python)

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

;;octave and matlab
(add-to-list 'auto-mode-alist '("\\.m$" . octave-mode))

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

;; do not load on startup, takes 25 seconds
;; (require 'ox-confluence)

;;ediff
(defun ediff-copy-both-to-C ()
  (interactive)
  (ediff-copy-diff ediff-current-difference nil 'C nil
                   (concat
                    (ediff-get-region-contents ediff-current-difference 'A ediff-control-buffer)
                    (ediff-get-region-contents ediff-current-difference 'B ediff-control-buffer))))
(defun add-d-to-ediff-mode-map () (define-key ediff-mode-map "d" 'ediff-copy-both-to-C))
(add-hook 'ediff-keymap-setup-hook 'add-d-to-ediff-mode-map)

(minions-mode)

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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(beacon-color "#c82829")
 '(c-default-style '((java-mode . "java") (awk-mode . "awk") (other . "java")))
 '(column-number-mode t)
 '(company-quickhelp-color-background "#4F4F4F")
 '(company-quickhelp-color-foreground "#DCDCCC")
 '(compilation-message-face 'default)
 '(csharp-want-imenu nil)
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#839496")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-enabled-themes nil)
 '(custom-safe-themes
   '("06f0b439b62164c6f8f84fdda32b62fb50b6d00e8b01c2208e55543a6337433a" "628278136f88aa1a151bb2d6c8a86bf2b7631fbea5f0f76cba2a0079cd910f7d" "bb08c73af94ee74453c90422485b29e5643b73b05e8de029a6909af6a3fb3f58" "1b8d67b43ff1723960eb5e0cba512a2c7a2ad544ddb2533a90101fd1852b426e" "82d2cac368ccdec2fcc7573f24c3f79654b78bf133096f9b40c20d97ec1d8016" "51ec7bfa54adf5fff5d466248ea6431097f5a18224788d0bd7eb1257a4f7b773" "7f1d414afda803f3244c6fb4c2c64bea44dac040ed3731ec9d75275b9e831fe5" "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "830877f4aab227556548dc0a28bf395d0abe0e3a0ab95455731c9ea5ab5fe4e1" "285d1bf306091644fb49993341e0ad8bafe57130d9981b680c1dbd974475c5c7" "00445e6f15d31e9afaa23ed0d765850e9cd5e929be5e8e63b114a3346236c44c" "13a8eaddb003fd0d561096e11e1a91b029d3c9d64554f8e897b2513dbf14b277" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "0fffa9669425ff140ff2ae8568c7719705ef33b7a927a0ba7c5e2ffcfac09b75" "f56eb33cd9f1e49c5df0080a3e8a292e83890a61a89bceeaa481a5f183e8e3ef" "b12be36f77442e77dba317814d8ca99acb7613bb9262df5737031bd4c0a6f88c" "fa2b58bb98b62c3b8cf3b6f02f058ef7827a8e497125de0254f56e373abee088" "bffa9739ce0752a37d9b1eee78fc00ba159748f50dc328af4be661484848e476" default))
 '(ecb-options-version "2.40")
 '(fci-rule-color "#d6d6d6")
 '(flycheck-color-mode-line-face-to-color 'mode-line-buffer-id)
 '(frame-background-mode 'light)
 '(highlight-changes-colors '("#d33682" "#6c71c4"))
 '(highlight-symbol-colors
   '("#3b6b40f432d6" "#07b9463c4d36" "#47a3341e358a" "#1d873c3f56d5" "#2d86441c3361" "#43b7362d3199" "#061d417f59d7"))
 '(highlight-symbol-foreground-color "#93a1a1")
 '(highlight-tail-colors
   '(("#073642" . 0)
     ("#5b7300" . 20)
     ("#007d76" . 30)
     ("#0061a8" . 50)
     ("#866300" . 60)
     ("#992700" . 70)
     ("#a00559" . 85)
     ("#073642" . 100)))
 '(hl-bg-colors
   '("#866300" "#992700" "#a7020a" "#a00559" "#243e9b" "#0061a8" "#007d76" "#5b7300"))
 '(hl-fg-colors
   '("#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36"))
 '(hl-paren-colors '("#2aa198" "#b58900" "#268bd2" "#6c71c4" "#859900"))
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
 '(indent-tabs-mode nil)
 '(initial-buffer-choice t)
 '(initial-scratch-message nil)
 '(lsp-ui-doc-border "#93a1a1")
 '(nrepl-message-colors
   '("#dc322f" "#cb4b16" "#b58900" "#5b7300" "#b3c34d" "#0061a8" "#2aa198" "#d33682" "#6c71c4"))
 '(package-selected-packages
   '(dockerfile-mode color-theme-sanityinc-tomorrow solarized-theme zenburn-theme kotlin-mode fsharp-mode yaml-mode fish-mode neotree magit racer yasnippet-snippets blacken spacemacs-theme minions inf-ruby typescript-mode go-snippets go-mode java-snippets yasnippet-classic-snippets python company-jedi cargo typing-game markdown-mode clojure-mode alchemist elixir-mode powershell company-lua erlang ac-js2 company-racer web-mode scss-mode ecb color-theme coffee-mode))
 '(pdf-view-midnight-colors '("#b2b2b2" . "#292b2e"))
 '(pos-tip-background-color "#073642")
 '(pos-tip-foreground-color "#93a1a1")
 '(scroll-bar-mode nil)
 '(show-paren-mode t)
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
 '(term-default-bg-color "#002b36")
 '(term-default-fg-color "#839496")
 '(tool-bar-mode nil)
 '(uniquify-buffer-name-style 'post-forward nil (uniquify))
 '(vc-annotate-background nil)
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   '((20 . "#c82829")
     (40 . "#f5871f")
     (60 . "#eab700")
     (80 . "#718c00")
     (100 . "#3e999f")
     (120 . "#4271ae")
     (140 . "#8959a8")
     (160 . "#c82829")
     (180 . "#f5871f")
     (200 . "#eab700")
     (220 . "#718c00")
     (240 . "#3e999f")
     (260 . "#4271ae")
     (280 . "#8959a8")
     (300 . "#c82829")
     (320 . "#f5871f")
     (340 . "#eab700")
     (360 . "#718c00")))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   '(unspecified "#002b36" "#073642" "#a7020a" "#dc322f" "#5b7300" "#859900" "#866300" "#b58900" "#0061a8" "#268bd2" "#a00559" "#d33682" "#007d76" "#2aa198" "#839496" "#657b83"))
 '(window-divider-mode nil)
 '(xterm-color-names
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#eee8d5"])
 '(xterm-color-names-bright
   ["#002b36" "#cb4b16" "#586e75" "#657b83" "#839496" "#6c71c4" "#93a1a1" "#fdf6e3"]))
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
 '(default ((t (:inherit nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "outline" :family "Source Code Pro")))))
