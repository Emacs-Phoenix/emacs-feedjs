(require 'emcas-feedjs-mode)

(require 'json)

(defvar feedjs--process "/Users/soul/PROJECT/NodeAtom/app.js")


(defvar feedjs--buffer "*FeedJs*")

(defvar feedjs--process-name "FeedJs")

(defun fetch-feed-by-process ()
  (interactive)
  (start-process feedjs--process-name feedjs--buffer
                 "node" feedjs--process "--emacs")
  )

;;;###autoload
(defun feedjs ()
  "Enter elfeed."
  (interactive)
  (switch-to-buffer (feedjs-mode-buffer))
  (unless (eq major-mode 'emacs-feedjs-mode)
    (emacs-feedjs))
  ;TODO
  )


(provide 'emacs-feedjs)
