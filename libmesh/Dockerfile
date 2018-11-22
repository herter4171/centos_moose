FROM centos_moose_base:latest

WORKDIR /app
COPY . /app

RUN /app/build_libmesh.sh

CMD ["/bin/bash", "/app/run_libmesh.sh"]

