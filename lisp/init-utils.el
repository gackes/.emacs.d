;;; init-utils.el Helper function and command

(define-obsolete-function-alias 'after-load 'with-eval-after-load "")

;; define-obsolete-function-alias OBSOLETE-NAME CURRENT-NAME WHEN &optional DOCSTRING
;; 用CURRENT-NAME替代OBSOLETE-NAME的函数，并把OBSOLETE-NAME设为丢弃


(defun add-auto-mode (mode &rest patterns)
  "Add entries to 'auto-mode-list' to use 'MODE' for all given file 'PATTERNS'."
  (dolist (pattern patterns)
    (add-to-list 'auto-mode-alist (cons pattern mode))))

;; auto-mode-alist 是文件名 和与其对应的主模式函数
;; 每个成员是(REGEXP . FUNCTION) 或者 (REGEXP FUNCTION NON-NIL)
;; REGEXP是正则，用于寻找文件。为该文件指定模式函数。

(defun pss/set-major-mode-name (name)
  "Override the major mode NAME in this buffer"
  (setq-local mode-name name))

;; mode-name 目前buffer的主mode名

(defun pss/major-mode-lighter (mode name)
  (add-hook (derived-mode-hook-name mode)
	    (apply-partially 'pss/set-major-mode-name name)))

;; derived-mode-hook-name NAME
;; 基于NAME生成一个mode-hook name

;; apply-partially FUN &rest ARGS
;; 返回FUN函数，把ARGS作为参数传给FUN

(defun pss/string-all-matches (regex str &optional group)
  "Find all matched for 'REGEX' within 'STR', returning the full match string or 'GROUP'."
  (let ((result nil)
	(pos 0)
	(group (or group 0)))
	(while (string-match regex str pos)
	       (push (match-string group str) result)
	       (setq pos (match-end group)))
	result))

;; string-match REGEXP STRING &optional START
;; 返回STRING中第一个匹配到REGEXP的index，如果START为non-nil，则在STRING中START处开始寻找。

;; match-string NUM &optional STRING
;; 返回上一次搜索到的string
;; NUM指的是选择第几个分组的匹配结果
;; 如果上次搜索是在STRING中用string-match，则这次也应该加上STRING

(defun delete-this-file ()
  "Delete the current file, and kill the buffer."
  (interactive)
  (unless (buffer-file-name)
    (error "No file is currently being edited"))
  (when (yes-or-no-p (format "Really delete '%s'?"
			     (file-name-nondirectory buffer-file-name)))
    (delete-file (buffer-file-name))
    (kill-this-buffer)))

;; yes-or-no-p 输出后面的字符串，用户输入yes或者no
;; file-name-nondirectory返回文件名，不带路径
;; delete-file 删除文件
;; kill-this-buffer 关闭当前buffer

(defun rename-this-file-and-buffer (new-name)
  "Renames both current buffer and file it's visitiong to NEW_NAME."
  (interactive "sNew name:")
  (let ((name (buffer-name))
	(file-name (buffer-file-name)))
    (unless file-name
      (error "Buffer '%s' is not visiting a file!" name))
    (progn
      (when (file-exists-p filename)
	(rename-file filename new-name 1))
      (set-visited-file-name new-name)
      (rename-buffer new-name))))

;; file-exists-p 判断文件名是否存在
;; rename-file FILE NEWNAME &optional OK-IF-ALREADY-EXIST
;; 如果NEWNAME存在，且OK-IF-ALREADY-EXIST为nil，则会报出错
;; OK-IF-ALREADY-EXIST为non-nil，则不会

;; set-visited-file-name FILENAME &optional NO-QUERY ALONG-WITH-FILE
;; 

  (defun browse-current-file ()
    "Open the current file as URL using 'browse-url'."
    (interactive)
    (let ((file-name (buffer-file-name)))
      (if (and (fboundp 'tramp-tramp-file-p)
	       (tramp-tramp-file-p file-name))
	(error "Cannot open tramp file")
	(browse-url (concat "file://" filename)))))

;; tramp-tramp-file-p NAME
;; 如果NAME符合Tramp File Name Syntax，则返回t

(provide 'init-utils)
