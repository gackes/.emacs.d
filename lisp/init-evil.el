;;; init-evil --- Emacs下使用vim模式的插件
;;; Commentary:
;;; Code:

(add-to-list 'load-path "G:\Emacs\.emacs.d\lisp")
(require-package 'evil)
(require-package 'evil-surround)
(require-package 'evil-nerd-commenter)
(require-package 'evil-leader)
;; 激活 Leader
(global-evil-leader-mode)

(evil-mode 1)
(global-evil-surround-mode)

(evilnc-default-hotkeys)
(evil-leader/set-key
  "ci" 'evilnc-comment-or-uncomment-lines
  "cl" 'evilnc-comment-or-uncomment-to-the-line
  "ll" 'evilnc-comment-or-uncomment-to-the-line
  "cc" 'evilnc-copy-and-comment-lines
  "cp" 'evilnc-comment-or-uncomment-paragraphs
  "cr" 'comment-or-uncomment-region
  "cv" 'evilnc-toggle-invert-comment-line-by-line
  "." 'evilnc-copy-and-comment-operator
  "\\" 'evilnc-comment-operator)

(provide 'init-evil)
;;; init-evil.el ends here
