;;; init-benchmarking.el 计算启动时间

(defun pss/time-subtract-millis (b a)
  (* 1000.0 (float-time (time-subtract b a))))

;; time-substract (b a) 返回两个时间之差
;; float-time 没有参数时返回当前的时间，计算方式应该是从1997年开始那个
;; 有参数就把它转换为float

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

;; memq (ELT LIST) 用 eq 判断 ELT 在不在 LIST 中， 如果在返回 non-nil
;; features是 Emacs 运行时的特征组成的符号列表 
;; prog1 FIRST BODY 先执行FIRST，在执行BODY，返回值是FIRST的结果
;; apply FUNCTION &rest ARGUMENTS 把ARGMNETS当参数传给FUNCTION

(advice-add 'require :around 'pss/required-time-wrapper)

;; advice-add SYMBOL WHERE FUNCTION &optional PROPS
;; 把 SYMBOL绑定到另一个函数
;; where指定函数的类型。
;; 	如果是：:around，SYMBOL绑定到 (lambda (&rest x) (apply FUNCTION SYMBOL x))
;;	如果是：:filter-return，SYMBOL绑定到 (lambda (&rest x) (funcall FUNCTION (apply SYMBOL x)))
;; 匿名函数中的SYMBOL是之前的值


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
;; 创建一个已有模式PARENT的变体模式CHILD
;; NAME是在状态栏显示的字符串
;; [DOCSTRING]是说明字符串
;; [KEYWORD-ARGS]是键值对

;; tabulated-list-format 是一个向量，存的是
;;	NAME 当前列的名字
;;	WIDTH 当前列的宽度
;;	SORT 当前列的排序方法

;; tabulated-list-sort-key 
;; 为nil说明没有其他额外的排序键
;; 否则，这个应该是(NAME . FLIP)
;;	NAME是在tabulated-list-format中对应的NAME
;;FLIP为non-nil，意味着逆序NAME选中的列

;; tabulated-list-entries 
;; 在当前tabulated list buffer显示的实体，其值可以是list或者function
;; 如果为list，每个元素的形式应该是 (ID [DESC1 DESC2 ...])
;; 	ID 是nil 或者用来表示实体的Lisp Object。如果是后者的话，鼠标将等在相同的实体
;;	DESC 是列描述子，是一个列表，列表的元素是tabulated-list-format定义的。描述子如果是String，则按照原来的样子显示在buffer中。描述子如果是list [LABEL . PROPS]，则会调用insert-text-button LABEL PROPS。
;; 如果为function，则函数应该返回上述类型的list

;; tabulated-list-init-header 为Tabulated List Buffer设置一个Header Line(标题栏)

;; tablist-minor-mode 开关tablist minor mode

(defun pss/require-times-sort-by-start-time-pred (entry1 entry2)
  (< (string-to-number (elt (nth 1 entry1) 0))
     (string-to-number (elt (nth 1 entry2) 0))))

;; elt SEQUENCE N
;; 返回SEQUENCE中的第N个


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
;; 当 BUFFER-OR-NAME 发生时就执行BODY，BUFFER-OR-NAME必须是BUFEER或者是Buffer Name

;; get-buffer-create BUFFER-OR-NAME
;; 如果BUFFER-OR-NAME和已经存在的buffer有相同的名字，则返回该buffer。否则创建一个新的buffer

;; display-buffer BUFFER-OR-NAME &optional ACTION FRAME
;; 在某个window显示BUFFER-OR-NAME, 如果存在这样的window则返回该window,否则返回nil


(defun pss/show-init-time ()
  (message "init completed in %.2fms" (pss/time-subtract-millis after-init-time before-init-time)))

(add-hook 'after-init-hook 'pss/show-init-time)

(provide 'init-benchmarking)
