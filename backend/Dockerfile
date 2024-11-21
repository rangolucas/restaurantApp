FROM ruby:3.3

COPY . .
RUN bundle install
EXPOSE 4567
ENV APP_ENV=production
CMD ["ruby", "Application.rb"]