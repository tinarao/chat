run: database
	mix phx.server

database:
	docker compose up -d