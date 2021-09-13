;;; init-org.el  ---- 配置org文件
;;; Commentary:
;;; Code:

;; (require-package 'ob-sh)

(org-babel-do-load-languages
 'org-babel-load-languages
 '(
   (shell . t)
   (python . t)
   (R . t)
   (octave . t)
   (C . t)
   (lua . t)
   (gnuplot . t)
   (dot . t)
   (emacs-lisp . t)
   (js . t)
   ))




(provide 'init-org)
;;; init-org.el ends here
