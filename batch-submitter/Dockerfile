ARG BRANCH=master
ARG REMOTE=https://github.com/MetisProtocol/batch-submitter

FROM node:14-buster as build

RUN apt-get update \
    && apt-get install -y bash git python build-essential

ARG BRANCH
ARG REMOTE
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

COPY --from=build /opt/batch-submitter /opt/batch-submitter
COPY wait-for-l1-and-l2.sh /opt/
RUN ln -s /opt/batch-submitter/exec/run-batch-submitter.js \
    /usr/local/bin/

ENTRYPOINT ["/opt/wait-for-l1-and-l2.sh", "run-batch-submitter.js"]
