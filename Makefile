BACKEND_REPOSITORY_NAME ?= nic-speed-backend
FRONTEND_REPOSITORY_NAME ?= nic-speed-frontend


# Build backend
build-backend:
	test -d $(BACKEND_REPOSITORY_NAME) && echo "Repository exists" \
		|| git clone https://github.com/alexeymel/nic-speed-backend.git $(BACKEND_REPOSITORY_NAME)
	cd $(BACKEND_REPOSITORY_NAME) \
		&& $(MAKE) clean \
		&& git checkout master \
		&& $(MAKE) all


# Deploy backend
deploy-backend: build-backend
	docker-compose up -d $(BACKEND_REPOSITORY_NAME)


# Drop backend
drop-backend:
	docker-compose down $(BACKEND_REPOSITORY_NAME)


# Build frontend
build-frontend:
	test -d $(FRONTEND_REPOSITORY_NAME) && echo "Repository exists" \
		|| git clone https://github.com/alexeymel/nic-speed-frontend.git $(FRONTEND_REPOSITORY_NAME)
	cd $(FRONTEND_REPOSITORY_NAME) \
		&& $(MAKE) clean \
		&& git checkout master \
		&& cp ../nginx.conf ./nginx.conf \
		&& $(MAKE) all


# Deploy frontend
deploy-frontend: build-frontend
	docker-compose up -d $(FRONTEND_REPOSITORY_NAME)


# Drop frontend
drop-frontend:
	docker-compose down $(FRONTEND_REPOSITORY_NAME)


# Drop all
drop-all:
	docker-compose down


# Deploy backend and frontend
all: deploy-backend deploy-frontend


# Clean
clean:
	rm -rf $(BACKEND_REPOSITORY_NAME)
	rm -rf $(FRONTEND_REPOSITORY_NAME)