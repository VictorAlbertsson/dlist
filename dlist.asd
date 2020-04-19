;;;; dlist.asd

(asdf:defsystem #:dlist
  :description "Simple and flexible doubly-linked list."
  :author "Victor Albertsson <victor.albertsson@live.se>"
  :version "0.2.0"
  :license "GPLv3"
  :serial t
  :components
  ((:file "package")
   (:file "dlist")))
