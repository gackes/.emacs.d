;; init-misc.el ªÏ∫œµƒ≈‰÷√

(add-auto-mode 'tcl-mode "^Portfile\\'")
(fset 'yes-or-no-p 'y-or-n-p)

(add-hook 'prog-mode-hook 'goto-address-prog-mode)
(setq goto-address-mail-face 'link)


(when (maybe-require-package 'info-colors)
  (with-eval-after-load 'info
			(add-hook 'Info-slection-hook 'info-colors-fontify-node)))

(setq make-backup-files nil)

(when (maybe-require-package 'rainbow-delimiters)
  (add-hook 'after-init-hook #'rainbow-delimiters-mode))

(provide 'init-misc)

