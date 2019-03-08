FROM alpine:3.9

ENV BASH_VERSION 4.4.19-r1
ENV CURL_VERSION 7.64.0-r1
ENV DOWNLOAD_SCRIPT_URL "https://raw.githubusercontent.com/frncsdrk/supa.sh/master/download.sh"
ENV OPENSSH_VERSION 7.9_p1-r4

RUN apk -q update \
  && apk -q upgrade \
  && apk -q --no-progress add bash="$BASH_VERSION" \
  && apk -q --no-progress add curl="$CURL_VERSION" \
  && apk -q --no-progress add openssh="$OPENSSH_VERSION" \
  && rm -rf /var/cache/apk/*

# download and install
RUN curl "$DOWNLOAD_SCRIPT_URL" -sSf | bash

# entrypoint supa.sh
ENTRYPOINT ["/usr/local/bin/supa.sh"]
CMD ["--help"]
