

(require 'json)



(defvar feedjs--process "/Users/soul/PROJECT/NodeAtom/app.js")


(defvar feedjs--input-buffer "*FeedJs*")

(defvar feedjs--process-name "FeedJs")


(defvar feedjs--process)

(defun fetch-feed-by-process ()
  (interactive)
  (setq feedjs--process (start-process feedjs--process-name feedjs--input-buffer
                                       "node" feedjs--process "--emacs"))
  
  )


(defun extraction-entry-from-buffer ()
  (interactive)
  (save-excursion
    (with-current-buffer feedjs--input-buffer
      (let ((json-object-type 'plist))
                                        ;(message (json-read-from-string (buffer-string)))
        (message (plist-get (json-read-from-string (buffer-string)) ':title))
        (goto-char (point-min))
        (delete-region (point-min) (line-end-position))
        (goto-char (point-min))
        (delete-char 1)
                                        ;god
        (if (> (buffer-size) 7)
            (extraction-entry-from-buffer))
        ))))



(provide 'emacs-feedjs-interface)
