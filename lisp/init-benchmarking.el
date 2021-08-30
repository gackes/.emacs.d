;;; init-benchmarking.el ��������ʱ��

(defun pss/time-subtract-millis (b a)
  (* 1000.0 (float-time (time-subtract b a))))

;; time-substract (b a) ��������ʱ��֮��
;; float-time û�в���ʱ���ص�ǰ��ʱ�䣬���㷽ʽӦ���Ǵ�1997�꿪ʼ�Ǹ�
;; �в����Ͱ���ת��Ϊfloat

(defvar pss/required-times nil
  "A list of (FEATURE LOAD_START_TIME LOAD_DURATION)
  LOAD_DURATION is the time taken in millisecond to load FEATURE")

(defun pss/required-time-wrapper (orig feature &rest args)
  ""
  (let* ((already-loaded (memq feature features))
	 (require-start-time (and (not already-loaded) (current-time))))
    (prog1
      (apply orig feature args)
      (when (and (not already-loaded) (memq feature features))
	(let ((time (pss/time-subtract-millis (current-time) require-start-time)))
	  (add-to-list 'pss/required-times 
		       (list feature require-start-time time)
		       t))))))

;; memq (ELT LIST) �� eq �ж� ELT �ڲ��� LIST �У� ����ڷ��� non-nil
;; features�� Emacs ����ʱ��������ɵķ����б� 
;; prog1 FIRST BODY ��ִ��FIRST����ִ��BODY������ֵ��FIRST�Ľ��
;; apply FUNCTION &rest ARGUMENTS ��ARGMNETS����������FUNCTION

(advice-add 'require :around 'pss/required-time-wrapper)

;; advice-add SYMBOL WHERE FUNCTION &optional PROPS
;; �� SYMBOL�󶨵���һ������
;; whereָ�����������͡�
;; 	����ǣ�:around��SYMBOL�󶨵� (lambda (&rest x) (apply FUNCTION SYMBOL x))
;;	����ǣ�:filter-return��SYMBOL�󶨵� (lambda (&rest x) (funcall FUNCTION (apply SYMBOL x)))
;; ���������е�SYMBOL��֮ǰ��ֵ


(define-derived-mode pss/required-time-mode tabulated-list-mode "Required-Time"
		     "show times taken to 'required' packages."
		     (setq tabulated-list-format
			   [("Start time (ms)" 20 pss/require-times-sort-by-start-time-pred)
			    ("Feature" 30 t)
			    ("Time (ms)" 12 pss/require-times-sort-by-load-time-prd)])
		     (setq tabulated-list-sort-key (cons "Start time (ms)" nil))
		     (setq tabulated-list-entries #'pss/require-times-tabulated-list-entries)
		     (tabulated-list-init-header)
		     (when (fboundp 'tablist-minor-mode)
		       (tablist-minor-mode)))

;; define-derived-mode CHILD PARENT NAME [DOCSTRING] [KEYWORD-ARGS...] &rest BODY
;; ����һ������ģʽPARENT�ı���ģʽCHILD
;; NAME����״̬����ʾ���ַ���
;; [DOCSTRING]��˵���ַ���
;; [KEYWORD-ARGS]�Ǽ�ֵ��

;; tabulated-list-format ��һ�������������
;;	NAME ��ǰ�е�����
;;	WIDTH ��ǰ�еĿ��
;;	SORT ��ǰ�е����򷽷�

;; tabulated-list-sort-key 
;; Ϊnil˵��û����������������
;; �������Ӧ����(NAME . FLIP)
;;	NAME����tabulated-list-format�ж�Ӧ��NAME
;;FLIPΪnon-nil����ζ������NAMEѡ�е���

;; tabulated-list-entries 
;; �ڵ�ǰtabulated list buffer��ʾ��ʵ�壬��ֵ������list����function
;; ���Ϊlist��ÿ��Ԫ�ص���ʽӦ���� (ID [DESC1 DESC2 ...])
;; 	ID ��nil ����������ʾʵ���Lisp Object������Ǻ��ߵĻ�����꽫������ͬ��ʵ��
;;	DESC ���������ӣ���һ���б��б��Ԫ����tabulated-list-format����ġ������������String������ԭ����������ʾ��buffer�С������������list [LABEL . PROPS]��������insert-text-button LABEL PROPS��
;; ���Ϊfunction������Ӧ�÷����������͵�list

;; tabulated-list-init-header ΪTabulated List Buffer����һ��Header Line(������)

;; tablist-minor-mode ����tablist minor mode

(defun pss/require-times-sort-by-start-time-pred (entry1 entry2)
  (< (string-to-number (elt (nth 1 entry1) 0))
     (string-to-number (elt (nth 1 entry2) 0))))

;; elt SEQUENCE N
;; ����SEQUENCE�еĵ�N��


(defun pss/require-times-sort-by-load-time-prd (entry1 entry2)
  (> (string-to-number (elt (nth 1 entry1) 2))
     (string-to-number (elt (nth 1 entry2) 2))))

(defun pss/require-times-tabulated-list-entries ()
  (cl-loop for (feature start-time millis) in pss/required-times
	   with order = 0
	   do (incf order)
	   collect (list order
			 (vector 
			   (format "%.3f" (pss/time-subtract-millis start-time before-init-time))
			   (symbol-name feature)
			   (format "%.3f" millis)))))

(defun pss/require-times ()
  "Show a tabular view of how long various libraries took to load"
  (interactive)
  (with-current-buffer (get-buffer-create "*Require Times*")
		       (pss/required-time-mode)
		       (tabulated-list-revert)
		       (display-buffer (current-buffer))))

;; with-current-buffer BUFFER-OR-NAME &rest BODY
;; �� BUFFER-OR-NAME ����ʱ��ִ��BODY��BUFFER-OR-NAME������BUFEER������Buffer Name

;; get-buffer-create BUFFER-OR-NAME
;; ���BUFFER-OR-NAME���Ѿ����ڵ�buffer����ͬ�����֣��򷵻ظ�buffer�����򴴽�һ���µ�buffer

;; display-buffer BUFFER-OR-NAME &optional ACTION FRAME
;; ��ĳ��window��ʾBUFFER-OR-NAME, �������������window�򷵻ظ�window,���򷵻�nil


(defun pss/show-init-time ()
  (message "init completed in %.2fms" (pss/time-subtract-millis after-init-time before-init-time)))

(add-hook 'after-init-hook 'pss/show-init-time)

(provide 'init-benchmarking)
