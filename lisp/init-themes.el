;; init-themes.el ����

(require-package 'all-the-icons)
(require-package 'doom-themes)
(require-package 'doom-modeline)
(setq custom-safe-themes t)

;; custom-safe-themesΪt����Ϊ���е����ⶼ��safe

(setq doom-themes-enable-bold t
      doom-themes-enable-italic t)

(setq-default custom-enabled-themes '(doom-one))

;; custom-enabled-themes ��ʹ�õ�custom �����б���ߵ����ȴ���

(doom-themes-visual-bell-config)
(doom-themes-neotree-config)

(defun reapply-themes ()
  "Forcibly load the themes listed in 'custom-enabled-themes'"
  (dolist (theme custom-enabled-themes)
    (unless (custom-theme-p theme)
      (load-theme theme)))
  (custom-set-variables `(custom-enabled-themes (quote ,custom-enabled-themes))))

;; custom-theme-p THEME
;; �����Ѿ������˷���non-nil
;; custom-set-variables

(setq doom-modeline-icon (display-graphic-p))
(setq doom-modeline-major-mode-icon t)
(setq doom-modeline-major-mode-color-icon t)
(setq doom-modeline-buffer-state-icon t)
(setq doom-modeline-enable-word-count t)
(setq doom-modeline-buffer-encoding t)
(setq doom-modeline-workspace-name t)
(setq doom-modeline-lsp t)

(doom-modeline-mode 1) 
;;(add-hook 'after-init-hook 'reapply-themes)
(reapply-themes)

(defun pss/doom-one()
  "Enable doom-one theme"
  (interactive)
  (setq custom-enabled-themes '(doom-one));;ע�����()�Ǳ����
  (reapply-themes))

(defun pss/doom-one-light()
  "Enable light theme."
  (interactive)
  (setq custom-enabled-themes '(doom-one-light))
  (reapply-themes))
  ;;(load-theme 'doom-one-light))

(defun pss/doom-moonlight()
  "Enable doom-moonlight theme"
  (interactive)
  (setq custom-enabled-themes '(doom-moonlight))
  (reapply-themes))
  ;;(load-theme 'doom-vibrant))

(defun pss/doom-monokai-octagon ()
  "ENABLE doom-monokai-pro theme."
  (interactive)
  (setq custom-enabled-themes '(doom-monokai-octagon))
  (reapply-themes))

(defun pss/doom-solarized-light ()
  "ENABLE doom-solarized-light theme."
  (interactive)
  (setq custom-enabled-themes '(doom-solarized-light))
  (reapply-themes))

(when (maybe-require-package 'dimmer)
  (setq-default dimmer-fraction 0.3)
  (add-hook 'after-init-hook 'dimmer-mode)
  (with-eval-after-load 'dimmer
			(advice-add 'frame-set-background-mode :after (lambda (&rest args) (dimmer-process-all))))
  (with-eval-after-load 'dimmer
			(defun pss/display-non-graphic-p ()
			  (not (display-graphic-p)))
			(add-to-list 'dimmer-exclusion-predicateds 'pss/display-non-graphic-p)))

(provide 'init-themes)
