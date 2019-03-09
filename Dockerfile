FROM ruby:slim-stretch
RUN apt-get update
RUN apt-get install -y build-essential patch ruby-dev zlib1g-dev liblzma-dev libsqlite3-dev sqlite3 nodejs
COPY . /microservice/
WORKDIR /microservice/
RUN bundle install
RUN rake db:migrate
ENV APP_ENV=production
CMD ["rerun","microservice.rb"]