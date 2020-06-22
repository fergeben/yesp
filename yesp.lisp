;;;; yesp.lisp

(in-package #:yesp)

(defparameter *db* (make-hash-table))
(defparameter *db-dir*
  (make-pathname
   :directory `(,@(pathname-directory (user-homedir-pathname))
		  ".yesp.d" "streams")))

(defun make-event (action payload version)
  (list :action action :payload payload :version version))

(defun make-event-stream (name events)
  (list :name name :events events))

(defun push-event (event stream)
  (push event (getf stream :events)))

(defun event-stream-path (name)
  (make-pathname
   :defaults *db-dir*
   :name name
   :type "lisp"))

(defun save-event-stream (event-stream)
  (with-open-file (out (event-stream-path (getf event-stream :name))
		       :direction :output
		       :if-exists :append
		       :if-does-not-exist :create)
    (with-standard-io-syntax
      (dolist (item (getf event-stream :events)) (print item out)))))

(defun event-stream-files ()
  (list-directory *db-dir*))

(defun load-event-stream (name)
  name)

(defun save-db ()
  (with-open-file (out *db-path*
		       :direction :output
		       :if-exists :append
		       :if-does-not-exist :create)
    (with-standard-io-syntax
      (print *db* out))))

(defun load-db ()
  (dolist (f (event-stream-files))
    (with-open-file (in f)
      (with-standard-io-syntax
	(print (read in))))))
