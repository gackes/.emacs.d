;;; init-lsp.el --- 语言服务器配置
;;; Commentary:
;;; Code:

(require-package 'lsp-mode)
(require-package 'lsp-ui)
(require-package 'lsp-treemacs)


(add-hook 'c-mode-hook #'lsp-deferred)
(add-hook 'c++-mode-hook #'lsp-deferred)

(add-hook 'lsp-mode-hook 'lsp-ui-mode)
(add-hook 'lsp-mode-hook 'flycheck-mode)


(provide 'init-lsp)
;;; init-lsp.el ends here
