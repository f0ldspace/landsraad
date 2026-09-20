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
