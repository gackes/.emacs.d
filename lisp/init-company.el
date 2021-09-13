;;; init-company.el --- ��ȫ
;;; Commentary:
;;; Code:

(setq tab-always-indent 'complete)

;; tab-always-indent����tab������
;; ֵΪt��TAB��ֻ��������
;; ֵΪnil��
;; ֵΪcomplete��TAB��������������������Ѿ����ڣ�TAB����ʵ�ֲ�ȫ

(add-to-list 'completion-styles 'initials t)

;;

(when (maybe-require-package 'company)
  (add-hook 'after-init-hook 'global-company-mode)
  (with-eval-after-load 'company
    (diminish 'company-mode)
    (define-key company-mode-map (kbd "M-/") 'company-complete)
    (define-key company-mode-map [remap completion-at-point] 'company-complete)
    (define-key company-mode-map [remap indent-for-tab-command] 'company-indent-or-complete-common)
    (define-key company-active-map (kbd "M-/") 'company-other-backend)
    (define-key company-active-map (kbd "C-n") 'company-select-next)
    (define-key company-active-map (kbd "C-p") 'company-select-previous)
    (define-key company-active-map (kbd "C-d") 'company-show-doc-buffer)
    (define-key company-active-map (kbd "M-.") 'company-show-location)
;;    (define-key company-active-map (kbd "TAB")  'yas-expand)
    (setq-default company-dabbrev-other-buffers 'all
                  company-tooltip-align-annotations t))
  (global-set-key (kbd "M-C-/") 'company-complete)
  (when (maybe-require-package 'company-quickhelp)
    (add-hook 'after-init-hook 'company-quickhelp-mode)))

(provide 'init-company)
;;; init-company.el ends here
