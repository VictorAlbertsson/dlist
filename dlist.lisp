;;;; dlist.lisp
;;; The canonical implementation of DLL fo LISP
;;; was insufficient, so I'm goind to try to
;;; implement it myself.

;;(defstruct dlist head tail)
;;(defstruct dlink content prev next)

(in-package #:dlist)

(defclass dlink ()
  ((content
    :initarg :content
    :type t
    :initform nil
    :accessor content)
   (prev
    :initarg :prev
    :type dlink
    :initform nil
    :accessor dprev)
   (next
    :initarg :next
    :type dlink
    :initform nil
    :accessor dnext)))

(defmethod print-object ((obj dlink) stream)
  (print-unreadable-object (obj stream :type t)
    (format stream "~a" (content obj))))

(defclass dlist ()
  ((head
    :initarg :head
    :type dlink
    :initform nil
    :accessor dhead)
   (tail
    :initarg :tail
    :type list
    :initform nil
    :accessor dtail)))

(defmethod print-object ((obj dlist) stream)
  (print-unreadable-object (obj stream :type t)
    (format stream "(~{~a~^ ~})" (dl-unlink :head obj))))

(defun dl-between (dlist before after data)
  (let ((new-link (make-instance 'dlink :content data :prev before :next after)))
    (if (null before)
	(setf (dhead dlist) new-link)
	(setf (dnext before) new-link))
    (if (null after)
	(setf (dtail dlist) new-link)
	(setf (dprev after) new-link))
    new-link))

;;; Not ideal.
;;; TODO: Add key-based removal
(defun dl-remove (dlist dlink)
  (let ((before (dprev dlink))
	(after  (dnext dlink)))
    (if (null before)
	(setf (dhead dlist) after)
	(setf (dnext before) after))
    (if (null after)
	(setf (dtail dlist) before)
	(setf (dprev after) before))))

;;; TODO: Pattern matching
(defmethod dl-add (where (dlist dlist) value)
  (cond ((eq where :head) (dl-between dlist nil (dhead dlist) value))
	((eq where :tail) (dl-between dlist (dtail dlist) nil value))
	('else            (error "Invalid keyword: ~a, expected :HEAD or :TAIL" where))))

(defmethod dl-get (where (dlist dlist))
  (cond ((eq where :head) (dhead dlist))
	((eq where :tail) (labels ((final-value (dlink)
				     (let ((next-dlink (dnext dlink)))
				       (if (null next-dlink)
					   dlink
					   (final-value next-dlink)))))
			    (final-value (dhead dlist))))
	('else            (error "Invalid keyword: ~a, expected :HEAD or :TAIL" where))))

(defmethod dl-del (where (dlist dlist))
  (cond ((eq where :head) (dl-remove dlist (dhead dlist)))
	((eq where :tail) (dl-remove dlist (dl-get :tail dlist)))
	('else            (error "Invalid keyword: ~a, expected :HEAD or :TAIL" where))))

(defmethod dl-unlink (where (dlist dlist))
  (cond ((eq where :head) (labels ((extract-values (dlink acc)
				     (if (null dlink)
					 acc
					 (extract-values (dnext dlink) (cons (content dlink) acc)))))
			    (reverse (extract-values (dhead dlist) nil))))
	((eq where :tail) (labels ((extract-values (dlink acc)
				     (if (null dlink)
					 acc
					 (extract-values (dnext dlink) (cons (content dlink) acc)))))
			    (extract-values (dhead dlist) nil)))
	('else            (error "Invalid keyword: ~a, expected :HEAD or :TAIL" where))))

;;; DEPRECATED: To be replaced by key-based variant
(defun insert-before (dlist dlink data)
  (dl-between dlist (dprev dlink) dlink data))

;;; DEPRECATED: To be replaced by key-based variant
(defun insert-after (dlist dlink data)
  (dl-between dlist dlink (dnext dlink) data))
