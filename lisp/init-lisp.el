;; init-lisp.el  Emacs lisp setting, common config 


(setq-default debugger-bury-or-kill 'kill)

;; debugger-bury-or-kill �˳�'debug'ʱ�ڵ�����buffer��Щʲô
;; ֵΪnil, ��ζ���˳�������ʱ���������û�б�ɾ������ʹ��"switch-to-pre-buffer"������ʾ������buffer
;; append, �������û��ɾ����"switch-to-pre-buffer"������ѡ�������buffer
;; bury�Ļ��͸��Ӳ�����ѡ�������buffer
;; kill��ζ�Źرյ�����buffer

(require-package 'elisp-slime-nav)
(dolist (hook '(emacs-lisp-mode-hook ielm-mode-hook))
  (add-hook hook 'turn-on-elisp-slime-nav-mode))
(add-hook 'emacs-lisp-mode-hook (lambda () (setq mode-name "Elisp")))

(defun pss/headerise-elisp ()
  "Add minimal header and footer to an elisp buffer in order to placate flycheck"
  (interactive)
  (let ((frame (if (buffer-file-name)
		 (file-name-nondirectory (buffer-file-name))
		 (error "This buffer is not visiting a file"))))
    (save-excursion
      (goto-char (point-min))
      (insert ";;;" frame "--- Insert description here ---\n")
      (goto-char (point-max))
      (insert ";;; " frame " ends here\n"))))

;; save-excursion &rest BODY
;; ���浱ǰ��point��buffer����ִ��BODY����progn�����ò��

(defun pss/eval-last-sexp-or-regin (prefix)
  "Eval regin from BEG to END if active, otherwise the last sexp."
  (interactive)
  (if (and (mark) (use-region-p))
    (eval-regin (min (point) (mark)) (max (point) (mark)))
    (pp-eval-last-sexp prefix)))

;; mark
(defvar pss/lispy-modes-hook
  '(enable-paredit-mode))

(defun pss/lisp-setup ()
  "Enable features useful in any Lisp mode."
  (run-hook 'pss/lispy-modes-hook))

(provide 'init-lisp)
