FROM bitwalker/alpine-elixir-phoenix:latest
RUN apk add --no-cache bash inotify-tools postgresql-client
WORKDIR /opt/app
EXPOSE 4000
