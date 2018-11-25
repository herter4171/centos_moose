FROM rebuild_test_base:latest

WORKDIR /app
COPY . /app

RUN /app/build_libmesh.sh

CMD ["/bin/bash", "/app/run_libmesh.sh"]

