

(defvar feedjs-search-mode-map
  (let ((map (make-sparse-keymap)))
    (prog1 map
      (suppress-keymap map)
      (define-key map "q" 'qut-window))))

(defvar feedjs-search-entries ()
  "List of the entries currently on display.")

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

(defun feedjs-search-print (entry)
  "Print ENTRY to the buffer."
  (insert "Text"))

(defun elfeed-search-update (&optional force)
  "Update the elfeed-search buffer listing ")

(provide 'emacs-feedjs-search)
