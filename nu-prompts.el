;;
;;
;;   Pierre-Yves Luyten
;;   2014
;;
;;
;;   This file is part of Nu.
;;
;;   Nu is free software: you can redistribute it and/or modify
;;   it under the terms of the GNU General Public License as published by
;;   the Free Software Foundation, either version 3 of the License, or
;;   (at your option) any later version.
;;
;;   Nu is distributed in the hope that it will be useful,
;;   but WITHOUT ANY WARRANTY; without even the implied warranty of
;;   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;   GNU General Public License for more details.
;;
;;   You should have received a copy of the GNU General Public License
;;   along with Nu.  If not, see <http://www.gnu.org/licenses/>.
;;
;;
;;

;; Get the macro make-help-screen when this is compiled,
;; or run interpreted, but not when the compiled code is loaded.
(eval-when-compile (require 'help-macro))


(defun nu-prompt (&optional title message)
 (interactive)
 (setq curb (current-buffer))
 (unless title (setq title "Enter:"))
 (setq buf (generate-new-buffer title))
 (view-buffer-other-window buf)
 (read-only-mode t)
 (org-mode)
 (funcall (and initial-major-mode))
 (setq message
   (concat "\n    ~~~ ☸ ~~~\n" ; U+2638
            message))
 (insert message)
 (setq x (read-event))
 (quit-window)
 (kill-buffer buf)
 (switch-to-buffer curb)
 (setq x x))


(define-prefix-command 'nu-print-map)
(define-key nu-print-map (kbd "p") 'print-buffer)
(define-key nu-print-map (kbd "s") 'eval-last-sexp)
(define-key nu-print-map (kbd "b") 'eval-buffer)
(define-key nu-print-map (kbd "w") 'pwd)
(define-key nu-print-map (kbd "-") 'negative-argument)
(define-key nu-print-map (kbd "\C-p") 'universal-argument)
(define-key nu-print-map (kbd "c") 'compile)
(make-help-screen nu-print-prompt ; wow notice this sound! =)
(purecopy "Print")
"Control+p : universal argument
 p: Really Print this (hardware)
 s: eval last sexp
 b: eval buffer
 w: pwd
 -: negative argument
 m: make
 c: compile"
nu-print-map)


(define-prefix-command 'nu-delete-map)
(define-key nu-delete-map (kbd "i") 'nu-delete-above-line)
(define-key nu-delete-map (kbd "j") 'backward-delete-char)
(define-key nu-delete-map (kbd "$") 'kill-line)
(define-key nu-delete-map (kbd "x") 'kill-whole-line)
(define-key nu-delete-map (kbd "k") 'nu-delete-below-line)
(define-key nu-delete-map (kbd "l") 'delete-forward-char)
(define-key nu-delete-map (kbd "u") 'backward-kill-word)
(define-key nu-delete-map (kbd "o") 'kill-word)
(define-key nu-delete-map (kbd "h") 'delete-horizontal-space)
(define-key nu-delete-map (kbd "t") 'delete-trailing-whitespace)
(define-key nu-delete-map (kbd "b") 'delete-blank-lines)
(define-key nu-delete-map (kbd "s") 'kill-sexp)
(define-key nu-delete-map (kbd "e") 'kill-sentence)
(define-key nu-delete-map (kbd "f") 'nu-delete-defun)
(define-key nu-delete-map (kbd "a") 'nu-delete-all)
(make-help-screen nu-delete-prompt-internal
(purecopy "Delete")
"=i= above line
 =j= backward-delete-char (C-j)
 =k= delete below line
 =$= kill-line
 =x= kill whole line
 =l= next char (C-l)
 =u= backward kill word (C-u)
 =o= kill word
 =e= kill sentence

 =h= horizontal space
 =t= trailing space
 =w= whole line (C-x)
 =b= blank lines
 =s= function `kill-sexp'
 =f= delete function
 =a= delete whole buffer"
nu-delete-map)
(defun nu-delete-prompt ()
  (interactive)
  (if mark-active
    (call-interactively 'kill-region)
    (progn
      (nu-delete-prompt-internal)
      (help-make-xrefs (help-buffer)))))


(define-prefix-command 'nu-insert-map)
(define-key nu-insert-map (kbd "v") 'nu-yank-pop-or-yank)
(define-key nu-insert-map (kbd "k") 'yank)
(define-key nu-insert-map (kbd "i") 'browse-kill-ring)
(define-key nu-insert-map (kbd "b") 'insert-buffer)
(define-key nu-insert-map (kbd "f") 'insert-file)
(define-key nu-insert-map (kbd "c") 'quoted-insert)
(define-key nu-insert-map (kbd "o") 'open-line)
(define-key nu-insert-map (kbd "s") 'async-shell-command)
(define-key nu-insert-map (kbd "S") 'shell-command)
(make-help-screen nu-insert-prompt
(purecopy "Insert")
"
 =v= Yank / *pop*   =i= browsekillring
 =k= Yank but *do not*

 =b= Insert buffer       =f= Insert file

 =c= Insert litterally (~quoted insert~)
 =o= open line below

 =s= async-shell-command (=S= for sync)

 Use _alt v_ to yank pop"
nu-insert-map)


(define-prefix-command 'nu-save-map)
(define-key nu-save-map (kbd "s") 'save-buffer)
(define-key nu-save-map (kbd "w") 'ido-write-file)
(define-key nu-save-map (kbd "r") 'rename-buffer)
(define-key nu-save-map (kbd "m") 'magit-status)
(make-help-screen nu-save-prompt
(purecopy "Save")
"(Use Alt+s to directly save a buffer.)
Press q to quit or :

s: save
w: save-as
r: rename buffer
m: magit-status"
nu-save-map)


(define-prefix-command 'nu-a-map)
(define-key nu-a-map (kbd "a") 'mark-whole-buffer)
(define-key nu-a-map (kbd "f") 'mark-defun)
(define-key nu-a-map (kbd "s") 'mark-sentence)
(define-key nu-a-map (kbd "w") 'nu-mark-a-word)
(define-key nu-a-map (kbd "p") 'mark-paragraph)
(define-key nu-a-map (kbd "j") 'nu-mark-to-beginning-of-line)
(define-key nu-a-map (kbd "l") 'nu-mark-to-end-of-line)
(define-key nu-a-map (kbd "k") 'nu-mark-current-line)
(define-key nu-a-map (kbd "<SPC>") 'cua-set-mark)
(define-key nu-a-map (kbd "RET") 'cua-set-rectangle-mark)
(make-help-screen nu-a-prompt-internal
(purecopy "A[ll]")
"Set mark:
 Once mark is set, C-a to exchange point & mark.

_space_ set mark         Use C-return to set rectangle

a: select all            f : mark-function
p : mark-paragraph       l : mark to end of line
s : mark sentence        j : mark to beginning of line
w : mark-word            k : mark current line
"
nu-a-map)
(defun nu-a-prompt ()
  "Triggers nu-a-map.

But if mark is active, exchange point and mark."
     (if mark-active
      (exchange-point-and-mark)
      (nu-a-prompt-internal)))


(defun nu-other-win () (interactive) (other-window 1))
(defun nu-other-win-minus () (interactive) (other-window -1))
(define-prefix-command 'nu-open-map)
(define-key nu-open-map (kbd "f")  'find-file)
(define-key nu-open-map (kbd "F")  'find-file-other-window)
(define-key nu-open-map (kbd "r")  'recentf-open-files)
(define-key nu-open-map (kbd "m")  'bookmark-bmenu-list)
(define-key nu-open-map (kbd "M")  'bookmark-jump)
(define-key nu-open-map (kbd "b")  'bookmark-set)
(define-key nu-open-map (kbd "x")  'list-registers)
(define-key nu-open-map (kbd "l")  'next-buffer)
(define-key nu-open-map (kbd "j")   'previous-buffer)
(define-key nu-open-map (kbd "o")   'nu-other-win)
(define-key nu-open-map (kbd "O")   'nu-other-win-minus)
(define-key nu-open-map (kbd "i")   'ibuffer)
(define-key nu-open-map (kbd "I")   'ibuffer-other-window)
(define-key nu-open-map (kbd "C-<SPC>") 'ido-switch-buffer)
(make-help-screen nu-open-prompt
(purecopy "Open")
"
=f= open file/dir         =l= next-buffer
=F= file other window     =j= previous-buffer
=r= recent files          =Control+space= ido-switch-buffer
=o= other-window (next)
=O= other-window (prev.)  =i= ibuffer
                          =I= ibuffer-other-window
=x= registers

=m= bookmarks menu, =M= jump to bookmark
=b= bookmark set"
nu-open-map)


(define-prefix-command 'nu-global-map)
(defun nu-no-goal-column () (interactive) (setq goal-column nil) (message "No goal column"))
(defun nu-set-x-4-map () (interactive) (set-temporary-overlay-map ctl-x-4-map))
(defun nu-set-x-5-map () (interactive) (set-temporary-overlay-map ctl-x-5-map))
(define-key nu-global-map (kbd "a") 'async-shell-command)
(define-key nu-global-map (kbd "à") 'delete-other-windows)
(define-key nu-global-map (kbd "1") 'delete-other-windows)
(define-key nu-global-map (kbd "&") 'delete-other-windows)
(define-key nu-global-map (kbd "2") 'split-window-below)
(define-key nu-global-map (kbd "é") 'split-window-below)
(define-key nu-global-map (kbd "3") 'split-window-right)
(define-key nu-global-map (kbd "\"") 'split-window-right)
(define-key nu-global-map (kbd "4")  'nu-set-x-4-map)
(define-key nu-global-map (kbd "'") 'nu-set-x-4-map)
(define-key nu-global-map (kbd "5") 'nu-set-x-5-map)
(define-key nu-global-map (kbd "(") 'nu-set-x-5-map)
(define-key nu-global-map (kbd "g") 'set-goal-column)
(define-key nu-global-map (kbd "G") 'nu-no-goal-column)
(define-key nu-global-map (kbd "\C-q") 'save-buffers-kill-emacs)
(define-key nu-global-map (kbd "t") 'transpose-frame)
(define-key nu-global-map (kbd "x") 'Control-X-prefix)
(make-help-screen nu-global-prompt
(purecopy "GLOBAL")
"
 a: async-shell-command     g:    goal column
 t: transpose-frame         G: rm goal column

 0 or à Close             50 Close frame
 1 or & This window only
 2 or é Hsplit	          52 New frame
 3 or \" VSplit
 4 or ' xxx

 x: Emacs standard Control-X keymap
 Control-q: quit emacs

<!> if you wanted C-g to keyboard-quit, use C-q <!>"
nu-global-map)


(define-key help-map (kbd "h") 'nu-help)

(make-help-screen nu-help-prompt
(purecopy "Help")
"Press q to quit or :

h: emacs-nu help page
r: emacs manual
i: info
f: describe-function         d: search in documentation
k: describe-key              m: describe-mode
v: describe-variable"
help-map)

(define-prefix-command 'nu-find-map)
(defun nu-isearch-forward ()
  (interactive)
  (if mark-active
      (progn
	(call-interactively 'isearch-forward)
	(isearch-yank-string (buffer-substring-no-properties (region-beginning) (region-end))))
      (isearch-forward)))
(defun nu-isearch-backward ()
  (interactive)
    (if mark-active
      (progn
	(call-interactively 'isearch-backward)
	(isearch-yank-string (buffer-substring-no-properties (region-beginning) (region-end))))
    (isearch-backward)))
(defun nu-isearch-forward-regexp ()
  (interactive)
    (if mark-active
      (progn
	(call-interactively 'isearch-forward-regexp)
	(isearch-yank-string (buffer-substring-no-properties (region-beginning) (region-end))))
    (isearch-forward-regexp)))
(defun nu-isearch-backward-regexp ()
  (interactive)
    (if mark-active
      (progn
	(call-interactively 'isearch-backward-regexp)
	(isearch-yank-string (buffer-substring-no-properties (region-beginning) (region-end))))
    (isearch-backward-regexp)))
(defun nu-set-mark-1 () (interactive) (cua-set-mark 1))
(defun nu-goto-line-previousbuffer () (interactive) (goto-line (previous-buffer)))
(define-key nu-find-map (kbd "F") 'nu-isearch-forward)
(define-key nu-find-map (kbd "R") 'nu-isearch-backward)
(define-key nu-find-map (kbd "f") 'nu-isearch-forward-regexp)
(define-key nu-find-map (kbd "r") 'nu-isearch-backward-regexp)
(define-key nu-find-map (kbd "i") 'beginning-of-buffer)
(define-key nu-find-map (kbd "k") 'end-of-buffer)
(define-key nu-find-map (kbd "b") 'regexp-builder)
(define-key nu-find-map (kbd "s") 'nu-set-mark-1)
(define-key nu-find-map (kbd "l") 'ace-jump-line-mode)
(define-key nu-find-map (kbd "c") 'ace-jump-char-mode)
(define-key nu-find-map (kbd "w") 'ace-jump-word-mode)
(define-key nu-find-map (kbd "z") 'nu-find-char)
(define-key nu-find-map (kbd "g") 'goto-line)
(define-key nu-find-map (kbd "G") 'nu-goto-line-previousbuffer)
(make-help-screen nu-find-prompt
(purecopy "Find")
"<!> if you wanted to forward char, use M-l <!>

f: isearch-forward-regexp    r: isearch-backward-regexp
F: isearch-forward	     R: isearch-backward
			     b: regexp-builder
l: ace-jump-line-mode
c: ace-jump-char-mode        z: nu-find-char (zap...)
w: ace-jump-word-mode
                             s: goto previous selection
i: beginning-of-buffer       g: goto line
k: end-of-buffer             G: goto line (previous-buffer)
"
nu-find-map)



(define-prefix-command 'nu-replace-map)
(defun nu-join-line () (interactive) (join-line 1))
(defun nu-rot-reg-or-toggle-rot () (interative) (if mark-active (rot13-region) (toggle-rot13-mode)))
(define-key nu-replace-map (kbd "r")  'query-replace-regexp)
(define-key nu-replace-map (kbd "a")  'revert-buffer)
(define-key nu-replace-map (kbd "R")  'query-replace)
(define-key nu-replace-map (kbd "k")  'overwrite-mode)
(define-key nu-replace-map (kbd "I")  'replace-string)
(define-key nu-replace-map (kbd "i")  'replace-regexp)
(define-key nu-replace-map (kbd "j")   'nu-join-line)
(define-key nu-replace-map (kbd "J")   'join-line)
(define-key nu-replace-map (kbd "t")   'transpose-lines)
(define-key nu-replace-map (kbd "z")   'zap-to-char)
(define-key nu-replace-map (kbd "u")   'upcase-word)
(define-key nu-replace-map (kbd "d") 'downcase-word)
(define-key nu-replace-map (kbd "c") 'capitalize-word)
(define-key nu-replace-map (kbd "x") 'nu-rot-reg-or-toggle-rot)
(define-key nu-replace-map (kbd "h") 'delete-horizontal-space)
(make-help-screen nu-replace-do-prompt
(purecopy "Replace")
"
  r: query-replace-regexp	 j: join-line (following)
  R: query-replace		 J: join-line (previous)
  I: replace-string
  i: replace-regexp		 t: transpose-lines

  k: overwrite-mode		 u: UPCASE-WORD
				 d: downcase-word
  z: zap-to-char		 c: Capitalize-Word
  h: delete-horizontal-space

  a: revert buffer		 x: rot13-region (if region)"
nu-replace-map)

(defun nu-replace-prompt ()
  (interactive)
  (if (or (eq overwrite-mode 'overwrite-mode-textual)
	  (eq overwrite-mode 'overwrite-mode-binary))
    (overwrite-mode -1)
    (nu-replace-do-prompt)))


(provide 'nu-prompts)
