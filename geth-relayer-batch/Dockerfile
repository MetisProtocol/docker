# geth
ARG BRANCH=master
ARG REMOTE=https://github.com/MetisProtocol/go-ethereum

FROM golang:1.14-buster as geth

RUN apt-get update \
  && apt-get install -y build-essential

ARG BRANCH
ARG REMOTE

RUN git ls-remote $REMOTE | grep heads/$BRANCH | tee /cache.txt
RUN git clone \
    --depth=1 \
    --branch $BRANCH \
    $REMOTE /go-ethereum \
    && cd /go-ethereum \
    && make geth

FROM golang:1.14-buster

ARG BRANCH
ARG REMOTE
LABEL io.optimism.repo.git.remote=$REMOTE

RUN apt-get update \
    && apt-get install -y bash curl jq ca-certificates

# batch-submitter

FROM node:14-buster as batch

RUN apt-get update \
    && apt-get install -y bash git python build-essential

ARG BRANCH
ARG REMOTE=https://github.com/MetisProtocol/batch-submitter

LABEL io.optimism.repo.git.remote=$REMOTE

RUN git ls-remote $REMOTE | grep heads/$BRANCH | tee /cache.txt
RUN git clone $REMOTE /opt/batch-submitter \
    && cd /opt/batch-submitter \
    && git checkout $BRANCH \
    && yarn install \
    && yarn build

FROM node:14-buster
ARG REMOTE
LABEL io.optimism.repo.git.remote=$REMOTE

RUN apt-get update \
    && apt-get install -y bash curl jq

# message relayer
FROM node:14-buster as relayer

RUN apt-get update \
    && apt-get install -y bash curl jq

FROM relayer as relayerBuild

RUN apt-get update \
    && apt-get install -y bash git python build-essential

ARG BRANCH
ARG REMOTE=https://github.com/MetisProtocol/optimism-ts-services

RUN git ls-remote $REMOTE | grep heads/$BRANCH | tee /cache.txt
RUN git clone $REMOTE /opt/optimism-ts-services \
    && cd /opt/optimism-ts-services \
    && git checkout $BRANCH \
    && yarn install \
    && yarn build

# FROM relayer
# ARG REMOTE
# LABEL io.optimism.repo.git.remote=$REMOTE

# RUN apt-get update \
#     && apt-get install -y bash curl jq

# copy & run

# use aws
FROM isentia/python3.8-aws

LABEL maintainer IoStrike

# env install
RUN apt-get install -y supervisor bash curl jq
RUN curl -sL https://deb.nodesource.com/setup_14.x | bash -
RUN apt-get install -y nodejs

RUN apt-get -y install git binutils
RUN mkdir -p /efs
WORKDIR /efs
RUN git clone https://github.com/aws/efs-utils
WORKDIR /efs/efs-utils
RUN ./build-deb.sh
RUN apt-get -y install ./build/amazon-efs-utils*deb

RUN pip3 install uwsgi
RUN pip3 install flask
RUN pip3 install requests

RUN mkdir /app 
RUN mkdir /app/log
RUN mkdir -p /var/www/flask

# copy 3 in 1
COPY --from=geth /go-ethereum/build/bin/geth /usr/local/bin/
EXPOSE 8543 8545 8546 8547

COPY --from=batch /opt/batch-submitter /opt/batch-submitter
RUN ln -s /opt/batch-submitter/exec/run-batch-submitter.js \
    /usr/local/bin/

COPY --from=relayerBuild /opt/optimism-ts-services /opt/optimism-ts-services
RUN ln -s /opt/optimism-ts-services/exec/run.js \
    /usr/local/bin/

COPY clear-log.sh /bin/clear-log.sh
COPY wait-for-l1.sh /bin/wait-for-l1.sh
COPY wait-for-l1-and-l2.sh /bin/wait-for-l1-and-l2.sh
COPY start-geth.sh /bin/start-geth.sh
COPY start-others.sh /bin/start-others.sh

# mount folder
RUN mkdir -p /metis

COPY src /app

COPY settings/restart.sh /app/restart.sh
RUN chmod +x /app/restart.sh

COPY settings/efs-utils.conf /etc/amazon/efs/efs-utils.conf
COPY settings/uwsgi.ini /usr/local/etc/uwsgi/uwsgi.ini
COPY settings/supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# ENTRYPOINT ["/bin/wait-for-l1.sh", "/bin/start-geth.sh", "/opt/wait-for-l1-and-l2.sh", "/bin/start-others.sh"]
WORKDIR /app
COPY entrypoint.sh /app/entrypoint.sh
COPY clear.sh /app/clear.sh
RUN touch crontab.key && echo "*/10 * * * * /app/clear.sh">crontab.key
RUN chmod 777 /app/clear.sh
RUN apt-get update 
RUN apt-get install cron -y --no-install-recommends

RUN mkdir -p /app/log && echo "t_batch.. ">>/app/log/t_batch.log && echo "t_geth.. ">>/app/log/t_geth.log && echo "t_msgrelay.. ">>/app/log/t_msgrelay.log && echo "t_supervisord.. ">>/app/log/t_supervisord.log 
#ENTRYPOINT ["supervisord","-c","/etc/supervisor/conf.d/supervisord.conf"]
#ENTRYPOINT supervisord -c /etc/supervisor/conf.d/supervisord.conf && tail -f /app/log/t_*.log
ENTRYPOINT ["/app/entrypoint.sh"]