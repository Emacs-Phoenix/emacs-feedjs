(defface feedjs-notifiy-face
  '((((class color) (background light)) (:foreground "#aaa" :background "white"))
    (((class color) (background dark))  (:foreground "#77a" :background "white")))
  "Face used in search mode for dates."
  :group 'feedjs)

(setq notify-queue '())

(setq notify-timer nil)

(defvar extract-timer nil "Timer for extrante entries form input buffer.")

(defvar feedjs-notify-interval 10)

(defun add-to-feedjs-notify-queue (title)
  (add-to-list 'notify-queue title))

(defun show-notify-to-message ()
  (interactive)
  (let ((feed-title (pop notify-queue)))
    (when feed-title
      (message "%s" (concat (propertize "FeedJs Notifiy: " 'face '(:foreground "white" :background "green"))
                            " "
                            (propertize feed-title 'face '(:foreground "green" :background "white")))))))

(defun start-feedjs-notify ()
  (interactive)
  (when extract-timer
    (progn
      (message "start feedjs notify")
      (unless notify-timer
        (progn
          (message "Start notify feedjs")
          (setq notify-timer
                (run-at-time t feedjs-notify-interval 'show-notify-to-message)))))
    (message "You must extract entry from input buffer.")))

(defun feedjs-stop-notify ()
  (interactive)
  (when notify-timer
    (progn
      (cancel-timer notify-timer)
      (message "Cancel nofity."))))

(defun extraction-entry-from-buffer-to-notify ()
  (extraction-entry-from-buffer #'add-to-feedjs-notify-queue))

;; 定时抽取
(defun feedjs-start-extract-timer ()
  "Start feedjs extract timer."
  (interactive)
  (unless extract-timer
    (progn
      (message "Timer extract-timer start!")
      (setq extract-timer
            (run-at-time t 10 'extraction-entry-from-buffer-to-notify)))))

(defun feedjs-stop-extract-timer ()
  "Stop feedjs extract timer."
  (interactive)
  (when extract-timer
    (progn
      (cancel-timer extract-timer)
      (message "Cancel Timer extract timer."))))

(provide 'emacs-feedjs-notifiy)
