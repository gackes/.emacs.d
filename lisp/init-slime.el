;; init-slime.el Slime support for Commom Lisp

(require-package 'slime)

(when (maybe-require-package 'slime-company)
  (setq slime-company-completion 'fuzzy
	slime-company-after-completion 'slime-company-just-one-space)
  (with-eval-after-load 'slime-company
			(add-to-list 'company-backends 'company-slime)))

(with-eval-after-load 'slime
		      (setq slime-protocol-version 'ignore)
		      (setq slime-net-coding-system 'utf-8-unix)
		      (let ((features '(slime-fancy slime-repl slime-fuzzy)))
			(when (require 'slime-company nil t)
			(push 'slime-company features))
		      (slime-setup features)) )

(defun pss/slime-repl-setup ()
  "Mode setup function for slime REPL"
  (pss/lisp-setup))

(with-eval-after-load 'slime-repl
		      (with-eval-after-load 'paredit
					    (define-key slime-repl-mode-map (read-kdb-macro paredit-backward-delete-ket) nil))
		      (define-key slime-repl-mode-map (kbd "TAB") 'indent-for-tab-command)
		      (add-hook 'slime-repl-mode-hook 'pss/slime-repl-setup))

(provide 'init-slime)
