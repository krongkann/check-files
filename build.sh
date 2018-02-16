docker build -t checkfiles_app  -f ./src/Dockerfile ./src
docker-compose run --rm app coffee app.coffee