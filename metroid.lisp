;;;; metroid.lisp

(in-package #:metroid)

(define-component 'coords)
(defstruct coords
  (x 0.0 :type float)
  (y 0.0 :type float)
  (z 0.0 :type float))

(define-component 'viewable)
(defstruct vector3
  (x 0.0 :type float)
  (y 0.0 :type float)
  (z 0.0 :type float))
(defstruct viewable
  (target (make-vector3) :type vector3)
  (up (make-vector3) :type vector3)
  (fovy 45.0 :type float)
  (projection 0 :type fixnum))

(defun make-camera (&key (x 0.0) (y 0.0) (z 0.0))
  (let ((id (make-entity)))
    (update-component 'position id (make-coords :x x :y y :z z))
    (update-component 'viewable id (make-viewable))))

(defparameter *camera* (make-instance 'camera-3d))

(defun gather-input ()
  (cond
    ((key-down? (key-code 'key-left)) (setf (first (target *camera*)) (- (first (target *camera*)) 0.5)))
    ((key-down? (key-code 'key-right)) (setf (first (target *camera*)) (+ (first (target *camera*)) 0.5)))
    ((key-down? (key-code 'key-d)) (setf (nth 2 (target *camera*)) (+ (nth 2 (target *camera*)) 0.5)))
    ((key-down? (key-code 'key-a)) (setf (nth 2 (target *camera*)) (- (nth 2 (target *camera*)) 0.5)))
    ((key-down? (key-code 'key-up)) (setf (second (target *camera*)) (+ (second (target *camera*)) 0.5)))
    ((key-down? (key-code 'key-down)) (setf (second (target *camera*)) (- (second (target *camera*)) 0.5)))))

(defun render-window ()
  (update-camera *camera* (gethash 'camera-custom +camera-modes+))
  (begin-drawing)
  (set-background-color 'darkpurple)
  (begin-mode-3d *camera*)
  (draw-grid 40 1.0)
  (draw-cube '(-16.0 2.5 0.0) 1.0 5.0 32.0 'blue)
  (draw-cube '(16.0 2.5 0.0) 1.0 5.0 32.0 'lime)
  (draw-cube '(0.0 2.5 16.0) 32.0 5.0 1.0 'gold)
  (draw-plane '(0.0 0.0 0.0) '(32.0 32.0) 'lightgray)
  (end-mode-3d)
  (set-text (format nil "Position: ~A | Target: ~A" (pos *camera*) (target *camera*)) 400 600 20 'yellow)
  (set-text (format nil "Mouse Delta: ~A" (get-mouse-delta)) 400 700 20 'yellow)
  (draw-fps 10 10)
  (end-drawing))

(defun main ()
  (init-window 1024 768 "Hello Metroid")
  (set-target-fps 60)
  (loop until (window-should-close)
        do (gather-input)
           (render-window)
        finally
           (close-window)))
