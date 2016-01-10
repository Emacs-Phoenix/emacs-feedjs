

(require 'json)



(defvar feedjs--process "/Users/soul/PROJECT/NodeAtom/app.js")

(defvar feedjs--listen-input-buffer "*FeedJs-Listen-Input*")

(defvar feedjs--process-name "FeedJs")


(defvar feedjs--process-var nil)



(defun fetch-feed-by-process ()
  (interactive)
  (if feedjs--process-var
      (message "feedjs readly running")
    (progn
      (message "start Feedjs Process")
      (setq feedjs--process (start-process feedjs--process-name feedjs--listen-input-buffer
                                           "node" feedjs--process "--emacs")))))
(defun feedjs-process-running? ()
  (interactive)
  (if feedjs--process-var
      t
    nil))

(defun kill-feedjs-process ()
  (interactive)
  (if feedjs--process-var
      (delete-process feedjs--process)))

(defun restart-feedjs-process ()
  (interactive)
  (kill-feedjs-process)
  (fetch-feed-by-process))

(defun extraction-entry-from-buffer ()
  (interactive)
  (save-excursion
    (with-current-buffer feedjs--listen-input-buffer
      (let ((json-object-type 'plist))
        ;;(message (json-read-from-string (buffer-string)))
        (feedjs-search-entry-print (json-read-from-string (buffer-string)))
        ;;(message (plist-get (json-read-from-string (buffer-string)) ':title))
        (goto-char (point-min))
        (delete-region (point-min) (line-end-position))
        (goto-char (point-min))
        (delete-char 1)
        ;; god seven
        (if (> (buffer-size) 7)
            (extraction-entry-from-buffer))
        ))))



(provide 'emacs-feedjs-interface)
