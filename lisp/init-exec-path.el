;;; init-exec-path.el --- Set up exec-path
;;; Commentary:
;;; Code:

(require-package 'exec-path-from-shell)

(with-eval-after-load 'exec-path-from-shell
		 (dolist (var '("SSH_AUTH_SOCK" "SSH_AGENT_PID" "GPG_AGENT_INFO" "LANG" "LC_CTPE" "NIX_SSL_CERT_FILE" "NIX_PATH" "PATH"))
		   (add-to-list 'exec-path-from-shell-variables var)))

;;; exec-path-from-shell-variables
;; 


(when (or (memq window-system '(mac ns x))
  (unless (memq system-type '(ms-dos windows-nt))
    (daemonp)))
  (exec-path-from-shell-initialize))

;;; daemonp 判断Emacs是后台进程，返回non-nil

;;; exec-path-from-shell-initialize
(provide 'init-exec-path)
;;; init-exec-path.el ends here
