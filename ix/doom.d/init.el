;;; init.el -*- lexical-binding: t; -*-
;;; Doom module selection. See https://docs.doomemacs.org/-/289 for all modules.

(doom! :input
       pinyin                     ; pinyin-based search, for working with Chinese text

       :completion
       vertico                    ; the search engine of the future

       :ui
       doom                       ; makes doom look... doomier
       dashboard                  ; a splash screen for Emacs
       hl-todo                    ; highlight TODO/FIXME/NOTE/DEPRECATED/HACK
       modeline                   ; snazzy, Atom-inspired modeline
       nav-flash                  ; blink cursor line after big motions
       ophints                    ; highlight the region an operation acts on
       (popup +defaults)          ; tame sudden yet inevitable temporary windows
       treemacs                   ; a project drawer like neovim's NERDTree
       vc-gutter                  ; vcs diff in the fringe
       window-select              ; visually switch windows

       :editor
       evil                       ; come to the dark side, we have cookies
       format                     ; automated prettiness
       snippets                   ; my elves. They type so I don't have to

       :emacs
       (dired +icons)             ; making dired pretty [functional]
       electric                   ; shorten, repeat kbd keys
       ibuffer                    ; interactive buffer management
       undo                       ; persistent, smarter undo for your mistakes
       vc                         ; version-control and Emacs, sitting in a tree

       :term
       eshell                     ; the elisp shell that works everywhere
       vterm                      ; the best terminal emulation in Emacs

       :os
       tty                        ; improve the terminal Emacs experience

       :lang
       emacs-lisp                 ; drown in parentheses
       json                       ; At least it's not YAML
       javascript                 ; all(hop(abuse(laguage)))
       typescript                 ; javascript, but with static types
       markdown                   ; writing docs for people who don't use doom
       (nix +lsp)                 ; I hereby declare "nix gonna be the future"
       (org +pretty)              ; organize your plain life in plain text
       (python +lsp)              ; beautiful is better than ugly
       (rust +lsp)                ; your lung becomes a blackened lump of coal
       sh                         ; she sells (ba|z|fi)sh shells on the C xor
       yaml                       ; JSON, sans the parentheses

       :tools
       direnv                     ; be direct about your environment
       (eval +overlay)            ; run code, run (also, repls)
       (lsp +eglot)               ; M-x emacs support for language-aware servers
       magit                      ; a git porcelain for Emacs

       :config
       (default +bindings +smartparens))  ; the default, minus the kitchen sink
