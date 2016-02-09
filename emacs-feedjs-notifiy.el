

(setq notify-queue '())


(defun add-to-feedjs-notify-queue (title)
  (add-to-list 'notify-queue title))

(defun show-notify-to-message ()
  (interactive)
  (message (pop notify-queue)))

(setq notify-timer nil)

(defun start-feedjs-notify ()
  (interactive)
  (unless notify-timer
    (progn
      (message "Start notify feedjs")
      (setq notify-timer
            (run-at-time t 5 'show-notify-to-message)))))

(defun stop-feedjs-notify ()
  (interactive)
  (when notify-timer
    (progn
      (cancel-timer notify-timer)
      (message "Cancel nofity."))))

(provide 'emacs-feedjs-notifiy)
