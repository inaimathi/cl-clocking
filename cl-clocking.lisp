;;;; cl-clocking.lisp

(in-package #:cl-clocking)

(defparameter *generator* (session-token:make-generator :token-length 1000))
(defun gen! () (funcall *generator*))

(defun sha256 (str)
  (ironclad:byte-array-to-hex-string
   (ironclad:digest-sequence
    :sha256 (ironclad:ascii-string-to-byte-array str))))

(defun tcp-send (host port input)
  (let* ((sock (usocket:socket-connect host port))
         (stream (usocket:socket-stream sock)))
    (format stream "~a" input)
    (force-output stream)
    (read-sequence (make-string 2) stream)
    (usocket:socket-close sock)))

(defun tcp-receive (server)
  (let* ((sock (usocket:socket-accept server))
         (stream (usocket:socket-stream sock))
         (buf (make-string 1000)))
    (read-sequence buf stream)
    (format stream "~a" "ok")
    (force-output stream)
    (usocket:socket-close sock)
    buf))

(defun battery-status ()
  (loop for b in (trivial-battery:battery-info)
     collect (trivial-battery:battery-details
              (cdr (assoc "name" b :test #'string=)))))

(defun profile! (&key (times 1) (port 8080))
  (let* ((server (usocket:socket-listen usocket:*wildcard-host* port :reuse-address t))
         (server-thread (bt:make-thread (lambda () (loop (tcp-receive server)))))
         (before (battery-status)))
    (loop repeat times
       do (let ((inp (gen!)))
            (sha256 inp)
            (tcp-send "localhost" port inp)))
    (usocket:socket-close server)
    (bt:destroy-thread server-thread)
    (list :before before :after (battery-status))))
