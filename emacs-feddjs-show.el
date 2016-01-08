
(defvar message-show-list [])

(defun show-feed-message (text)
  (interactive)
  (message text))


(defun message-list-show ()
  "Start show list with (message).")

(defun message-list-stop ()
  "Stop show list.")

(defun add-entry-to-message-show-list ()
  "Add entry to message-show-list.")

(defun clear-message-show-list ()
  "Clear message-show-list.")


(provide 'emacs-feedjs-show)
