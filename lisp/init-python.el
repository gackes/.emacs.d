;; init-python.el Python????

(setq auto-mode-alist (append '(("SConstruct\\'" . python-mode)
				("SConscript\\'" . python-mode))
			      auto-mode-alist))

(setq python-shell-interpreter "python3")

(require-package 'pip-requirements)

(when (maybe-require-package 'anaconda-mode)
  (with-eval-after-load 'python
			(add-hook 'python-mode-hook
				  (lambda () (unless (file-remote-p default-directory)
					       (anaconda-mode 1))))
			(add-hook 'anaconda-mode-hook
				  (lambda ()
				    (anaconda-eldoc-mode (if anaconda-mode 1 0)))))
  (with-eval-after-load 'anaconda-mode
			(define-key anaconda-mode-map (kbd "M-?") nil))
  (when (maybe-require-package 'company-anaconda)
    (with-eval-after-load 'company
			  (with-eval-after-load 'python
						(add-to-list 'company-backends 'company-anaconda)))))

(when (maybe-require-package 'toml-mode)
  (add-to-list 'auto-mode-alist '("poetry\\.lock\\'" . toml-mode)))

(when (maybe-require-package 'reformatter)
  (reformatter-define black :program "black"))

(provide 'init-python)
