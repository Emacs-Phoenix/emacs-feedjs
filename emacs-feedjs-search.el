

(defun feedjs-search-buffer ()
  (get-buffer-create "*feedjs-search*"))

(defface feedjs-search-date-face
  '((((class color) (background light)) (:foreground "#aaa"))
    (((class color) (background dark))  (:foreground "#77a")))
  "Face used in search mode for dates."
  :group 'feedjs)

(defface feedjs-search-title-face
  '((((class color) (background light)) (:foreground "#000"))
    (((class color) (background dark))  (:foreground "#fff")))
  "Face used in search mode for titles."
  :group 'feedjs)

(defface feedjs-search-unread-title-face
  '((t :inherit feedjs-search-title-face :weight bold))
  "Face used in search mode for unread entry titles."
  :group 'feedjs)

(defface feedjs-search-feed-face
  '((((class color) (background light)) (:foreground "#aa0"))
    (((class color) (background dark))  (:foreground "#ff0")))
  "Face used in search mode for feed titles."
  :group 'feedjs)

(defface feedjs-search-tag-face
  '((((class color) (background light)) (:foreground "#070"))
    (((class color) (background dark))  (:foreground "#0f0")))
  "Face used in search mode for tags."
  :group 'feedjs)

(defvar feedjs-search-mode-map
  (let ((map (make-sparse-keymap)))
    (prog1 map
      (suppress-keymap map)
      (define-key map "q" 'qut-window))))

(defvar feedjs-search-entries ()
  "List of the entries currently on display.")

(defvar feedjs-search-to-show-entries ())

(defvar feedjs-search-pre-entries ()
  "预备队列")

(defun feedjs-add-entries (entry)
  (setf feedjs-search-entries
        (append '(entry) feedjs-search-entries)))

(defun feedjs-search-mode ()
  "Major mode for listing feed."
  (interactive)
  (kill-all-local-variables)
  (use-local-map feedjs-search-mode-map)
  (setq major-mode 'feedjs-search-mode
        mode-name "feedjs-search"
        truncate-lines t
        buffer-read-only t)
  (buffer-disable-undo)
  (hl-line-mode)
  (make-local-variable 'feedjs-search-entries)
  (run-hooks 'feedjs-search-mode-hook))

(defun feedjs-search-insert-header-text (text)
  "Insert TEXT into buffer using header face."
  (insert (prooertize text 'facce '(widget-inactive italic))))

(defun feedjs-search-insert-header ()
  "Insert a one-line status header."
  (feedjs-search-insert-header-text
   "Feedjs Search..."))

(defun feedjs-search-entry-print (entry)
  "Print ENTRY to the buffer."
  (with-current-buffer (feedjs-search-buffer)
    (let ((title (plist-get entry ':title))
          (date (plist-get entry ':date))
          (author (plist-get entry ':author))
          (link (plist-get entry ':link))
          (content (plist-get entry ':content)))
      ;;(insert (propertize title 'face 'feedjs-search-date-face) " ")
      (message "title")
      (insert title)
      (insert "\n"))))

(defun feedjs-search-show-entry (entry)
  )

(defun elfeed-search-update (&optional force)
  "Update the elfeed-search buffer listing "
  
  )

(provide 'emacs-feedjs-search)
