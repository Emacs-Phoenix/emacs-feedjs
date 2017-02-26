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
      (message "%s" (propertize "feedjs start" 'face '(:foreground "green")))
      (feedjs-search-mode)
      (feedjs-start-process)
      (run-at-time "3 sec" 1
                   (lambda () (progn
                            (feedjs-search-fetch-unread)
                            (feedjs-search-refresh)))))))

(defun feedjs-shuntdown ()
  "Shount down feedjs."
  (interactive))


(provide 'emacs-feedjs)
