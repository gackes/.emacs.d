;; init-spelling.el ƴд���

(require 'ispell)

(when (executable-find ispell-program-name)
  (add-hook 'prog-mode-hook 'flyspell-prog-mode)

  (withe-eval-after-load 'flyspell
			 (define-key flyspell-mode-map (kbd "C-;") nil)
li			 (add-to-list 'flyspell-prog-text-faces 'nxml-text-face)))

(provide 'init-spelling)
