;;; init-yasnippet.el --- 代码略写配置
;;; Commentary:
;;; Code:

(require-package 'yasnippet)
;; (yas-reload-all)
;; (add-hook 'prog-mode-hook #'yas-minor-mode)
(yas-global-mode 1)
;;  (require-package 'yasnippet-snippets)
(setq yas-snippet-dirs
       '("~/.emacs.d/snippets"))

(provide 'init-yasnippet)
;;; init-yasnippet.el ends here
