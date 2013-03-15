;;org-mode setup
;; (defln org-summary-todo (n-done n-not-done)
;;   "Switch entry to DONE when all subentries are done, to TODO otherwise."
;;   (let (org-log-done org-log-states)   ; turn off logging
;;     (org-todo (if (= n-not-done 0) "DONE" "TODO"))))

;; (add-hook 'org-after-todo-statistics-hook 'org-summary-todo)

;; first autoload org-mode (don't think we need this?)
;;(require 'org-install)
;;(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))

  ;; key bindings
  (define-key mode-specific-map [?a] 'org-agenda)

  (eval-after-load "org"
    '(progn
       (define-prefix-command 'org-todo-state-map)

       (define-key org-mode-map "\C-cx" 'org-todo-state-map)

       (define-key org-todo-state-map "x"
         #'(lambda nil (interactive) (org-todo "CANCELLED")))
       (define-key org-todo-state-map "d"
         #'(lambda nil (interactive) (org-todo "DONE")))
       (define-key org-todo-state-map "f"
         #'(lambda nil (interactive) (org-todo "DEFERRED")))
       (define-key org-todo-state-map "l"
         #'(lambda nil (interactive) (org-todo "DELEGATED")))
       (define-key org-todo-state-map "s"
         #'(lambda nil (interactive) (org-todo "STARTED")))
       (define-key org-todo-state-map "w"
         #'(lambda nil (interactive) (org-todo "WAITING")))

       ;; (define-key org-agenda-mode-map "\C-n" 'next-line)
       ;; (define-key org-agenda-keymap "\C-n" 'next-line)
       ;; (define-key org-agenda-mode-map "\C-p" 'previous-line)
       ;; (define-key org-agenda-keymap "\C-p" 'previous-line)
       )
    )

  ;; remember mode and key binding (C-M-r)
  (require 'remember)
  (add-hook 'remember-mode-hook 'org-remember-apply-template)
  (define-key global-map [(control meta ?r)] 'remember)

  ;; org setup

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(c-basic-offset 4)
 '(desktop-path (quote ("." "~/emacs-desktop" "~/.emacs.d/" "~")))
 '(font-use-system-font t)
 '(js2-allow-keywords-as-property-names nil)
 '(js2-basic-offset 4)
 '(js2-bounce-indent-p t)
 '(js2-cleanup-whitespace t)
 '(js2-highlight-external-variables nil)
 '(js2-highlight-level 3)
 '(js2-idle-timer-delay 0.2)
 '(js2-indent-on-enter-key nil)
 '(js2-missing-semi-one-line-override nil)
 '(js2-mode-escape-quotes nil)
 '(js2-mode-show-parse-errors nil)
 '(js2-mode-show-strict-warnings nil)
 '(js2-strict-cond-assign-warning nil)
 '(js2-strict-inconsistent-return-warning nil)
 '(js2-strict-missing-semi-warning nil)
 '(js2-strict-trailing-comma-warning nil)
 '(js2-strict-var-hides-function-arg-warning nil)
 '(js2-strict-var-redeclaration-warning nil)
 '(org-agenda-custom-commands (quote (("d" todo "DELEGATED" nil) ("c" todo "DONE|DEFERRED|CANCELLED" nil) ("w" todo "WAITING" nil) ("W" agenda "" ((org-agenda-ndays 21))) ("A" agenda "" ((org-agenda-skip-function (lambda nil (org-agenda-skip-entry-if (quote notregexp) "\\=.*\\[#A\\]"))) (org-agenda-ndays 1) (org-agenda-overriding-header "Today's Priority #A tasks: "))) ("u" alltodo "" ((org-agenda-skip-function (lambda nil (org-agenda-skip-entry-if (quote scheduled) (quote deadline) (quote regexp) "
]+>"))) (org-agenda-overriding-header "Unscheduled TODO entries: "))))))
 '(org-agenda-files (quote ("/home/sbbd168/orgs/august.org")))
 '(org-agenda-ndays 7)
 '(org-agenda-show-all-dates t)
 '(org-agenda-skip-deadline-if-done t)
 '(org-agenda-skip-scheduled-if-done t)
 '(org-agenda-start-on-weekday nil)
 '(org-deadline-warning-days 14)
 '(org-default-notes-file "~/orgs/notes.org")
 '(org-fast-tag-selection-single-key (quote expert))
 '(org-remember-store-without-prompt t)
 '(org-remember-templates (quote ((116 "* TODO %?
  %u" "~/todo.org" "Tasks") (110 "* %u %?" "~/notes.org" "Notes"))))
 '(org-reverse-note-order t)
 '(org-src-fontify-natively t)
 '(remember-annotation-functions (quote (org-remember-annotation)))
 '(remember-handler-functions (quote (org-remember-handler)))
 '(vc-svn-global-switches nil))

;; add .emacs.d/elisp to load path
(let ((default-directory  "~/.emacs.d/elisp/"))
  (setq load-path
        (append
         (let ((load-path (copy-sequence load-path))) ;; Shadow
           (normal-top-level-add-subdirs-to-load-path))
         load-path)))

;; add .emacs.d/vendor/* to load path
(let ((default-directory "~/.emacs.d/vendor/"))
  (normal-top-level-add-subdirs-to-load-path))

;;load hl-tags-mode
;;(require 'hl-tags-mode)

;;spaces not tabs!
(setq-default indent-tabs-mode nil)

;;take the stabilisers off downcase-region
(put 'downcase-region 'disabled nil)

;jshint hookup
(require 'flymake-jshint)
(add-hook 'js2-mode-hook
     (lambda () (flymake-mode t)))

;; sensitive mode - disables backup ~ files on current buffer
(define-minor-mode sensitive-mode
  "For sensitive files like password lists.
It disables backup creation and auto saving.

With no argument, this command toggles the mode.
Non-null prefix argument turns on the mode.
Null prefix argument turns off the mode."

  ;; The initial value.
  nil

  ;; The indicator for the mode line.
  " Sensitive"

  ;; The minor mode bindings.
  nil
  (if (symbol-value sensitive-mode)
      (progn
	;; disable backups
	(set (make-local-variable 'backup-inhibited) t)
	;; disable auto-save
	(if auto-save-default
	    (auto-save-mode -1)))
    ;resort to default value of backup-inhibited
    (kill-local-variable 'backup-inhibited)
    ;resort to default auto save setting
    (if auto-save-default
	(auto-save-mode 1))))

;; look up on google using w3m
(defun google (what)
  "Use google to search for WHAT."
  (interactive "sSearch: ")
  (save-window-excursion
    (delete-other-windows)
    (let ((dir default-directory))
      (w3m-browse-url (concat "http://www.google.com/search?q="
			      (w3m-url-encode-string what)))
      (cd dir)
      (recursive-edit))))
(global-set-key "\C-Cg" 'google)

;; allow region narrowing
(put 'narrow-to-region 'disabled nil)

;; ido-mode enabling
(ido-mode t)

(put 'upcase-region 'disabled nil)

;; geben
(autoload 'geben "geben" "PHP Debugger on Emacs" t)

;; newer php-mode
;;(require 'pi-php-mode)

;; Perl syntax checking
(defun steveperl-check-syntax ()
  (interactive)
  (if (not (equal mode-name "CPerl"))
      ;; ignore
      ()
    ;; get the full path of this file
    (setq source-full-path (buffer-file-name))
    ;; clear the buffer of earlier error
    (set-buffer (get-buffer-create "perlsyn"))
    (erase-buffer)
    ;; set the perl5lib
    (setenv "PERL5LIB" "/usr/lib/perl5")
    ;; execute perl -wc
    (call-process "perl" nil "perlsyn" nil "-wc" source-full-path)
    ;; execute podchecker
;;    (call-process "podchecker" nil "perlsyn" nil
;;                                                source-full-path)
    ;; checks if perl returned a syntax OK string
    (if (not (equal (substring (buffer-string) -3 -1) "OK"))
    (switch-to-buffer "perlsyn")))
  )
(add-hook 'after-save-hook 'steveperl-check-syntax)

;;sample func to copy pl file to server on save
;;(defun steve-perl-make ()
 ;; "run make svn in current dir"
  ;;(interactive)
  ;;(if (not (equal mode-name "CPerl"))
   ;;   ()
   ;; ;; get the full path of this file
   ;; (setq source-full-path (buffer-file-name))
   ;; ;; clear the buffer of earlier error
   ;; (set-buffer (get-buffer-create "perlmake"))
   ;; (erase-buffer)
   ;; ;;execute the make
   ;; (call-process "make" nil "perlmake" nil "svn" source-full-path)
   ;; (switch-to-buffer "perlmake"))
 ;; )

;; PHP syntax checking (on F8)
;; (defun phplint-thisfile ()
;;   (interactive)
;;   (compile (format "php -l %s" (buffer-file-name)))
;; )
;; (add-hook
;;  'php-mode-hook
;;  '(lambda ()
;;     (local-set-key [f8] 'phplint-thisfile)
;;   )
;; )

;;flymake setup
(require 'php-mode)
(require 'flymake)
(defun flymake-php-init ()
  "Use php to check the syntax of the current file."
  (when (not (tramp-file-name-p buffer-file-name))
    ;make sure this buffer isn't over tramp
    (let* ((temp (flymake-init-create-temp-buffer-copy 'flymake-create-temp-inplace))
           (local (file-relative-name temp (file-name-directory buffer-file-name))))
      (list "php" (list "-f" local "-l")))
    ) ; end when
  ) ; end func

(add-to-list 'flymake-err-line-patterns
  '("\\(Parse\\|Fatal\\) error: +\\(.*?\\) in \\(.*?\\) on line \\([0-9]+\\)$" 3 4 nil 2))

(add-to-list 'flymake-allowed-file-name-masks '("\\.php$" flymake-php-init))
(add-to-list 'flymake-allowed-file-name-masks '("\\.phtml$" flymake-php-init))
(add-to-list 'flymake-allowed-file-name-masks '("\\.inc$" flymake-php-init))

(add-hook 'php-mode-hook (
  lambda () (
    ;; todo: check if we are editing accross TRAMP
    flymake-mode 1)))

;;(define-key php-mode-map '[M-S-up] 'flymake-goto-prev-error)
;;(define-key php-mode-map '[M-S-down] 'flymake-goto-next-error)

;; from http://paste.lisp.org/display/60617,1/raw :
;;
;; -*- emacs-lisp -*-
;; License: Gnu Public License
;;
;; Additional functionality that makes flymake error messages appear
;; in the minibuffer when point is on a line containing a flymake
;; error. This saves having to mouse over the error, which is a
;; keyboard user's annoyance

;;flymake-ler(file line type text &optional full-file)
(defun show-fly-err-at-point ()
  "If the cursor is sitting on a flymake error, display the
message in the minibuffer"
  (interactive)
  (let ((line-no (line-number-at-pos)))
    (dolist (elem flymake-err-info)
      (if (eq (car elem) line-no)
	  (let ((err (car (second elem))))
	    (message "%s" (fly-pyflake-determine-message err)))))))

(defun fly-pyflake-determine-message (err)
  "pyflake is flakey if it has compile problems, this adjusts the
message to display, so there is one ;)"
  (cond ((not (or (eq major-mode 'Python) (eq major-mode 'python-mode) t)))
	((null (flymake-ler-file err))
	 ;; normal message do your thing
	 (flymake-ler-text err))
	(t ;; could not compile err
	 (format "compile error, problem on line %s" (flymake-ler-line err)))))

(defadvice flymake-goto-next-error (after display-message activate compile)
  "Display the error in the mini-buffer rather than having to mouse over it"
  (show-fly-err-at-point))

(defadvice flymake-goto-prev-error (after display-message activate compile)
  "Display the error in the mini-buffer rather than having to mouse over it"
  (show-fly-err-at-point))

(defadvice flymake-mode (before post-command-stuff activate compile)
  "Add functionality to the post command hook so that if the
cursor is sitting on a flymake error the error information is
displayed in the minibuffer (rather than having to mouse over
it)"
  (set (make-local-variable 'post-command-hook)
       (cons 'show-fly-err-at-point post-command-hook)))

;; remove tool bar in X11 mode
(tool-bar-mode -1)

;; remove menu
(menu-bar-mode -1)

;; remove scrollbars in X11 mode
(scroll-bar-mode -1)

;; turn on show-parens
(show-paren-mode t)

;; set fg/bg
(set-background-color "black")
(set-foreground-color "white")

;; set C-TAB to equal TAB
(global-set-key [C-tab] 'indent-for-tab-command)

;; w3m config
(require 'w3m-load)
(setq w3m-use-favicon nil)
(setq w3m-command-arguments' ("-cookie" "-F"))

;; use cperl for perl
(add-to-list 'auto-mode-alist '("\\.pl$" . cperl-mode))

;; use css for *.scss
(add-to-list 'auto-mode-alist '("\\.scss$" . css-mode))

;; linum-mode on for php/js/css/perl
(defun linum-mode-please () (linum-mode 1))
(add-hook 'php-mode-hook 'linum-mode-please)
(add-hook 'cperl-mode-hook 'linum-mode-please)
(add-hook 'js2-mode-hook 'linum-mode-please)
(add-hook 'css-mode-hook 'linum-mode-please)

;; ediff-trees
;(require 'ediff-trees)

;; re-builder+
;(require 're-builder+)

;; hidelines.el
;;(autoload 'hide-lines "hide-lines" "Hide lines based on a regexp" t)
;;(global-set-key "\C-ch" 'hide-lines)

;; mmm-mode setup
(setq mmm-global-mode 'maybe)
(mmm-add-mode-ext-class 'html-mode "\\.php\\'" 'html-php)
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

;;start emacs-server
(server-start)

;;buffer boundries not scrollbars
(setq-default indicate-empty-lines t)
(setq-default indicate-buffer-boundaries 'left)

;;textile minor mode (http://code.google.com/p/textile-minor-mode/)
;;(require 'textile-minor-mode)

;;org-jira setup
;;(setq jiralib-url "https://jira.city.ac.uk/tracker")
;;(require 'org-jira)

;;external browser setup
(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "chromium-browser")

;;mark-multiple modules
(require 'inline-string-rectangle)
(global-set-key (kbd "C-x r t") 'inline-string-rectangle)

(require 'mark-more-like-this)
(global-set-key (kbd "C-<") 'mark-previous-like-this)
(global-set-key (kbd "C->") 'mark-next-like-this)
(global-set-key (kbd "C-M-m") 'mark-more-like-this)

;;marmalade
(require 'package)
(add-to-list 'package-archives
  '("marmalade" . "http://marmalade-repo.org/packages/"))
(package-initialize)

;;yasnippet setup
(setq yas/root-directory '("~/.emacs.d/yasnippets"))
(mapc 'yas/load-directory yas/root-directory)