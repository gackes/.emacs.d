;; init-elpa.el ��package.el�й�

(require 'package)
(require 'cl-lib)

(setq package-user-dir
      (expand-file-name (format "elpa-%s-%s" emacs-major-version emacs-minor-version)
			user-emacs-directory))

;; package-user-dir Ϊ����lisp����Ŀ¼��Ӧ���Ǿ���·��

(setq package-archives '(("gnu" . "http://elpa.emacs-china.org/gnu/")
			  ("melpa" . "https://elpa.emacs-china.org/melpa/")))
;; (add-to-list 'package-archives '(("gnu" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/gnu/")
;;				 ("melpa" . "http://mirrors.tuna.tsinghua.edu.cn/elpa/melpa/")) t)
;; (add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

;; add-to-list LIST-VAR ELEMENT &optional APPEND COMPARE-FN
;; APPEND���Ϊnil����ELEMNENT�����LIST-VAR�Ŀ�ͷ�������ڽ�β��

(when (and (version< emacs-version "26.3") (boundp 'libgnutls-version) (>= libgnutls-version 20604))
  (setq gnutls-algorithm-priority "NORMAK:-VERS-TLS1/3"))

;; boundp Symbol
;; ���Symbol��Ϊ�գ�����t

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

;; package-archive-contents ��һ��package-archives�Ļ���
;; ����һ��alist�����ǰ�����ֵ��package-desc�ṹ���б�
;; package-desc����name, version, summary��


;; sort SEQ PREDICATE
;; ����SEQ��ʹ��PREDICATE���Ƚ�Ԫ��
;; �����һ��Ԫ��Ҫ���ڵڶ���Ԫ�غ��棬PREDICATEӦ�÷���non-nil

;; version-list-<= L1 L2
;; ����б� L1 С�ڵ����б� L2 �Ļ����� t
;; ���� (1) ���� (1 0) (1 0 0) ������(1 -1 -2)


;; package-desc-version CL-X
;; ��ȡ package-desc�ṹ�е�version

;; package-refresh-contents &optional ASYNC
;; �����������õ�ELPA����������ÿ��package-archives�����ý����ṩemacs�����µİ���
;; ASYNC��˵�Ƿ��ں�̨����

(defun maybe-require-package (package &optional min-version no-refresh)
  "Try to install PACKAGE, and return non-nil if successful.
  In the event of failure, return nil and print a warning message."
  (condition-case err
		  (require-package package min-version no-refresh)
		  (error 
		    (message "Couldn't install optional package `&s': %s`" package err)
		    nil)))

;; condition-case VAR BODYFORM &rest HANDLERS
;; ���û�д�����ִ��BODYFORM������ִ�еĽ��
;; HANDLERS��Ԫ����(CONDITION-NAME BODY ...), BODY��LISP��S���ʽ
;; ���BODY���ִ��󣬼���־ĳһ�������ñ�־ʹ�õĺ���Ϊ(signal ����ķ��� �����ַ���)
;; ��ʱVAR��ֵ��Ϊ(����ķ��� .  �����ַ���)��Ȼ����HANDLERS���Ҵ�����Ŷ�Ӧ������������ִ�и�������Ӧ��BODY
;; ����ķ��ź����Ӧ����������ʹ��(define ����ķ��� ������)


(setq package-enable-at-startup nil)
(package-initialize)

;; package-enable-at-startup ��emacs����ʱ�Ƿ�ʹ�Ѿ���װ�İ�������
;; ���Ϊnon-nil�����ڶ�init�ļ�֮ǰ����ʹ��
;; ���ܸñ���ֵΪʲô��������ʹ��package-initialize��ʹ������

;; package-initialize &optional NO-ACTIVATE
;; װ��Emacs Lisp Package��������
;; ����package-load-list�����Ǹ���װ��
;; NO-ACTIVATE˵���Ƿ񼤻�

(defvar pss/required-packages nil)

(defun pss/note-selected-package (oldfun package &rest args)
"If OLDFUN reports PACKAGE was successfully installed, note that fact."
  (let ((available (apply oldfun package args)))
    (prog1
      available
      (when available
	(add-to-list 'pss/required-packages package)))))

;; prog1 FIRST BODY
;; ��˳��ִ��FIRST BODY������FIRST��ֵ��FIRST��ֵ��ʣ�²�������ʱ��һֱ�����

(advice-add 'require-package :around 'pss/note-selected-package)

(when (fboundp 'package--save-selected-package)
  (require-package 'seq)
  (add-hook 'after-init-hook
	    (lambda ()
	      (package--save-selected-package
		(seq-uniq (append pss/required-packages package-selected-packages))))))

;; package--save-selected-package &optional VALUE
;; ��'package-selected-packages'�����ò�����ΪVALUE
;; package-selected-packages�洢���û���װ�İ������û���װ�°�ʱ���Զ����浽package-selected-packages
;; ���һ�����Ƿ��ڴ��б��п�ʹ��'package--user-selected-p'
;; ʹ��'package-autoremove'ʱ���ݴ��б�ɾ����

;; seq-uniq SEQUENCE &optional TESTEN
;; ��SEQUENCE���ظ���Ԫ��ɾ������һ�����������������SEQUENCE
  
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
