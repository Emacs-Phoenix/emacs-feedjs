(require 'emacs-feedjs-lib)
(require 'emacs-feedjs-interface)
(require 'emacs-feedjs-search)
(require 'emacs-feedjs-show)

;;;###autoload
(defun feedjs ()
  "Enter elfeed."
  (interactive)
  (switch-to-buffer (feedjs-search-buffer))
  (unless (eq major-mode 'feedjs-search-mode)
    (progn
      (message "%s" (propertize "☛ feedjs start" 'face '(:foreground "green")))
      (feedjs-search-mode)
      (fetch-feed-by-process)
      (feedjs-search-fetch-unread)
      (feedjs-search-refresh))))

(defun run-feedjs ()
  (interactive)
  (fetch-feed-by-process))

(provide 'emacs-feedjs)
