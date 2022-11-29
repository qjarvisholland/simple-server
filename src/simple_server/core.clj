(ns web.core
  (:require [org.httpkit.server :as s]))

(defn handler [req]
  {:status 200
   :headers {"Content-Type" "text/html"}
   :body "<h1> HI !!!</h1>"})

(defn create-server []
  (s/run-server handler {:port 8080}))

(defn stop-server [server]
  (server :timeout 10))
  

