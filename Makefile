# Include the .env file:
ifneq (,$(wildcard ./.env))
    include .env
    export
endif
# 
#
.DEFAULT_GOAL := help 
help:
	@egrep -h '\s#\s' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?# "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

VERSION=demo
IMAGE_NAME=nfl_postgres

.PHONY: build-nfl-pg tag-nfl-pg push-nfl-pg run-nfl-pg-local run-nfl-pg-prod
build-nfl-pg: # Build the nfl capable postgres image
	@docker build -t $(IMAGE_NAME) .

tag-nfl-pg: # Tag the nfl capable postgres image
	docker tag $(IMAGE_NAME) $(REGISTRY_IMAGE)

push-nfl-pg: # Push the nfl capable postgres image
	docker push $(REGISTRY_IMAGE)

run-nfl-pg-init: # Initialize the database in the docker volume
	docker compose -f docker-compose.init.yml

run-nfl-pg-local: # Run the nfl capable postgres locally
	docker compose down && docker compose up -d

run-nfl-pg-prod: # Run the nfl capable postgres in prod server
	docker compose -f docker-compose.yml -f docker-compose.prod.yml up -d
