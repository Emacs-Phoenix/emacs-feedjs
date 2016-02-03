(require 'json)

(require 'request)

(require 'emacs-feedjs-notifiy)

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
      (setq feedjs--process-var (start-process feedjs--process-name feedjs--listen-input-buffer
                                               "node" feedjs--process "--emacs")))))
(defun feedjs-process-running? ()
  (interactive)
  (if feedjs--process-var
      t
    nil))

(defun kill-feedjs-process ()
  (interactive)
  (if feedjs--process-var
      (progn
        (delete-process feedjs--process-var)
        (setq feedjs--process-var nil))))

(defun restart-feedjs-process ()
  (interactive)
  (kill-feedjs-process)
  (fetch-feed-by-process))

;; 用于抽取 实时加载buffer 中的feed
(defun extraction-entry-from-buffer ()
  (interactive)
  ;;(message "extraction-entry-from-buffer")
  (save-excursion
    (with-current-buffer feedjs--listen-input-buffer
      (let ((json-object-type 'plist))
        ;;(message (json-read-from-string (buffer-string)))
        (unwind-protect
            ;; TODO check empty better
            (if (> (buffer-size) 7)
                (progn
                  
                  (feedjs-add-entry (json-read-from-string (buffer-string)))
                  
                  ;;(message (plist-get (json-read-from-string (buffer-string)) ':title))
                  (goto-char (point-min))
                  (delete-region (point-min) (line-end-position))
                  (goto-char (point-min))
                  (delete-char 1)
                  ;; TODO
                  ;; check buffer empty
                  
                  ;; god seven
                  (if (> (buffer-size) 7)
                      (extraction-entry-from-buffer)))))))))

(defun extraction-entry-from-buffer-to-notify ()
  (interactive)
  (save-excursion
    (with-current-buffer feedjs--listen-input-buffer
      (let ((json-object-type 'plist))
        ;;(message (json-read-from-string (buffer-string)))
        (unwind-protect
            ;; TODO check empty better
            (if (> (buffer-size) 7)
                (progn
                  
                  (add-to-feedjs-notify-queue (plist-get (json-read-from-string (buffer-string))
                                                         ':title))
                  
                  ;;(message (plist-get (json-read-from-string (buffer-string)) ':title))
                  (goto-char (point-min))
                  (delete-region (point-min) (line-end-position))
                  (goto-char (point-min))
                  (delete-char 1)
                  ;; TODO
                  ;; check buffer empty
                  
                  ;; god seven
                  (if (> (buffer-size) 7)
                      (extraction-entry-from-buffer)))))))))

(defun check-input-buffer-empty ()
  (interactive)
  (message (not (eq nil (get-buffer feedjs--listen-input-buffer)))))



(provide 'emacs-feedjs-interface)
