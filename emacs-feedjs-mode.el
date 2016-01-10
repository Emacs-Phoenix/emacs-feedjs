

(defun feedjs-mode-buffer ()
  "get *emacs-feedjs* buffer"
  (get-buffer-create "*emacs-feedjs*"))

(defvar emacs-feedjs-mode-map
  (let ((map (make-sparse-keymap)))
    (prog1 map
      (suppress-keymap map)
      (define-key map "q" 'quit-window)))
  "Keymap for emacs-feedjs-mode.")

(defun emacs-feedjs-mode ()
  "Magor mode for listing feed."
  (interactive)
  (kill-all-local-variables)
  (use-local-map emacs-feedjs-mode-map)
  (setq major-mode 'emacs-feedjs-mode
        mode-name "emacs-feedjs"
        truncate-lines t
        buffer-read-only t)
  (buffer-disable-undo)
  (hl-line-mode);highlight-changes-mode
  (make-local-variable 'emacs-feedjs-entries)
  (make-local-variable 'emacs-feedjs-filter)
                                        ;(add-hook 'feedjs-update-hooks #'emacs-feedjs-update)

  (run-hooks 'elfeed-search-mode-hooks))




(provide 'emacs-feedjs-mode)
