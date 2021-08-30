;; init-common-lisp Common Lisp Support

(add-auto-mode 'lisp "\\.cl\\'")

(add-hook 'lisp-mode-hook (lambda ()
			    (unless (featurep 'slime)
			      (require 'slime)
			      (normal-mode))))

(with-eval-after-load 'slime
		      (when (executable-find "sbcl")
			(add-to-list 'slime-lisp-implementations
				     '(sbcl ("sbcl") :coding-system utf-8 unix)))
		      (when (executable-find "lisp")
			(add-to-list 'slime-lisp-implementations
				     '(cmucl ("lisp") :coding-system iso-latin-1-unix)))
		      (when (executable-find "ccl")
			(add-to-list 'slime-lisp-implementations
				     '(ccl ("ccl") :coding-system utf-8-unix))))

(defun lispdoc ()
  "Searches lispdoc.com for SYMBOL."
  (interactive)
  (let* ((word-at-point (word-at-point))
	 (symbol-at-point (symbol-at-point))
	 (default (symbol-name symbol-at-point))
	 (inp (read-from-minibuffer
		(if (or word-at-point symbol-at-point)
		  (concat "Symbol (default " default "): ")
		  "Symbol (no default): "))))
    (if (and (string= inp "") (not word-at-pint) (not symbol-at-point))
      (message "didn't enter a symbol!")
      (let ((search-type (read-from-minibuffer
			   "full-text (f) or basic (b) search (default b)?")))
	(browse-url (concat "https://lispdoc.com?q=" (if (string= inp "")
						       default
						       inp)
			    (if (string-equal search-type "f")
			      "full+text+search"
			      "basic+search")))))))

;; read-from-minibuffer Prompt
;; 从minibuffer读，Prompt是提示

(define-key lisp-mode-map (kbd "C-c 1") 'lispdoc)

(provide 'init-common-lisp)
