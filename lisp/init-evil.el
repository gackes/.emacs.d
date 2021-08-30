;;; init-evil Emacs下使用vim模式的插件

(require-package `evil)
(require-package `evil-surround)
;; 激活 Leader
;; (global-evil-leader-mode)

(evil-mode 1)
(global-evil-surround-mode)



(provide 'init-evil)

