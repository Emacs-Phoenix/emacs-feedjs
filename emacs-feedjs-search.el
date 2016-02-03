(require 'emacs-feedjs-show)

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





(defvar feedjs-search--offset 2
  "Offset between line numbers and entry list position.")



(defvar feedjs-search-entries '())


(defvar feedjs-search-to-show-entries ())

(defvar feedjs-search-pre-entries ()
  "预备队列")

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

(defun feedjs-search-entry-print (entry)
  "Print ENTRY to the buffer."
  (let* ((title (plist-get entry ':title))
         (date (substring (plist-get entry ':date) 5 19))
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
    (insert (propertize "⊙ " 'face 'feedjs-search-ascii-face))
    (insert (propertize date 'face 'feedjs-search-date-face) " ")
    (insert (propertize title-column 'face 'feedjs-search-unread-title-face) "    ")

    ;; (when title
    ;;   (insert (propertize title 'face 'feedjs-search-feed-face) " "))
                                        ;
    (insert (propertize author 'face 'feedjs-search-author-face))
    (insert "\n")))


(defun feedjs-search-show-entry (entry)
  (interactive (list (feedjs-search-selected)))
  (when entry
    (feedjs-show-entry entry)))

(defun feedjs-test ()
  (interactive)
  (message (feedjs-search-selected)))

(defun feedjs-search-selected ()
  (let* ((line-index (line-number-at-pos))
         (offset (- line-index feedjs-search--offset)))
    
    (when (and (>= offset 0) (nth offset feedjs-search-entries))
      (nth offset feedjs-search-entries))))

(defun feedjs-search-update (&optional force)
  "Update the elfeed-search buffer listing "
  
  )


(defun feedjs-search-entries-clean ()
  (with-current-buffer (feedjs-search-buffer)
    (setf feedjs-search-entries ())))

(defun feedjs-search-clean ()
  (interactive)
  (feedjs-search-entries-clean)
  (feedj-search-redraw-all))

;; (defun print-entries ()
;;   (interactive)
;;   (with-current-buffer (feedjs-search-buffer)
;;     (message feedjs-search-entries)))


(defun feedjs-search-redraw-all ()
  (interactive)
  (with-current-buffer (feedjs-search-buffer)
    (let ((inhibit-read-only t)
          (entries feedjs-search-entries))
      (erase-buffer)
      (save-excursion
        (feedjs-search-insert-header)
        (dolist (entry entries)
          (feedjs-search-entry-print entry))
        (insert "End of entries.\n")
        ))))

;; (defun set-feed-entries ()
;;   (interactive)
;;   (with-current-buffer (feedjs-search-buffer)
;;     (setf feedjs-search-entries
;;           '((:title "github webhook  如何实现 push 代码后把远程服务端执行 sh 脚本的输出返回到当前终端" :link "http://segmentfault.com/q/1010000004288300" :content "\n<p><img src=\"/img/bVr9J7\" alt=\"clipboard.png\" title=\"clipboard.png\"></p>\n<p>希望实现的效果如上图</p>\n<p>目前已经实现 push 后 自动 pull 并 build，但输出的消息无法返回。</p>\n" :date "2016-01-11T23:11:42+08:00" :author "王铁手")
;;             (:title "mysql 联合索引的问题" :link "http://segmentfault.com/q/1010000004288313" :content "\n<p>之前在mysql的文档里，看联合索引时，看的都是联合索引遵循最左缀原则，也就是如果对a、b两个字段建了联合索引，where查询里，必须要有对a的过滤才可能用到该联合索引，但今天，我却发现一个没有遵循这个原则的特例。</p>\n<p>索引：<br><img src=\"/img/bVr9Kh\" alt=\"图片描述\" title=\"图片描述\"></p>\n<p>查询<br><img src=\"/img/bVr9Kl\" alt=\"图片描述\" title=\"图片描述\"></p>\n<p>我用where order_status 查询，还是用到了 store_id_order_status索引</p>\n" :date "2016-01-11T23:12:56+08:00" :author "pz9042")
;;             (:title "github webhook  如何实现 push 代码后把远程服务端执行 sh 脚本的输出返回到当前终端" :link "http://segmentfault.com/q/1010000004288300" :content "\n<p><img src=\"/img/bVr9J7\" alt=\"clipboard.png\" title=\"clipboard.png\"></p>\n<p>如上图</p>\n<p>目前已经实现 push 后 自动 pull 并 build，但输出的消息无法返回。</p>\n" :date "2016-01-11T23:11:42+08:00" :author "王铁手")
;;             (:title "想通过局域网ip 来访问自己电脑的本地项目  " :link "http://segmentfault.com/q/1010000004286087" :content "\n<p>apache已经配置好了，上个星期还可以用，这个星期访问不到了，不报错什么都没，一直加载到超时  各位大神求帮助</p>\n<p>补充 本机可以访问  防火墙也关闭了</p>\n" :date "2016-01-11T16:05:32+08:00" :author "城市猎人v5")
;;             (:title "对分布式的理解和疑惑" :link "http://segmentfault.com/q/1010000004288080" :content "\n<p>在知乎上到的一个网页对分布式集群的定义。<br>**分布式：一个业务分拆多个子业务，部署在不同的服务器上<br>集群：同一个业务，部署在多个服务器上**</p>\n<p>我是这么理解的，分布式就是把一大块东西分割成多个小块到每个机器然后一起协作处理一件事情，不知道我理解的对么？<br>但从网上看到一些文章把MYSQL的主从，还有MONGO的副本集和分片等技术也认为是一种分布式，弱弱的问下这叫分布式吗？</p>\n" :date "2016-01-11T22:24:43+08:00" :author "3我只是一个菜鸟")
;;             (:title "对分布式的理解和疑惑" :link "http://segmentfault.com/q/1010000004288080" :content "\n<p>在知乎上到的一个网页对分布式集群的定义。<br>**分布式：一个业务分拆多个子业务，部署在不同的服务器上<br>集群：同一个业务，部署在多个服务器上**</p>\n<p>我是这么理解的，分布式就是把一大块东西分割成多个小块到每个机器然后一起协作处理一件事情，不知道我理解的对么？<br>但从网上看到一些文章把MYSQL的主从，还有MONGO的副本集和分片等技术也认为是一种分布式，弱弱的问下这叫分布式吗？</p>\n" :date "2016-01-11T22:24:43+08:00" :author "1我只是一个菜鸟")
;;             (:title "对分布式的理解和疑惑" :link "http://segmentfault.com/q/1010000004288080" :content "\n<p>在知乎上到的一个网页对分布式集群的定义。<br>**分布式：一个业务分拆多个子业务，部署在不同的服务器上<br>集群：同一个业务，部署在多个服务器上**</p>\n<p>我是这么理解的，分布式就是把一大块东西分割成多个小块到每个机器然后一起协作处理一件事情，不知道我理解的对么？<br>但从网上看到一些文章把MYSQL的主从，还有MONGO的副本集和分片等技术也认为是一种分布式，弱弱的问下这叫分布式吗？</p>\n" :date "2016-01-11T22:24:43+08:00" :author "我只是一个菜鸟")))))



(provide 'emacs-feedjs-search)
