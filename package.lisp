;;;; package.lisp

(defpackage #:dlist
  (:use #:cl)
  (:export #:dlist
	   #:dlink
	   #:dl-between
	   #:dl-remove
	   #:dl-add
	   #:dl-get
	   #:dl-del
	   #:dl-unlink))
