;;; config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Almost all settings here can be
;; changed without rebuilding: the doom.d directory is bundled into the Emacs
;; profile, so changes here require a `nixos-rebuild switch` (or build).

(setq
 ;; Theme
 doom-theme 'doom-one

 ;; Fonts: JetBrainsMono Nerd Font is installed system-wide (nerd-fonts.jetbrains-mono).
 doom-font (font-spec :family "JetBrainsMono Nerd Font" :size 15)
 doom-variable-pitch-font (font-spec :family "JetBrainsMono Nerd Font" :size 15)
 ;; CJK fallback, for Chinese text (noto-fonts-cjk-sans is installed system-wide)
 doom-unicode-font (font-spec :family "Noto Sans CJK SC")

 ;; Relative line numbers, vim-style
 display-line-numbers-type 'relative

 ;; org
 org-directory "~/org/")

;; Dashboard: hide the banner entirely (keeps the menu/loaded widgets).
;; This fork's module uses `+dashboard-functions' / `+dashboard-widget-banner'
;; (no "doom-" prefix), and `+dashboard-banner-file nil' would actually FORCE
;; the ASCII banner, so remove the banner widget from the redraw list instead.
(remove-hook '+dashboard-functions #'+dashboard-widget-banner)

;; Org agenda: 1-week default span (instead of 10 days) with a clock
;; report table shown by default.
(after! org
  (setq org-agenda-span 'week
        org-agenda-start-on-weekday 1
        org-agenda-start-with-clockreport-mode t
        org-agenda-clockreport-parameter-plist '(:link t :maxlevel 3 :fileskip0 t)))

;; Confirm exit / quit in one shot instead of y/N full-word prompts.
(setq confirm-kill-emacs nil)

;; org-modern (via :lang (org +pretty)): don't turn [%] and [/] todo
;; statistics cookies into progress bars; keep the plain text.
(after! org-modern
  (setq org-modern-progress nil))

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
