;;; init-misc.el --- ªÏ∫œµƒ≈‰÷√
;;; Commentary:
;;; Code:

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

;; (when (maybe-require-package 'hungry-delete)
;;   (add-hook 'prog-mode-hook #'(lambda() (hungry-keyboard prog-mode-map)))
;;   (add-hook 'c-mode-hook #'(lambda () (hungry-keyboard c-mode-map)))
;;   (add-hook 'c++-mode-hook #'(lambda() (hungry-keyboard c++-mode-map))))

(add-hook 'prog-mode-hook #'(lambda () (hungry-delete-mode t)))

(electric-pair-mode t)
(setq electric-pair-pairs '((?\" . ?\")
			    (?\< . ?\>)
			    (?\( . ?\))
			    (?\[ . ?\])
			    (?\{ . ?\})
			    (?\' . ?\')
			    ))

(show-paren-mode 1)
(setq show-paren-style 'paranthesis)

(provide 'init-misc)
;;; init-misc.el ends here
