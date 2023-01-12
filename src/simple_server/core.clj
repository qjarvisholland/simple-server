(ns simple-server.core
  (:require [org.httpkit.server :as s]
            [compojure.core :refer :all]
            [compojure.route :as route]
            [ring.adapter.jetty :as jetty]
            [clojure.java.io :as io]
            [clojure.data.json :as json]
            [clojure.java.http :as http]
            [clojure.edn :as edn]
            )
  )

(defn handler [req]
  {:status 200
   :headers {"Content-Type" "text/html"}
   :body "<h1> HI !!!</h1>"})

(defn image-handler []
  (let [{:keys [status body]} (http/get "https://some.image.url/image.jpg"  {:as :byte-array})]
    (if (= 200 status)
      {:status 200
       :headers {"Content-Type" "image/jpeg"}
       :body body}
      {:status 404
       :body "Image not found"})))
You'll need to route requests to this handler using Compojure:
(defroutes app-routes
  (GET "/image" [] (image-handler))
  (GET "/index" [] (handler))
           )

(defn create-server []
  (s/run-server app-routes {:port 8080}))

(defn stop-server [server]
  (server :timeout 10))
  

