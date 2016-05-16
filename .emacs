;; in case of slow display update: -q -xrm Emacs.FontBackend:gdi
;; C-x C-- or + to zoom

;;; UNCOMMENT THIS TO DEBUG TROUBLE GETTING EMACS UP AND RUNNING.
;;; (setq debug-on-error t)

;; ----------------------------------------
;; shortcuts
(global-set-key "\M-n" 'revert-buffer)
(global-set-key "\C-c\C-a" 'auto-revert-tail-mode)
(global-set-key "\C-c\C-r" 'recompile)

;;(global-set-key  "\C-w" 'backward-kill-word)
;; ----------------------------------------
(setq exec-path (append exec-path '("D:/tools/mingw/msys/1.0/bin" "D:/tools/mingw/bin" "D:/tools/GnuWin32/bin")))
(setenv "PATH" (concat (expand-file-name "D:/tools/mingw/msys/1.0/bin") path-separator (expand-file-name "D:/tools/mingw/bin") path-separator (expand-file-name "D:/tools/GnuWin32/bin") path-separator (getenv "PATH")))
(require 'package)
(package-initialize)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
;;load path
(add-to-list 'load-path "D:/tools/emacsInc")

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
              auto-mode-alist))

;;-------------------------------------------
;; set default height
(setq default-frame-alist ' (
			     (user-size . t)
			     (height . 50)
                             (width . 85)
			     ))
(setq initial-frame-alist '(
                            (top . 10)
                            (left . 10)
                            ))
(set-background-color "grey97")

(when (window-system)
  (tool-bar-mode -1))
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
 
(when window-system 
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
(add-hook 'org-mode-hook 'turn-on-font-lock) ; not needed when global-font-lock-mode is on
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
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
;; does not work with skewer-html-mode
;;(add-to-list 'auto-mode-alist '("\\.html\\'" . web-mode))

;; skewer does only work with sgml
;;(add-hook 'web-mode-hook 'skewer-html-mode)
(add-hook 'web-mode-hook 'company-mode)

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
(setq racer-rust-src-path "d:/progra/rust/rust/src/")
(require 'company-racer)
(with-eval-after-load 'company
  (add-to-list 'company-backends 'company-racer))

(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)

(add-hook 'racer-mode-hook #'company-mode)
(global-set-key (kbd "TAB") #'company-indent-or-complete-common)
(setq company-tooltip-align-annotations t)

;; javascript
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(setq ac-js2-evaluate-calls t)
(add-hook 'js2-mode-hook 'ac-js2-mode)
(add-hook 'js2-mode-hook 'skewer-mode)
(add-hook 'js2-mode-hook 'company-mode)

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

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(c-default-style
   (quote
    ((java-mode . "java")
     (awk-mode . "awk")
     (other . "java"))))
 '(custom-enabled-themes (quote (adwaita)))
 '(ecb-options-version "2.40")
 '(ido-default-buffer-method (quote selected-window))
 '(indent-tabs-mode nil)
 '(initial-buffer-choice t)
 '(package-selected-packages
   (quote
    (ac-js2 company-racer racer yasnippet web-mode scss-mode rust-mode ecb csharp-mode color-theme coffee-mode)))
 '(uniquify-buffer-name-style (quote post-forward) nil (uniquify)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#EDEDED" :foreground "#2E3436" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 113 :width normal :foundry "outline" :family "Source Code Pro")))))
