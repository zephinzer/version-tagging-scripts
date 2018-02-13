FROM alpine:3.7
LABEL author="zephinzer <dev-at-joeir-dot-net>" \
  description="Docker image for use with CI/CD pipelines to perform version bumping"
ENV INSTALLED_PACKAGES="bash curl git vim jq"
ENV PATH_PACKAGE="/vtscripts"
ENV PATH_SYSTEM_BIN="/usr/local/bin"
WORKDIR /app
COPY . ${PATH_PACKAGE}
RUN apk add --no-cache ${INSTALLED_PACKAGES} \
  && ln -s ${PATH_PACKAGE}/get-branch ${PATH_SYSTEM_BIN}/get-branch \
  && ln -s ${PATH_PACKAGE}/get-latest ${PATH_SYSTEM_BIN}/get-latest \
  && ln -s ${PATH_PACKAGE}/get-next ${PATH_SYSTEM_BIN}/get-next \
  && ln -s ${PATH_PACKAGE}/init ${PATH_SYSTEM_BIN}/init \
  && ln -s ${PATH_PACKAGE}/iterate ${PATH_SYSTEM_BIN}/iterate
