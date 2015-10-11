;; Created by Nick DeCoursin

(require-package '4clojure)

(require 'cider)

(defadvice 4clojure-open-question (around 4clojure-open-question-around)
  "Start a cider/nREPL connection if one hasn't already been started when
opening 4clojure questions"
  ad-do-it
  (unless cider-current-clojure-buffer
    (cider-jack-in)))

(provide 'init-4clojure)
