(require 'compilation-colorization) ;; colorizes output of (i)grep
(require 'package)                  ;; ELPA
(require 'color-theme)

(package-initialize)

(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa" . "http://melpa.milkbox.net/packages/")
                         ("GELPA" . "http://internal-elpa.appspot.com/packages/")))

(add-to-list 'load-path (expand-file-name "~/.emacs.d/my-plugins"))
(require 'closure-template-html-mode)

;;;;;;;;;;;;;;; Set up packages ;;;;;;;;;;;;;;;;;;;;
(require 'ace-jump-mode)
(require 'evil)
(evil-mode 1)
(define-key evil-normal-state-map "f" 'ace-jump-char-mode)
(define-key evil-visual-state-map "f" 'ace-jump-char-mode)
(define-key evil-motion-state-map "f" 'ace-jump-char-mode)

(require 'evil-numbers)
(define-key evil-normal-state-map "+" 'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map "=" 'evil-numbers/inc-at-pt)
(define-key evil-normal-state-map "-" 'evil-numbers/dec-at-pt)

(require 'evil-matchit)
(defun evilmi-customize-keybinding ()
    (evil-define-key 'normal evil-matchit-mode-map
          "%" 'evilmi-jump-items))
(global-evil-matchit-mode 1)

(require 'linum+)
;;(setq linum-format "%4d\u2502")
(setq linum+-smart-format "%%%dd ")
(global-linum-mode)

(require 'move-text)
(require 'ido)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)
(ido-mode 1)
(defun ido-key-mappings ()
  "My key mappings for IDO completion prompts."
  (define-key ido-completion-map (kbd "ESC") 'keyboard-escape-quit))
(add-hook 'ido-setup-hook 'ido-key-mappings)

;; This messes things up if the terminal is configured correctly.
;; ignore it unless you need it.
;; (load-theme 'solarized-dark t)

(setq save-place-file "~/.emacs.d/saveplace")
(setq-default save-place t)
(require 'saveplace)

(require 'surround)
(global-surround-mode 1)

(require 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js$" . js2-mode))

(require 'key-chord)
(setq key-chord-two-keys-delay 0.2)
(key-chord-mode 1)

;; Filladapt mode doesn't seem to be working well with a number of other modes.
;; (require 'filladapt)
;; (setq-default filladapt-mode t)

(require 'markdown-mode)
;; (autoload 'markdown-mode "markdown-mode"
;;      "Major mode for editing Markdown files" t)
(add-to-list 'auto-mode-alist '("\\.markdown\\'" . markdown-mode))
(add-to-list 'auto-mode-alist '("\\.md\\'" . markdown-mode))

;; Do a little buffer management.
;; Uniquify makes buffer names unique and midnight kills off buffers if they've
;; been inactive for over 3 days.
(require 'uniquify)
(require 'midnight)

(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/my-plugins/ac-dict")
(ac-config-default)
(setq ac-delay 0.02)
(setq ac-auto-show-menu t)
(setq ac-disable-faces nil)  ;; Allow completion within strings.
(setq ac-ignore-case nil)
(setq ac-use-quick-help nil) ;; Disable the tooltip menu.
;; dirty fix for having AC everywhere
(define-globalized-minor-mode real-global-auto-complete-mode
    auto-complete-mode (lambda ()
                         (if (not (minibufferp (current-buffer)))
                             (auto-complete-mode 1))))
(real-global-auto-complete-mode t)

(require 'fill-column-indicator)
(add-hook 'after-change-major-mode-hook 'fci-mode)

(require 'zencoding-mode)
(add-hook 'html-mode-hook 'zencoding-mode)
(define-key evil-insert-state-map (kbd "C-e") 'zencoding-expand-line)


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Customizations taken from mknichel's .emacs
;; highlight trailing whitespace on a line in red
(setq-default show-trailing-whitespace t)

;;for text mode (sources files, sources.inc files, etc) point out when
;;hard tabs are used instead of spaces
(add-hook 'text-mode-hook (lambda () (font-lock-add-keywords nil '(("\t" (0 'hi-red append t))))))

;;;;;;;;;;;;;;;;;;;; Autosave Support ;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Allow saving of Emacs autosaves to a separate directory
;; Source: http://snarfed.org/gnu_emacs_backup_files
;; Put autosave files (ie #foo#) and backup files (ie foo~) in ~/.emacs.d/.
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-save-file-name-transforms (quote ((".*" "~/.emacs.d/autosaves/\\1" t))))
 '(backup-directory-alist (quote ((".*" . "~/.emacs.d/backups/"))))
 '(comment-auto-fill-only-comments t)
 '(custom-safe-themes (quote ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default)))
 '(evil-shift-width 2)
 '(fill-column 80)
 '(inhibit-startup-screen t)
 '(safe-local-variable-values (quote ((sh-indent-comment . t))))
 '(tab-always-indent (quote complete))
 '(uniquify-buffer-name-style (quote post-forward-angle-brackets) nil (uniquify)))

;;;;;;;;;;;;;;;;;;;; Emacs customizations ;;;;;;;;;;;;;;;;;;;;;;;
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)
(show-paren-mode 1)
(setq show-paren-delay 0)
(menu-bar-mode -1)  ;; disable the menubar
(tool-bar-mode -1)  ;; disable the toolbar
(setq inhibit-splash-screen t) ;; inhibit the splash screen on startup.
(column-number-mode)  ;; Show column numbers in the status bar
(defalias 'er 'eval-region) ;; Shorten eval-region.
(defalias 'sl 'sort-lines) ;; Shorten sort-lines.
(defalias 'yes-or-no-p 'y-or-n-p) ;; y or n is enough

;; Fill mode for automatic line wrapping.
(add-hook 'after-change-major-mode-hook 'turn-on-auto-fill)
;; (add-hook 'c-mode-common-hook
;;           (lambda () (auto-fill-mode 1)
;;             (set (make-local-variable 'fill-nobreak-predicate)
;;              (lambda ()
;;                (not (eq (get-text-property (point) 'face) 'font-lock-comment-face))))))

(add-hook 'c-mode-common-hook
          (lambda ()
            (when (featurep 'filladapt)
              (c-setup-filladapt))))

;; When switching to the build major mode, an inferior python process is
;; started. Stop asking whether to quit the process on exit.
(defun process-query-on-exit-flag (process) nil)

;; Command line arguments for P4 diff and merge.
;; -diff
(defun command-line-diff (switch)
  (let ((file1 (pop command-line-args-left))
        (file2 (pop command-line-args-left)))
    (ediff file1 file2)))
(add-to-list 'command-switch-alist '("-diff" . command-line-diff))

;; -merge
(defun command-line-merge (switch)
  (let ((base (pop command-line-args-left))
        (sccs (pop command-line-args-left))
        (mine (pop command-line-args-left))
        (merg (pop command-line-args-left)))
    (ediff-merge-with-ancestor sccs mine base () merg)))
(add-to-list 'command-switch-alist '("-merge" . command-line-merge))


;;;;;;;;;;;;;;;;;;;; Vim customizations ;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; esc quits

(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key minibuffer-local-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-ns-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-completion-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-must-match-map [escape] 'minibuffer-keyboard-quit)
(define-key minibuffer-local-isearch-map [escape] 'minibuffer-keyboard-quit)
(key-chord-define evil-insert-state-map "kj" 'evil-normal-state)
(key-chord-define evil-visual-state-map "kj" 'evil-normal-state)

;; Requires stty -ixon -ixoff to be run as part of your .bashrc in order to
;; allow C-s and C-q to not perform terminal flow control.
(defun save-buffer-and-return-to-normal-state ()
  "In insert mode, saves the current buffer and returns to normal mode."
  (interactive)
  (save-buffer)
  (evil-normal-state))
(define-key evil-insert-state-map (kbd "C-s") 'save-buffer-and-return-to-normal-state)
(define-key evil-normal-state-map (kbd "C-s") 'save-buffer)

;; Fix frequent typos of :wq
(evil-ex-define-cmd "qq" 'save-buffers-kill-terminal)
(evil-ex-define-cmd "Q" 'save-buffers-kill-terminal)
(evil-ex-define-cmd "Wq" 'save-buffers-kill-terminal)
(evil-ex-define-cmd "W" 'save-buffer)
(key-chord-define evil-normal-state-map "qq" 'save-buffers-kill-terminal)

;; Meta+X is too cumbersome. Bind to `.
(define-key evil-normal-state-map "`" 'execute-extended-command)
(define-key evil-visual-state-map "`" 'execute-extended-command)
(define-key evil-normal-state-map (kbd "C-j") 'move-text-down)
(define-key evil-normal-state-map (kbd "C-k") 'move-text-up)
(define-key evil-normal-state-map (kbd "C-d") 'kill-line)
(define-key evil-normal-state-map (kbd "C-u") 'kill-whole-line)
(define-key evil-insert-state-map (kbd "C-u") 'kill-whole-line)

;; Make H and 0 move to the logical beginning of line. If I really want to go to
;; the first column, I'll use ^.
(define-key evil-normal-state-map "H" 'back-to-indentation)
(define-key evil-visual-state-map "H" 'back-to-indentation)
(define-key evil-normal-state-map "0" 'back-to-indentation)
(define-key evil-visual-state-map "0" 'back-to-indentation)
(define-key evil-normal-state-map "^" 'beginning-of-line)
(define-key evil-visual-state-map "^" 'beginning-of-line)
(define-key evil-normal-state-map "L" 'end-of-line)
(define-key evil-visual-state-map "L" 'end-of-line)

(key-chord-define evil-normal-state-map "hh" 'backward-word)
(key-chord-define evil-normal-state-map "ll" 'forward-word)

;; Remap space and backspace in normal mode to speed up navigation.
(define-key evil-normal-state-map (kbd "SPC") (lambda () (interactive) (forward-line 20)))
(define-key evil-normal-state-map (kbd "C-SPC") (lambda () (interactive) (forward-line -20)))
(define-key evil-normal-state-map (kbd "DEL") (lambda () (interactive) (forward-line -20)))

;; Bind RET to always indent if it can.
(define-key evil-insert-state-map (kbd "RET") 'newline-and-indent)

;; Pop mark with C-t since ,d is bound to google's pop-tag-mark.
(define-key evil-normal-state-map (kbd "C-t") 'pop-global-mark)

;;;;;;;;;;;;;;;;;;;;; Buffer customizations ;;;;;;;;;;;;;;;;;;;;;
(setq-default compilation-scroll-output 'first-error)
(setq evil-shift-width 2)

;; js2-mode insists on setting the shift width to 4. Make it conform better to
;; Google style.
(add-hook 'js2-mode-hook (function (lambda () (setq evil-shift-width 2))))
(add-hook 'css-mode-hook (function (lambda () (setq evil-shift-width 2))))

(defun string/starts-with (s arg)
  "returns non-nil if string S starts with ARG.  Else nil."
  (cond ((>= (length s) (length arg))
         (string-equal (substring s 0 (length arg)) arg)) (t nil)))

(defun next-real-buffer ()
  "switches to the next buffer that is not an emacs special buffer."
  (interactive)
  (let ((bufname (buffer-name)))
    (next-buffer)
    (while (and (not (string-equal (buffer-name) bufname)) (string/starts-with (buffer-name)  "*"))
      (next-buffer))))

(defun split-window-vertically-and-use-next-buffer ()
  "Vertical window split and switch to next buffer in the split window"
  (interactive)
  (split-window-right)
  (other-window 1)
  (next-real-buffer))

;;;;;;;;;;;;;;;;;; Comma based commands ;;;;;;;;;;;;;;;;;;;;;;;
(define-key evil-normal-state-map ",," 'next-real-buffer)
(define-key evil-normal-state-map ",b" 'ido-switch-buffer)
(define-key evil-visual-state-map ",b" 'ido-switch-buffer)
(define-key evil-normal-state-map ",c" 'comment-or-uncomment-region)
(define-key evil-visual-state-map ",c" 'comment-or-uncomment-region)
(define-key evil-normal-state-map (kbd "C-O") 'ido-find-file)
(define-key evil-normal-state-map ",f" 'ido-find-file)
(define-key evil-visual-state-map ",F" 'google-clang-format)
(define-key evil-normal-state-map ",s" 'split-window-vertically-and-use-next-buffer)
(define-key evil-normal-state-map ",t" 'google-rotate-among-files)
(define-key evil-normal-state-map "w1" 'delete-other-windows)
(define-key evil-insert-state-map (kbd "C-h") 'backward-kill-word)


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ace-jump-face-background ((t (:foreground "yellow")))))


;;;;;;;;;;;;;;;;; File type customizations ;;;;;;;;;;;;;;;;;;;;;;;
(setq auto-mode-alist (cons '("\\.params$" . protobuffer-mode) auto-mode-alist))
