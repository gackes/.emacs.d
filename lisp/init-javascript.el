;; init-javascript.el Javascript ≈‰÷√

(maybe-require-package 'json-mode)
(maybe-require-package 'js2-mode)
(maybe-require-package 'prettier-js)

(add-to-list 'auto-mode-alist '("\\.\\(js\\|es6\\)\\(\\.erb\\)?\\'" . js-mode))

;;(with-eval-after-load 'js
;;		      (pss/major-mode-lighter 'js-mode "JS")
;;		      (pss/major-mode-lighter 'js-jsx-mode "JSX"))

(provide 'init-javascript)
