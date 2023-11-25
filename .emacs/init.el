(setq inhibit-startup-message t)


;; straight
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage)  )
;;
(when (memq window-system '(mac ns x))
  (exec-path-from-shell-initialize))

(scroll-bar-mode -1) ;;disable scrollbar
(tool-bar-mode -1)   ;; disable toolbar
(tooltip-mode -1)    ;; disable tooltips
(set-fringe-mode 10) ;; give some breathing room ?

(setq-default indent-tabs-mode nil)
(setq-default tab-width 2)
(setq evil-shift-width 2)
(setq indent-line-function 'insert-tab)

(setq visible-bell t)

(require 'package)
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)

;; definitions for packages


(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; General settings
(delete-selection-mode t)
(setq gc-cons-threshold 100000000)
(setq read-process-output-max (* 1024 1024)) ;; 1mb
(setq auto-save-default nil)
(setq make-backup-files nil)
(setq create-lockfiles nil)
(global-display-line-numbers-mode)


(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :config
  (ivy-mode 1))
;; projectile




;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

;; doom modeline
;; (use-package doom-modeline
;;   :ensure t
;;   :init (doom-modeline-mode 1))

;; mode line

(use-package minions
  :ensure t)

(use-package mood-line
  :demand t
  :init
  (mood-line-mode)
  :hook
  (mood-line-mode . minions-mode))
(setq mood-line-glyph-alist mood-line-glyphs-fira-code)

(when (autoloadp (symbol-function 'glasses-mode))
  (cl-pushnew 'glasses-mode minor-mode-list))


;; config
(column-number-mode)
(global-display-line-numbers-mode t)
(setq display-line-numbers-type 'relative)

;; number line not in treemacs;org;terminal;eshell
(dolist (mode '(org-mode-hook
		            term-mode-hook
		            treemacs-mode-hook
                neotree-mode-hook
                vterm-mode-hook
		            eshell-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))


(setq split-height-threshold nil)
(setq split-width-threshold 0)

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :init (which-key-mode)
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.3))

(use-package counsel
  :init (counsel-mode 1)
  :bind (:map minibuffer-local-map ("C-r" . 'counsel-minibuffer-history)))

(use-package flx
  :ensure t)

(use-package ivy-rich
  :init
  (ivy-rich-mode 1))

(use-package helpful
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(use-package doom-themes
  :ensure t
  :config
  ;; Global settings (defaults)
  (setq doom-themes-enable-bold t ; if nil, bold is universally disabled
        doom-themes-enable-italic t) ; if nil, italics is universally disabled
  (load-theme 'doom-gruvbox t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)
  ;; Enable custom neotree theme (all-the-icons must be installed!)
  ;; (doom-themes-neotree-config)
  ;; or for treemacs users
  ;; (setq doom-themes-treemacs-theme "doom-colors") ; use "doom-colors" for less minimal icon theme
  ;; (doom-themes-treemacs-config)
  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config))

(use-package all-the-icons :ensure t)

(use-package general
  :config
  (general-evil-setup t)
  (general-create-definer rune/leader-keys
		:keymaps '(normal insert visual emacs)
		:prefix "SPC"
		:global-prefix "C-SPC")
  (rune/leader-keys
    "s" '(lsp-ivy-workspace-symbol :which-key "symbol lookout")
    "t" '(:ignore t :which-key "toggles")
    "q" '(gpt-dwim :which-key "open gpt")
    "p" '(neotree-project-dir :which-key "open treemacs here")
    "c" '(compile :which-key "compile it")
    "tt" '(counsel-load-theme :which-key "choose theme")))

;; evil

(use-package evil
  :init
  (setq evil-want-integration t)
  (setq evil-want-keybinding nil)
  (setq evil-want-C-u-scroll t)
  (setq evil-want-C-d-scroll t)
  (setq evil-want-C-i-jump nil)
  :config
  (evil-mode 1)
  (define-key evil-insert-state-map (kbd "C-g") 'evil-normal-state)
  (define-key evil-insert-state-map (kbd "C-h") 'evil-delete-backward-char-and-join)

  ;; Use visual line motions even outside of visual-line-mode buffers
  (evil-global-set-key 'motion "j" 'evil-next-visual-line)
  (evil-global-set-key 'motion "k" 'evil-previous-visual-line)

  (evil-set-initial-state 'messages-buffer-mode 'normal)
  (evil-set-initial-state 'dashboard-mode 'normal))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; config of serach mode
(setq search-default-mode #'char-fold-to-regexp)



(use-package magit
  :commands (magit-status magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))


;; lsp-mode
(use-package lsp-mode
  :hook ((c-mode          ; clangd
          c-or-c++-mode   ; clangd
          js-mode         ; ts-ls (tsserver wrapper)
          js-jsx-mode     ; ts-ls (tsserver wrapper)
          typescript-mode ; ts-ls (tsserver wrapper)
          python-mode     ; pyright
          web-mode        ; ts-ls/HTML/CSS
          ) . lsp-deferred)
  :commands lsp
  :config
  (global-set-key (kbd "C-.") #'lsp-ui-peek-find-definitions)
  (setq lsp-auto-guess-root t)
  (setq lsp-keymap-prefix "C-c l")
  (setq lsp-log-io nil)
  (setq lsp-restart 'auto-restart)
  (setq lsp-enable-symbol-highlighting nil)
  (setq lsp-enable-on-type-formatting nil)
  (setq lsp-signature-auto-activate nil)
  (setq lsp-signature-render-documentation nil)
  (setq lsp-eldoc-hook nil)
  (setq lsp-modeline-code-actions-enable nil)
  (setq lsp-modeline-diagnostics-enable nil)
  (setq lsp-headerline-breadcrumb-enable nil)
  (setq lsp-semantic-tokens-enable nil)
  (setq lsp-enable-folding nil)
  (setq lsp-enable-imenu nil)
  (setq lsp-enable-snippet nil)
  (setq read-process-output-max (* 1024 1024)) ;; 1MB
  (setq lsp-idle-delay 0.5))



(use-package lsp-ui
  :commands lsp-ui-mode
  :config
  (setq lsp-ui-doc-enable nil)
  (setq lsp-ui-doc-header t)
  (setq lsp-ui-doc-include-signature t)
  (setq lsp-ui-doc-border (face-foreground 'default))
  (setq lsp-ui-sideline-show-code-actions t)
  (setq lsp-ui-sideline-delay 0.05))


(defun enable-minor-mode (my-pair)
  "Enable minor mode if filename match the regexp.  MY-PAIR is a cons cell (regexp . minor-mode)."
  (if (buffer-file-name)
      (if (string-match (car my-pair) buffer-file-name)
	        (funcall (cdr my-pair)))))

;; tree siter
(use-package tree-sitter
  :ensure t
  :config
  ;; activate tree-sitter on any buffer containing code for which it has a parser available
  (global-tree-sitter-mode)
  ;; you can easily see the difference tree-sitter-hl-mode makes for python, ts or tsx
  ;; by switching on and off
  (add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode))

(use-package tree-sitter-langs
  :ensure t
  :after tree-sitter)

;; company
(setq company-minimum-prefix-length 1
      company-idle-delay 0.0)
(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
              ("<tab>" . company-complete-selection))
  (:map lsp-mode-map
        ("<tab>" . company-indent-or-complete-common))
  :config
  (progn
    (setq company-idle-delay 0.2
	        ;; min prefix of 2 chars
	        company-minimum-prefix-length 2
	        company-selection-wrap-around t
	        company-show-numbers t
	        company-dabbrev-downcase nil
	        company-echo-delay 0
	        company-tooltip-limit 20
	        company-transformers '(company-sort-by-occurrence)
	        company-begin-commands '(self-insert-command)
	        )
    (global-company-mode)))

;; (use-package lsp-treemacs
;;   :after lsp)

(use-package neotree
  :ensure t)
(setq neo-smart-open t)
(setq projectile-switch-project-action 'neotree-projectile-action)

(defun neotree-project-dir ()
  "Open NeoTree using the git root."
  (interactive)
  (let ((project-dir (projectile-project-root))
        (file-name (buffer-file-name)))
    (neotree-toggle)
    (if project-dir
        (if (neo-global--window-exists-p)
            (progn
              (neotree-dir project-dir)
              (neotree-find file-name)))
      (message "Could not find git project root."))))


;; (setq doom-themes-treemacs-enable-variable-pitch nil)

(use-package lsp-ivy)


(use-package git-gutter
  :hook (prog-mode . git-gutter-mode)
  :config
  (setq git-gutter:update-interval 0.02))

(use-package git-gutter-fringe
  :config
  (define-fringe-bitmap 'git-gutter-fr:added [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:modified [224] nil nil '(center repeated))
  (define-fringe-bitmap 'git-gutter-fr:deleted [128 192 224 240] nil nil 'bottom))


(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))


(use-package highlight-indent-guides
  :ensure t
  :hook (prog-mode  . highlight-indent-guides-mode ))


(set-frame-font "mononoki 14" nil t)

(use-package dap-mode
  :ensure t)

(setq lsp-headerline-breadcrumb-enable-diagnostics nil)

(use-package copilot
  :straight (:host github :repo "zerolfx/copilot.el" :files ("dist" "*.el"))
  :ensure t)


;; lisp
(use-package racket-mode)

(use-package slime)
(setq inferior-lisp-program "sbcl")
(autoload 'enable-paredit-mode "paredit" "Turn on pseudo-structural editing of Lisp code." t)
(add-hook 'emacs-lisp-mode-hook       #'enable-paredit-mode)
(add-hook 'eval-expression-minibuffer-setup-hook #'enable-paredit-mode)
(add-hook 'ielm-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-mode-hook             #'enable-paredit-mode)
(add-hook 'lisp-interaction-mode-hook #'enable-paredit-mode)
(add-hook 'racket-mode-hook           #'enable-paredit-mode)
(add-hook 'racket-repl-mode-hook           #'enable-paredit-mode)
(add-hook 'scheme-mode-hook           #'enable-paredit-mode)
(add-hook 'slime-repl-mode-hook (lambda () (paredit-mode +1)))
;; Stop SLIME's REPL from grabbing DEL,
;; which is annoying when backspacing over a '('

(defun override-slime-repl-bindings-with-paredit ()
  (define-key slime-repl-mode-map
    (Read-kbd-macro paredit-backward-delete-key) nil))
(add-hook 'slime-repl-mode-hook 'override-slime-repl-bindings-with-paredit)
(setq inferior-lisp-program "clisp")


;; projectile
;; (use-package projectile
;;   :ensure t
;;   :init
;;   (projectile-mode +1)
;;   :bind (:map italic projectile-mode-map
;;               ("s-p" . projectile-command-map)
;;               ("C-c p" . projectile-command-map)))
;; (setq projectile-project-search-path '("~/Projects/" ))


;; json-mode
(use-package json-mode
  :ensure t)

;; web-mode
(setq-default tab-width 2)
(setq indent-tabs-mode nil)

(defun luke/webmode-hook ()
	"Webmode hooks."
	(setq web-mode-enable-comment-annotation t)
	(setq web-mode-markup-indent-offset 2)
	(setq web-mode-code-indent-offset 2)
	(setq web-mode-css-indent-offset 2)
	(setq web-mode-attr-indent-offset 0)
	(setq web-mode-enable-auto-indentation t)
	(setq web-mode-enable-auto-closing t)
	(setq web-mode-enable-auto-pairing t)
	(setq web-mode-enable-css-colorization t)
)

(use-package add-node-modules-path
  :ensure t)

(use-package web-mode
  :ensure t
  :mode (("\\.jsx?\\'" . web-mode)
	       ("\\.tsx?\\'" . web-mode)
	       ("\\.html\\'" . web-mode))
  :commands web-mode
	:hook (web-mode . luke/webmode-hook)
  )
(use-package prettier-js
  :ensure t)
  (add-hook 'web-mode-hook #'(lambda ()
                             (enable-minor-mode
                              '("\\.jsx?\\'" . prettier-js-mode))
			     (enable-minor-mode
                              '("\\.tsx?\\'" . prettier-js-mode))))



;; request functions
(defun make-request ()
  (interactive)
  (let ((request-buffer (get-buffer "*request*"))
        (response-buffer (get-buffer-create "*response*"))
        method url headers body curl-command)

    ;; Check if the request buffer exists
    (if (not request-buffer)
        (error "Request buffer *request* does not exist")
      ;; Parse the request buffer
      (with-current-buffer request-buffer
        (goto-char (point-min))
        ;; Parse method and URL
        (unless (looking-at "\\(GET\\|POST\\|PUT\\|DELETE\\|UPDATE\\) \\(http[^ \n]+\\)")
          (error "Invalid request format: Method and URL not found"))
        (setq method (match-string 1))
        (setq url (match-string 2))
        
        ;; Move to the next line
        (forward-line 1)

        ;; Initialize default headers
        (setq headers '("Content-Type: application/json"))

        ;; Parse body
        (when (re-search-forward "body: " nil t)
          (forward-line)
          (setq body (buffer-substring-no-properties (point) (point-max))))

        ;; Prepare the curl command
        (setq curl-command
              (append
               (list "curl" "-X" method (format "'%s'" url))
               (mapcan (lambda (h) (list "--header" (format "'%s'" h))) headers)
               (when body (list "--data" (format "'{%s'" body)))))

        ;; Print the curl command for debugging
        (with-current-buffer response-buffer
          (goto-char (point-max))
          (insert (format "\nCurl command:\n%s\n" (mapconcat 'identity curl-command " ")))
          (display-buffer response-buffer))

        ;; Make the curl request
        (let ((output (shell-command-to-string (mapconcat 'identity curl-command " "))))
          (with-current-buffer response-buffer
            (goto-char (point-max))
            (insert (format "\nResponse:\n%s" output))))))))
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
  '("e3daa8f18440301f3e54f2093fe15f4fe951986a8628e98dcd781efbec7a46f2" "4363ac3323e57147141341a629a19f1398ea4c0b25c79a6661f20ffc44fdd2cb" default))
 '(mood-line-glyph-alist
  '((:checker-info . 8627)
    (:checker-issues . 8594)
    (:checker-good . 10003)
    (:checker-checking . 10227)
    (:checker-errored . 120)
    (:checker-interrupted . 61)
    (:vc-added . 43)
    (:vc-needs-merge . 10231)
    (:vc-needs-update . 8595)
    (:vc-conflict . 120)
    (:vc-good . 10003)
    (:buffer-narrowed . 9698)
    (:buffer-modified . 9679)
    (:buffer-read-only . 9632)
    (:count-separator . 215))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
