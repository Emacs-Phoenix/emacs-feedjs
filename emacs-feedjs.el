(require 'emcas-feedjs-mode)

;;;###autoload
(defun feedjs ()
  "Enter elfeed."
  (interactive)
  (switch-to-buffer (feedjs-mode-buffer))
  (unless (eq major-mode 'emacs-feedjs-mode)
    (emacs-feedjs))
  ;TODO
  )


(provide 'emacs-feedjs)
