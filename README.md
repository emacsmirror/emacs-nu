# OVERVIEW

`nu` is an Emacs package which does not add features, but focus on interface, like `ErgoEmacs`, or `Hydra`. There are two parts of nu :
- The menu
  This part of nu aims to allow to run hundred(s) of different funcs without too much trouble, to leverage Emacs strength. It is possible to only employ nu menu and disregard keybindings.
- The keybindings (flavours)
  This part of nu deals with keys. It is possible to use of of them without the menu but other imply the menu to be used.

nu-mode is in Melpa. So it's the usual deal.

    (require 'package)

    (add-to-list 'package-archives
    '("melpa" . "https://melpa.org/packages") t)

(or look at https://melpa.org)

# The menu #

I dislike `Control+x` because many keybindings are difficult both to memorize and to type. Also it is not merged with `Alt+g` (**goto-map**) or `Control+c` (**mode specific map**). I rather prefer a global menu. `Spacemacs` uses a similar menu, except it is grouped by theme and might contain less modes specific items.

So nu has several Submenus ("operators" or also "verbs"), and also a leader menu to call these. Submenus are like operators : *save*; *open*, *new*, ... Menus content are like objects : *buffer*, *file*, *frame*, ... 

For example, a "file" command is bound to "f" when possible, so inside save menu one can type "f" to call "write-file", while inside delete menu "f" will call "delete-file".

### Menu verbs ###

in order to offer many funcs we need many operators. Currently 13 + help-map
so it is useful to have a good description of operators to knwow where to find funcs.

| verb    | synonym   | keymap         | description                                                                                 |
|---------|-----------|----------------|---------------------------------------------------------------------------------------------|
| change  | bold      | nu-change-map  | change an existing item, not a string replacement : rather emphasize, promote, face, toggle |
| copy    |           | nu-copy-map    | copy any element  (file buffer...)                                                          |
| kill    | delete    | nu-kill-map    | kill buffer, string, file, lines.                                                           |
| display | narrow    | nu-display-map | outline, shrink, hide, ...                                                                  |
| goto    |           | nu-goto-map    | goto next link, list item, error, other-win, register. But otherwise use "open"             |
| insert  |           | nu-insert-map  | insert file, register, command                                                              |
| mark    |           | nu-mark-map    | mark (only useful for modes)                                                                |
| new     | create    | nu-new-map     | create buffer, file, frame, win, compose mail, record macro                                 |
| print   | eval      | nu-print-map   | print, export, compile code or eval code / expression                                       |
| quit    | archive   | nu-quit-map    | quit something, archive something. For refile use save. For undo use undo-tree              |
| replace | transpose | nu-replace-map | replace string, transpose (string frame)                                                    |
| save    | refile    | nu-save-map    | save, refile, push to list                                                                  |
| switch  | setting   | nu-switch-map  | toggle a settings, customize. (but toggle a box is "change")                                |



### Menu objects ###

any of these verbs acts on an object. Whenever possible, an object is to be bound to its usal key.

| key | functions              | example                         |
|-----|------------------------|---------------------------------|
| a   | bookmark, rectangle    | bookmark-set                    |
| b   | buffer                 | insert-buffer                   |
| c   | calc                   | calc                            |
| d   | directory, dired       | dired                           |
| e   |                        |                                 |
| f   | file, frame            | write-file                      |
| g   | agenda                 |                                 |
| h   |                        |                                 |
| i   | interactive, list      |                                 |
| j   | next, down             |                                 |
| k   | previous, up           |                                 |
| l   | link                   |                                 |
| m   | mail                   |                                 |
| n   |                        |                                 |
| o   | other, inversed        | other-window, save-some-buffers |
| p   | macro, package, eval   | kmacro-end-or-call-macro        |
| q   | QUIT ANY MENU          | ~~~~~~~~~~~~~~~~~~~~~~~~~~~     |
| r   | recent, register, mark | point-to-register               |
| s   | string, save           |                                 |
| t   | tag                    |                                 |
| u   | undo, url, revert      |                                 |
| v   | abbrev                 |                                 |
| w   | window                 | ace-window                      |
| x   | [reg]exp               |                                 |
| y   | all                    |                                 |
| z   | command                | term                            |

### Menus for major and minor modes ###

emacs modes offer lot of funcs. sometimes not every func in bound to a key. but in nu emacs i tend to bind everything, to the usual menus. So if a mode allows to kill something, it will be bound in kill-delete prompt, altogether with usual funcs like delete-blank lines, delete-window and so on.

Convention is still work in progress : usual funcs use lower case keys, modes use uppercase keys. Usually punctations is available for minor modes.

Moving might be very specific to a mode. So while nu offers a common "goto" menu dedicated to going to, either a different place to the buffer, or somewhere like a specific char or specific line, there is a specific "move-to" menu which is only used by modes. So all keys in this specific menu are dedicated to current modes. I expect this menu to contain only moves inside the current buffer, while other functions should leverage goto-menu (or open-menu if appropriate).

MOVE-TO menu uses its own "objects" conventions in below table plus "modifiers": 
- k "lower case key" to go forward / down
- K "upper case key" to go backward / up
- "g" is a prefix to amend the key so
  - g + k is end (moving forward)
  - g + K is beginning (moving backward)
  
The convention is respected only if objects applies to this mode.

| move-to menu key | move-to menu object                              |
|------------------|--------------------------------------------------|
| a                | page                                             |
| b                | block                                            |
| e                | heading                                          |
| f                | <reference> (1)                                  |
| h                | paragraph                                        |
| l                | list                                             |
| n                | link (inside the buffer, otherwise use goto-map) |
| o                | outline                                          |
| r                | <reference> (2)                                  |
| t                | note                                             |
| y                | hierarchy                                        |

## FLAVOURS ##

so, nu comes with several flavours.

### No Flavour : just add nu menus to Emacs ###

Just adding nu menus to your Emacs is nice to keep Emacs keybindings or if you already use some keybinding, for example with ErgoEmacs. Obviously the drawback is that if menus are too difficult to reach, they might lose their power.

    (require 'nu-mode)
    (nu-initialize)
	(nu-populate-prompters)
	
Then bind the key or sequence you want to nu-menu-map, like

    (global-set-key (kbd "<menu>") 'nu-prompt-for-menus)
    (global-set-key (kbd "C-c") 'nu-prompt-for-menus)

### vim flavour : Nu State is based on evil ###

nu state is vim. It is simply integration of nu-menu into evil.
Well, nu state does preserve vim keys but adds some alt keys (y=copy, p=paste, d=cut, f=find)
So, vim states (normal, insert, visual) are used. Command state is available but not useful.

Some alt keys trigger immediate func (eg to switch windows without leaving home row), some trigger submenus.

     (require 'nu-state)
     (nu-state)
 
 
### slowMotion flavour : an Emacs respectful modal keybinding ###

slowm is modal and based on evil. It basically binds evil funcs to other keys, in order to respect emacs conventions like `a` for beginning-of-line or `k` to kill. slowm makes sense on itself but may also be used together with nu menu.

    (require 'nu-slow-motion)
    (nu-slow-motion)

Other modes than text are Emacs state. From a text bufffer you will use menu to switch buffer or do anyting. From another mode than text (mail, dired...) you may either stick to `C-x o` other-window, or bind nu leader menu to C-c, or replace C-x with nu leader menu. Or you may rely on `global-set-key` to assign keys but not break keybindings.

    (define-key evil-emacs-state-map (kbd "C-c m") 'nu-slowm-leader-prompt)
	(global-set-key (kbd "M-g") 'other-window)

### notepad Flavour : Nu Mode keybinding ###

It's a modern keybinding (c =copy, v=insert, x=cut, f=find)
Everything is done in insert mode. There are
- immediate keys : do something like save of find
- menus keys : access the save-archive menu or find menu

Hands remain most of time in home row because of alt keys.
Paddle is like evil (hjkl) or invesed T-like (jkil).
Default is to have alt keys do "immediate" funcs
So, menus , which are generally not necessary, are invoked using Control key like Control+f to have "Find menu"
nu mode also allows to have alt keys do menus, and control do immediate func.
This is compabilble with today's conventions (conrol+c copy, control+v find and so on)

Technically nu mode is based on evil. This includes selecting text (like vim selection mode), which is the only modal part of nu mode.
This also includes a keybinding to run evil-delete, like vi "d" operator to delete any vi motion.

    (require 'nu-mode)
    (nu-mode)

if you want to use ijkl paddle rather than default (vi),
use the variable nu-use-vi-paddle.
If you want control to be like CUA ; and alt keys trigger menus,
then use variables nu-immediate-key and nu-menu-key.

     (require 'nu-mode)
     (setq nu-immediate-key "C"
           nu-menu-key      "M"
           nu-use-vi-paddle t)
     (nu-mode)

# CUSTOMIZING AND EXTENDING

no matter if you use just menus, nu-mode, or nu-state, you have some common customizations.

## add a func to a menu

when nu does populate the menu to fit current modes, it runs the hook *nu-populate-hook*. After this hook runs, you can add a key to any of the keymap.

## Completion framework

Things should be ok if you just enable your ido / helm / ivy or whatever
Anyway i'd recommend to tell nu about your usage

    (nu-set-ivy)
    (nu-set-helm)

## Prompter

Default prompter is which-key

You can refer to which-key to customize behaviour like, how long it takes for menu to appear.
Actually which-key already offers a lot of options.
Or you can use another prompter
Other prompter allow more features : "+" to trigger repeat menu , "-" or "1", "2", … to customize universal argument, "?" to describe a command rather than describing it.

    (defalias 'nu-prompt-for-keymap 'nu-light-prompt-for-keymap)
    (defalias 'nu-prompt-for-keymap 'nu-completion-prompt-for-keymap)
    (defalias 'nu-prompt-for-keymap 'nu-buffer-prompt-for-keymap)


## Extend nu

### add a mode

First make a list of all funcs a mode offers. Do not use only describe-mode because some funcs may not be mapped. Instead you can use for example ivy : run counsel-M-x, then input the mode prefix (org-), then type `C-c C-o` to run *ivy-occur*, then save the list. Here you are. 

You might use `nu-check-candidates-for-menu` func to tell you what candidates you already added to menu or not.

`describe-mode` is still useful to note which funcs are actually a simple remap. You may not want to bind these to menu. Keep these documented so it is feasible to check all funcs are handled.


### add a prompter

Default prompter is which-key, so it is not really a prompter, just a quick help. Other prompters are nu-ivy-prompt-for-keymap, nu-helm-prompt-for-keymap, or nu-lv-prompt-for-keymap (requires hydra).
