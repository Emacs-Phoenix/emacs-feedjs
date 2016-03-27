(defface feedjs-notifiy-face
  '((((class color) (background light)) (:foreground "#aaa" :background "white"))
    (((class color) (background dark))  (:foreground "#77a" :background "white")))
  "Face used in search mode for dates."
  :group 'feedjs)

(setq notify-queue '())

(setq notify-timer nil)




(defun add-to-feedjs-notify-queue (title)
  (add-to-list 'notify-queue title))

(defun show-notify-to-message ()
  (interactive)
  (let ((feed-title (pop notify-queue)))
    (when feed-title
      (message "%s" (concat (propertize "FeedJs Notifiy: " 'face '(:foreground "white" :background "green"))
                            " "
                            (propertize feed-title 'face '(:foreground "green" :background "white"))))))
  )


(defun start-feedjs-notify ()
  (interactive)
  (message "start feedjs notify")
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
