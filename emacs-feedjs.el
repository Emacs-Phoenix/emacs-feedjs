;;(require 'emcas-feedjs-search)




;;;###autoload
(defun feedjs ()
  "Enter elfeed."
  (interactive)
  (switch-to-buffer (feedjs-search-buffer))
  (unless (eq major-mode 'emacs-feedjs-mode)
    (feedjs-search-mode))
  ;;TODO
  )


(provide 'emacs-feedjs)
