;;; init-recentf.el ---  配置跟踪最近的文件
;;; Commentary:
;;; Code:

(add-hook 'after-init-hook 'recentf-mode)
(setq-default
 recentf-max-menu-items 1000
 recentf-exclude `("/tmp/" "/ssh:" ,(concat package-user-dir "/.*-autoloads\\.el\\'")))

(provide `init-recentf)
;;; init-recentf.el ends here


