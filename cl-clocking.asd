;;;; cl-clocking.asd

(asdf:defsystem #:cl-clocking
  :description "Describe cl-clocking here"
  :author "Your Name <your.name@example.com>"
  :license  "Specify license here"
  :version "0.0.1"
  :serial t
  :depends-on (#:alexandria #:trivial-battery #:session-token #:bordeaux-threads #:ironclad #:usocket)
  :components ((:file "package")
               (:file "cl-clocking")))
