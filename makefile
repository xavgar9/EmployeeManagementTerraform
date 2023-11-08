run:
	@echo "Building and running containers with docker-compose..."
	@./init.sh

run-migrations:
	@echo "Running migration..."
	sudo -u root docker exec -i db mysql -uroot -proot -e "CREATE DATABASE IF NOT EXISTS employeemanagement;"
	sudo -u root docker exec -i db mysql -uroot -proot employeemanagement < ./Backend/scripts/CreateDB.sql
	sudo -u root docker exec -i db mysql -uroot -proot employeemanagement < ./Backend/scripts/FunctionsProcedures.sql
	sudo -u root docker exec -i db mysql -uroot -proot employeemanagement < ./Backend/scripts/ResetDB.sql

.PHONY: build up