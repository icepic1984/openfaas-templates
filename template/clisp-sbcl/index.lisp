;; Copyright (c) 2022, Christoph Buck. All rights reserved.

;; Redistribution and use in source and binary forms, with or without
;; modification, are permitted provided that the following conditions
;; are met:

;; 1. Redistributions of source code must retain the above copyright
;; notice, this list of conditions and the following disclaimer.

;; 2. Redistributions in binary form must reproduce the above
;; copyright notice, this list of conditions and the following
;; disclaimer in the documentation and/or other materials provided
;; with the distribution.

;; THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
;; "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
;; LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS
;; FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE
;; COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT,
;; INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
;; (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
;; SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
;; HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
;; STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
;; ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED

;; package alexandria will be loaded at compile time because of the
;; :compile-toplevel situation, loaded when the FASL is loaded because
;; of :load-toplevel, and loaded when the source is loaded because of
;; the :execute.

;; (eval-when (:compile-toplevel :load-toplevel :execute )
;;   (ql:quickload :alexandria))

(in-package :clisp-sbcl)

(defun get-stdin-binary ()
  (with-output-to-binary (datum)
    (let ((buffer (make-array 4096 :element-type 'octet)))
      (loop for bytes-read = (read-sequence buffer *standard-input*)
            do (write-sequence buffer datum :start 0 :end bytes-read)
            while (= bytes-read 4096)))))

(defun get-stdin-string ()
  (with-output-to-string (datum)
    (let ((buffer (make-array 4096 :element-type 'character)))
      (loop for bytes-read = (read-sequence buffer *standard-input*)
            do (write-sequence buffer datum :start 0 :end bytes-read)
            while (= bytes-read 4096)))))

(defun get-stdin ()
  (loop for line = (read-line *standard-input* nil)
        while line
        collect line))

(defun write-stdout (ret)
  (loop for line in ret
        do (write-line line)))

(defun main-binary ()
  (let* ((st (get-stdin-binary))
         (ret (handler st)))
    (when ret (write-sequence ret *standard-output*))))

(defun main-string ()
  (let* ((st (get-stdin-string))
         (ret (handler st)))
    (when ret (write-sequence ret *standard-output*))))

