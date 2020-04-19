;;;; dlist.asd

(asdf:defsystem #:dlist
  :description "Simple and flexible doubly-linked list."
  :author "Victor Albertsson <victor.albertsson@live.se>"
  :license "0.1.0"
  :serial t
  :components
  ((:file "package")
   (:file "dlist")))
