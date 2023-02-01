run:
	docker-compose up -d
stop:
	docker-compose down
clean: stop
	docker volume rm my-apache-php_database-volume || true
	docker network rm my-apache-php_default || true
