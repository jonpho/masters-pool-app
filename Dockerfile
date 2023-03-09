FROM ruby:3.2.1-alpine3.17

RUN apk update && apk upgrade
RUN apk add ruby-dev make nodejs yarn gcc libc-dev openssl mysql mysql-client mysql-dev tzdata

WORKDIR /app
COPY . .
RUN gem install bundler -v 2.4.7
RUN bundle install

CMD [ "rails", "server" ]
EXPOSE 3000
