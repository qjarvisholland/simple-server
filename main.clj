
(require '[simple-server.core :as c])
(println "Heating up server tubes")
(def server (c/create-server))
(delay 10)
(println "Server tubes are hot.")

