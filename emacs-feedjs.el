(require 'emacs-feedjs-lib)
(require 'emacs-feedjs-interface)
(require 'emacs-feedjs-search)
(require 'emacs-feedjs-mode)
(require 'emacs-feedjs-show)


(defvar extract-timer nil
  "")

;;;###autoload
(defun feedjs ()
  "Enter elfeed."
  (interactive)
  (switch-to-buffer (feedjs-search-buffer))
  (unless (eq major-mode 'emacs-feedjs-mode)
    (feedjs-search-mode)
    (fetch-feed-by-process)
    (when extract-timer
      (cancel-timer extract-timer)
      (setq extract-timer
            (run-at-time t 60 'extraction-entry-from-buffer))))
  ;;TODO
  )




(provide 'emacs-feedjs)
