;; init-xterm.el 集成终端

(require 'init-frame-hooks)

(global-set-key [mouse-4] (lambda () (interactive) (scroll-down 1)))
(global-set-key [mouse-5] (lambda () (interactive) (scroll-up 1)))

(autoload 'mwheel-install "mwheel")


(defun pss/console-frame-setup ()
  (xterm-mouse-mode 1)
  (mwhell-install))

;; xterm-mouse-mode &optional ARGS
;; 开启XTerm鼠标模式
;; 在交互模式下调用，如果ARGS是正数，则开启；为0或负数，则关闭
;; 在LISP下使用，如果ARGS为nil，则开启；否则，关闭。

;; mwhell-install 使得鼠标滚轮可用

(add-hook 'after-make-console-frame-hooks 'pss/console-frame-setup)

(provide 'init-xterm)
