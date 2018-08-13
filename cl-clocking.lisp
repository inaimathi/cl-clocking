;;;; cl-clocking.lisp

(in-package #:cl-clocking)

(defun sha256 (str)
  (ironclad:byte-array-to-hex-string
   (ironclad:digest-sequence
    :sha256 (ironclad:ascii-string-to-byte-array str))))

(defun tcp-send (sock input)
  nil)

(defun tcp-receive (sock)
  nil)

(defun battery-status ()
  (loop for b in (trivial-battery:battery-info)
     collect (trivial-battery:battery-details
              (cdr (assoc "name" b :test #'string=)))))

(defun profile! (&key (times 1000))
  (let* ((gen (session-token:make-generator :token-length 1000))
         (server (usocket:socket-listen usocket:*wildcard-host* 8080 :reuse-address t))
         (before (battery-status)))
    (loop repeat times
       do (let ((inp (funcall gen)))
            (sha256 inp)))
    (list :before before :after (battery-status))))
