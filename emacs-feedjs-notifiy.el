

(setq notify-queue '())


(defun add-to-feedjs-notify-queue (title)
  (defun feedjs-add-entry (entry)
    ;; (setf feedjs-search-entries
    ;;       (append '(entry) feedjs-search-entries))
    (with-current-buffer (feedjs-search-buffer)
      (add-to-list 'notify-queue entry))))

(defun show-notify-to-message ()
  (interactive)
  (message (pop notify-queue)))


(provide 'emacs-feedjs-notifiy)
