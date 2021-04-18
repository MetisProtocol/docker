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

FROM relayer
ARG REMOTE
LABEL io.optimism.repo.git.remote=$REMOTE

RUN apt-get update \
    && apt-get install -y bash curl jq

# copy & run
  
COPY --from=geth /go-ethereum/build/bin/geth /usr/local/bin/
EXPOSE 8545 8546 8547

COPY --from=batch /opt/batch-submitter /opt/batch-submitter
RUN ln -s /opt/batch-submitter/exec/run-batch-submitter.js \
    /usr/local/bin/

COPY --from=relayerBuild /opt/optimism-ts-services /opt/optimism-ts-services
RUN ln -s /opt/optimism-ts-services/exec/run.js \
    /usr/local/bin/

COPY wait-for-l1.sh /bin/wait-for-l1.sh
COPY wait-for-l1-and-l2.sh /opt/
COPY start-geth.sh /bin/start-geth.sh
COPY start-others.sh /bin/start-others.sh

ENTRYPOINT ["/bin/wait-for-l1.sh", "/bin/start-geth.sh", "/opt/wait-for-l1-and-l2.sh", "/bin/start-others.sh"]
