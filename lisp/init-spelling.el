;; init-spelling.el Æ´Ð´¼ì²é

(require 'ispell)

(when (executable-find ispell-program-name)
  (add-hook 'prog-mode-hook 'flyspell-prog-mode)

  (with-eval-after-load 'flyspell
			 (define-key flyspell-mode-map (kbd "C-;") nil)
			 (add-to-list 'flyspell-prog-text-faces 'nxml-text-face)))

(provide 'init-spelling)
