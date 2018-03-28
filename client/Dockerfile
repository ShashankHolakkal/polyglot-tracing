#FROM ruby:2.5.0-slim-stretch
FROM ruby:latest

# Set the work directory
RUN mkdir /usr/src/app
ADD Gemfile /usr/src/app
WORKDIR /usr/src/app/
#RUN bundle exec rake install
RUN bundle install

ADD . /usr/src/app/


CMD ["/usr/src/app/lib/client.rb"]
#docker run -dt -p 4567:4567 client bash