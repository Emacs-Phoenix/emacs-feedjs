(require 'json)

(require 'request)

(require 'emacs-feedjs-notifiy)
(require 'emacs-feedjs-search)

(defvar feedjs--process "~/PROJECT/NodeAtom/app.js")

(defvar feedjs--listen-input-buffer "*FeedJs-Listen-Input*")

(defvar feedjs--process-name "FeedJs")


(defvar feedjs--process-var nil)

(defvar server-url "http://localhost:7788")

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
        (setq feedjs--process-var nil)
        (with-current-buffer feedjs--listen-input-buffer
          (erase-buffer)))))

(defun restart-feedjs-process ()
  (interactive)
  (kill-feedjs-process)
  (fetch-feed-by-process))

;; 用于抽取 实时加载buffer 中的feed
;; (defun extraction-entry-from-buffer ()
;;   (interactive)
;;   ;;(message "extraction-entry-from-buffer")
;;   (save-excursion
;;     (with-current-buffer feedjs--listen-input-buffer
;;       (let ((json-object-type 'plist))
;;         ;;(message (json-read-from-string (buffer-string)))
;;         (unwind-protect
;;             ;; TODO check empty better
;;             (if (> (buffer-size) 7)
;;                 (progn

;;                   (feedjs-add-entry (json-read-from-string (buffer-string)))

;;                   ;;(message (plist-get (json-read-from-string (buffer-string)) ':title))
;;                   (goto-char (point-min))
;;                   (delete-region (point-min) (line-end-position))
;;                   (goto-char (point-min))
;;                   (delete-char 1)
;;                   ;; TODO
;;                   ;; check buffer empty

;;                   ;; god seven
;;                   (if (> (buffer-size) 7)
;;                       (extraction-entry-from-buffer)))))))))

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
                  ;; TODO check-input-buffer-empty 函数 在下面
                  ;; check buffer empty                  
                  (if (> (buffer-size) 7) ;; god seven
                      (extraction-entry-from-buffer-to-notify)))))))))

(defun check-input-buffer-empty ()
  (interactive)
  (message (not (eq nil (get-buffer feedjs--listen-input-buffer)))))

;;(setq response-buffer "*feedjs-response-buffer*")

(defun request-server-get-feed (url)
  (request
   ;;"http://localhost:7788/new-unread/1"
   url
   :parser 'buffer-string
   :success
   (function* (lambda (&key data &allow-other-keys)
                (when data
                  (let* ((json-object-type 'plist)
                         (entries
                          (plist-get (json-read-from-string data) ':result)))
                    (message (plist-get (elt entries 0) ':date))
                    (feedjs-search-entries-clean)
                    (mapcar (lambda (entry2)
                              (feedjs-add-entry entry2)) entries)))))))

(defun new-unread-feed-from-server-url (number)
  (request-server-get-feed
   (concat server-url "/new-unread/" (number-to-string number))))

(defun new-feed-from-server-url (number)
  (request-server-get-feed
   (concat server-url "/new/" (number-to-string number))))

(provide 'emacs-feedjs-interface)
