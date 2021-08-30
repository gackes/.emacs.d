;; init-lisp.el  Emacs lisp setting, common config 


(setq-default debugger-bury-or-kill 'kill)

;; debugger-bury-or-kill 退出'debug'时在调试器buffer做些什么
;; 值为nil, 意味着退出调试器时，如果窗口没有被删除，会使用"switch-to-pre-buffer"继续显示调试器buffer
;; append, 如果窗口没有删除，"switch-to-pre-buffer"不可能选择调试器buffer
;; bury的话就更加不可能选择调试器buffer
;; kill意味着关闭调试器buffer

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
;; 保存当前的point和buffer，并执行BODY。和progn的作用差不多

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
