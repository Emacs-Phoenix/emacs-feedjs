

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
      (message (json-read-from-string (buffer-string)))))
  )


(provide 'emacs-feedjs-interface)
