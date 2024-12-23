;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
(setq doom-font (font-spec :family "Hack" :size 10 :weight 'semi-light)
      doom-variable-pitch-font (font-spec :family "Hack" :size 10))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-sora)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type nil)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/.config/doom/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; mac keybindings
(setq mac-option-modifier 'meta)
(setq mac-command-modifier 'hyper)
(setq mac-right-command-modifier 'super)
(global-set-key [(hyper a)] 'mark-whole-buffer)
(global-set-key [(hyper v)] 'yank)
(global-set-key [(hyper c)] 'kill-ring-save)
(global-set-key [(hyper x)] 'kill-region)
(global-set-key [(hyper k)] 'kill-this-buffer)
(global-set-key [(hyper s)] 'save-buffer)
(global-set-key [(hyper l)] 'goto-line)
(global-set-key [(hyper w)]
                (lambda () (interactive) (delete-window)))
(global-set-key [(hyper z)] 'undo)
(global-set-key [(hyper q)] 'save-buffers-kill-emacs)

;; fullscreen
(add-to-list 'default-frame-alist '(fullscreen . maximized))
(add-hook 'window-setup-hook 'toggle-frame-fullscreen t)

;; buffers
(global-set-key (kbd "M-l") 'ace-window)


;; env
(when (or (daemonp) (memq window-system '(mac ns x)))
  (setq exec-path-from-shell-arguments '("-l"))
  (setq exec-path-from-shell-check-startup-files nil)
  (exec-path-from-shell-initialize)
  (exec-path-from-shell-copy-env "PATH")
  (exec-path-from-shell-copy-env "GOPATH")
  (exec-path-from-shell-copy-env "LANG")
  (exec-path-from-shell-copy-env "LANGUAGE")
  (exec-path-from-shell-copy-env "LC_CTYPE")
  (exec-path-from-shell-copy-env "LC_NAME")
  (exec-path-from-shell-copy-env "LC_ALL"))


;; string
(use-package! string-inflection
  :bind (("C-c C-u" . string-inflection-all-cycle)
         ("C-c C-s" . string-inflection-underscore)))


;; multi-cursors
(use-package! multiple-cursors
  :config
  (setq mc/always-run-for-all t))


;; helm
(after! helm
        (global-set-key (kbd "C-x C-b")      'helm-buffers-list)
        (global-set-key (kbd "C-x C-d")      'helm-browse-project)
        (global-set-key (kbd "C-x C-f")      'helm-find-files)
        (global-set-key (kbd "C-s")          'helm-do-ag-this-file)

        (define-key helm-map (kbd "<tab>")   'helm-execute-persistent-action) ; rebind tab to run persistent action
        (define-key helm-map (kbd "C-i")     'helm-execute-persistent-action) ; make TAB works in terminal
        (define-key helm-map (kbd "C-z")     'helm-select-action) ; list actions using C-z
        (define-key global-map (kbd "C-o")   'helm-occur)
        (define-key global-map (kbd "M-g g") 'helm-grep-do-git-grep)

        (setq helm-ag-insert-at-point 'symbol))


;; auth
(epa-file-enable)
(setq epg-pinentry-mode 'loopback)
(setq auth-sources
    '((:source "~/.authinfo.gpg")))

;; pdf
(add-hook 'pdf-view-mode-hook
  (lambda ()
    (pdf-misc-size-indication-minor-mode)
    (pdf-links-minor-mode)
    (pdf-isearch-minor-mode)
    (pdf-view-midnight-minor-mode)
  )
)
(setq pdf-view-midnight-colors '("#74B9C3" . "#3D4C55"))

;; multi-cursor
(defun insert-rectangle-push-lines ()
  "Yank a rectangle as if it was an ordinary kill."
  (interactive "*")
  (when (and (use-region-p) (delete-selection-mode))
    (delete-region (region-beginning) (region-end)))
  (save-restriction
    (narrow-to-region (point) (mark))
    (yank-rectangle)))

(global-set-key (kbd "C-x r C-y") #'insert-rectangle-push-lines)


;; dired
(use-package! dired-ranger
  :bind (:map dired-mode-map
              ("W" . dired-ranger-copy)
              ("X" . dired-ranger-move)
              ("Y" . dired-ranger-paste)))

;; rss
(after! elfeed
  (add-hook 'elfeed-search-mode-hook #'elfeed-update)
  (setq elfeed-search-filter "@1-month-ago +unread")
  (setq elfeed-show-entry-switch #'my/elfeed-show-entry
        elfeed-show-entry-delete #'my/elfeed-kill-buffer)
  (defun my/elfeed-show-entry (buff)
    (popwin:popup-buffer buff
                         :position 'right
                         :width 0.5
                         :dedicated t
                         :stick t))
  (defun my/elfeed-kill-buffer ()
    (interactive)
    (let ((window (get-buffer-window (get-buffer "*elfeed-entry*"))))
      (kill-buffer (get-buffer "*elfeed-entry*"))
      (delete-window window))))


;; ollama
(defvar llm-local-chat-model "llama3.2:latest"
  "Default local model to use for chat.")

(defvar llm-local-embedding-model "nomic-embed-text"
  "Default local model to use for embeddings.")

(use-package! ellama
  :defer t
  :init
  (require 'llm-ollama)
  (require 'llm-openai)
  (setopt ellama-enable-keymap t
          ellama-keymap-prefix "C-|"
          ellama-auto-scroll t)

  (setopt ellama-language "English")
  (setopt ellama-provider
          (make-llm-ollama
           :chat-model llm-local-chat-model
           :embedding-model llm-local-embedding-model))
  (setopt ellama-user-nick (car (string-split user-full-name)))
  (setopt ellama-providers
          '(("llama3.1"  . (make-llm-ollama
                            :chat-model llm-local-chat-model
                            :embedding-model llm-local-embedding-model))
            ("llama3.2"  . (make-llm-ollama
                            :chat-model "llama3.2:latest"
                            :embedding-model llm-local-embedding-model))
            ("codestral" . (make-llm-ollama
                            :chat-model "codestral:latest"
                            :embedding-model llm-local-embedding-model))
            ("mistral"   . (make-llm-ollama
                            :chat-model "mistral:latest"
                            :embedding-model llm-local-embedding-model))
            ("nemo"      . (make-llm-ollama
                            :chat-model "mistral-nemo:latest"
                            :embedding-model llm-local-embedding-model))
            ("codestral" . (make-llm-ollama
                            :chat-model "codestral"
                            :embedding-model llm-local-embedding-model))
            ("aya"       . (make-llm-ollama
                            :chat-model "aya"
                            :embedding-model llm-local-embedding-model))))
  (setopt ellama-naming-provider
          (make-llm-ollama
           :chat-model llm-local-chat-model
           :embedding-model llm-local-embedding-model))
  (setopt ellama-naming-scheme 'ellama-generate-name-by-llm)
  (setopt ellama-translation-provider (make-llm-ollama
                                       :chat-model "llama3.2"
                                       :embedding-model llm-local-embedding-model)))



;; gptel
(use-package! gptel
 :defer
 :config
 (defun my/gptel-api-key (host)
   (let ((secret (auth-source-pick-first-password
                  :host host)))
     secret))
 (setq
  gptel-default-mode 'org-mode
  gptel-model 'claude-3-5-sonnet-20241022
  gptel-backend (gptel-make-anthropic "Claude"
                                      :stream t :key (my/gptel-api-key "api.anthropic.com"))))

;; git
(use-package! browse-at-remote
  :config
  (global-set-key (kbd "C-c g g") 'browse-at-remote)
  (add-to-list 'browse-at-remote-remote-type-regexps
               '(:host "code.byted.org" :type "gitlab")))

;; go
(use-package! go-mode
  :init
  (setq gofmt-command "goimports")
  (add-hook 'before-save-hook 'gofmt-before-save))

(use-package! go-playground
  :custom
  (go-playground-basedir "~/Go/src/playground"))


;; py
(use-package! lsp-pyright
  :custom (lsp-pyright-langserver-command "pyright")
  :hook (python-mode . (lambda ()
                         (require 'lsp-pyright)
                         (lsp))))

(after! python
  (setq flycheck-python-ruff-executable "ruff")
  (setq-hook! 'python-mode-hook +format-with 'ruff))

(use-package! reformatter
  :config
  (reformatter-define ruff-format
    :program "ruff"
    :args '("format" "-"))
  (add-hook 'python-mode-hook #'ruff-format-on-save-mode))


;; json
;; require jq preinstalled
(defun json-unpretty-print (beg end)
  (interactive "r")
  (shell-command-on-region beg end "jq -c ." nil t))


;; epub
(add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))


;; highlight symbols
(use-package! symbol-overlay
  :bind (("M-i" . symbol-overlay-put)
         ("M-n" . symbol-overlay-switch-forward)
         ("M-p" . symbol-overlay-switch-backward)
         ("<f7>" . symbol-overlay-mode)
         ("<f8>" . symbol-overlay-remove-all)))

;; thrift
(after! thrift
  (setq thrift-indent-level 4))


;; utils
(defun func-region (start end func)
  "run a function over the region between START and END in current buffer."
  (save-excursion
    (let ((text (delete-and-extract-region start end)))
      (insert (funcall func text)))))

(defun url-encode-region (start end)
  "urlencode the region between START and END in current buffer."
  (interactive "r")
  (func-region start end #'url-hexify-string))

(defun url-decode-region (start end)
  "de-urlencode the region between START and END in current buffer."
  (interactive "r")
  (func-region start end #'url-unhex-string))
