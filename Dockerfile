#
# Build Stage
#
FROM golang:alpine as build-stage
LABEL MAINTAINER='Vasilios Tzanoudakis <vasilios.tzanoudakis@voiceland.gr>'
ARG CGRATES_REPO
ARG CGRATES_VERSION

RUN apk add --update alpine-sdk git
RUN mkdir /usr/src/
WORKDIR /usr/src/
RUN git clone https://github.com/cgrates/cgrates.git && cd cgrates && ./build.sh

#
# Production Stage
#
FROM alpine:latest as production-stage
LABEL MAINTAINER='Vasilios Tzanoudakis <vasilios.tzanoudakis@voiceland.gr>'
COPY --from=build-stage /go/bin/cgr-engine /go/bin/
COPY --from=build-stage /go/bin/cgr-console /go/bin/
COPY --from=build-stage /go/bin/cgr-loader /go/bin/
COPY --from=build-stage /go/bin/cgr-migrator /go/bin/
COPY --from=build-stage /go/bin/cgr-tester /go/bin/


# Install Config
COPY configs/cgrates.json /etc/cgrates/cgrates.json
COPY scripts/run.sh /run.sh
ENTRYPOINT ["/run.sh"]






