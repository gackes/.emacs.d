;; init-frame-hooks.el  Provide specific hook for GUI/TTY frame creation

(defvar after-make-console-frame-hooks '()
  "Hooks to run after creating a new TTY frame")

(defvar after-make-window-system-frame-hooks '()
  "Hooks to run after creating a new window-system frame")

(defun run-after-make-frame-hooks (frame)
  "Run configured hooks in response to the newly-created FRAME.
  Selectively runs either 'after-make-console-frame-hooks' or 
  'after-make-window-system-frame-hooks'"
  (with-selected-frame frame
		       (run-hooks (if window-system
				    'after-make-console-frame-hooks
				    'after-make-window-system-frame-hooks))))

;; with-selected-frame FRAME &rest BODY
;; 选择FRAME，并执行 BODY

;; run-hooks &rest HOOKS
;; 运行HOOKS中的hook

(add-hook 'after-make-frame-function 'run-after-make-frame-hooks)

(defconst pss/initial-frame (selected-frame)
	  "The frame (if any) active during Emacs initialization.")

(add-hook 'after-init-hook
	  (lambda () (when pss/initial-frame
		       (run-after-make-frame-hooks pss/initial-frame))))


(provide 'init-frame-hooks)
