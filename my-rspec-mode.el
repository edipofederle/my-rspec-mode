;;Author: elf<edipofederle@gmail.com>

(require 'compile)

;; get project directory
(defun* find-current-project (&optional (file "Gemfile"))
  (let ((root (expand-file-name "/")))
    (loop 
     for d = default-directory then (expand-file-name ".." d)
     if (file-exists-p (expand-file-name file d))
     return d
     if (equal d root)
     return nil)))

(defun current-file ()
  (buffer-file-name))

;; Run all spec on current file
(defun run-all-specs()
  (interactive)
  (compile (format "cd %s; bundle exec rspec %s"
		   (find-current-project) (current-file))))

;; Run a single spec
(defun run-single-spec ()
  (interactive)
  (compile (format "cd %s; bundle exec rspec %s:%s"
		   (find-current-project) (current-file) (line-number-at-pos))))

;; Run all specs
(defun run-all ()
  (interactive)
  (compile (format "cd %s; bundle exec rspec"
		   (find-current-project))))

(add-hook 'ruby-mode-hook
	  (lambda ()
	    (local-set-key (kbd "C-c C-a") 'run-all-specs)
	    (local-set-key (kbd "C-c l")   'run-single-spec)
	    (local-set-key (kbd "C-c s") 'run-all)))

(provide 'my-rspec-mod)
