FROM ruby:2.7.3-alpine

ENV LANG=C.UTF-8 \
    TZ=Asia/Tokyo \
    ROOT=/myapp

WORKDIR $ROOT

RUN apk update && \
    apk upgrade && \
    apk add --no-cache \
    gcc \
    g++ \
    libc-dev \
    libxml2-dev \
    linux-headers \
    make \
    nodejs \
    postgresql \
    postgresql-dev \
    tzdata \
    yarn \
    git \
    bash

RUN apk add --virtual build-packs --no-cache \
    build-base \
    curl-dev

COPY Gemfile* $ROOT/

RUN bundle install -j4

RUN rm -rf /usr/local/bundle/cache/* /usr/local/share/.cache/* /var/cache/* /tmp/* && \
    apk del build-packs

COPY . $ROOT

COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["sh", "/usr/bin/entrypoint.sh"]
EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
