(defsystem #:clisp-sbcl
  :version "0.1.0"
  :author "Christoph Buck"
  :license "MIT License"
  :depends-on (:alexandria :babel :iterate :trivial-gray-streams)
  :serial t
  :components ((:file "package")
               (:file "binary-streams")
               (:file "function/handler")
               (:file "index"))
  :build-operation "program-op"
  :build-pathname "index"
  :entry-point "clisp-sbcl:main-binary"
  ;; :entry-point "clisp-sbcl:main-string" ;; Use this for string io
   :description "Sbcl common lisp language template for openfaas")


;; sbcl --eval "(ql:quickload :clisp-sbcl)" --eval "(asdf:make :clisp-sbcl)" --quit

;; Build for sbcl
;; sbcl --eval "(ql:quickload :clisp-sbcl)" --eval "(asdf:make :clisp-sbcl)" --quit
;; (asdf:make-build :clisp-sbcl
;;                  :type :program)
;;

;; Build for ecl
;; (ext:install-c-compiler)
;; (asdf:make-build
;;  :clisp-sbcl
;;  :type :program
;;  :move-here #P"./"
;;  :epilogue-code '(progn
;;                   (clisp-sbcl:main-binary)
;;                   (si:exit)))
