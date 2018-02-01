FROM ruby:2.5.0

ENV LANG=C.UTF-8 \
    APP_HOME=/usr/src/app

RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME

RUN curl -sL https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
 && sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list' \
 && apt-get update -qq \
 && apt-get install -y \
    google-chrome-stable \
    vim \
 && curl -sL 'https://deb.nodesource.com/setup_9.x  ' | bash - \
 && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
 && echo 'deb https://dl.yarnpkg.com/debian/ stable main' | tee /etc/apt/sources.list.d/yarn.list \
 && apt-get update -qq \
 && apt-get install -y \
    nodejs \
    yarn \
 && rm -rf /var/lib/apt/lists/* \
 && rm -rf /src/*.deb

ENV BUNDLE_GEMFILE=$APP_HOME/Gemfile \
    BUNDLE_JOBS=4
