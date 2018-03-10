;;; treemacs.el --- A tree style file viewer package -*- lexical-binding: t -*-

;; Copyright (C) 2018 Alexander Miller

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;; General persistence and desktop-save-mode integration.

;;; Code:

(require 'f)
(require 'treemacs-projects)

(defconst treemacs--persist-file (f-join user-emacs-directory ".cache" "treemacs-persist")
  "File treemacs uses to persist its current state.")

(defun treemacs--persist ()
  "Persist treemacs' state in `treemacs--persist-file'."
  (-> treemacs-current-workspace
      (list)
      (pp-to-string)
      (f-write 'utf-8 treemacs--persist-file)))

(defun treemacs--restore ()
  "Restore treemacs' state from `treemacs--persist-file'."
  (condition-case e
      (-let [workspaces (-> treemacs--persist-file (f-read 'utf-8) (read))]
        (setq treemacs-current-workspace (car workspaces)))
    (error (treemacs-log "Error '%s' when loading the persisted workspace." e))))

(add-hook 'kill-emacs-hook #'treemacs--persist)

(unless (featurep 'treemacs)
  (treemacs--restore))

(provide 'treemacs-persist)

;;; treemacs-persist.el ends here
