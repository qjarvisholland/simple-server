# simple-server

This is a hands-free way to deploy a containerized clojure webserver

### Dependencies
- Ansible
- Leiningen
- OpenJDK

### To deploy
Open a terminal in this directory and run the playbook
'''
ansible-playbook deploy-jetty.yml
'''

This playbook will:
- Build the docker file resulting in a running alpine linux docker container named 'jettyserver'
- Configure port-forwarding on the container, map the directory to local
- Run a bash script that builds a leiningen Clojure project
- Run the project, resulting in a webserver accessible via localhost:3000/

You can also visit
'''
localhost:3000/about
/news
/help
'''
As configured in  /src/hello_world_webserver/core.clj
