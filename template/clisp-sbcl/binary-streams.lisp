(in-package :binary-streams)

(deftype octet () '(unsigned-byte 8))

(defclass binary-base-stream ()
  ((data :initarg :data :type (vector octet) :reader data)
   (stream-position :initarg :stream-position :initform 0 :reader stream-position)))

(defgeneric (setf stream-position) (value object)
  (:documentation "Resets the stream position to value."))

(defmethod (setf stream-position) (value (object binary-base-stream))
  (when (or (> value (length (data object)))
            (< value 0))
    (error "Stream position out of bound."))
  (setf (slot-value object 'stream-position) value))

(defmethod stream-element-type ((stream binary-base-stream))
  'octet)

(defclass binary-output-stream
    (binary-base-stream fundamental-binary-output-stream)
  ())

(defmethod stream-write-byte ((stream binary-output-stream) value)
  (with-slots (data stream-position) stream
    (if (< stream-position (length data))
        (prog1 (setf (aref data stream-position) value)
          (incf stream-position))
        (prog1 (vector-push-extend value data)
          (incf stream-position))))
  value)

(defun make-binary-output-stream (size)
  (make-instance 'binary-output-stream :data (make-array size :adjustable t
                                                              :element-type 'octet
                                                              :fill-pointer size)))

(defun get-output-stream-binary (stream)
  (setf (fill-pointer (data stream)) (stream-position stream))
  (data stream))


(defmacro with-output-to-binary ((var) &body body)
  `(let ((,var (make-binary-output-stream 4096)))
     (unwind-protect
          (progn
            ,@body)
       (close ,var))
     (get-output-stream-binary ,var)))

