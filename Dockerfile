FROM alpine:3.7
LABEL author="zephinzer <dev-at-joeir-dot-net>" \
  description="Docker image for use with CI/CD pipelines to perform version bumping"
ENV INSTALLED_PACKAGES="\
  bash \
  curl \
  git \
  vim \
  jq \
"
ENV ALIASES="\
  alias v-get-branch='/vtscripts/get-branch'\n\
  alias v-get-latest='/vtscripts/get-latest'\n\
  alias v-get-next='/vtscripts/get-next'\n\
  alias v-init='/vtscripts/init'\n\
  alias v-iterate='/vtscripts/iterate'"
WORKDIR /app
RUN apk add --no-cache ${INSTALLED_PACKAGES} \
  && printf -- "${ALIASES}" >> ~/.profile
COPY . /vtscripts
ENTRYPOINT [ "cat", "/vtscripts/usage.txt" ]