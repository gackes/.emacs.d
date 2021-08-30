;; init-ido.el  ido-mode配置

(require 'ido)
(ido-mode 1)

(setq ido-enable-flex-matching t)

(setq ido-enable-regexp t)

(setq ido-enable-last-directory-history t)

(setq ido-use-filename-at-point 'guess)

(setq ido-everywhere t)

(make-local-variable 'ido-decorations)
(setf (nth 2 ido-decorations) "\n")

(provide 'init-ido)
