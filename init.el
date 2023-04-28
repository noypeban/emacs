;; デバッグ用
(setq debug-on-error t
      init-file-debug t)

;; leafのインストール
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))
(package-initialize)
(unless (package-installed-p 'leaf)
    (package-refresh-contents)
    (package-install 'leaf))

(leaf leaf-keywords
    :ensure t
    :init
    ;; optional packages if you want to use :hydra, :el-get, :blackout,,,
    (leaf hydra :ensure t)
    (leaf el-get :ensure t)
    (leaf blackout :ensure t)
    (leaf diminish :ensure t)

    :config
    ;; initialize leaf-keywords.el
    (leaf-keywords-init))

(leaf leaf-tree :ensure t)
(leaf leaf-convert :ensure t)

;; custom
(leaf cus-edit
  :doc "tools for customizing Emacs and Lisp packages"
  :tag "builtin" "faces" "help"
  :custom `((custom-file . ,(locate-user-emacs-file "custom.el"))))

(leaf cus-start
  :doc "define customization properties of builtins"
  :tag "builtin" "internal"
  :custom (
           ;; UI
           (menu-bar-mode . nil)
           (tool-bar-mode . nil)
           (scroll-bar-mode . nil)
	       (frame-resize-pixelwise . t)
           (enable-recursive-minibuffers . t)
           ;; startup
           (inhibit-startup-screen . t)
           (inhibit-startup-message . t)
           (inhibit-startup-echo-area-message . t)
           ;; tab
	       (indent-tabs-mode . nil)
           (tab-width . 4)
           ;; scroll
           (scroll-preserve-screen-position . t)
           (scroll-conservatively . 100)
           (ring-bell-function . 'ignore)
           ;; アポストロフィーが変換されないようにする
           (text-quoting-style . 'straight)
           ;; non-nil: 右端を越えた行を$で示す
           (truncate-lines . nil)
	       ;; history
           (recentf-mode . t)
           (savehist-mode . t)
	       (history-length . 1000)
           (history-delete-duplicates . t)
	       (create-lockfiles . nil)
           ;; tab bar
           ;; (tab-bar-mode . 1)
           ;; (tab-bar-new-tab-choice . "*scratch*")
           
           (select-enable-primary . t)
           ;; (select-enable-clipboard . t)
           
           ;; Exclude ".lib" from completion-ignored-extensions
	       (completion-ignored-extensions
            . `,(delete ".lib" completion-ignored-extensions)))
  :config
  (defalias 'yes-or-no-p 'y-or-n-p))

(leaf myBindkeys
  :bind (("C-x C-f" . 'find-file-at-point)
         ("C-x C-r" . 'recentf-open-files)
	     ;; move buffer
	     ("<kanji> <tab>" . 'hydra-tab-move-buffer/iflipb-next-buffer)
         ("<kanji> <backtab>" . 'hydra-tab-move-buffer/iflipb-previous-buffer)
	     ;; close current buffer
	     ("<kanji> k" . (lambda ()
                          (interactive)
                          (message "Kill buffer.")
                          (kill-buffer)))
	     ;; open buffer
	     ("<kanji> s" . (lambda ()
			              (interactive)
			              (switch-to-buffer "*scratch*")))
         ("<kanji> i" . (lambda ()
                          (interactive)
                          (let ((path "~/.config/emacs/init.el"))
                            (switch-to-buffer
                             (find-file-noselect path))
                            (message "Open `%s'." path))))
         ;; insert current day
         ("<kanji> d" . (lambda ()
                          (interactive)
                          (insert (format-time-string "%Y/%m/%d" (current-time)))))
         ;; yank current file's path
         ("<kanji> n" . (lambda ()
                          (interactive)
                          (let ((path (file-truename buffer-file-name)))
                            (kill-new path)
                            (message "Yank `%s'." path))))))

(leaf which-key
  :doc "Display available keybindings in popup"
  :req "emacs-24.4"
  :tag "emacs>=24.4"
  :url "https://github.com/justbur/emacs-which-key"
  :added "2023-04-15"
  :emacs>= 24.4
  :ensure t)

(leaf iflipb
  :doc "Interactively flip between recently visited buffers"
  :url "https://github.com/jrosdahl/iflipb"
  :added "2022-12-21"
  :ensure t
  :custom
  ;; persp-modeのbuffer listを使う
  (iflipb-buffer-list-function . 'persp-buffer-list-restricted)
  (iflipb-wrap-around . t)
  :hydra (hydra-tab-move-buffer
          ()
          "Tab move buffer"
          ("<tab>" iflipb-next-buffer "next buffer")
          ("<backtab>" iflipb-previous-buffer "previous buffer")
          )
  )

(leaf fullscreen
  :custom
  ((initial-frame-alist quote
				        ((fullscreen . maximized)))))

;; theme
(leaf modus-themes
  :doc "Elegant, highly legible and customizable themes"
  :req "emacs-27.1"
  :tag "accessibility" "theme" "faces" "emacs>=27.1"
  :url "https://git.sr.ht/~protesilaos/modus-themes"
  :added "2023-04-03"
  :emacs>= 27.1
  :custom
  (modus-themes-italic-constucts . t)
  (modus-themes-bold-constructs . t)
  :config
  (load-theme 'modus-vivendi :no-confirm)
  )

(leaf powerline
  :doc "Rewrite of Powerline"
  :req "cl-lib-0.2"
  :tag "mode-line"
  :url "http://github.com/milkypostman/powerline/"
  :added "2022-12-09"
  :ensure t
  :config (powerline-default-theme))

;; Installing Fonts
;; M-x all-the-icons-install-fonts
(leaf all-the-icons
  :doc "A library for inserting Developer icons"
  :req "emacs-24.3"
  :tag "lisp" "convenient" "emacs>=24.3"
  :url "https://github.com/domtronn/all-the-icons.el"
  :added "2023-01-12"
  :emacs>= 24.3
  :ensure t
  :if (display-graphic-p))

;; backup file setting
(leaf files
  :doc "file input and output commands for Emacs"
  :tag "builtin"
  :custom `((auto-save-timeout . 3)
            (auto-save-interval . 60)
            (auto-save-file-name-transforms . 
                                            (cons `(,(car (car auto-save-file-name-transforms)) 
                                                   ,(concat BACKDIR "\\2") t) auto-save-file-name-transforms))
            (backup-directory-alist . '((".*" . ,(locate-user-emacs-file "backup"))
                                        (,tramp-file-name-regexp . nil)))
	        (auto-save-visited-mode . t)
            (version-control . t)
            (delete-old-versions . t)
            (find-file-visit-truename . t)))

;; スクリプトに実行権限付加
(leaf executable
  :hook
  (after-save-hook . executable-make-buffer-file-executable-if-script-p))

(leaf undo-tree
  :doc "Treat undo history as a tree"
  :req "queue-0.2" "emacs-24.3"
  :tag "tree" "history" "redo" "undo" "files" "convenience" "emacs>=24.3"
  :url "https://www.dr-qubit.org/undo-tree.html"
  :added "2022-12-09"
  :emacs>= 24.3
  :ensure t
  :custom
  (undo-tree-history-directory-alist . `(("" . ,(concat user-emacs-directory "undo-tree/"))))
  :bind* (("C-x u" . undo-tree-visualize))
  :global-minor-mode global-undo-tree-mode
  :diminish t
  )

(leaf autorevert
  :doc "revert buffers when files on disk change"
  :tag "builtin"
  :custom ((auto-revert-interval . 0.1))
  :global-minor-mode global-auto-revert-mode)

;; magit
;; C-x g magit起動
;; s ステージング
;; c->c コミット->C-c C-c
;; P->u push origin/master
;; F->u プル
;; b->b チェックアウト
(leaf magit
  :doc "A Git porcelain inside Emacs."
  :req "emacs-25.1" "compat-28.1.1.2" "dash-20210826" "git-commit-20221127" "magit-section-20221127" "transient-20220325" "with-editor-20220318"
  :tag "vc" "tools" "git" "emacs>=25.1"
  :url "https://github.com/magit/magit"
  :added "2022-12-10"
  :emacs>= 25.1
  :ensure t
  :after compat git-commit magit-section with-editor)

;; restart enable
(leaf restart-emacs
  :doc "Restart emacs from within emacs"
  :tag "convenience"
  :url "https://github.com/iqbalansari/restart-emacs"
  :added "2023-04-03"
  :ensure t)

(leaf consult
  :doc "Consulting completing-read"
  :req "emacs-27.1" "compat-29.1.4.1"
  :tag "emacs>=27.1"
  :url "https://github.com/minad/consult"
  :added "2023-04-03"
  :emacs>= 27.1
  :ensure t
  :bind
  ("C-x C-r" . consult-recent-file)
  ("C-S-s" . consult-line))

;; ミニバッファー補完
(leaf vertico
  :doc "VERTical Interactive COmpletion"
  :req "emacs-27.1" "compat-29.1.4.0"
  :tag "emacs>=27.1"
  :url "https://github.com/minad/vertico"
  :added "2023-04-03"
  :emacs>= 27.1
  :ensure t
  :hook (after-init-hook . vertico-mode))

(leaf orderless
  :doc "Completion style for matching regexps in any order"
  :req "emacs-26.1"
  :tag "extensions" "emacs>=26.1"
  :url "https://github.com/oantolin/orderless"
  :added "2023-04-03"
  :emacs>= 26.1
  :ensure t
  :custom
  (completion-styles . '(orderless)))

(leaf marginalia
  :doc "Enrich existing commands with completion annotations"
  :req "emacs-27.1" "compat-29.1.4.0"
  :tag "emacs>=27.1"
  :url "https://github.com/minad/marginalia"
  :added "2023-04-03"
  :emacs>= 27.1
  :ensure t
  :hook
  (after-init-hook . marginalia-mode))

;; 入力中の補完
(leaf corfu
  :doc "Completion Overlay Region FUnction"
  :req "emacs-27.1" "compat-29.1.4.0"
  :tag "emacs>=27.1"
  :url "https://github.com/minad/corfu"
  :added "2023-04-03"
  :emacs>= 27.1
  :ensure t
  :custom
  (corfu-auto . t)    ;; Enable auto completion
  (corfu-preselect-first    . nil)  ;; Disable candidate preselection
  :init (global-corfu-mode))

(leaf expand-region
  :doc "Increase selected region by semantic units."
  :tag "region" "marking"
  :added "2022-12-09"
  :ensure t
  :bind (("C-@" . er/expand-region)
         ("C-M-@" . er/contract-region)))

(leaf smartparens
  :doc "Automatic insertion, wrapping and paredit-like navigation with user defined pairs."
  :req "dash-2.13.0" "cl-lib-0.3"
  :tag "editing" "convenience" "abbrev"
  :url "https://github.com/Fuco1/smartparens"
  :added "2022-12-18"
  :ensure t
  :require smartparens-config
  :diminish t
  :hook
  (prog-mode-hook . turn-on-smartparens-mode)
  :config
  (show-smartparens-global-mode t)
  :bind
  (
   ;; S式単位移動
   ("C-M-f" . sp-forward-sexp)
   ("C-M-b" . sp-backward-sexp)
   ("C-M-n" . sp-next-sexp)
   ("C-M-p" . sp-previous-sexp)
   ;; シンボル単位移動
   ("M-F" . sp-forward-symbol)
   ("M-B" . sp-backward-symbol)
   ;; 子のS式の関数名に移動
   ("C-<down>" . sp-down-sexp)
   ;; 閉括弧を出ながらS式を上る
   ("C-<up>" . sp-up-sexp)
   ;; backward-up-list C-M-uと同じ？
   ("M-<up>" . sp-backward-up-sexp)
   ;; 閉括弧の中に入りながらS式を降りる
   ("M-<down>" . sp-backward-down-sexp)
   ;; S式内移動
   ("C-M-a" . sp-beginning-of-sexp)
   ("C-M-e" . sp-end-of-sexp)
   ;; カット
   ("C-M-k" . sp-kill-sexp)
   ("C-M-w" . sp-copy-sexp)
   ;; 括弧外し
   ("M-<delete>" . sp-unwrap-sexp)
   ("M-<backspace>" . sp-backward-unwrap-sexp)
   ("C-<right>" . sp-forward-slurp-sexp)
   ("C-<left>" . sp-forward-barf-sexp)
   ("C-M-<left>" . sp-backward-slurp-sexp)
   ("C-M-<right>" . sp-backward-barf-sexp)
   ;; other
   ("M-D" . sp-splice-sexp)
   ("C-M-<delete>" . sp-splice-sexp-killing-forward)
   ("C-M-<backspace>" . sp-splice-sexp-killing-backward)
   ("C-S-<backspace>" . sp-splice-sexp-killing-around)
   ("C-]" . sp-select-next-thing-exchange)
   ("C-M-]" . sp-select-next-thing)
   ("C-M-SPC" . sp-mark-sexp)
   ))

(leaf multiple-cursors
  :doc "Multiple cursors for Emacs."
  :req "cl-lib-0.5"
  :tag "cursors" "editing"
  :url "https://github.com/magnars/multiple-cursors.el"
  :added "2023-02-01"
  :ensure t
  :hydra 
  (hydra-mc (global-map "C-S-c")
            "multiple-cursors"
            ("n" mc/mark-next-like-this)
            ("p" mc/mark-previous-like-this)
            ("m" mc/mark-more-like-this-extended)
            ("u" mc/unmark-next-like-this)
            ("U" mc/unmark-previous-like-this)
            ("s" mc/skip-to-next-like-this)
            ("S" mc/skip-to-previous-like-this)
            ("*" mc/mark-all-like-this)
            ("a" mc/mark-all-like-this)
            ("d" mc/mark-all-like-this-dwim)
            ("i" mc/insert-numbers)
            ("l" mc/insert-letters)
            ("o" mc/sort-regions)
            ("O" mc/reverse-regions)
            ))

;; == neotree buffer bindkeys ==
;; n next line, p previous line
;; SPC or RET or TAB Open current item if it is a file. Fold/Unfold current item if it is a directory.
;; U Go up a directory
;; g Refresh
;; A Maximize/Minimize the NeoTree Window
;; H Toggle display hidden files
;; O Recursively open a directory
;; C-c C-n Create a file or create a directory if filename ends with a ‘/’
;; C-c C-d Delete a file or a directory.
;; C-c C-r Rename a file or a directory.
;; C-c C-c Change the root directory.
;; C-c C-p Copy a file or a directory.
(leaf neotree
  :doc "A tree plugin like NerdTree for Vim"
  :req "cl-lib-0.5"
  :url "https://github.com/jaypei/emacs-neotree"
  :added "2022-12-14"
  :ensure t
  :bind (("<f3>" . neotree-toggle))
  :custom
  (eo-window-fixed-size . nil)
  :setq
  (neo-smart-open . t)
  ;; (projectile-switch-project-action . 'neotree-projectile-action)
  )

(leaf persp-mode
  :doc "windows/buffers sets shared among frames + save/load."
  :req "emacs-24.3"
  :tag "convenience" "buffers" "windows" "persistence" "workspace" "session" "perspectives" "emacs>=24.3"
  :url "https://github.com/Bad-ptr/persp-mode.el"
  :added "2022-12-29"
  :emacs>= 24.3
  :ensure t
  :custom
  (persp-autokill-buffer-on-remove . 'kill-weak)
  :config
  (persp-mode +1)
  :bind
  (("C-<tab>" . persp-next)
   ("C-<iso-lefttab>" . persp-prev)
   ;; ("<kanji> k" . (lambda ()
   ;;                  (interactive)
   ;;                  (message "Kill buffer.")
   ;;                  (persp-kill-buffer)))
   ))

(leaf ace-jump-mode
  :doc "a quick cursor location minor mode for emacs"
  :tag "cursor" "location" "motion"
  :url "https://github.com/winterTTr/ace-jump-mode/"
  :added "2022-12-22"
  :ensure t
  :bind (("<muhenkan>" . ace-jump-mode)))

(leaf evil-numbers
  :doc "Increment/decrement numbers like in VIM"
  :req "emacs-24.1" "evil-1.2.0"
  :tag "tools" "convenience" "emacs>=24.1"
  :url "http://github.com/juliapath/evil-numbers"
  :added "2022-12-22"
  :emacs>= 24.1
  :ensure t
  :bind (("M-+" . evil-numbers/inc-at-pt)
	     ("M--" . evil-numbers/dec-at-pt)))

(leaf csv-mode
  :doc "Major mode for editing comma/char separated values"
  :req "emacs-27.1" "cl-lib-0.5"
  :tag "convenience" "emacs>=27.1"
  :url "https://elpa.gnu.org/packages/csv-mode.html"
  :added "2023-04-03"
  :emacs>= 27.1
  :ensure t)

(leaf markdown-mode
  :doc "Major mode for Markdown-formatted text"
  :req "emacs-26.1"
  :tag "itex" "github flavored markdown" "markdown" "emacs>=26.1"
  :url "https://jblevins.org/projects/markdown-mode/"
  :added "2023-04-03"
  :emacs>= 26.1
  :ensure t
  :custom
  (markdown-fontify-code-blocks-natively . t))

(leaf nix-mode
  :doc "Major mode for editing .nix files"
  :req "emacs-25.1" "magit-section-0" "transient-0.3"
  :tag "unix" "tools" "languages" "nix" "emacs>=25.1"
  :url "https://github.com/NixOS/nix-mode"
  :added "2023-04-28"
  :emacs>= 25.1
  :ensure t
  :after magit-section)

(leaf ein
  :doc "Emacs IPython Notebook"
  :req "emacs-25" "websocket-1.12" "anaphora-1.0.4" "request-0.3.3" "deferred-0.5" "polymode-0.2.2" "dash-2.13.0" "with-editor-0.-1"
  :tag "reproducible research" "literate programming" "jupyter" "emacs>=25"
  :url "https://github.com/dickmao/emacs-ipython-notebook"
  :added "2023-04-03"
  :emacs>= 25
  :ensure t
  :after websocket anaphora deferred polymode with-editor)

(leaf skill-mode
  :load-path "/home/utools/release/elisp"
  :mode (".il$" ".ils$" ".skl$")
  ;; :hook ((skill-mode-hook . slime-mode))
  )

(leaf ediff
  :custom
  ;; ediffでウィンドウを横分割
  (ediff-split-window-function . 'split-window-horizontally)
  ;; ediffにframeを生成させない
  (ediff-window-setup-function . 'ediff-setup-windows-plain))

;; org-roam
;; roam research風Personal Knowledge Management ツール
;; 使い方::
;; <kanji>-c で today's note captureを開く
;; 何を書く？
;; <kanji>-t で today's noteを開く
;; tagはどうやって使う？
;; tagノートはどうやって開く？
;; tagノートをどうやったらHTML化できる？
;; TODOを入力するには、C-c C-t 
(leaf org-roam
  :ensure t
  :after org
  :init
  (org-roam-db-autosync-mode)
  :custom
  (org-roam-directory . "~/.config/org-roam")
  (org-roam-mode-sections . (list #'org-roam-backlinks-section
                                  #'org-roam-reflinks-section
                                  #'org-roam-unlinked-references-section
                                  ))
  :bind
  ("<kanji> c" . org-roam-dailies-capture-today)
  ("<kanji> t" . org-roam-dailies-goto-today)
  ("C-c n l" . org-roam-buffer-toggle)
  ("C-c n f" . org-roam-node-find)
  ("C-c n g" . org-roam-graph)
  (:org-mode-map
   ("C-c n i" . org-roam-insert)
   ("C-c n I" . org-roam-insert-immediate))
  )


