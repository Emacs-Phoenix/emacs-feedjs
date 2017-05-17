(require 'emacs-feedjs-show)

(defvar feedjs-search-show-n 50)

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

(defface feedjs-search-author-face
  '((((class color) (background light)) (:foreground "#aa0"))
    (((class color) (background dark))  (:foreground "#982Baa")))
  "Face used in search mode for feed titles."
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

(defface feedjs-search-ascii-face
  '((((class color) (background light)) (:foreground "#070"))
    (((class color) (background dark))  (:foreground "#25E70f")))
  "Face used in search mode for tags."
  :group 'feedjs)

;;---
(defface feedjs-search-date-face-b
  '((((class color) (background light)) (:foreground "#aaa" :background "#a0ee76"))
    (((class color) (background dark))  (:foreground "#77a" :background "#a0ee76")))
  "Face used in search mode for dates."
  :group 'feedjs)

(defface feedjs-search-title-face-b
  '((((class color) (background light)) (:foreground "#000" :background "#a0ee76"))
    (((class color) (background dark))  (:foreground "#fff" :background "#a0ee76")))
  "Face used in search mode for titles."
  :group 'feedjs)

(defface feedjs-search-unread-title-face-b
  '((t :inherit feedjs-search-title-face :weight bold :background "#a0ee76"))
  "Face used in search mode for unread entry titles."
  :group 'feedjs)

(defface feedjs-search-author-face-b
  '((((class color) (background light)) (:foreground "#aa0" :background "#a0ee76"))
    (((class color) (background dark))  (:foreground "#982Baa" :background "#a0ee76")))
  "Face used in search mode for feed titles."
  :group 'feedjs)

(defface feedjs-search-feed-face-b
  '((((class color) (background light)) (:foreground "#aa0" :background "#a0ee76"))
    (((class color) (background dark))  (:foreground "#ff0" :background "#a0ee76")))
  "Face used in search mode for feed titles."
  :group 'feedjs)

(defface feedjs-search-tag-face-b
  '((((class color) (background light)) (:foreground "#070" :background "#a0ee76"))
    (((class color) (background dark))  (:foreground "#0f0" :background "#a0ee76")))
  "Face used in search mode for tags."
  :group 'feedjs)

(defface feedjs-search-ascii-face-b
  '((((class color) (background light)) (:foreground "#070" :background "#a0ee76"))
    (((class color) (background dark))  (:foreground "#25E70f" :background "#a0ee76")))
  "Face used in search mode for tags."
  :group 'feedjs)
;;---

(defvar feedjs-search--offset 1
  "Offset between line numbers and entry list position.")

(defvar feedjs-search-entries '())

(defvar feedjs-search-to-show-entries ())

(defvar feedjs-search-trailing-width 30
  "Space reserved for displaying the feed end tag information.")

(defvar feedjs-search-title-min-width 16)

(defvar feedjs-search-title-max-width 70)

(defun feedjs-add-entry (entry)
  ;; (setf feedjs-search-entries
  ;;       (append '(entry) feedjs-search-entries))
  (with-current-buffer (feedjs-search-buffer)
    (add-to-list 'feedjs-search-entries entry)))

(defvar feedjs-search-mode-map
  (let ((map (make-sparse-keymap)))
    (prog1 map
      (suppress-keymap map)
      (define-key map "q" 'quit-window)
      (define-key map (kbd "RET") 'feedjs-search-show-entry)
      (define-key map (kbd "r") 'feedjs-search-refresh)
      (define-key map (kbd "u") 'feedjs-search-fetch-unread)
      (define-key map "m" 'feedjs-search-show-entry))))

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
  (insert (propertize text 'facce '(widget-inactive italic))))

(defun feedjs-search-insert-header ()
  "Insert a one-line status header."
  (feedjs-search-insert-header-text
   "Feedjs Search...\n"))

(defun feedjs-search-entry-print (entry cn)
  "Print ENTRY to the buffer."
  (let* ((title (plist-get entry ':title))
         (date (plist-get entry ':date))
         (author (concat (plist-get entry ':author) " "))
         (link (plist-get entry ':link))
         (content (plist-get entry ':content))

         ;;TODO add title unread faces and read faces
         ;;(title-faces (if ()))
         (title-width (- (window-width) 10 feedjs-search-trailing-width))
         (title-column (feedjs-format-column
                        title (feedjs-clamp
                               feedjs-search-title-min-width
                               title-width
                               feedjs-search-title-max-width)
                        :left)))
    (progn
      (insert (propertize "⊙" 'face 'feedjs-search-ascii-face))
      (insert (propertize date 'face 'feedjs-search-date-face) " ")
      (insert (propertize title-column 'face 'feedjs-search-unread-title-face) "    ")
      (insert (propertize author 'face 'feedjs-search-author-face))
      (insert "\n"))
))


(defun feedjs-search-show-entry (entry)
  (interactive (list (feedjs-search-selected)))
  (when entry
    (feedjs-show-entry entry)))

(defun feedjs-search-selected ()
  (let* ((line-index (line-number-at-pos))
         (offset (- line-index feedjs-search--offset)))
    (when (and (>= offset 0) (nth offset feedjs-search-entries))
      (nth offset feedjs-search-entries))))


(defun feedjs-search-entries-clean ()
  (with-current-buffer (feedjs-search-buffer)
    (setf feedjs-search-entries ())))

(defun feedjs-search-clean ()
  (interactive)
  (feedjs-search-entries-clean)
  (feedjs-search-redraw-all))


(defun feedjs-search-redraw-all ()
  (interactive)
  (with-current-buffer (feedjs-search-buffer)
    (let ((inhibit-read-only t)
          (entries feedjs-search-entries)
          (cn 0))
      (erase-buffer)
      (save-excursion
        (feedjs-search-insert-header)
        (dolist (entry entries)
          (feedjs-search-entry-print entry cn)
          (setq cn (+ cn 1)))
        (insert "End of entries.\n")
        ))))

(defun feedjs-search-refresh ()
  (interactive)
  (feedjs-search-redraw-all))

(defun feedjs-search-fetch-unread ()
  (interactive)
  (new-unread-feed-from-server-url feedjs-search-show-n))

(defun feedjs-search-new ()
  (interactive)
  (new-feed-from-server-url feedjs-search-show-n))

(provide 'emacs-feedjs-search)
