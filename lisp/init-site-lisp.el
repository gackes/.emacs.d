;; init-site-lisp.el ֧��elisp����site-lisp idr���ֶ���װ

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
;; �Ƴ�������SEQ�в�����PREDICATE����

;; directory-files DIRECTORY &optional FULL MATCH NOSORT
;; ����DIRECTORY���ļ������б�
;; ���FULLΪnon-nil�������������ļ���
;; ���MATCHΪnon-nil����������MATCH���ļ���
;; ���NOSORTΪnon-nil�����ص��ļ��������򣻷��򣬻�ʹ��"string-lessp"����

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
;; ��URL�����ݸ��Ƶ�NEWNAME��
;; OK-IF-ALREADY-EXISTSΪnon-nil������ļ��Ѿ����ڲ��ᱨ��
;; 

(defun ensure-lib-from-url (name url)
  (unless (site-lisp-library-loadable-p name)
    (byte-compile-file (download-site-lisp-module name url))))

;; byte-comile-file FILENAME &optional LOAD
;; ����FILENAMEΪ�ֽڴ���


(defun site-lisp-library-loadable-p (name)
  "Return whether or not the library 'name' can be loaded from a source file under ~/.emacs.d/site-lisp/name"
  (let ((f (locate-library (symbol-name name))))
    (and f (string-prefix-p (file-name-as-directory (site-lisp-dir-for name)) f))))

;; locate-library LIBRARY &optional NOSUFFIX PATH INTERACTIVE-CALL
;; չʾLIBRARY��ȷ���ļ�����LIBRARYӦ��������ļ���
;; ���NOSUFFIXΪnil����LIBRARY���Ժ����ļ�����׺

;; file-name-as-directory FILE
;; ����һ��string����ʾFILE��Ӧ��Ŀ¼��
;; ����������ԭ����һ��Ŀ¼Ҳ��һ���ļ������Ǳ�ʾĿ¼�����ļ�ʱ�����ֲ�һ��

;; string-prefix-p PREFIX STRING &optional IGNORE-CASE
;; ���PREFIX��STRING��ǰ׺���򷵻�non-nil
;; ���IGNORE-CASE��non-nil����Ƚϲ�ע���Сд


(provide 'init-site-lisp)
