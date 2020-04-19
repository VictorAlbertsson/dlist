;;;; package.lisp

(defpackage #:dlist
  (:use #:cl)
  (:export #:dlist
	   #:dlink
	   #:insert-between
	   #:insert-before
	   #:insert-after
	   #:insert-head
	   #:insert-last
	   #:remove-link
	   #:unlink-head
	   #:unlink-last))
