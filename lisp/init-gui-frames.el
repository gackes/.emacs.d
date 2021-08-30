;;; init-gui-frames GUI配置

(setq-default initial-scratch-message (concat ";; Hello , " user-login-name " Emacs need you!\n\n"))

(setq use-file-dialog nil)
(setq use-dialog-box nil)
(setq inhibit-startup-screen nil)
(setq inhibit-splash-screen nil)

(tool-bar-mode -1)
(set-scroll-bar-mode nil)
(menu-bar-mode -1)
(global-linum-mode 1)

(provide 'init-gui-frames)
