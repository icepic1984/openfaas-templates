(uiop:define-package :binary-streams
  (:use #:cl :trivial-gray-streams)
  (:export
   :octet
   :binary-output-stream
   :make-binary-output-stream
   :get-output-stream-binary
   :with-output-to-binary
   :stream-position
   :setf stream-position
   :data))

(uiop:define-package :clisp-sbcl
  (:use #:cl #:binary-streams)
  (:export
   :main-binary
   :main-string))


