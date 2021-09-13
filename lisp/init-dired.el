;;; init-dired.el --- 配置Dired和目录树
;;; Commentary:
;;; Code:

(setq-default dired-dwim-target t)

;; dired-dwim-target 如果值为non-nil, Dired尝试去猜一个目标文件夹
;; 比如说在一个DIRED的窗口下COPY文件，会自动选择另一个DIRED窗口作为目标窗口。

(provide 'init-dired)
;;; init-dired.el ends here
