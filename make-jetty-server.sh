#!/bin/bash

PROJECT_DIR="hello-world-webserver"

# Determine if the project already exists
if [ -d "$PROJECT_DIR" ]; then
  echo "Updating existing project..."
  cd "$PROJECT_DIR"
else
  echo "Creating a new project..."
  lein new app $PROJECT_DIR
  cd $PROJECT_DIR
fi

# Function to create or update content files only if they don't contain the desired content
create_or_update_content() {
  local file=$1
  local content=$2
  if [ -f "$file" ]; then
    if ! grep -qF -- "$content" "$file"; then
      echo "$content" > "$file"
    fi
  else
    echo "$content" > "$file"
  fi
}

# Create or update content files with default HTML messages
create_or_update_content "content" "<html><body><h1>Hello, Welcome to the Home Page!</h1></body></html>"
create_or_update_content "content-about" "<html><body><h1>About us page content here.</h1></body></html>"
create_or_update_content "content-help" "<html><body><h1>Help page information here.</h1></body></html>"
create_or_update_content "content-news" "<html><body><h1>Latest news page content here.</h1></body></html>"

# Always update dependencies in project.clj for Ring and Jetty including middleware defaults
cat <<EOF > project.clj
(defproject hello-world-webserver "0.1.0-SNAPSHOT"
  :dependencies [[org.clojure/clojure "1.11.1"]
                 [ring "1.9.4"]
                 [ring/ring-core "1.9.4"]
                 [ring/ring-jetty-adapter "1.9.4"]
                 [ring/ring-defaults "0.3.3"]]
  :main ^:skip-aot hello-world-webserver.core)
EOF

# Create or update the Clojure file to handle HTTP requests for multiple URIs and serve HTML content
cat <<EOF > src/hello_world_webserver/core.clj
(ns hello-world-webserver.core
  (:require [ring.adapter.jetty :refer [run-jetty]]
            [ring.util.response :refer [response content-type]]
            [ring.middleware.defaults :refer [wrap-defaults site-defaults]]
            [clojure.java.io :as io]
            [clojure.string :as str]))

(defonce routes {
  "/" "content",
  "/about" "content-about",
  "/help" "content-help",
  "/news" "content-news"
})

(defn read-content [file-path]
  (try
    (slurp file-path)
    (catch Exception e
      (str "Error reading " file-path ": " (.getMessage e)))))

(defn handler [request]
  (let [uri (get request :uri)
        content-file (get routes uri "content")] ; Default to "content" if no specific route
    (-> (read-content content-file)
        (response)
        (content-type "text/html"))))

(defn -main []
  (run-jetty (wrap-defaults handler site-defaults) {:port 3000 :join? true}))
EOF

# Inform user that the server is about to run and then execute lein run
echo "Project setup complete, will now run lein project"
lein run
