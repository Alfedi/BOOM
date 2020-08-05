MIX_ENV?=dev

deps:
	mix deps.get
	mix deps.compile

compile: deps
	mix compile

install: deps
	mix ecto.create
	mix ecto.migrate

start:
	mix phx.server
