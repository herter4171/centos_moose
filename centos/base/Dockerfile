FROM centos

WORKDIR /app
COPY . /app

RUN /app/build_base.sh

CMD ["/bin/bash", "/app/run_base.sh"]

