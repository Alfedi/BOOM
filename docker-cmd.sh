# docker-cmd.sh

#!/bin/bash
exec mix ecto.migrate
exec mix phx.server --no-halt --no-deps-check
