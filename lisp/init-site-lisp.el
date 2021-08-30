;; init-site-lisp.el 支持elisp库在site-lisp idr的手动安装

(require 'cl-lib)

(defun pss/add-subdirs-to-load-path (parent-dir)
  "Add every non-hidden subdir of PARENT-DIR to 'load-path'."
  (let ((default-directory parent-dir))
    (setq load-path 
	  (append
	    (cl-remove-if-not
	      #'file-directory-p
	      (directory-files (expand-file-name parent-dir) t "^[^\\.]"))
	    load-path))))

;; cl-remove-if-not PREDICATE SEQ [KEYWORD VALUE] ...
;; 移除所有在SEQ中不满足PREDICATE的项

;; directory-files DIRECTORY &optional FULL MATCH NOSORT
;; 返回DIRECTORY中文件名的列表
;; 如果FULL为non-nil，返回完整的文件名
;; 如果MATCH为non-nil，返回满足MATCH的文件名
;; 如何NOSORT为non-nil，返回的文件名不排序；否则，会使用"string-lessp"排序

(let ((site-lisp-dir (expand-file-name "site-lisp/" user-emacs-directory)))
  (push site-lisp-dir load-path)
  (pss/add-subdirs-to-load-path site-lisp-dir))

(defun site-lisp-dir-for (name)
  (expand-file-name (format "site-lisp/%s" name) user-emacs-directory))

(defun site-lisp-library-el-path (name)
  (expand-file-name (format "%s.el" name) (site-lisp-dir-for name)))

(defun download-site-lisp-module (name url)
  (let ((dir (site-lisp-dir-for name)))
    (message "Downloading %s from %s" name url)
    (unless (file-directory-p dir)
      (make-directory dir t))
    (add-to-list 'load-path dir)
    (let ((el-file (site-lisp-library-el-path name)))
      (url-copy-file url el-file t nil)
      el-file)))

;; url-copy-file URL NEWNAME &optional OK-IF-ALREADY-EXISTS &rest IGNORED
;; 把URL的内容复制到NEWNAME中
;; OK-IF-ALREADY-EXISTS为non-nil，如果文件已经存在不会报错
;; 

(defun ensure-lib-from-url (name url)
  (unless (site-lisp-library-loadable-p name)
    (byte-compile-file (download-site-lisp-module name url))))

;; byte-comile-file FILENAME &optional LOAD
;; 编译FILENAME为字节代码


(defun site-lisp-library-loadable-p (name)
  "Return whether or not the library 'name' can be loaded from a source file under ~/.emacs.d/site-lisp/name"
  (let ((f (locate-library (symbol-name name))))
    (and f (string-prefix-p (file-name-as-directory (site-lisp-dir-for name)) f))))

;; locate-library LIBRARY &optional NOSUFFIX PATH INTERACTIVE-CALL
;; 展示LIBRARY精确的文件名，LIBRARY应该是相对文件名
;; 如果NOSUFFIX为nil，则LIBRARY可以忽略文件名后缀

;; file-name-as-directory FILE
;; 返回一个string，表示FILE对应的目录名
;; 能这样做的原因是一个目录也是一个文件，但是表示目录还是文件时的名字不一样

;; string-prefix-p PREFIX STRING &optional IGNORE-CASE
;; 如果PREFIX是STRING的前缀，则返回non-nil
;; 如果IGNORE-CASE是non-nil，则比较不注意大小写


(provide 'init-site-lisp)
