;; -*- no-byte-compile: t; -*-
;;; $DOOMDIR/packages.el  -*- lexical-binding: t; -*-

;; To install a package here, these rules apply (nix-doom-emacs-unstraightened):
;; - Every custom package! MUST be pinned (`:pin "<commit sha>") so it can be
;;   fetched deterministically from nix.
;; - A package not in nixpkgs/emacs-overlay/ELPA needs a `:recipe' with a git
;;   URL so nix knows where to fetch it, e.g.:
;;
;;   (package! my-package
;;     :recipe (:host github :repo "user/my-package")
;;     :pin "abcdef1234567890...")
;;
;; - Disabling a Doom-bundled package:
;;
;;   (package! some-package :disable t)

;; org-roam-ui: web-based graph UI for org-roam (browser at 127.0.0.1:35901).
;; org-roam itself comes from the :lang (org +roam) module flag.
;; No :recipe needed: it's in MELPA/emacs-overlay, and its MELPA recipe
;; bundles the prebuilt web app (the "out" dir), which a bare recipe would
;; drop. Deps (simple-httpd, websocket) are pulled in automatically.
(package! org-roam-ui :pin "2894dcbf56d2eca8d3cae2b1ae183f51724b5db6")
