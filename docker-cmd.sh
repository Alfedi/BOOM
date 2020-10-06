#!/bin/bash

mix ecto.migrate
mix phx.server --no-halt --no-deps-check
