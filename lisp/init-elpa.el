;; init-elpa.el 与package.el有关

(require 'package)
(require 'cl-lib)

(setq package-user-dir
      (expand-file-name (format "elpa-%s-%s" emacs-major-version emacs-minor-version)
			user-emacs-directory))

;; package-user-dir 为包含lisp包的目录，应该是绝对路径

(setq package-archives '(("gnu" . "http://elpa.emacs-china.org/gnu/")
			  ("melpa" . "https://elpa.emacs-china.org/melpa/")))
;; (add-to-list 'package-archives '(("gnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
;;				 ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")) t)
;; (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; add-to-list LIST-VAR ELEMENT &optional APPEND COMPARE-FN
;; APPEND如果为nil，则ELEMNENT会加在LIST-VAR的开头；否则，在结尾。

(when (and (version< emacs-version "26.3") (boundp 'libgnutls-version) (>= libgnutls-version 20604))
  (setq gnutls-algorithm-priority "NORMAK:-VERS-TLS1/3"))

;; boundp Symbol
;; 如果Symbol不为空，返回t

(defun require-package (package &optional min-version no-refresh)
  "Install PACKAGE. If NO-REFRESH is non-nil, the available package lists will not be re-downloaded in order to locate PACKAGE"
  (or (package-installed-p package min-version)
      (let* ((known (cdr (assoc package package-archive-contents)))
	    (best (car (sort known (lambda (a b)
			     (version-list-<= (package-desc-version b)
					      (package-desc-version a)))))))
      (if (and best (version-list-<= min-version (package-desc-version best)))
	(package-install best)
	(if no-refresh
	  (error "No version of %s >= %S is available" package min-version)
	  (package-refresh-contents)
	  (require-package package min-version t)))
      (package-installed-p package min-version))))


;; package-installed-p package min-version

;; package-archive-contents 是一个package-archives的缓存
;; 它是一个alist，键是包名，值是package-desc结构的列表
;; package-desc包含name, version, summary等


;; sort SEQ PREDICATE
;; 排序SEQ，使用PREDICATE来比较元素
;; 如果第一个元素要排在第二个元素后面，PREDICATE应该返回non-nil

;; version-list-<= L1 L2
;; 如果列表 L1 小于等于列表 L2 的话返回 t
;; 例如 (1) 等于 (1 0) (1 0 0) ，大于(1 -1 -2)


;; package-desc-version CL-X
;; 获取 package-desc结构中的version

;; package-refresh-contents &optional ASYNC
;; 下载所有配置的ELPA包的描述。每个package-archives的配置将会提供emacs它最新的包。
;; ASYNC是说是否在后台下载

(defun maybe-require-package (package &optional min-version no-refresh)
  "Try to install PACKAGE, and return non-nil if successful.
  In the event of failure, return nil and print a warning message."
  (condition-case err
		  (require-package package min-version no-refresh)
		  (error 
		    (message "Couldn't install optional package `&s': %s`" package err)
		    nil)))

;; condition-case VAR BODYFORM &rest HANDLERS
;; 如果没有错误发生执行BODYFORM，返回执行的结果
;; HANDLERS的元素是(CONDITION-NAME BODY ...), BODY是LISP的S表达式
;; 如果BODY出现错误，即标志某一错误，设置标志使用的函数为(signal 错误的符号 描述字符串)
;; 此时VAR的值变为(错误的符号 .  描述字符串)，然后在HANDLERS中找错误符号对应的条件名，并执行该条件对应的BODY
;; 错误的符号和其对应的条件名是使用(define 错误的符号 条件名)


(setq package-enable-at-startup nil)
(package-initialize)

;; package-enable-at-startup 在emacs启动时是否使已经安装的包可利用
;; 如果为non-nil，包在读init文件之前就能使用
;; 不管该变量值为什么，都可以使用package-initialize来使包可用

;; package-initialize &optional NO-ACTIVATE
;; 装载Emacs Lisp Package，并激活
;; 变量package-load-list决定那个包装载
;; NO-ACTIVATE说明是否激活

(defvar pss/required-packages nil)

(defun pss/note-selected-package (oldfun package &rest args)
"If OLDFUN reports PACKAGE was successfully installed, note that fact."
  (let ((available (apply oldfun package args)))
    (prog1
      available
      (when available
	(add-to-list 'pss/required-packages package)))))

;; prog1 FIRST BODY
;; 按顺序执行FIRST BODY，返回FIRST的值，FIRST的值在剩下参数计算时是一直保存的

(advice-add 'require-package :around 'pss/note-selected-package)

(when (fboundp 'package--save-selected-package)
  (require-package 'seq)
  (add-hook 'after-init-hook
	    (lambda ()
	      (package--save-selected-package
		(seq-uniq (append pss/required-packages package-selected-packages))))))

;; package--save-selected-package &optional VALUE
;; 把'package-selected-packages'的设置并保存为VALUE
;; package-selected-packages存储被用户安装的包，当用户安装新包时会自动保存到package-selected-packages
;; 检查一个包是否在此列表中可使用'package--user-selected-p'
;; 使用'package-autoremove'时依据此列表删除包

;; seq-uniq SEQUENCE &optional TESTEN
;; 把SEQUENCE中重复的元素删除保留一个，返回这个处理后的SEQUENCE
  
(require-package 'fullframe)
(fullframe list-packages quit-window)

;; fullframe

(defun pss/set-tabulated-list-column-windth (col-name width)
  "Set any column with name COL-NAME to the given WIDTH."
  (when (> width (length col-name))
    (cl-loop for column across tabulated-list-format
	     when (string= col-name (car column))
	     do (setf (elt column 1) width))))

(defun pss/maybe-widen-package-menu-columns ()
  "Widen some colnumns of the package menu table to avoid truncation."
  (when (boundp 'tabulated-list-format)
    (pss/set-tabulated-list-column-windth "Version" 13)
    (let ((longest-archive-name (apply 'max (mapcar 'length (mapcar 'car package-archives)))))
      (pss/set-tabulated-list-column-windth "Archive" longest-archive-name))))

(add-hook 'package-menu-mode-hook 'pss/maybe-widen-package-menu-columns)

(provide 'init-elpa)
