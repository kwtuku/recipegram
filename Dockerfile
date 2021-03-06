FROM ruby:2.7
ENV LANG C.UTF-8

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

RUN apt-get update -qq && \
    apt-get install -y \
      build-essential \
      nodejs \
      yarn

# Rails Setup
RUN mkdir /app
WORKDIR /app
