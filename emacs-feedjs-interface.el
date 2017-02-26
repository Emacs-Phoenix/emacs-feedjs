(require 'json)
(require 'request)
(require 'emacs-feedjs-notifiy)

(defvar feedjs--listen-input-buffer "*FeedJs-Listen-Input*")

(defvar feedjs--process-name "FeedJs")

(defvar feedjs--process-var nil)

(defvar server-url "http://localhost:7788")

(defun feedjs-start-process ()
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

(defun feedjs-kill-process ()
  (interactive)
  (if feedjs--process-var
      (progn
        (delete-process feedjs--process-var)
        (setq feedjs--process-var nil)
        (with-current-buffer feedjs--listen-input-buffer
          (erase-buffer)))))

(defun feedjs-restart-process ()
  (interactive)
  (feedjs-kill-process)
  (feedjs-start-process))

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

(defun extraction-entry-from-buffer (add-fn)
  (save-excursion
    (with-current-buffer feedjs--listen-input-buffer
      (let ((json-object-type 'plist))
        ;;(message (json-read-from-string (buffer-string)))
        (unwind-protect
            ;; TODO check empty better

            ;; (if (> (buffer-size) 7)
            ;;     (progn
            ;;       (add-to-feedjs-notify-queue (plist-get (json-read-from-string (buffer-string))
            ;;                                              ':title))
            ;;       ;;(message (plist-get (json-read-from-string (buffer-string)) ':title))
            ;;       (goto-char (point-min))
            ;;       (delete-region (point-min) (line-end-position))
            ;;       (goto-char (point-min))
            ;;       (delete-char 1)
            ;;       ;; TODO check-input-buffer-empty 函数 在下面
            ;;       ;; check buffer empty
            ;;       (if (> (buffer-size) 7) ;; god seven
            ;;           (extraction-entry-from-buffer-to-notify))))

            (when (check-input-buffer-empty)
              (progn
                (funcall add-fn (plist-get (json-read-from-string (buffer-string))
                                                       ':title))
                (goto-char (point-min))
                (delete-region (point-min) (line-end-position))
                (goto-char (point-min))
                (delete-char 1)

                (extraction-entry-from-buffer add-fn)
                )))))))

(defun check-input-buffer-empty ()
  "检查程序输入 buffer 是否为空"
  ;;(not (eq nil (get-buffer feedjs--listen-input-buffer)))
  (> (buffer-size) 0))

(defun check-input-buffer-not-empty ()
  "检查程序输入 buffer 是否不为空."
  (not (check-input-buffer-empty)))

;; (defun request-server-get-feed (url)
;;   (request
;;    ;;"http://localhost:7788/new-unread/1"
;;    url
;;    :parser 'buffer-string
;;    :success
;;    (function* (lambda (&key data &allow-other-keys)
;;                 (when data
;;                   (let* ((json-object-type 'plist)
;;                          (entries
;;                           (plist-get (json-read-from-string data) ':result)))
;;                     (message (plist-get (elt entries 0) ':date))
;;                     (feedjs-search-entries-clean)
;;                     (mapcar (lambda (entry2)
;;                               (feedjs-add-entry entry2))
;;                             entries)))))))


(require 'web)
(defun request-server-get-feed (url)
  (web-http-get
   (lambda (http header my-data)
     (let* ((json-object-type 'plist)
            (entries (plist-get (json-read-from-string (decode-coding-string my-data 'utf-8) ) ':result)))
       (feedjs-search-entries-clean)
       (mapcar (lambda (entry2)
                 (feedjs-add-entry entry2))
               entries)))
   :url url))


;; (defun new-unread-feed-from-server-url (number)
;;   (request-server-get-feed
;;    (concat server-url "/new-unread/" (number-to-string number))))

(defun new-feed-from-server-url (number)
  (request-server-get-feed
   (concat server-url "/new/" (number-to-string number))))

(defun new-unread-feed-from-server-url (number)
  (request-server-get-feed
   (concat server-url "/new-unread/" (number-to-string number))))

(defun my-url-http-post (url args)
      "Send ARGS to URL as a POST request."
      (let ((url-request-method "GET")
            (url-request-extra-headers
             '(("Content-Type" . "application/x-www-form-urlencoded")))
            (url-request-data
             (mapconcat (lambda (arg)
                          (concat (url-hexify-string (car arg))
                                  "="
                                  (url-hexify-string (cdr arg))))
                        args
                        "&")))
        ;; if you want, replace `my-switch-to-url-buffer' with `my-kill-url-buffer'
        (url-retrieve url 'my-switch-to-url-buffer)))

    (defun my-kill-url-buffer (status)
      "Kill the buffer returned by `url-retrieve'."
      (kill-buffer (current-buffer)))

    (defun my-switch-to-url-buffer (status)
      "Switch to the buffer returned by `url-retreive'.
    The buffer contains the raw HTTP response sent by the server."
      (switch-to-buffer (current-buffer)))

;; (my-url-http-post "http://localhost:7788/new-unread/50" '(("GET")))


(provide 'emacs-feedjs-interface)
