(require 'emacs-feedjs-lib)
(require 'emacs-feedjs-interface)
(require 'emacs-feedjs-search)
(require 'emacs-feedjs-mode)
(require 'emacs-feedjs-show)

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
