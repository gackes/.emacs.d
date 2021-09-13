;;; init.el -- 装载全部配置文件
;;; Commentary:
;;; Code:

(let ((minversion "25.1"))
  (when (version< emacs-version minversion)
    (error "Emacs版本太低, 最低要求" minversion)))

;; version<是emacs自带函数，还有version=,version>

(when (version< emacs-version "26.1")
  (message "Emaca版本旧，可能有些功能不能使用。请更新。"))

(add-to-list 'load-path (expand-file-name "lisp" user-emacs-directory))

;; add-to-list是把第二个参数放到第一个参数的列表中
;; expand-file-name是获取"lisp"的路径，就是把第二个参数的路径加上"lisp"。
;; user-emacs-directory 是G:\Emacs\.emacs.d\这个路径，所以最后返回的结果是
;; G:\Emacs\.emacs.d\lisp，如果没有user-emacs-directory，那么使用的会是
;; default-directory，而它的值是 G:\Emacs

;; 用于修改require函数，引入计算每个包require时需要的时间
(require 'init-benchmarking)

(defconst *spell-check-support-enabled* nil)
(defconst *is-a-mac* (eq system-type 'darwin))

;; system-type返回系统类型

(let ((normal-gc-cons-threshold (* 20 1024 1024))
      (init-gc-cons-threshold (* 128 1024 1024)))
  (setq gc-cons-threshold init-gc-cons-threshold)
  (add-hook 'emacs-startup-hook
	    (lambda () (setq gc-cons-threshold (* 20 1024 1024)))))

;; gc-cons-threshold
;; 设置内存垃圾管理

;; 启动配置
(setq custom-file (expand-file-name "custom.el" user-emacs-directory))
;; 定义一些重命名、删除文件和buffer的函数
(require 'init-utils)
;; 定义手动下载包的函数
(require 'init-site-lisp)
;; 设置包下载网站，下载函数
(require 'init-elpa)
(require 'init-exec-path)
;; 设置环境变量
(require 'init-env)


;; 允许用户提供可选的"init-preload-local.el"
(require 'init-preload-local nil t)

;; 装载配置包
(require-package 'diminish)
(maybe-require-package 'scratch)
(require-package 'command-log-mode)

(require 'init-frame-hooks)
(require 'init-xterm)

;; 设置主题
(require 'init-themes)
;; 设置隐藏工具栏、菜单栏、显示行号
(require 'init-gui-frames)
(require 'init-dired)
;; 设置跟踪最近访问的文件
(require 'init-recentf)

;; 语法检查
(require 'init-flycheck)
;; 增强company的补全
(require 'init-hippie-expand)
(require 'init-company)
(require 'init-lsp)
;; 设置代码缩写
(require 'init-yasnippet)



;; 语言相关的配置
(require 'init-c)
(require 'init-markdown)
(require 'init-javascript)
(require 'init-python)
(require 'init-http)

;; 与lisp语言有关
(require 'init-lisp)
(require 'init-slime)
(require 'init-common-lisp)

;;用于ctr-x ctr-f和ctr-x b列出可能的结果
(require 'init-ido)
(require 'init-ivy)
(require 'init-spelling)
(require 'init-misc)
(require 'init-folding)
(require 'init-ripgrep)

;; vim有关的插件
(require 'init-evil)

;; Org-mode的配置
(require 'init-org)

(message "init文件装载完成。")
        
(provide 'init)
;;; init.el ends here
