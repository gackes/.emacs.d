;; init-xterm.el �����ն�

(require 'init-frame-hooks)

(global-set-key [mouse-4] (lambda () (interactive) (scroll-down 1)))
(global-set-key [mouse-5] (lambda () (interactive) (scroll-up 1)))

(autoload 'mwheel-install "mwheel")


(defun pss/console-frame-setup ()
  (xterm-mouse-mode 1)
  (mwhell-install))

;; xterm-mouse-mode &optional ARGS
;; ����XTerm���ģʽ
;; �ڽ���ģʽ�µ��ã����ARGS��������������Ϊ0��������ر�
;; ��LISP��ʹ�ã����ARGSΪnil�����������򣬹رա�

;; mwhell-install ʹ�������ֿ���

(add-hook 'after-make-console-frame-hooks 'pss/console-frame-setup)

(provide 'init-xterm)
