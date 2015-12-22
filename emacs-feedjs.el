
(require 'json)

(setq feedjs--process "/Users/soul/PROJECT/NodeAtom/app.js")



(defvar feedjs--buffer "*FeedJs*")

(defvar feedjs--process-name "FeedJs")

(defun fetch-feed-by-process ()
  (interactive)
  (start-process feedjs--process-name feedjs--buffer
                 "node" feedjs--process "--emacs")
  )

(provide 'emacs-feedjs)
