;;; config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Almost all settings here can be
;; changed without rebuilding: the doom.d directory is bundled into the Emacs
;; profile, so changes here require a `nixos-rebuild switch` (or build).

(setq
 ;; Theme
 doom-theme 'doom-one

 ;; Fonts: JetBrainsMono Nerd Font is installed system-wide (nerd-fonts.jetbrains-mono).
 doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 13)
 doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font" :size 13)
 ;; CJK fallback, for Chinese text (noto-fonts-cjk-sans is installed system-wide)
 doom-unicode-font (font-spec :family "Noto Sans CJK SC")

 ;; Relative line numbers, vim-style
 display-line-numbers-type 'relative

 ;; org
 org-directory "~/org/")

;; Confirm exit / quit in one shot instead of y/N full-word prompts.
(setq confirm-kill-emacs nil)

;; Load tramp / recentf defaults sane for a Nix profile build: Doom's profile
;; is rebuilt by nix, so state belongs in DOOMLOCALDIR (~/.local/share/nix-doom),
;; which Doom already uses.

(after! evil
  ;; Start in normal mode in comint/term buffers (vterm already does)
  (when (modulep! :editor evil)
    ;; J/K motions on visual lines (nicer for wrapped prose)
    (define-key evil-normal-state-map "j" #'evil-next-visual-line)
    (define-key evil-normal-state-map "k" #'evil-previous-visual-line)))

;; Eglot: use servers that are installed system-wide or on PATH.
;; (rust-analyzer, nil, pyright are made available by doom-emacs.nix)
(after! eglot
  (add-to-list 'eglot-server-programs
               '(nix-mode . ("nil"))))
