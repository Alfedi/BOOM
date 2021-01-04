# Production image for boom
FROM elixir:1.10.4-slim

EXPOSE 4000

## Create directory and isolate it from the rest of the docker for security reasons
RUN mkdir /app && \
    groupadd -r boom && \
    useradd -d /app -g boom boom && \
    chown boom:boom /app usr/local/lib/

# Build vars
ARG CODE_VERSION

## Env vars
WORKDIR /app
ENV MIX_ENV=prod
ENV CODE_VERSION=$CODE_VERSION
ENV SECRET_KEY_BASE=$SECRET_KEY_BASE
ENV POSTGRESQL_HOST=$POSTGRESQL_HOST
ENV POSTGRESQL_USERNAME=$POSTGRESQL_USERNAME
ENV POSTGRESQL_PASSWORD=$POSTGRESQL_PASSWORD
ENV POSTGRESQL_DATABASE=$POSTGRESQL_DATABASE
ENV POSTGRESQL_PORT=$POSTGRESQL_PORT

# Install hex locally
RUN mix local.hex --force && mix local.rebar --force

# Copy the contents
COPY . .

# Compile
RUN mix deps.get
RUN mix deps.compile
RUN mix compile

# Run the application
RUN chmod +x ./docker-cmd.sh
CMD ["./docker-cmd.sh"]
