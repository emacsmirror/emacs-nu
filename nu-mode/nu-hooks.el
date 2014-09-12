;;
;; Pierre-Yves Luyten <py@luyten.fr> 2014
;; GPL V3.
;;
;;
;; hooks and eval-after-load stuff.
;;
;;

(defvar ibuffer-mode-map)
(defvar dired-mode-map)


(defun nu-prepare-for-isearch ()
  (define-key isearch-mode-map (kbd "C-f") 'isearch-repeat-forward)
  (define-key isearch-mode-map (kbd "C-r") 'isearch-repeat-backward)
  (define-key isearch-mode-map (kbd "C-j") 'isearch-repeat-backward)
  (define-key isearch-mode-map (kbd "C-v") 'isearch-yank-kill)
  (define-key isearch-mode-map (kbd "C-q") 'isearch-cancel))

(defun nu-prepare-for-ibuffer ()
  ; or use <space> to go down.
  (define-key ibuffer-mode-map (kbd "M-i") 'ibuffer-backward-line)
  (define-key ibuffer-mode-map (kbd "M-k") 'ibuffer-forward-line))


; stock M-i & M-k functions to restore them
; while leaving minibuffer

(defvar nu-m-i-sname nil)
(defvar nu-m-k-sname nil)

(defun nu-prepare-for-minibuffer ()
  (setq nu-m-i-sname (symbol-name (lookup-key nu-keymap (kbd "M-i"))))
  (setq nu-m-k-sname (symbol-name (lookup-key nu-keymap (kbd "M-k"))))
  (define-key nu-keymap (kbd "M-i") 'previous-history-element)
  (define-key nu-keymap (kbd "M-k") 'next-history-element))


(defun nu-leave-minibuffer ()
  "Restore tab for previous."
  (define-key nu-keymap (kbd "M-i") (intern-soft nu-m-i-sname))
  (define-key nu-keymap (kbd "M-k") (intern-soft nu-m-k-sname)))


(defun nu-prepare-for-dired ()
  ; or use <space> to go down.
  (define-key dired-mode-map  (kbd "M-i") 'dired-previous-line)
  (define-key dired-mode-map  (kbd "M-k") 'dired-next-line)
  (define-key dired-mode-map  (kbd "M-z") 'dired-undo)
  (define-key dired-mode-map  (kbd "C-c") 'nu-copy-prompt))

(add-hook 'minibuffer-setup-hook 'nu-prepare-for-minibuffer)
(add-hook 'minibuffer-exit-hook  'nu-leave-minibuffer)
(add-hook 'ibuffer-hook          'nu-prepare-for-ibuffer)
(add-hook 'isearch-mode-hook     'nu-prepare-for-isearch)
(add-hook 'dired-mode-hook       'nu-prepare-for-dired)




(eval-after-load "helm-mode"
  '(progn
    (define-key helm-map (kbd "C-q") 'helm-keyboard-quit)
    (define-key helm-map (kbd "C-x") 'helm-delete-minibuffer-content)
    (define-key helm-map (kbd "M-k") 'helm-next-line)
    (define-key helm-map (kbd "M-i") 'helm-previous-line)
    (define-key helm-map (kbd "M-o") 'helm-next-source)
    (define-key helm-map (kbd "M-u") 'helm-previous-source)
    (define-key helm-map (kbd "M-h") 'previous-history-element)
    (define-key helm-map (kbd "M-$") 'next-history-element)
    (define-key helm-map (kbd "M-p") 'universal-argument)
    (define-key helm-map (kbd "M-<SPC>") 'helm-next-page)
    (define-key helm-map (kbd "M-<backspace>") 'helm-previous-page)
    (define-key helm-map (kbd "C-v") 'helm-yank-text-at-point)
    (define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)))

 ;helm next source : open
 ;helm-mark-all
 ;helm-copy-to-buffer
 ;helm-yank-selection



(provide 'nu-hooks)
