(require 'emacs-feedjs-lib)
(require 'emacs-feedjs-interface)
(require 'emacs-feedjs-search)
(require 'emacs-feedjs-mode)
(require 'emacs-feedjs-show)


(defvar extract-timer nil
  "Timer for extrante entries form input buffer.")

;;;###autoload
(defun feedjs ()
  "Enter elfeed."
  (interactive)
  (switch-to-buffer (feedjs-search-buffer))
  (unless (eq major-mode 'feedjs-search-mode)
    (progn
      (message "feedjs")
      (feedjs-search-mode)
      (fetch-feed-by-process)
      ))
  ;;TODO
  (start-feedjs-extract-timer)
  (start-feedjs-notify)
  )

;; 定时抽取
(defun start-feedjs-extract-timer ()
  "Start feedjs extract timer."
  (interactive)
  (unless extract-timer
    (progn
      (message "Timer extract-timer start!")
      (setq extract-timer
            (run-at-time t 10 'extraction-entry-from-buffer-to-notify)))))


(defun stop-feedjs-extract-timer ()
  "Stop feedjs extract timer."
  (interactive)
  (when extract-timer
    (progn
      (cancel-timer extract-timer)
      (message "Cancel Timer extract timer."))))



(provide 'emacs-feedjs)
