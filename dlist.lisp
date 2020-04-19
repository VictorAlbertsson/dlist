;;;; dlist.lisp
;;; The canonical implementation of DLL fo LISP
;;; was insufficient, so I'm goind to try to
;;; implement it myself.

;;(defstruct dlist head tail)
;;(defstruct dlink content prev next)

(in-package #:dlist)

(defclass dlist ()
  ((head
    :initarg :head
    :initform nil
    :accessor dhead)
   (tail
    :initarg :tail
    :initform nil
    :accessor dtail)))

(defclass dlink ()
  ((content
    :initarg :content
    :initform nil
    :accessor content)
   (prev
    :initarg :prev
    :initform nil
    :accessor dprev)
   (next
    :initarg :next
    :initform nil
    :accessor dnext)))

(defun insert-between (dlist before after data)
  (let ((new-link (make-instance 'dlink :content data :prev before :next after)))
    (if (null before)
	(setf (dhead dlist) new-link)
	(setf (dnext before) new-link))
    (if (null after)
	(setf (dtail dlist) new-link)
	(setf (dprev after) new-link))
    new-link))

(defun insert-before (dlist dlink data)
  (insert-between dlist (dprev dlink) dlink data))

(defun insert-after (dlist dlink data)
  (insert-between dlist dlink (dnext dlink) data))

(defun insert-head (dlist data)
  (insert-between dlist nil (dhead dlist) data))

(defun insert-last (dlist data)
  (insert-between dlist (dtail dlist) nil data))

;;; Not ideal.
;;; TODO: Add key-based removal
(defun remove-link (dlist dlink)
  (let ((before (dprev dlink))
	(after  (dnext dlink)))
    (if (null before)
	(setf (dhead dlist) after)
	(setf (dnext before) after))
    (if (null after)
	(setf (dtail dlist) before)
	(setf (dprev after) before))))

(defun unlink-head (dlist)
  "Convert the DL list DLIST to a linked-list from the head element."
  (labels ((extract-values (dlink acc)
	     (if (null dlink)
		 acc
		 (extract-values (dnext dlink) (cons (content dlink) acc)))))
    (reverse (extract-values (dhead dlist) nil))))

(defun unlink-last (dlist)
  "Convert the DL list DLIST to a linked-list from the last element."
  (labels ((extract-values (dlink acc)
	     (if (null dlink)
		 acc
		 (extract-values (dnext dlink) (cons (content dlink) acc)))))
    (extract-values (dhead dlist) nil)))
